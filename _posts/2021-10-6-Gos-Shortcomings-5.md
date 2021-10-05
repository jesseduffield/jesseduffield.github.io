---
layout: post
title: "Go'ing Insane Part Five: Crazy Conventions"
series: going-insane
series-title: 'Part Five: Crazy Conventions'
---

First off, let's get the standard caveats out of the way:

- The purpose of these posts is not to denigrate the language: it's to see who shares my grievances
- These things bother me, they may not bother you. Much of what I take issue with is considered nitpicking and I don't disagree
- I'm not an authority on Go, I just use it in open-source projects
- On average these posts contain at least one embarrassing error. If you're reading near the time of publication, you may spot such an error
- Many Gophers value simplicity over richness, some believing simplicity actually affords more expressiveness than richer languages. I disagree but understand
- This series does not attempt to be balanced. There are many good things about Go (fast compile times, compatibility, etc), but there are plenty of other posts talking about those. Do not let this series alone determine your perspective on Go

With that out of the way, let's begin.

I find myself disagreeing with much of what is considered idiomatic or good practice in Go. Let's go through some examples.

## Package Names

The _Effective Go_ guide tells me to use single-word package names, [claiming](https://golang.org/doc/effective_go#package-names):

> By convention, packages are given lower case, single-word names; there should be no need for underscores or mixedCaps

That's like sending somebody into a battlefield with a single magazine of ammunition and telling them there should be _no need_ for extra ammo. That's all well and good until there _is_ a need. This convention dooms anybody with a sufficiently complex project to eventually break convention and write what the authors would call _Ineffective Go_.

It doesn't take much digging to find awkward applications of this rule in Go's lauded open source projects Kubernetes, Docker, Cockroach DB, and Hugo: see [kubeapiserver](https://github.com/kubernetes/kubernetes/tree/master/pkg/kubeapiserver), [credentialprovider](https://github.com/kubernetes/kubernetes/tree/master/pkg/credentialprovider), [cloudprovider](https://github.com/kubernetes/kubernetes/tree/master/pkg/cloudprovider), [serviceaccount](https://github.com/kubernetes/kubernetes/tree/master/pkg/serviceaccount), [securitycontext](https://github.com/kubernetes/kubernetes/tree/master/pkg/securitycontext), [resolvepath](https://github.com/docker/compose-cli/tree/main/cli/mobycli/resolvepath), [generatecommands](https://github.com/docker/compose-cli/tree/main/cli/metrics/generatecommands), [livereload](https://github.com/gohugoio/hugo/tree/master/livereload), [docshelper](https://github.com/gohugoio/hugo/tree/master/docshelper), [clusterversion](https://github.com/cockroachdb/cockroach/tree/master/pkg/clusterversion), [featureflag](https://github.com/cockroachdb/cockroach/tree/master/pkg/featureflag), [scheduledjobs](https://github.com/cockroachdb/cockroach/tree/master/pkg/scheduledjobs), [spanconfig](https://github.com/cockroachdb/cockroach/tree/master/pkg/spanconfig), and [startupmigrations](https://github.com/cockroachdb/cockroach/tree/master/pkg/startupmigrations). Does anybody really think that `docshelper` (which I reflexively pronounced as 'Dock Shelper' on first pass) is preferable to `docs_helper`?

There is simply no way that you can find a single word to describe every package you write, and even if you could, it's not desirable for readability. Cheating by having each word being its own directory (e.g `startup/migrations`) doesn't count, and god forbid you ever want to name a package 'human_skill'. Perhaps the idea behind this rule was to make people think really hard about simple package names, by applying a shame cost for anybody being too wordy, but by taking underscores and mixed caps off the table, it hurts readability on net.

## Variable names

The Go team are on the same page around short variable names (see [here](https://research.swtch.com/names), [here](https://talks.golang.org/2014/names.slide#1), and [here](https://www.lysator.liu.se/c/pikestyle.html)). Short but descriptive is typically what's proposed. Hard to argue with that, but some examples given stand in stark opposition to my own preferences:

Rob Pike [says](https://www.lysator.liu.se/c/pikestyle.html)

> I say maxphysaddr (not MaximumPhysicalAddress)

Shortening `Maximum` to `max` I get, but is `physaddr` really preferable to `PhysicalAddress`?

This slide [says](https://talks.golang.org/2014/names.slide#7)

```go
// GOOD
func RuneCount(b []byte) int {
	count := 0
	for i := 0; i < len(b); {
		if b[i] < RuneSelf {
			i++
		} else {
			_, n := DecodeRune(b[i:])
			i += n
		}
		count++
	}
	return count
}

// BAD
func RuneCount(buffer []byte) int {
	runeCount := 0
	for index := 0; index < len(buffer); {
		if buffer[index] < RuneSelf {
			index++
		} else {
			_, size := DecodeRune(buffer[index:])
			index += size
		}
		runeCount++
	}
	return runeCount
}
```

Has there been a mix-up here? I find the 'BAD' example far more natural.

I rarely find tiny variable names easier to read than their longer counterparts. I'll use single-letter loop iterators but otherwise I want to read code like I would read a book: _in English_.

## Receiver Names

Speaking of short variable names, consider this from the [wiki](https://github.com/golang/go/wiki/CodeReviewComments#receiver-names):

> The name of a method's receiver should be a reflection of its identity; often a one or two letter abbreviation of its type suffices (such as "c" or "cl" for "Client"). Don't use generic names such as "me", "this" or "self", identifiers typical of object-oriented languages that gives the method a special meaning. In Go, the receiver of a method is just another parameter and therefore, should be named accordingly. The name need not be as descriptive as that of a method argument, as its role is obvious and serves no documentary purpose. It can be very short as it will appear on almost every line of every method of the type; familiarity admits brevity.

The idiom that struct receivers should only be one or two letters strikes me as particularly crazy. I have an unfounded, uncharitable, probably false conspiracy theory that single-letter variable names were actually pushed as idiomatic to prevent naming collisions with private types (whose names are lower-case). Ignoring that theory for now, I can count on one hand the number of times I've made a struct whose name I haven't eventually had to change. And some of them are found in this blog series. When we go from:

```go
type Car struct {
	// ...
}

func (c *Car) Start() {
	// ...
}

func (c *Car) Stop() {
	// ...
}
```

... to ...

```go
type Vehicle struct {
	// ...
}

func (c *Vehicle) Start() {
	// ...
}

func (c *Vehicle) Stop() {
	// ...
}
```

... you need to go and change that stupid pointer receiver name to `v` in every single method defined on the struct. To quote a certain fashion designer, this makes me _Feel Like I'm Taking Crazy Pills_. If there's a way to do this in one go, it sure doesn't exist in VSCode and the fact it probably does exist in the pay-to-play Goland is no consolation. Even if this feature did exist, it's one more step I shouldn't have to perform when refactoring.

When working on the [_OK?_ language](https://github.com/jesseduffield/OK) (heavily inspired by everything in this series) I found myself copy+pasting countless structs in the AST package with small modifications and after my twentieth time updating the receiver name I decided to just use [`self`](https://github.com/jesseduffield/OK/blob/master/ok/ast/ast.go), idioms be damned.

There are two arguments I see for why Go should _not_ use a catch-all receiver name like `self`:

1. `self` is misleading given Go's specialness
2. `self` can lead to bugs when refactoring

Let's consider these one at a time.

### 'self' is misleading given Go's specialness

What makes Go special compared to other languages, when it comes to receivers? Off the top of my head:

#### You can call methods on nil struct values

The fact that you can call `foo.bar()` when `foo` is `nil` does not necessarily follow from the fact that receivers are passed into method calls as if they were any other argument. Ignoring the fact that discriminated unions (e.g. Rust's `Option` type) would render this all moot, there's nothing stopping the language from doing a `nil` check when you call a method on `foo`, and I'm not yet convinced that doing so is such a bad idea. Even if you believed doing so would be a _very_ bad idea, the use of single-letter receiver names did nothing to prepare me for the nil-method-call revelation.

Maybe that just means I'm stupid, but I think most of the intuition has nothing to do with the receiver name, and has everything to do with the appearance of the call site. I appreciate that swapping out method calls for overloaded functions has its own downsides, but if we really wanted to remove the ambiguity, that would prove far more effective than worrying about the receiver name.

#### The receiver is not necessarily a pointer

Rust uses `self` whether you're dealing with a reference or a copied value, and I don't see anybody complaining there. If you replace a series of mutations with a immutative method chain that produces a new object on each call, I don't see how all of a sudden `self` becomes inappropriate: you're still basically doing the same thing. You could argue that it is confusing, but I don't find a single-letter substitute any less confusing.

#### A struct's method can be called with some other receiver passed in explicitly

In Go, `(*Foo).Bar(foo)` is the same as `foo.Bar()` (where `foo` is of type `*Foo`). I don't see this pattern very often, and I still don't see how it makes `self` suddenly inappropriate.

Perhaps you think that some of the above cases _are_ sufficiently weird with `self` that we should avoid it, but then why not have a convention that says _use `self` when it's appropriate, otherwise use whatever you would use if dealing with a regular argument_. If anything, that would allow for even more expressive code because based on the receiver name you'll know whether methods are being used as convenient syntactic sugar or whether they're used for the common use case of encapsulating the access and mutation of an object.

### Not special enough

Every language handles receivers differently: JavaScript has special scoping for `this`, Python's `self` is just another variable. People seem perfectly capable of switching between those languages and dealing with the differences; I'm not convinced by the argument that Go is so special that you now need to follow an idiom that makes refactoring harder just in case you carry across the wrong intuitions from other languages. Chances are those intuitions are coming along with you no matter what you name the receiver and you'll just need to work out what the differences are, as is the case when learning any language.

Consider that in Go, an array is not extensible: only slices can be extended. Yet the equivalent of a slice in Javascript and Ruby is called an 'array'. Should we rename 'array' to 'apple' to remove the chance of confusion? No, because 'array' is still a pretty good name and developers are smart enough to work out the differences.

I'd rather have a roughly applicable intuition from another language than a completely novel, completely annoying idiom to follow.

So, let's now move onto a different argument in favour of struct-specific receiver names:

### 'self' can lead to bugs when refactoring

Here is where we go from saying _Go is special_ to _every other language is wrong_.

When I first came across this [argument](https://blog.heroku.com/neither-self-nor-this-receivers-in-go#reshaping-our-code) I found it pretty sensible, but the more I think about it, the less it resonates: the idea is that if you have `self` being used in a method, and you want to cut+paste that method to some other struct, there is a slight chance that:

1. you forget to rename a `self`
2. That `self` is being used as an argument to a method call that takes an interface which both the original struct and the new struct implement
3. This produces a bug

Consider that there are only three times you're going to have `self` included in a chunk of code being copy pasted from one struct to another:

1. when accessing `self.myField`
2. when calling `self.myMethod()`
3. when passing `self` as an argument to another function

In cases 1 and 2, the fact you're copying that code means there's a good chance you're moving `myField` or `myMethod` into the new struct as well, which means continuing to use `self` is perfectly fine. If you're dealing with public fields/methods then the only risk is that those same fields/methods exist in the destination struct, which again I find unlikely. As for case 3, am I the only one who considers passing `self` as an argument a code smell? I hate when people invoke code smells to win an argument so take this with a grain of salt but if a struct passes itself as an argument that tells me it knows too much. If I'm missing a common use case where this practice is completely sensible please let me know.

So yes, it is possible that when moving code from one struct to another, you can run into this problem, but I consider the problem too minimal for me to disavow `self`.

Let's say this refactoring issue arised all the time for you. If you really wanted to streamline things you would just name your receivers as if they were regular function arguments. Then you really wouldn't need to make many changes when doing these refactorings. Yet Go doesn't advocate that: it advocates one or two-letter receiver names, because [_Familiarity Admits Brevity_](https://github.com/jesseduffield/ok#familiarity-admits-brevity). Sounds like the worst of both worlds to me: now you need to update naming when updating struct names _and_ when moving code between structs, because once the receiver name is just a regular variable, you'll be using a sensible-length name again.

At any rate, I find that `self`'s universally understood meaning as 'the thing this method revolves around' makes it perfectly sensible to use as a receiver name, especially considering the struct type sits right there in the method header. Compare this to an arbitrary one-letter receiver name that you need to keep changing. Would I introduce a `self` keyword to be enforced? No, but I see no reason why there exists an idiom scorning its use.

## Conclusion

The idiom for short package names offers no solution for complex situations. The idiom for short variable names results in code that I find cryptic and obscure. And the idiom for single-letter receiver names sacrifices readability in the name of reducing confusion.

The fact I disagree with these idioms doesn't really bother me. Every language will have idioms that people disagree with. What bothers me is that the Go team felt the need to dictate these idioms for the rest of us in the first place.

It would be uncharitable of me to ascribe status-quo bias to everybody who defends these idioms (maybe I'm the one with status quo bias given the legacy of `self` in prior languages), but I simply cannot imagine the community having landed on these idioms independently, and now that they're in place, many go to great lengths to defend them. Yes, one of the main reasons for having idioms is to reduce fragmentation, but with our current idioms being so questionable, we _already_ have fragmentation! The only difference is that people violating the current idioms do so with a hint of shame: the kind of shame that turns into anger and inspires one to write a six part critique of the language!

Speaking of which, it's time to finish this series with Part Six: whose title I'm yet to decide on, but you can rest assured it will contain alliteration.
