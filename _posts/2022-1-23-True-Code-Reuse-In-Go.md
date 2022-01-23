---
layout: post
title: True Code Reuse In Go
---

If you google 'Code Reuse In Go' and read through the first two pages of results, you'll see many of the same concepts come up:

- Composition > Class Inheritance
- Go lacks class inheritance
- Go achieves polymorphism through interfaces
- Struct embedding makes this easier

We can all agree that class inheritance is problematic because it can lead to rigid class hierarchies and often it makes more sense to model relationships between objects as _has-a_ (composition) rather than _is-a_ (inheritance). So it's suspicious that the Gang Of Four whose design patterns book popularised the phrase 'Favour composition over class inheritance' went on to fill that book with design patterns that almost all involved class inheritance.

Something's going on. I feel a discussion on what's so bad about class inheritance could benefit from spending more time asking: what's so _good_ about class inheritance, such that its absence can feel so stunting to Go newcomers? Turns out it has nothing to do with class hierarchies.

Reading through the typical blog post on the topic, you'll be told that the closest relative to class inheritance in Go is struct embedding. The idea is that you can wrap an interface in your struct and in doing so, you can forward method calls to that embedded struct. To give a classic (and infamous) example, your car struct can embed an engine to handle engine-ey stuff:

```go
type mycar struct {
	*engine
}

type engine struct{}

func (e *engine) start() {
	fmt.Print("broom")
}

func main() {
	car := mycar{engine: &engine{}}
	car.start() // prints 'broom'
}
```

So much for class inheritance! Go has everything we need. Or does it? Note that above I said that with struct embedding you can _forward_ methods to embedded structs. _Forwarding_ is not the same as _delegating_.

As stated in [Effective Go](https://go.dev/doc/effective_go#embedding):

> There's an important way in which embedding differs from subclassing. When we embed a type, the methods of that type become methods of the outer type, but when they are invoked the receiver of the method is the inner type, not the outer one.

Our engine has no access to the other fields in our car: it only has access to its own fields. When you call `car.start()` it's just syntactic sugar for `car.engine.start()`. So, if I add a `startSound` field to my `mycar` struct, I can't make use of that in my `engine` struct:

```go
type mycar struct {
	*engine
	startSound string
}

type engine struct{}

func (e *engine) start() {
	// ERROR: e.startSound undefined (type *engine has no field or method startSound)
	fmt.Print(e.startSound)
}

func main() {
	car := mycar{engine: &engine{}}
	car.start()
}
```

Damn! With delegation, the receiver in our embedded struct `engine` could actually point to the embedding struct `mycar`. Let's look at an example where delegation is called for.

Say I had various structs representing people, each with a `GetName()` method. I want a way to allow these people to greet you in their native language.

```go
type HasName interface {
	GetName() string
}

type SimpleNamedPerson struct {
	name string
}

func (p *SimpleNamedPerson) GetName() string {
	return p.name
}

type ComplexNamedPerson struct {
	firstname string
	lastname  string
}

func (p *ComplexNamedPerson) GetName() string {
	return fmt.Sprintf("%s %s", p.firstname, p.lastname)
}

type Greeter interface {
	Greet()
}
```

That is, I want to find a way to have both `SimpleNamedPerson` and `ComplexNamedPerson` implement the `Greeter` interface.

We could introduce a couple of greeter functions like so:

```go
func GreetInEnglish(p HasName)  {
	fmt.Printf("Hello %s\n", p.GetName())
}

func GreetInFrench(p HasName) {
	fmt.Printf("Bonjour %s\n", p.GetName())
}
```

This is what's typically recommended in blog posts that talk about type embedding: you enable polymorphism by having a function take an instance of an interface and then make use of that instance's methods. But how does this help us satisfy the `Greet` interface? We could define the `Greet()` function in our struct and call the language-specific greet function from within:

```go
func (p *SimpleNamedPerson) Greet() {
	GreetInEnglish(p)
}

func (p *ComplexNamedPerson) Greet() {
	GreetInFrench(p)
}
```

But now we're hardcoding the language of our person. Who says all complex-named people speak French? We could pass in a `greetFn` when creating our person instance:

```go
type SimpleNamedPerson struct {
	name    string
	greetFn func(HasName)
}

func NewSimpleNamedPerson(name string, greetFn func(HasName)) *SimpleNamedPerson {
	return &SimpleNamedPerson{name: name, greetFn: greetFn}
}

func (p *SimpleNamedPerson) Greet() {
	self.greetFn(p)
}
```

But this isn't very flexible: if we want to promote our 'Greeter' interface to 'Speaker' and add a `SayGoodbye` method we'd need to explicitly add a `sayGoodByeFn` to each struct and call it from a `SayGoodBye` function:

```go
type Speaker interface {
	Greet()
	SayGoodbye()
}

type SimpleNamedPerson struct {
	name    string
	greetFn func(HasName)
	sayGoodbyeFn func(HasName)
}

...

func NewSimpleNamedPerson(
	name string,
	greetFn func(HasName),
	sayGoodByeFn func(HasName),
) *SimpleNamedPerson {
	return &SimpleNamedPerson{name: name, greetFn: greetFn, sayGoodByeFn: sayGoodbyeFn}
}

func (p *SimpleNamedPerson) SayGoodbye() {
	self.sayGoodbyeFn(p)
}
```

Can struct embedding save us? It actually can, with a little extra effort. Let's create some 'speaker' structs which themselves embed an instance of the `HasName` interface.

```go
type EnglishSpeaker struct {
	HasName
}

func (s *EnglishSpeaker) Greet() {
	fmt.Printf("Hello %s\n", s.GetName())
}

func (s *EnglishSpeaker) SayGoodbye() {
	fmt.Printf("Goodbye %s\n", s.GetName())
 }

func NewEnglishSpeaker(person HasName) Speaker {
	return &EnglishSpeaker{HasName: person}
}

type FrenchSpeaker struct {
	HasName
}

func (s *FrenchSpeaker) Greet() {
	return fmt.Printf("Bonjour %s\n", s.GetName())
}

...
```

And then we tweak our person struct to now embed a speaker, and pass in the speaker in the constructor.

```go
type SimpleNamedPerson struct {
	name    string
	Speaker
}

func NewSimpleNamedPerson(name string, makeSpeaker func(HasName) Speaker) *SimpleNamedPerson {
	p := &SimpleNamedPerson{name: name}
	p.Speaker = makeSpeaker(p)

	return p
}

func main() {
	person := NewSimpleNamedPerson("Jesse Duffield", NewEnglishSpeaker)
	fmt.Println(person.GetName()) // prints "Jesse Duffield"
	person.Greet() // prints "Hello Jesse Duffield"
	person.SayGoodbye() // prints "Goodbye Jesse Duffield"
}
```

Here's a diagram of what's happening:

![]({{ site.baseurl }}/images/posts/go-traits/sequence.png)

Mission accomplished: You can add new methods to our Speaker interface, using our `person` structs' methods in new ways, without needing to update the `person` structs themselves! This is the kind of code-reuse I was looking for when I started using Go. Yes, using vanilla interfaces and struct embedding is technically a form of code reuse, in the same way that a single standalone function enables code-reuse. But when somebody googles code reuse mechanisms, they typically have something more powerful in mind, and I'd say this pattern hits the spot.

I haven't come across any online posts talking about this pattern in Go (I'm sure they exist) so until somebody tells me the real name, I'm calling this the Go Trait Pattern. Adding 'delegation' to the name wouldn't suit given how most people conflate delegation with forwarding, and given how closely our embedded struct in this pattern resemble's Rust's traits, I think the name fits. If your trait contains its own state, you could call it a mixin, but that's up to you. With this pattern, the trait (i.e. the embedded struct: `EnglishSpeaker` and FrenchSpeaker`) defines an interface that the embedder (`SimpleNamedPerson`, `ComplexNamedPerson`) must satisfy, and the deal is that if the embedding struct can satisfy that interface, the trait will reward it with extra functionality. Unlike with forwarding, here the embedded struct can actually make use of logic defined in the embedding struct.

In the broader context of programming, this pattern is nothing new. It's just classic delegation. In 1994, Grady Brooch defined delegation like so:

> Delegation is a way to make composition as powerful for reuse as inheritance. In delegation, two objects are involved in handling a request: a receiving object delegates operations to its delegate. This is analogous to subclasses deferring requests to parent classes. But with inheritance, an inherited operation can always refer to the receiving object through the this member variable in C++ and self in Smalltalk. To achieve the same effect with delegation, the receiver passes itself to the delegate to let the delegated operation refer to the receiver.

You might be thinking: doesn't this just re-introduce the fragile base-class problem? Not so! Our trait decides what interface the embedding struct must satisfy, and can only interact with it through that interface. Likewise, the embedding struct can override methods on the trait, but doing so won't actually affect the trait's behaviour. For example, if `SimpleNamedPerson` defines their own `Greet()` method, it will simply shadow the trait's own `Greet()` method.

The ability for method invocations to go in both directions is the secret sauce that most Go newcomers are looking for when they ask about inheritance, and struct embedding with basic forwarding does not fill the void, but the trait pattern can.

There are some things worth keeping in mind. Firstly, Go lacks contravariance, meaning the general rule that functions should accept interface values and return concrete types doesn't work here. `NewEnglishSpeaker` needs to return `Speaker` if it is to be passed as the `makeSpeaker` argument. This isn't a huge deal: you can always just make a separate function for that. Don't forget that we don't always need to inject the trait into the constructor: If we're only dealing with english speakers, we could directory use `p.Speaker = NewEnglishSpeaker(p)`

Another thing to note is that our person constructor is a little weird:

```go
func NewSimpleNamedPerson(name string, makeSpeaker func(HasName) Speaker) *SimpleNamedPerson {
  p := &SimpleNamedPerson{name: name}
  p.Speaker = makeSpeaker(p)

  return p
}
```

We need to first partially build the struct, then assign the speaker field to finish it off. In any other context I'd consider this a red flag because it demonstrates they're a circular dependency, but it seems to be our only option with the trait pattern, and I don't consider it dangerous. Go uses a mark and sweep garbage collector so it handles circular dependencies fine.

One final implication of this approach is that when I call `person.Greet()` we're using dynamic dispatch twice: that is, we call `Greet()` on our trait interface which in turn calls `GetName()` on our embedding struct, also through an interface. This means we have to traverse a couple of pointers to get the functions we want. But, in my opinion, it's worth the cost, and Go provides no alternative that I know of.

So there you have it, the trait pattern. Do you need to use it? No? But you might come across a situation where it proves useful. My typical post contains some embarrassing oversight or error, so I look forward to finding out what it is this time. At any rate, see you in the next post!

## Addendum

Here are the posts I read through in the first two pages of googling 'Code Reuse in Go':

https://tinystruggles.com/2015/08/29/golang-code-reuse.html

https://yourbasic.org/golang/inheritance-object-oriented/

http://jmoiron.net/blog/idiomatic-code-reuse-in-go/

https://cdmana.com/2021/08/20210831152245884I.html

https://medium.com/swlh/what-is-the-extension-interface-pattern-in-golang-ce852dcecaec

https://blog.birost.com/a?ID=01100-f026fb15-5faf-4e5c-95d2-c8cf675f18e0

https://go.dev/doc/effective_go#embedding

https://www.jawahar.tech/blog/golang-inheritance-vs-composition

https://www.toptal.com/go/golang-oop-tutorial

https://developpaper.com/golang-interfaces-are-nested-to-realize-the-operation-of-reuse/

https://dev.to/makalaaneesh/golang-for-object-oriented-people-l7h

https://medium.com/applike/how-to-using-composition-over-inheritance-6681ed1b78e4

In this post I've contended that the good thing about inheritance is two-way method invocation, but if you want to learn much more about it's various features, and how they can be ported in a non-inheritancey way, read [this](https://pling.jondgoodwin.com/post/delegated-inheritance/).
