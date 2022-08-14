---
layout: post
title: Trailing Commas Are Just The Beginning
---

Trailing commas, also known as dangling commas, are a formatting strategy that's grown in popularity over time. Only 2 years ago did Prettier (a javascript formatter) start enforcing trailing commas by default, and if you read the associated GitHub [issue](https://github.com/prettier/prettier/issues/68) you'll see how hard-fought the change was. In this post I'm going to explain why trailing commas fix the problem of position-depedence and how position-dependence gets in our way in a bunch of other contexts too.

Firstly, what's the point of trailing commas?

## Avoiding Diff Pollution

Consider the following array, defined over multiple lines:

```js
const arr = [
  foo,
  bar,
  bam
]
```

This array does _not_ have a trailing comma. If you want to add a new entry into my array at the end, you need to append a comma to `baz` before adding the new line:

```js
const arr = [
  foo,
  bar,
  bam,
  baz
]
```

Meaning this is what our diff looks like:

```diff
 const arr = [
   foo,
   bar,
-  baz
+  baz,
+  bam
 ]
```

This has a minor cost when reading a pull request, because it makes it think that the `baz` item is important when it's not: it's just a formatting change. But in my opinion there is also a major cost in that a git blame on the `baz` line will now show the name of the person who added `bam`, rather than the person who originally added `baz`. When your coworker furiously walks up to you and demands what was going through your head when you decided to add baz to that array, costing the company millions of dollars for your imprudence, you'll need to ask them to calm down and look at the actual diff to see that it was just a formatting change on your end and that if you walk backwards through the commits to the point where `baz` was actually added, you'll find it was actually _Dave_ who added that item, the bastard.

Needless to say, polluting diffs with arbitrary formatting changes is not great when you want to quickly find out who's behind a certain change.

## Allowing easy rearranging

What if I decided that `bam` should be the first element in my array? Either because of how the array will be processed or just because I want it next to `foo` which is conceptually related. In my editor I can easily go and move the line up:

```js
// Word to the wise: DO NOT add baz to this array. Especially if your name is Dave.
const arr = [
  bam
  foo,
  bar,
]
```

Except this is no longer valid code: I need to add a comma to `bam` and if my org never uses trailing commas I need to remove the comma from `bar`.

## The crux of the matter

The trailing comma pattern is not some quirk of formatting. At it's core, it's about position-dependence. When a given line only has a comma based on its position in some list, then we need to fiddle with commas whenever a new item is added or when the list is reordered.

Sometimes, things are in specific positions for good reason. For example, you wouldn't want to reorder these two lines:

```js
const a = 'foo'
console.log(a)
```

But much of the time, re-ordering lines leads to cleaner code: related things can be closer together, and variables that live for too long can have their live-time reduced by shifting them down closer to where they're actually used in a function.

The kind of position dependence I care about is the _unnecessary_ kind where you need to pollute your diffs and fiddle with formatting whenever you want to do something as simple as add an item to a list or move an item.

So, what other language constructs create position dependence?

## Javascript: Multi-line const declarations

In Javascript you can declare multiple variables on multiple lines, comma-separated:

```js
const a = 'foo',
  b = 'bar',
  c = 'baz', // DAMN YOU DAVE!
  d = 'bam'
```

This is actually worse than a simple array because not only do you pollute the diff when adding an item, you also pollute the diff if you want to add add/move an item to the top:

```js
const lmao = 23,
  a = calc(lmao),
  b = 'bar',
  c = 'baz',
  d = 'bam'
```

Having each variable on its own line means we duplicate the `const` keyword, but it's well worth it in my opinion.

Check out the eslint [lint](https://eslint.org/docs/latest/rules/one-var-declaration-per-line) for this if this pattern has bothered you.

## Go: errors

Let me preface this by saying that for all its flaws, Go actually does enforce trailing commas on arrays, structs, and even function arguments, when spread across multiple lines. So kudos to Go for that. Nonetheless there's plenty more position dependence to go around within the language.

Here we want to call three things in sequence where each may return an error.

```go
func blah() error {
  if err := foo(); err != nil {
    return err
  }

  if err := bar(); err != nil {
    return err
  }

  return baz()
}
```

We're opportunistically avoiding the `if err...` construct with `baz` because we can just return the error directly. But if we want to do something after `baz` we'll need to switch it to the `if err` construct:

```go
func blah() error {
  if err := foo(); err != nil {
    return err
  }

  if err := bar(); err != nil {
    return err
  }

  if err := baz(); err != nil {
    return err
  }

  return bam()
}
```

This is why you'll often see this seemigly redundant boilerplate in a function to avoid the position dependence:

```go
func blah() error {
  if err := foo(); err != nil {
    return err
  }

  if err := bar(); err != nil {
    return err
  }

  if err := baz(); err != nil {
    return err
  }

  if err := bam(); err != nil {
    return err
  }

  return nil
}
```

What about adding an item to the beginning of the list? In the above example you can do that easily, but what about this one:

```go
func blah() error {
  b, err := bar();
  if err != nil {
    return err
  }

  return bam(b)
}
```

I'm not using the `if err` construct here because I need `b` to be in scope for later. What if I want to add another call at the top of the function:

```go
func blah() error {
  a, err := foo();
  if err != nil {
    return err
  }

  var b B
  b, err = bar();
  if err != nil {
    return err
  }

  return bam(a, b)
}
```

I can't use the `:=` construct with `err` on the line that calls `bar` because `err` has already been declared. And I can't mix a declaration and a reassignment on one line, meaning I need to declare b on its own line now too, which means I need to remember what its explicit type actually is because standalone variable declarations require that. Damn! You can get around this by just having `errA` and `errB` but I haven't actually come across that pattern very often.

## Go: Enums

In go, You create an enum like so:

```go
type Blah int
const (
  Foo Blah = iota
  Bar
  Baz
)
```

That `iota` keyword means to start at zero and increment for each enum down the list. `Foo` is a de-facto default value because if you don't explicitly assign a value to a `Blah` variable, its value will be zero. If I decide that instead Baz makes more sense as a default, it's not as easy as rearranging lines, and again the diff gets polluted.

## Go: Method chains

I know I harp on Go a lot but what can I say, I spend lots of time writing it. Nonetheless, here's the last Go example. Multi-line method chains on Go require that the period be trailing, not leading.

```go
Thing.
  foo().
  bar().
  baz()
```

Exact same problem that trailing commas solves. If you used leading periods, life would be easier:

```go
Thing
  .foo()
  .bar()
  .baz()
```

I should mention I also find leading periods easier to read.

## Rust: clones

Thought I would let Rust off the hook, did you? It's a testament to rust that this problem has nothing to do with formatting, but it's nonetheless something I've encountered in my own code. If you're not in a hot path and you're happy to clone things when needed, you can end up with something like this:

```rust
fn haha() {
  let a = owned_val();
  foo(a.clone());
  bar(a.clone());
  baz(a);
}
```

Of course you can just clone `a` again when calling `baz`, but then you'd be wasting precious memory!

This is not something I _commonly_ come across and it should be obvious the above is a contrived example, but it is a thing.

## What else?

If you know of a similar example of unnecessary position dependence in your language of choice let me know and I'll add it to this list.

Thanks for reading!
