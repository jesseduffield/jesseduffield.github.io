---
layout: post
title: "Go'ing Insane Part Two: Partial Privacy"
series: going-insane
series-title: 'Part Two: Partial Privacy'
---

Before we start, let me make something clear on the back of the [comments](https://news.ycombinator.com/item?id=28522269) from the first post: this series is my attempt to put absolutely everything on the table that frustrates me when using Go. As such, I'll be doing some extreme nitpicking, much of which people will consider overblown or shortsighted. But my goal is not to do a take-down of the language (I'm stuck writing in it for now anyway), I really just want to get a feel for how many Go devs there are who share my grievances. If none of my grievances bother you, that's fine: we probably differ on values (or I've missed something obvious).

In the last post we talked through Go's error handling issues. In this post I'm going to talk through an issue that is more subtle than error handling, but in my opinion, worse for code structure.

## Privacy via Capitalisation

Unlike in other languages where privacy is controlled with `private` or `public` keywords, Go marks privacy with capitalisation. To mark a function/struct/field as public in Go you need to upcase its first letter:

```go
type MyStruct struct { // public (exported) struct
	name string // private field
	Email string // public field
}

func (s *MyStruct) GetName() { // public method
	return s.name
}

func (s *MyStruct) clearName() { // private method
	s.name = ""
}
```

I find this annoying for three reasons:

### Polluted Diffs

Because the privacy of a struct field is encoded into the name, any code that references that field is now dependent on its privacy level. So if you want make `name` public in `MyStruct`, you'll need to update every place referencing the `name` field. VSCode provides a refactor tool to do this, but even so, your `git diff` will now be polluted by a bunch of lines that have nothing to do with your change, eroding the utility of `git blame`.

```diff
 type MyStruct struct {
-	name string
+	Name string
 	Email string
 }

 func (s *MyStruct) GetName() { // public method
-	return s.name
+	return s.Name // This line shouldn't care about visibility
 }

 func (s *MyStruct) clearName() { // private method
-	s.name = ""
+	s.Name = "" // This line shouldn't care about visibility
 }
```

### Awkward Serialisation

If you want to serialize and deserialize a struct to JSON, you'll need your struct fields to be public, but given that JSON keys typically start with lower-case letters, you'll need to adorn your struct's fields with _struct tags_ to make things work:

```go
type MyStruct struct {
	Name string `json:"name"`
	Email string `json:"email"`
}
```

Struct tags are strings, accessed via reflection. We wouldn't need all this ceremony if we had a `private` keyword instead of using case to communicate visibility.

### Name Collisions And Confusion

It's fairly common in other languages for type names to be capitalised. In another language, you could have a private struct called `Car` and then instantiate an instance of that struct named `car`. In `Go`, if you want the `Car` struct to be private, you'll need to downcase its name, causing this problem:

```go
type car struct {
	sound string
}

func main() {
	car := &car{}
	car.sound = "broom"

	car2 := &car{} // ERROR: car (variable of type *car) is not a type
	car2.sound = "broom broom"
}
```

By declaring a `car` variable we're shadowing the `car` type meaning we can't use re-use it to instantiate a second car. I find this annoying. Yes, you could just call the instance `myCar` or something, but I don't find this easy to read:

```go
myCar := &car{}
myCar.sound = "broom"

myCar2 := &car{}
myCar2.sound = "broom broom"
```

I would much rather use capitalisation to distinguish between types and variables than between private and public, given that if a struct's field is private and I'm using that struct's public interface, I don't even want to know about its private fields, and if I'm _inside_ the struct, I don't need reminders of what is/isn't private because I can modify them all the same and I can easily scroll up to check privacy.

To resolve the ambiguity, I've seen people default to capitalising their structs, and it must be a common enough practice for [talks to have been given](https://about.sourcegraph.com/go/idiomatic-go/) telling people to stop exporting everything¹. From my experience, this isn't a widespread issue in languages with a `public` or `export` keyword in place of capitalisation-based privacy.

Oh well, at least we still _have_ privacy right?

## Not Private Enough

When I say that a `car`'s `sound` field is private, that does not mean that only the `car` struct can read and write to that field.

```go
type car struct {
	sound string
}

func (c *car) Start() {
	// so far so good: accessing a private field from within a method
	fmt.Println(c.sound)
}

// in another file of the same directory
func startCar() {
	c := &car{}
	// WTF? I'm allowed to write to this private field from the outside?
	c.sound = "broom"
	fmt.Println(c.sound) // I'm allowed to read from it?
}
```

It is not merely that privacy modifiers are scoped to the current file, they are scoped to the current _directory_, i.e. the current package. Any other file in this directory is allowed to create a `car` and do whatever sick, twisted things it wants with its ostensibly private fields.

Contrast this to most languages which scope privacy to within a class, or within a file. Rust scopes privacy to a _module_ (analagous to a Go package) but allows you to decide the scope of a module (multiple files, one file, part of a file) so that you can clearly confine the scope of a private field.

```rs
mod foo {
    pub struct Car {
        // this is a private field, so can't be accessed outside the foo module
        sound: String
    }

    impl Car {
        pub fn start(self) {
            println!("{}", self.sound)
        }

        pub fn new(sound: String) -> Self {
            Car{sound: sound}
        }
    }
}

fn main() {
    let car = foo::Car::new(String::from("broom"));
    car.start(); // prints 'broom'
    car.sound // ERROR: private field
}
```

Back in the land of Go, our only means of tightening up our privacy scopes is to give each struct its own package i.e. one file per package:

```
pkg/
  car/
    car.go
    internal/ ('internal' means that the Wheel struct is only accessible to the car package)
      wheel/
        wheel.go
  driver/
    driver.go
```

For whatever reason this approach is [frowned upon](https://about.sourcegraph.com/go/idiomatic-go/). I appreciate the argument that privacy is about locking certain behaviour in place for the sake of clients, and through that lens who cares if a whole package has access to a struct's fields, given that you the author have control over that whole package? Well, I care. I don't want to worry about other files in the same package inadvertently accessing a struct's private fields.

In my experience (admittedly limited to open source), most people just lump a bunch of vaguely related files into the one top-level directory. And remembering that privacy is scoped to the package, the larger the package, the less meaningful those privacy modifiers are.

You might argue that nobody is forcing me to use private fields in some random package file, but if people had the self discipline to only use fields where appropriate we wouldn't need privacy modifiers in the first place. If I'm programing at 2AM I do not trust myself to honour implicit privacy restrictions, I'd much rather my language do that for me. Furthermore, if I'm trying to understand somebody _else's_ project, I can't know where a struct's private fields are mutated without checking the entire package.

Even though I meant it as a joke, I would actually prefer the _OK?_ language's [approach](https://github.com/jesseduffield/ok#all-fields-are-private) to struct-level privacy.

## Too Many Things In Scope

Package-level visibility increases the chance of name collisions and means that at any point in time you may have a bunch of crap in scope that you don't care about. Enums are a prime example.

Enums are constructed like so:

```go
type status int // here I'm creating a `status` type that is really just an integer

const (
	stopped status = iota // iota here means start from 0 and increment each line
	running // 1
	starting // 2
	killed // 3
)

func main() {
	fmt.println(stopped) // prints '0'
}
```

Notice that to print `stopped` I don't actually need to qualify it with `status`, I can just use the value directly. This is because enums are really just a collection of constants that happen to share a type and happen to be assigned mutually exclusive values. And because everything in Go is scoped to the package, this means that if in another file you want to create another enum with a value of the same name, you'll get an error:

```go
type otherStatus int

const (
	running otherStatus = iota // ERROR: running redeclared in this block
	finished
)
```

Suffice it to say I'm not a huge fan of how Go handles enums. And once again, resolving the name collision means creating a whole new package. We'll have our enum sitting in a file that itself sits in a package made just for that enum.

## Conclusion

This peculiar set of language design choices frustrates me: I find package level visibility leads to a polluted scope, with struct invariants being harder to ensure, and the obvious workaround (putting everything in its own package) is both awkward and un-idiomatic. The lack of a `private` or `public` keyword similarly complicates things for no obvious benefit.

Go could resolve the privacy scoping issue by allowing something like Rust's `mod` keyword. But of course, Go's forte is simplicity and I don't expect such a change to ever be accepted.

Up next we're going to talk about interfaces.

_After writing this blog series, I decided I needed to balance out all the negativity of the posts with something positive, so I made a joke programming language to air my grievances with a comedic spin. Feel free to check it out: [OK?](https://github.com/jesseduffield/ok). If you're intimately familiar with Go's history you might spot some easter eggs_

## Footnotes

1. That talk bundled a few different concepts together when deeming the many-packages approach an anti-pattern, so it's hard to say how much the one-struct-per-package part alone is actually frowned upon. But I'm fairly confident the community does indeed frown upon trying to break up packages into heaps of subpackages for the sake of restricting privacy scopes. And even if that were not the case, the fact you need to go and create separate packages is burdensome.
