---
layout: post
title: "Don't Let Go (of compile-time knowledge)"
---

![]({{ site.baseurl }}/images/posts/dont-let-go/image.webp)

Back in 1966, when the GOTO statement was not yet 'considered harmful' and still enjoyed widespread usage with impunity, the Böhm-Jacopini Theorem[^1] hit the scene which said that at the end of the day, all software can be constructed as a glorified combo of:

- Sequence: Executing one statement after another
- Selection: If-statements, switch-statements
- Iteration: Loops

Nobody cares about Sequence because it's so simple. Some people care about Iteration[^2], especially when there's nested loops involved. But _everybody_ cares about Selection. A single if-else statement can double the number of possible paths through your program, and it's in the combinatorial explosion of possible code paths where all the bugs lie dormant, waiting to rear their ugly heads when the time is ripe and they've surreptitiously made it past your test suite into production.

So it's worth considering ways in which we can reduce the amount of Selection (i.e. conditional logic) going on in our programs.

One thing that I regularly encounter is a situation where the programmer has some knowledge at compile-time that they sacrifice and leave to run-time logic to piece back together. In the tradition of programming blog posts, here's an extremely contrived example:

## An extremely contrived example

```ruby
def foo
  create_user(name: "Jimbo", email: "jimbo@gmail.com", type: "admin")
end

def create_user(name:, email:, type:)
  case type
  when "admin"
    # pretend that actually creating an admin requires a few more lines than this
    Admin.create(name: name, email: email)
  when "customer"
    # pretend that actually creating an customer requires a few more lines than this
    Customer.create(name: name, email: email)
  else
    raise("Unexpected type: #{type}")
  end
end
```

What's wrong with this picture?

When we call `foo`, we know at compile time that we want to create an admin. But at run-time, once we're in the `create_user` method, we need to piece that information back together with conditional logic by inspecting the `type` parameter. What's worse, it's possible for somebody to call `create_user` with an invalid type, inadvertently crashing the program.

What's the fix?

```ruby
def foo
  create_admin(name: "Jimbo", email: "jimbo@gmail.com")
end

def create_admin(name:, email:)
  Admin.create(name: name, email: email)
end

def create_customer(name:, email:)
  Customer.create(name: name, email: email)
end
```

Just like that, the conditional logic is gone. The compile-time knowledge about what kind of user we want to create is no longer sacrificed to the whims of runtime logic. And if we're aiming for 100% code coverage, we no longer need to add a test for when an invalid user type is passed, because we've removed that code!

_(For the record, we've also dismantled a [Wrong Abstraction](https://jesseduffield.com/Beginners-Guide-To-Abstraction/) in that we should expect the creation of an admin and the creation of a customer to require different arguments over time, which would have led to an increasingly tortured signature for the `create_user` method, but this post is focused more on the conditional logic itself.)_

This is a contrived example, but I see things code like this all the time. Some other places I've seen this happen:

- In React, passing a prop to a component that determines which element gets rendered, even though the prop's value is always known at compile time.
- Building up an array of items to process, where items are tagged with a type, to be switched on later.

## What about serialized data?

'Okay', you say, 'but what if I don't know ahead of time what method to call? What if I need to deal with serialized data?'.

Let's consider that possibility. Perhaps you're processing a CSV of users to create, and so it's impossible to know at compile time which method to call. In that case, the original `create_user` method would not just be helpful, it would be _necessary_.

```ruby
def import_users
  user_attributes = CSV.read("my_input.csv")
  user_attributes.each do |attributes|
    create_user(
      name: attributes["name"],
      email: attributes["email"],
      type: attributes["type"]
    )
  end
end

def create_user(name:, email:, type:)
  case type
  when "admin"
    Admin.create(name: name, email: email)
  when "customer"
    Customer.create(name: name, email: email)
  else
    raise("Unexpected type: #{type}")
  end
end
```

Okay, fine, fine. _But_, just because your `create_user` method has a reason to exist in the context of parsing a CSV file does not mean you should opportunistically also use it in cases where you _do_ know what type of user you want at compile time.

You should instead separate the conditional logic from the non-conditional logic:

```ruby
# In my CSV-parsing file
class CsvImporter
  def import_users
    user_attributes = CSV.read("my_input.csv")
    user_attributes.each do |attributes|
      import_user(
        name: attributes["name"],
        email: attributes["email"],
        type: attributes["type"]
      )
    end
  end

  private

  # Renamed to 'import_user' to emphasize the fact that we're dealing
  # with serialized data
  def import_user(name:, email:, type:)
    case type
    when "admin"
      create_admin(name: name, email: email)
    when "customer"
      create_customer(name: name, email: email)
    else
      raise("Unexpected type: #{type}")
    end
  end
end

# =============================

# In another file (to be used from anywhere)
def create_admin(name:, email:)
  Admin.create(name: name, email: email)
end

def create_customer(name:, email:)
  Customer.create(name: name, email: email)
end
```

Why? Because we already have enough conditional logic to deal with without adding if statements and switch statements in places where it's completely unnecessary.

## So basically, you like static types

'Okay', you say, 'But isn't this just an argument for static typing?'

Partly, yes. If you have static typing, you can remove a bunch of conditional logic you would otherwise need to catch type errors. But consider that there's nothing stopping you from writing the above problematic code in a statically typed language. Even Rust, a language famous for its pathologically anal type checker, won't stop you from creating an enum for a user type and pattern-matching on that enum value. In fact, Rust can ensure that it's impossible to pass an invalid user type. But even in the absence of bugs, the less conditional logic your code has, the easier it is to read.

My argument is not to capture compile-time knowledge in types, it's to avoid storing compile-time knowledge in run-time data that must be acted upon by conditional logic.

## An extremely contrived counter-example

Are there counter-examples, where it is simply more readable, or more maintainable, to 'let go' of the compile-time knowledge?

Things can get hairy when you want to enforce certain invariants, like running some code before or after doing something. Consider again the case of creating a user. Perhaps you want to ensure that you're always logging the total user count after a user of any type is created. That's easy to enforce if you have a a single `create_user` method:

```ruby
def create_user(name:, email:, type:)
  case type
  when "admin"
    Admin.create(name: name, email: email)
  when "customer"
    Customer.create(name: name, email: email)
  else
    raise("Unexpected type: #{type}")
  end

  Foo.log_total_user_count
end
```

If you were to add a third type of user (again in the spirit of contrived examples, let's call it `super_admin`), then you would add an extra case in the switch statement and you'd get the logging for free. On the other hand, if you had used standalone methods, you might forget to add the logging:

```ruby
def create_admin(name:, email:)
  Admin.create(name: name, email: email)

  Foo.log_total_user_count
end

def create_customer(name:, email:)
  Customer.create(name: name, email: email)

  Foo.log_total_user_count
end

def create_super_admin(name:, email:)
  SuperAdmin.create(name: name, email: email)

  # Whoops, forgot to follow the implicit pattern of logging the total count
end
```

There is a middle path, where you pass a function as an argument to the function that does the logging:

```ruby
def create_user_and_log_count(create:)
  create.call()

  Foo.log_total_user_count
end

...

create_user_and_log_count(->() { Customer.create(name: name, email: email) }
```

But despite the lack of conditional logic, this approach has its own cognitive overhead: firstly because first-class functions are just hard for humans to get their heads around, and secondly because that `create` argument could do anything when called, so it's hard to know what's expected of it when viewed out of context, let alone enforce that it only creates a user. Furthermore, given that the callsite needs to pass in the creation function, nothing's stopping a user of the API from just ignoring the logging function and calling that creation function directly.

There's another middle path where you still bite the bullet and use the `create_user` method in its all its conditional-logic glory but you make it private so that users of the API are oblivious to the use of the `type` argument and future refactoring becomes trivial:

```ruby
def create_admin(name:, email:)
  create_user(name: name, email: email, type: "admin")
end

def create_customer(name:, email:)
  create_admin(name: name, email: email, type: "customer")
end

private

def create_user(name:, email:, type:)
  case type
  when "admin"
    Admin.create(name: name, email: email)
  when "customer"
    Customer.create(name: name, email: email)
  else
    raise("Unexpected type: #{type}")
  end

  Foo.log_total_user_count
end
```

This approach, like the function argument approach, lets you keep the catch-all code (in this case, the log statement) but also minimises the blast radius as the create-admin and create-customer use cases diverge over time and start to require different arguments.

## Conclusion

The ideological[^3] part of my brain thinks that no matter how you slice it, conditional logic is the enemy and any any person who joins the crusade against it will be rewarded in the next life. But the pragmatic part of my brain thinks... yep, there are some valid cases where you just bite the bullet and permit the conditional logic.

Luckily for me, when I see somebody violating the Don't Let Go aka DLG principle[^4] it's almost always because the non-conditional approach simply hasn't been considered, rather than being chosen as the lesser of all evils.

Next time you find yourself letting go of compile-time knowledge, ask yourself if there is a better way!

## Footnotes

[^1]: The Böhm-Jacopini Theorem demonstrated that any computer program can be written using just three control structures: Sequence, Selection, and Iteration, eliminating the need for GOTO statements. It was two years later that Edsger Dijkstra published his famous 'Go To Statement Considered Harmful' essay.
[^2]:
    One example of somebody really caring about Iteration is in John Carmack's [post](http://number-none.com/blow/john_carmack_on_inlined_code.html) on inlining functions:

    > The fly-by-wire flight software for the Saab Gripen (a lightweight
    > fighter) went a step further. It disallowed both subroutine calls and
    > backward branches, except for the one at the bottom of the main loop.
    > Control flow went forward only. Sometimes one piece of code had to leave
    > a note for a later piece telling it what to do, but this worked out well
    > for testing: all data was allocated statically, and monitoring those
    > variables gave a clear picture of most everything the software was doing.
    > The software did only the bare essentials, and of course, they were
    > serious about thorough ground testing.
    >
    > No bug has ever been found in the "released for flight" versions of that
    > code.

[^3]: I have written about this topic before [here](https://jesseduffield.com/Type-Keys/) (albeit with a different focus) and got crucified on Hacker News for it because I did not do enough bullet-biting. The purpose of this post is to make a more general argument than the original post, and with more tribute to counter examples.
[^4]: Again, in the programming tradition of naming principles in three-letter acronyms, demanding that they never be violated, and then coyly admitting that in some cases they should indeed be violated
