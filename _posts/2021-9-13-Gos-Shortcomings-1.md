---
layout: post
title: "Go'ing Insane Part One: Endless Error Handling"
series: going-insane
series-title: 'Part One: Endless Error Handling'
---

I've been using Go for a few years now, mostly in my open source project Lazygit. In my day job I use Ruby and Typescript, and I've also spent some time with Rust. Each of those languages have design quirks that can grind a developer's gears, and although my own precious gears have been ground by every language I've used, Go is the only language that has made me feel _indignant_.

This series is my attempt to spell out exactly why. My goal is not to convince you that Go is an objectively bad language (I'm not qualified to make that judgment call), it's to convince you that for certain people, working in Go feels like a constant struggle against stupid constraints.

Some of Go's shortcomings will be resolved in the future, but I'm going to focus on what it's like using the language _today_.

This post is about Go's error handling.

## Error handling

_Based on some feedback from Hacker News, let me preface this by saying that we will not show any error wrapping here. Assume that the error is wrapped at the source, and these functions are just bubbling up the error to a function responsible for handling it (e.g. retrying after a period)._

How does Go handle errors? Ignoring unrecoverable errors for which the program will crash and print a stacktrace, errors in Go are just regular values. People still argue about whether error values are better than exceptions, but even if Programming God came down and decreed that error values were indeed superior, he would still take the time to scorn Go's particular implementation of error values before ascending back into the heavens.

For every function that might return an error, there will be three lines of boilerplate:

```go
err := foo()
if err != nil {
	return err
}
```

This bloats functions and obscures their logic. If you have a function that simply calls three other functions, the result is huge:

```go
func myFunc() error {
	err := foo()
	if err != nil {
		return err
	}

	err = bar()
	if err != nil {
		return err
	}

	err = baz()
	if err != nil {
		return err
	}

	return nil
}
```

## Order Dependence

Notice that we're only declaring our `err` variables once (via `:=`) and afterwards we're reassigning to it (via `=`). This is because you're not allowed to re-declare variables in Go.

```go
err := foo()
err := bar() // ERROR: no new variables on left side of :=
```

This means if we wanted to swap the block of code that calls `foo()` with the one that calls `bar()` we'd need to fix up our `:=` and `=` operators or we'll get a compile error:

```go
err = ba() // ERROR: undeclared name: err
if err != nil {
	return err
}

err := foo()
if err != nil {
	return err
}
```

This order-dependence problem is a pain in the ass. Although you may not often need to reorder the existing function calls, it is common to add a new one to the beginning/end, and that produces the same problem.

Luckily Go allows us to merge our assignments into if-statements like so:

```go
func myFunc() error {
	if err := foo(); err != nil {
		return err
	}

	if err := bar(); err != nil {
		return err
	}

	if err := baz(); err != nil {
		return err
	}

	return nil
}
```

This solves the order-dependence problem because the variable declarations are scoped to the if-statement. This is great, until your function also returns another value that you need to use later on:

```go
if val, err := bar(); err != nil { // ERROR: val declared but not used
	return err
}
fmt.Println(val) // ERROR: undeclared name: val
```

The only way to resolve this problem is to put the assignment back on its own line again:

```go
val, err := bar()
if err != nil {
	return err
}

fmt.Println(val) // no error
```

Go will let you re-use variables in the LHS of the `:=` operator so long as they're alongside at least one undeclared variable.

```go
val, err := bar()
val2, err := baz() // no error
```

But if baz changes such that it only returns an error, we'll need to remember to turn the `:=` into a `=`:

```go
val, err := bar()
err := baz() // ERROR: no new variables on left side of :=
```

If this wasn't complex enough, there is an exception to the rule about re-using variables with `:=`. You can't use struct fields on the LHS

```go
s.myField, err := bam() // ERROR: expected identifier on left side of :=
```

For this you'll need to declare `err` separately.

```go
var err error
s.myField, err = bam() // no error
```

You can get around this by writing to a temp variable instead but damn, that's a lot of permutations to keep in mind.

The reason for this fragile system of order-dependent declarations is that, by design, error values really are just like any other value, and unless you want to name your error variables `err1`, `err2`, `err3`,... (which is itself order dependent), you're subject to the exact same rules that apply to the declarations of other variables. Because it's your job to read and bubble-up these errors, you're charged with solving the Rubik's Cube of declarations.

As a user you can also go `var err error` at the top of all your functions, but nobody currently does this and it feels like additional boilerplate. The language itself could the order-dependence problem by permitting variable re-declaration in the same scope, but I'd prefer to not even have to treat errors as variables in the first place.

## Trailing Returns

You may have noticed that our function which calls `foo`, `bar`, and `baz` could be slimmed down by directly returning `baz()` at the end:

```go
func myFunc() error {
	if err := foo(); err != nil {
		return err
	}

	if err := bar(); err != nil {
		return err
	}

	return baz()
}
```

Fewer lines of code, yes, but this just further contributes to order-dependence. I can't just shuffle my function calls around and have everything work:

```go
func myFunc() error {
	if err := foo(); err != nil {
		return err
	}

	return baz()

	// unreachable code

	if err := bar(); err != nil {
		return err
	}
	// ERROR: missing return
}
```

Likewise, if I want to add a new function call after `baz()` I need to resurrect the boilerplate around `baz()` so that it's no longer directly returning. This is the exact problem trailing commas solve! By having the final item in a list slightly different to the other items (whether through a direct return or the lack of a comma), we hinder reordering and the addition of new items. As such, I just have a separate `return nil` at the end of my functions.

## Loops

In the early days I tried slimming things down by constructing a loop like so:

```go
func myFunc() error {
	for _, f := range []func()error{foo, bar, baz} {
		if err := f(); err != nil {
			return err
		}
	}

	return nil
}
```

But by using this loop we're creating a dependence on our function signatures, meaning if e.g. `baz` now returns multiple values, we'll need to dismantle the loop and revert to separate function calls.

## Zero Values

If we want to return both an integer and an error from our function, we need to specify both return values whenever we return. Typically you'll have a heap of returns that use the zero-value of non-errors (e.g. 0 for `int`s) and then at the very end we return a value along with a `nil` error.

```go
func myFunc() (int, error) {
	if err := foo(); err != nil {
		return 0, err
	}

	if err := bar(); err != nil {
		return 0, err
	}

	val, err := baz()
	if err != nil {
		return 0, err
	}

	// ... more stuff

	return val, nil
}
```

This creates a dependency between the non-error return values in our function signature and our error return sites which is completely unnecessary. If we now want to also return a string from our function we'll need to visit each return site and explicitly return the zero value for a string (`""`)

```go
func myFunc() (int, string, error) {
	if err := foo(); err != nil {
		return 0, "", err
	}

	if err := bar(); err != nil {
		return 0, "", err
	}

	val, val2, err := baz()
	if err != nil {
		return 0, "", err
	}

	return val, val2, nil
}
```

This sucks, and would be resolved if Go supported discriminated unions. In Rust, functions can return a Result type (a discriminated union) which contains either an error or some payload of values, meaning returning an error is as simple as `return Err("my error")`, and returning a non-error looks like `return Ok(my_data)`. In a world where Go has a Result type, we can change the type and number of 'ok' return values without needing to go and update all the places we return an error.

## Named return values

Go provides an alternative syntax where you name your return values like so:

```go
func myFunc() (val int, val2 string, err error) {
	err = foo()
	if err != nil {
		return
	}

	err = bar()
	if err != nil {
		return
	}

	val, val2, err = baz()
	return
}
```

But I rarely see anybody use this form and it always catches me off guard when I do stumble across it. _Why on Earth are we just returning nothing here? Oh right we're using names return values_.

I want to live in a world where the function looks like this:

```go
func myFunc() (int, string, error) {
	foo()?
	bar()?
	return baz()?
}
```

Here the question mark tells us that if the function returns an error, we should return that error with zero-values for all the other return values. Otherwise, we return the non-error values from the function. There is a [proposal](https://github.com/golang/go/issues/21182#issuecomment-542416036) addresses the zero-value problem but for now the question mark operator is [off the cards](https://github.com/golang/go/wiki/Go2ErrorHandlingFeedback#recurring-themes).

## Conclusion

What happens when you mix error values, an inability to shadow variable declarations, and a lack of an error-specific control flow mechanism? We get a mess of dependencies where one small change will have you tweaking the boilerplate in a bunch of unrelated lines. Given how nearly every function returns an error, and most functions call multiple other functions, you're left with obscenely bloated code that's hard to change.

In the next post we'll talk about Go's awkward approach to privacy.

_After writing this blog series, I decided I needed to balance out all the negativity of the posts with something positive, so I made a joke programming language to air my grievances with a comedic spin. Feel free to check it out: [OK?](https://github.com/jesseduffield/ok). If you're intimately familiar with Go's history you might spot some easter eggs._

## Addendum

Check out the [follow-up]({{ site.baseurl }}/Questionable-Questionmarks) to this post where I address arguments against importing Rust's '?' operator into Go.
