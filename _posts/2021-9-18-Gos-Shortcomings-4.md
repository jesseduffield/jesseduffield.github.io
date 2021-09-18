---
layout: post
title: "Go'ing Insane Part Four: Mandatory Mutation"
series: going-insane
series-title: 'Part Four: Mandatory Mutation'
---

_Standard caveats apply: these things bother me, they may not bother you, prepare for nitpicking, etc._

When in Rome we do as the Romans do, and when in Go we do as the Gophers do, which means mutation _everywhere_.

## Mutation in Javascript

At my day job I'm a bit of an anti-mutation nazi. If I'm reviewing code and see something like this in javascript:

```js
let env = 'dev';
if (isProd) {
  env = 'prod';
}
// (env is never assigned to again)
```

I'll request that we use `const` instead like so:

```js
const env = isProd ? 'prod' : 'dev';
```

This is not for the sake of sparing keystrokes or vertical space. It's because it gives the reader more information to help them understand the code. If you see a `const` keyword before a variable you can rest assured that that variable will never be re-assigned a value, which saves space in your brain for reasoning about the rest of the code.

## Mutation in Ruby

Ruby lacks a const keyword (you can freeze objects to prevent mutation but I care more about reassignment), yet even in ruby I'll push for minimising mutation. For example, in a world where Ruby lacked the ternary operator, I would still prefer:

```ruby
# in Ruby, as it is with Rust, if statements and switch statements are themselves expressions,
# meaning they can live on the RHS of an assignment
env = if is_prod
  "prod"
else
  "dev"
end
```

to:

```ruby
env = nil
if is_prod
  env = "prod"
else
  env = "dev"
end
```

Because it's easier to read a codebase where mutation is the exception rather than the rule.

## Mutation in Go

This brings us to Go. Go has a `const` keyword but it can only be used when the right-hand side of the assignment holds a basic type like an integer or string literal. Go constants can't be re-assigned and their values can't be mutated because Go constants can't hold mutable values. As such we'll only see a handful of constants in the typical Go package, and rarely on the inside of a function where most of the action happens.

```go
const myConst1 = 1 // okay

const myConst2 = []int{1} // ERROR: ([]int literal) (value of type []int) is not a basic type

myVar := 1
const myConst3 = myVar // ERROR: myVar (variable of type int) is not constant
```

Even if Go allowed the `const` keyword when the RHS contained a variable, it wouldn't help us with the common requirement of determining a value based on some condition, because Go lacks the ternary operator and its if/switch statements can't be treated as expressions.

In Go, if I want to set my `env` variable to `"prod"` or `"dev"` depending on `isProd` I have two choices:

```go
env := "dev"
if isProd {
	env = "prod"
}
```

Or this longer form:

```go
var env string
if isProd {
	env = "prod"
} else {
	env = "dev"
}
```

So why does Go lack a ternary operator?

## The Ternary Operator

In the Go [FAQ](https://golang.org/doc/faq#Does_Go_have_a_ternary_form), under the question about the absence of ternaries from the language, the if-else approach is advised. Under the example they say

> The if-else form, although longer, is unquestionably clearer [than a ternary].

Allow me to question the unquestionable. If you're somebody who understands the syntax of a ternary, it's pretty clear.

What if you don't understand the syntax of a ternary? I've heard the argument that the ternary operator is hard to learn and we can't expect everybody to know it, but this argument makes no sense to me: If you're a developer learning Go, you're probably familiar with other languages (I've never met anybody around my age whose first language was statically typed) and given that Javascript, Ruby, C, C++, C#, Java, Perl, PHP, Swift, Crystal and Dart, _all_ use ternary operators, what are that odds somebody has never come across the ternary operator before learning Go? I'd say slim. On the off-chance such a person exists, it takes two minutes to learn how the operator works: far less time than it takes to understand how Go's channels work for example. And that's two minutes they're going to have to spend sooner or later, unless they manage to avoid all the above-listed languages for the remainder of their life.

Assuming that we're dealing with somebody who recognises the ternary operator, let's rank the following alternatives from most to least clear:

```go
// 1) Most clear: If-statements as expressions
env := if isProd { "prod" } else { "dev" } // not actually valid Go syntax

// 2) Using ternary operator
env := isProd ? "prod" : "dev" // not actually valid Go syntax

// 3) Using mutative if-else statement
var env string
if isProd {
	env = "prod"
} else {
	env = "dev"
}

// 4) Least clear: using mutative if statement
env := "dev"
if isProd {
	env = "prod"
}
```

Note that options 1 and 2 read the same from left to right: _if isProd is true, set to "prod", otherwise set to "dev"_. This is the natural way you would explain the logic in english. Admittedly option 3 also shares the same flow, however it's spread over six lines and the reader has to work harder to recognise what's actually going on: _Hmm so we assign "prod" to `env` in the first case and "dev" to `env` in the other case and oh right so this is basically mimicking a ternary_.

Option 4's flow is backwards. As the reader follows the code they think: _So env's value is "dev"... oh wait no we'll change that value to "prod" if `isProd` is true_. The _oh wait_ part of that process is exactly what we want to avoid when writing code: we should be minimising surprise whenever possible.

Why am I bothering to evaluate the fourth option, given that the Go team didn't advise it and it's the least-clear alternative? Because I see this form being used everywhere, likely because it requires the fewest keypresses! In a world with ternaries or if-statements that constitute expressions, lazy developers like me can save themselves keystrokes without sacrificing clarity. But gophers do not live in that world, so clarity suffers as a result.

There are two arguments I hear against ternaries that resonate with me. The first is that when nested they are hard to read. I completely agree with this argument, as do the linters of pretty much every language that supports ternaries. I wouldn't even mind if the Go team allowed ternaries but disallowed nesting them. Of course, I would be happy to forgo ternaries to have if-statements and switch statements treated as expressions, but I can't see that happening any time soon. The second argument is that although adding ternaries (or conditional expressions in general) would not itself raise the complexity waterline much, if a bunch of similar features were added, we could end up in a language that's needlessly complex, which is antithetical to Go's desire for simplicity. Can't argue with that, other than to say I simply don't value simplicity as much as other Gophers.

From my perspective, Go's simplicity stands in opposition to expressiveness: I lack the tools required to communicate what a developer can expect as they read my code (e.g. this variable will never be assigned to again) which makes it harder to glean what's going on as the reader. Better support for immutable variables and conditional expressions would solve this.

## Mutative Boilerplate

A post about mutation in Go would be remiss not to mention the current lack of generics. I've [talked about this](https://jesseduffield.com/Gaining-Ground-Without-Generics-In-Go/) in the past so I'm not going to beat a dead horse here, other to say that a lack of generics leads to mutative boilerplate which is error-prone and hard to read.

I've [written before]({{ site.baseurl }}/Array-Functions-And-Rule-Of-Least-Power) about using the least powerful tool for the job in the context of collection functions (map, filter reduce, etc), and how your code becomes more readable when you use, say, a map instead of a for loop. In the diagram I used for that post, Go only really provides the for loop and `forEach` in the form of the `range` operator:

![]({{ site.baseurl }}/images/posts/2020-7-9-Array-Functions-And-Rule-Of-Least-Power/2.png)

This means that instead of doing this:

```go
userNames := users.map(func (u User) string { return u.Name }) // invalid syntax
```

we have to do this:

```go
// backing array starts with a length of `len(users)` with
// each element being an empty string
userNames := make([]string, len(users))
for i, user := range users {
  userNames[i] = user.Name
}
```

Or is it more efficient to do this?

```go
// backing array starts empty but has the capacity of `len(users)`
userNames := make([]string, 0, len(users))
for _, user := range users {
  userNames = append(userNames, user.Name)
}
```

Why do I even need to care about which of those two approaches is more efficient? All I want to do is map from a slice of users to a slice of their names. Just like with the examples of the previous section, you need to read the whole block of code to understand _oh this is just doing a map_ and there's nothing stopping me from making the mistake of going:

```go
userNames := make([]string, len(users))
for i, user := range users {
  userNames = append(userNames, user.Name)
}
```

Which looks fine but would actually give me a completely incorrect result.

Yes, generics are on their way, but as I said at the beginning of this series, I'm voicing my grievances about _today's_ Go, not tomorrow's.Generics were originally set for release in August, and now I doubt they'll be out by the end of the year.

## Conclusion

To get anything done in Go you need to explicitly mutate variables, which decreases the code's expressiveness and increases your difficulty as both a reader and writer of Go code. There are probably people out there who find immutable variables and conditional expressions and map/filter/reduce more confusing than what Go currently provides, and that's fine, but I'm not one of them.

As with basically all of these posts, there are solutions to solve these problems (conditional expressions, immutability keywords), but I doubt Go has the appetite for them given the inherent complexity bump, and once again, this comes down to a difference in values.

Next up, Crazy Conventions.

## Addendum

I haven't touched on immutable types here, but if you want to get a feel for that, here's a very extensive [proposal](https://github.com/golang/go/issues/27975) for them. Given that immutability would be opt-in, this is one of the few times I actually think a proposal might add too much complexity for the benefits.
