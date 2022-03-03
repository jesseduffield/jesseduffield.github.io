---
layout: post
title: Beginner's Guide To Abstraction
redirect_from: /beginners-guide-to-abstraction
---

In _The Pragmatic Programmer_, Andrew Hunt and David Thomas introduced the DRY (Don't Repeat Yourself) principle. The rationale being that if you see the same code copy+pasted 10 times you should probably factor that code into its own method/class.

But then Sandi Metz came along and [said](https://www.sandimetz.com/blog/2016/1/20/the-wrong-abstraction):

> Duplication is far cheaper than the wrong abstraction.

And so the eternal war began.

### What is abstraction?

For the purposes of this post I'm referring to the kind of abstraction as described in the [Abstraction Principle](<https://en.wikipedia.org/wiki/Abstraction_(computer_science)#Abstraction_in_object_oriented_programming>), which Wikipedia describes like so:

> In software engineering and programming language theory, the abstraction principle (or the principle of abstraction) is a basic dictum that aims to reduce duplication of information in a program (usually with emphasis on code duplication) whenever practical by making use of abstractions provided by the programming language or software libraries

This post has nothing to say about the conceptual kind of abstraction where from the concrete examples of 'Parrot' and 'Sparrow' you create an abstraction of 'Bird'. This post is about duplicated code, how to respond to it, and how to respond to other people's responses to it.

The way I define it is that the verb 'abstract' is to _attempt_ to reduce complexity by combining repeated commonality into some generalisation. And so, the noun 'abstraction' is the result of that attempt. If you're somebody who believes abstraction is by definition a _successful_ attempt, feel free to substitute the term 'wrong abstraction' with 'failure to abstract' throughout this post.

The process of abstraction typically goes like this:

1. you identify different chunks of code that you think are all essentially doing the same thing
2. you create a method or a class with a narrow interface which can be substituted in for all the chunks of code you found
3. you go and swap out the chunks of code with a call to your method/class

### Abstraction is always a gamble

In the world of software engineering, when requirements are always changing, every abstraction is a gamble. When you make an abstraction over some concrete things, you're making a bet that the concrete things are more similar than they are different, and that their similarities are not mere coincidences: that there is a common purpose shared by the concrete things which would lead them to evolve in lockstep as requirements evolve. If you win the bet, your codebase will be easier to work in and adding new use cases via your abstraction will be trivially easy. If you lose, you'll see a flash of fear in your colleague's eyes whenever they're assigned a ticket to make yet another extension to the misfigured monster that the once-innocent abstraction has now become

But risk abounds everywhere, and leaving duplicated code unabstracted is its own gamble. You're betting that the chunks of code will evolve in separate directions as requirements change and that their current similarities are more coincidence than a reflection of their common purpose. Win the bet and your colleague gets to sleep soundly at night knowing they won't be facing the abstraction monster at work the next day. Lose, and code that should have evolved in lockstep is now implemented in completely different ways across different files, where a developer fixes a bug identified in one place, only for the same bug to be reported days later in a completely different file.

Your job is to get good at making the right bets.

### The right/wrong abstraction

You'll know that you've made the _right_ abstraction when a long time passes and you haven't needed to expand the interface (an example of expanding the interface is adding an optional flag argument). You'll also know you've made the right abstraction when another developer doesn't find it that much harder to understand how the code behaves for a given use case than if somebody had written the code to satisfy the use case without the abstraction.

You'll know you've made the _wrong_ abstraction when after a while the interface has been expanded to support various optional flags, each for a different use case, and you need to be a genius to reason about what the code will actually do for a given use case. By the way, if you have a string arg that merely gets fed into a switch statement inside a method and for each new use case you come up with a new accepted value for it, you _are_ expanding the implicit interface, even if that fact isn't captured in your type system.

There is plenty of daylight between the perfect abstraction and the completely wrong abstraction (perhaps the interface needs to be fundamentally changed but afterwards you're back to having a good abstraction), and so the point of this section isn't to prescribe how much you should be abstracting, but to encourage you to think about both perspectives and be able to make a case in a PR\* review for why you think an abstraction should/should-not exist.

### Do you over or under-abstract?

Given it is impossible to make the right decision with regards to abstraction every time, you are probably either somebody who over-abstracts or somebody who under-abstracts.

If common feedback on your PR reviews is that you should DRY up your code, you could probably benefit from doing a scan for duplicated code before submitting a PR and considering whether it belongs in its own method/class.

If you commonly get feedback that your methods are hard to understand because they support too many disparate use cases at once, you are probaby over-abstracting and should consider whether you should increase your tolerance for duplication.

Note that it's not always as simple as under-abstracting vs over-abstracting. Sometimes abstraction is appropriate, but you might take the wrong approach. If an abstraction is deemed wrong by the team, that doesn't mean no abstraction is necessarily the best alternative.

### Under-abstraction examples

The main sign that you could be under-abstracting is that you have a heap of code doing the exact same thing called in a heap of places with no obvious reason why anybody would want the code to diverge.

#### Example: Hard-coded formulas

##### Bad:

```ruby
# sphere has radius of 11
sphere_volume = 4*Math::PI/3*11**3
puts "the volume of the sphere is #{sphere_volume} cm^3"
...

radius = calculate_radius
volume = 4*Math::PI/3*radius**3
sphere.volume = volume
```

##### Good:

```ruby
def sphere_volume(radius)
  4*Math::PI/3*radius**3
end

# sphere has radius of 11
sphere_volume = sphere_volume(11)
puts "the volume of the sphere is #{sphere_volume} cm^3"
...

radius = calculate_radius
volume = sphere_volume(radius)
sphere.volume = volume
```

Why is it a good idea to abstract the formula for a sphere's volume into its own method? Because if mathematicians ever found out they got the formula wrong, you would want to go through all the places in your code that you used the formula and update it to be correct. That is, we know ahead of time that we want the code to be in lockstep. This is as safe a gamble as you can get.

### Over-abstraction examples

The main sign that you're over-abstracting is that your method accepts a bunch of optional args:

#### Example: Bloated method

##### Bad:

```ruby
def average(arr, type = Integer, ignore_nulls = false)
  if arr.any?(&:nil?)
    if ignore_nulls
      arr = arr.compact
    else
      return nil
    end
  end

  if type == String
    arr = arr.map(&:to_i)
  end

  arr.sum / arr.size
end

puts average([1,2,3])
=> 2

puts average(['1','2','3'], String)
=> 2

puts average(['1','2','3', nil], String, true)
=> 2

puts average([1, 2, 3, nil], Integer, false)
=> nil
```

If you want to know how the `average` method behaves when you're dealing with an array of strings with no `nil` values, you have to read through the first if condition which has nothing to do with your use case before reaching the code that does. Likewise if you want to know how the `average` method behaves when the array contains either nils or integers, the second if condition is irrelevant, but you'll still need to read through that to understand how the whole thing works.

If each of the use cases came up dozens or hundreds of times, maybe then it would make sense to retain the abstraction, but when the number of optional arguments is roughly equal to the number of different use cases, chances are you've got the wrong abstraction.

##### Good:

```ruby
def average(arr)
  arr.sum / arr.size
end

puts average([1,2,3])
=> 2

arr = ['1','2','3'].map(&:to_i)
puts average(arr)
=> 2

arr = ['1','2','3', nil].compact.map(&:to_i)
puts average(arr)
=> 2

arr = [1, 2, 3, nil]
if arr.any?(&:nil?)
  puts nil
else
  puts average(arr)
end
=> nil
```

In this case we're not removing the abstraction altogether: we're just keeping the part that actually applies to all cases. Now understanding the logic of any one invocation of our `average` method is trivial.

We now have `.map(&:to_i)` being duplicated whereas it only appeared once in the `Bad` alternative, but it's a small cost for a vast improvement.

Note that looking at the `Good` variant, it's clear that the behaviour is quite different from one use case to the next, but that is not at all clear in the `Bad` variant because the method calls all look so simple and it was anybody's guess how much code inside `average` applied to each use case.

This is why abstractions go bad over time: because as you expand the interface more and more, it becomes harder and harder to judge how appropriate the abstraction is to any given use case, and developers end up assuming that all that convoluted code is vaguely relevant to the majority of use cases when in fact it's not.

#### Example: Awkward class

##### Bad:

```ruby
class Shape
  def initialize(radius: nil, width: nil, type:)
    @radius = radius
    @width = width
    @type = type
  end

  def area
    case @type
    when :square
      @width ** 2
    when :circle
      (@radius ** 2) * Math::PI
    end
  end

  def perimeter
    case @type
    when :square
      @width * 4
    when :circle
      @radius * 2 * Math::PI
    end
  end

  def diameter
    case @type
    when :square
      nil
    when :circle
      @radius * 2
    end
  end
end

square = Shape.new(type: :square, width: 10)
square.area
=> 100

circle = Shape.new(type: :circle, radius: 10)
circle.area
=> 314.159
```

Code smells:

- switching on type in several places
- returning nil or raising for a specific type when the method is non-applicable
- optional arguments in initializer where you're expected to use one or the other

##### Good

```ruby
class Circle
  def initialize(radius: nil)
    @radius = radius
  end

  def area
    (@radius ** 2) * Math::PI
  end

  def perimeter
    @radius * 2 * Math::PI
  end

  def diameter
    @radius * 2
  end
end

class Square
  def initialize(width: nil)
    @width = width
  end

  def area
    (@width ** 2)
  end

  def perimeter
    @width * 4
  end
end

square = Square.new(width: 10)
square.area
=> 100

circle = Circle.new(radius: 10)
circle.area
=> 314.159
```

Just because squares and circles each have an area and a perimeter doesn't mean they should be the same class when there is literally zero overlap in how we obtain those two things. Likewise the `diameter` method only applies to circles, not squares. In a typed language, we may want to define a Shape interface containing the area/perimeter methods but there is no good reason to combine the classes.

Note that we could also approach this in the other direction using multi-methods. The important thing is that enmeshing variant-specific code with behaviour-specific code makes for a bad abstraction.

#### Example: React Notice components

##### Option 1

```jsx
const SuccessNotice = ({ message }) => <Box color="green">{`Success: ${message}`}</Box>
const WarningNotice = ({ message }) => <Box color="yellow">{`Warning: ${message}`}</Box>
const ErrorNotice = ({ message }) => <Box color="red">{`Error: ${message}`}</Box>
...
<SuccessNotice message="You win!" />
```

##### Option 2

```jsx
const Notice = ({ type, message }) => {
  switch (type) {
    case 'success':
      return <Box color="green">{`Success: ${message}`}</Box>
    case 'warning':
      return <Box color="yellow">{`Warning: ${message}`}</Box>
    case 'error':
      return <Box color="red">{`Error: ${message}`}</Box>
  }

  return null
}
...
<Notice type="success" message="You win!" />
```

##### Option 3

```jsx
const noticeMap = {
  success: { color: 'green', prefix: 'Success: ' },
  warning: { color: 'yellow', prefix: 'Warning: ' },
  error: { color: 'red', prefix: 'Error: ' },
}

const ReallyAbstractedNotice = ({ type, message }) => {
  const options = noticeMap[type]

  return <Box color={options.color}>{`${options.prefix}${message}`}</Box>
}
...
<ReallyAbstractedNotice type="success" message="You win!" />
```

What advantage does option 2 have over option 1? Not much. The only possible advantage is that we might actually receive `type` and `message` props and need to map that to the right JSX, however we typically know at compile time whether we're dealing with an error or a success message. If, at compile time, we already know we need to show an error notice, why force the programmer to pass an arbitrary `type` prop to the `Notice` component? That's just adding complexity that is not intrinsic to the behaviour we want.

Option 2 recognises that our various use cases share an interface, but then does nothing more than jam them into a component with a switch statement. Option 2 makes the same mistake as we saw in the example with the Shape class; in thinking that classes with similar interfaces should necessarily all be in the same class.

Option 3 takes what option 2 did and justifies the abstraction by pulling out the differences between our use cases into a single mapping object, so that the similarities don't need to be duplicated. It identifies that the only difference between our three notices is the color of the Box and the prefix message.

So which is better between options 1 and 3? Two questions to ask:

###### Which is easier to read?

Option 1 hands down

###### Which is better equipped to handle new/evolving use cases?

The answer to this question comes down to our confidence that new use cases will conform to the current behaviour. If we need to add a new `info` variant, it's easier in option 3 because you can just add the colour/prefix in the noticeMap object.

On the other hand, what if we want the success case to disappear after a certain amount of time, but for the error and warning cases to require acknowledging by the user? Easy to handle when each case is its own component: less-so when it's all wrapped up into one. What if we don't need prefixes for errors because they typically come with their own? That would mean the prefix key in the noticeMap now only applies to 2 out of 3 use cases. What if we want to pass more props to the Box component if we're dealing with a warning? We would need to add a new option in our noticeMap object, and have logic for not passing that prop in our other cases.

In this situation, just go with option 1. Much easier to switch to option 3 if over time it turns out these things really do evolve in lockstep, but we can't know that at the beginning.

### Tips:

#### Minimise complexity

For any behaviour we want to encode, there is a certain level of intrinsic complexity required. Yet we often end up writing code that is far more complex than that. We should always be asking 'does this abstraction make the code _more_ complex or _less_ complex?'. And even if an abstraction is less complex theoretically, is it cognitively simple enough that another person can understand it?

#### Just because an abstraction is right now doesn't mean it won't be wrong later:

If your abstraction works great for three use cases but doesn't quite fit the fourth as snugly, be very careful about extending the interface. With enough new use cases you might find the abstraction is making life harder than if it didn't exist.

#### Don't be afraid to dismantle the wrong abstraction:

If you come across an abstraction that is only used in three places and already has two optional flags, do not be afraid to simply copy+paste its code back into the places that call it and then in each of those places, strip away the code that is irrelevant to the use case (see `average` method, above). You will be left with some duplicated code but as Sandi Metz says, 'Duplication is cheaper than the wrong abstraction'. Be prepared to defend the decision in a PR review.

#### When in doubt, do not abstract:

If you've found two files that each share a chunk of code, but you're not sure that you would always want the code to evolve in lockstep, don't abstract. It's much easier to abstract than to de-abstract, so there is no harm in waiting until some more use cases pop up and you get a better idea of what a good interface might look like.

#### When not in doubt, defend your decision:

If you have a single chunk of code that you think should be abstracted for the sake of future use cases, prepare for pushback in a PR review. The onus is on you to explain why this abstraction makes sense given how little evidence there is in the codebase for why it should exist.

## Conclusion

Different people need to hear different messages here. Maybe your code isn't DRY enough. Maybe you seize the opportunity to abstract too readily and it causes headaches down the line. Maybe you've struck a good balance. No matter where you stand, it's important to know that there are no clear cut right answers with the majority of debates around abstractions. So long as you can consider the pros/cons of abstracting more, less, and differently, and you make your case clear in a PR review, you should be fine. Happy coding!

## Appendices

\* A 'PR' is a Pull Request, which I believe is a Github-specific term for a set of code changes you want to have pulled into the master branch. In a team of developers you will typically make some changes locally on a feature branch, then create a PR for that branch on Github, and your colleagues will review the PR, leaving comments and feedback. Gitlab and Bitbucket (two of Github's competitors) probably have their own terms
