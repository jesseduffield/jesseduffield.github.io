---
layout: post
title: "Encapsulation Is Not Free"
---

So, you've made an open source project that is successful enough to require internationalisation. Where once upon a time you could just write an error message inline, now you need to support that error message in multiple languages:

```go
func foo() {
    err := bar()
    if err != nil {
        // What about french speakers?
        return errors.New("Bar failed!")
    }
}
```

So maybe you can just add an if statement and return a different error depending on the language:

```go
func foo() {
    err := bar()
    if err != nil {
        var errorMessage string
        if LANGUAGE == "fr" {
            errorMessage = "Bar a échoué!"
        } else {
            errorMessage = "Bar failed!"
        }

        return errors.New(errorMessage)
    }
}
```

But this is not going to scale: every place in your code that contains a user-facing message must now have this conditional logic included. That makes it very difficult to add support for a new language, and it obfuscates your business logic.

And so, we must _encapsulate_¹! Our business logic should not care what language is being used, so we can encapsulate our language-specific code behind an interface.

```go
// i18n.go
type TranslationSet struct {
    BarFailed string
}

var French = TranslationSet{
    BarFailed: "Bar a échoué!"
}

var English = TranslationSet{
    BarFailed: "Bar failed!"
}

func GetLanguageFromLangEnv() TranslationSet {
    lang := os.Getenv("LANG")
    if strings.HasPrefix(lang, "fr") {
        return French
    }
    // Default to English
    return English
}

Tr = GetLanguageFromLangEnv()
...

// foo.go
func foo() {
    err := bar()
    if err != nil {
        return errors.New(i18n.Tr.BarFailed)
    }
}
```

Notice what we've done: we started with an implicit interface (i.e. all the messages you want to show the user) and a single concrete implementation (i.e. the actual English strings for each message). We then made that interface _explicit_ (by creating the `TransationSet` struct) and tied our concrete implementation to that explicit interface (by creating the `English` and `French` structs).

Now, our conditional logic lives inside the `GetLanguageFromLangEnv` function which means:
* all of our business logic is immune to changes relating to message wording
* if a new language is added, we don't need to make a bunch of changes to business logic code
* it's clear what strings need to be implemented if a new language is added because it's all defined in our TranslationSet struct

This is the power of encapsulation.

But...

_Encapsulation is not free._ When you encapsulate, you make a deal with the devil. The deal is this: when you want to change an implementation (e.g. tweaking the wording of a message) or you want to add a new implementation (e.g. adding a German translation) it's easy, but when you want to change the interface, it's hard.

And with i18n, you are _constantly_ changing the interface! Any time you want to add a new string, you need to add a new field on the `TranslationSet` struct and then implement it on your language structs, and then refer to the new field in the business logic code. That's a lot more work than before when you could just write English inline!

This is the tradeoff. When you actually need to support multiple languages, the tradeoff is worth it because the alternative is that you have a bunch of language-specific conditional logic strewn throughout your codebase.

But _encapsulation is not free._

If an oracle approached you at the start of a new project and told you that you would only ever have English speaking users, and that you will never need to support other languages, you would be much better off keeping the interface implicit and defining all the strings inline.

Unfortunately, oracles do not regularly advise humans on what the future holds, so we are charged with the responsibility of preparing for the future as best we can. Adding internationalisation to a project after accruing years worth of inline strings is a huge pain in the ass: perhaps it's better to do it sooner than later. But perhaps not.

It's worth taking stock of all the places that you are currently encapsulating, and what it's costing you.

## Single Page Applications

In modern times, web apps are typically made as a Single Page Application (SPA) where you have something like a react frontend talking to a backend API over a network. SPAs rose in popularity because they allowed the frontend to be more responsive and dynamic, compared to sending every user action over the wire to be handled by a server. Another perceived benefit is the clear separation of presentation and business logic, meaning you could ostensibly add another client (like a mobile app, or an external API client) without needing to change the API. That is, the backend code is encapsulated from the frontend code.

But _encapsulation is not free._

In the days before SPAs (ancient times, I know²), loading a page all happened on the server: you would pull the info you needed from the database and directly build the HTML to return to the browser. Adding a new page was simple.

Compare that to now: in order to add a new page to a site, you'll typically design some new routes in your API, implement them, then get the frontend to call those routes and manipulate the data to produce the desired HTML. This typically happens across two different languages meaning two different teams are involved in the one page.

This wouldn't be so bad if the API simply defined a single route for the entire page which returned everything the frontend needed as a single blob of JSON. But most people don't do this! They make a RESTful API whose routes revolve around entities rather than pages, and end up defining several routes for a single page which the frontend needs to fetch and stitch together. Or they make a GraphQL endpoint which lets the frontend make a single request per page, but with the added complexity that the backend must now anticipate all the different ways that queries can be built and their performance implications.

All these approaches (RESTful, page-based, GraphQL) have pros and cons and I'm not trying to claim any is superior to the others. But consider, if an oracle approached you and said 'You Will Never Have A Mobile Frontend, Nor Will You Have An External API Client, And Even If You Did, You Would Need A Completely Different Interface To The One You're Currently Using So You Would Be Writing The New Interface From Scratch Anyway', would you do things differently?

Remember the tradeoff: when you encapsulate, changes to implementation are easy but changes to the interface are hard. And in a Single Page Application, you are _constantly_ changing the interface!

## Dependency Injection for the sake of testing

In some statically typed languages, when unit testing, the only way to test a class in isolation from a dependency is to create an interface to the dependency and then write a mock implementation of the interface to use in the test. This can require quite a bit of ceremony: typically you pass the interface into the class's constructor, a common form of dependency injection.

Now you can test your class in isolation!

But _encapsulation is not free._

Now each time you add a method to the dependency class, you need to also update two other places: the interface and the mock class. And each time you try to jump to a method definition in your editor, you'll land in the interface which is useless³. How annoying!

Often, you don't need an oracle to tell you that the dependency class is only ever going to have one implementation, yet the language requires you to introduce the interface anyway.

There's three possible approaches to solving this problem:
* Rather than start with a class and extract out an interface, start with an interface and then create a class to implement it. This is the top-down TDD approach.
* Only create an interface from a class if you expect it to be a stable interface. Otherwise, don't mock the class.
* YOLO: find a language that lets you mock things without needing to create interfaces

The first option doesn't actually solve the problem: if your interfaces prove unstable, you'll still need to update both interface and implementation in tandem.

The second option actually sounds pretty sensible, although it precludes many forms of testing, such as frontend tests that mock out API calls. I must admit, I am a fan of the third option. Dynamically typed languages don't have this problem (see DHH's great post [Dependency injection is not a virtue](https://dhh.dk/2012/dependency-injection-is-not-a-virtue.html)) and some statically typed languages can use [conditional compilation](https://github.com/nrxus/faux) to spare you the interface pollution

## Microservices

If you're AWS, where you have a bunch of different services managed by different teams, then a microservices architecture is a no-brainer. It's much better than having a bunch of services all sharing the one database and treading on eachother's toes.

But _encapsulation is not free._

If you're not AWS, exercise caution. Things can spiral completely out of control with microservices. You start with a class A that calls the method `foo` on class B and handles any raised error. But class A and B supposedly have completely different domain boundaries, so you split them out into separate services, talking across a network. Now service A calls the `foo` endpoint on service B, and has to handle both application errors _and_ network errors.

Then if you need to change B's interface, such that `foo` takes a couple more params, you'll need to make a backwards compatible update to B so that it still works with the old A (given that you can't deploy both at once), and then update A to pass the new params. To ensure A passes the right type of params, you introduce protobufs, but now whenever there's a change to B's API, you need to publish a new protobuf version and bump that within A.

And you think, service A shouldn't even know that service B exists, it should just be notifying of an event, and service B should be listening for that notification and then process the event. Now you introduce a service bus so that B is completely encapsulated from A. Except... now A has no way of knowing that an error occured... so you create a separate topic on the service bus for B's errors which A can read at its own pace... except you kind of would like to know immediately if an error occured so you can tell the user. Wasn't life better when you just had a class calling a method on another class?

Microservices are intended to solve problems for large systems. If you have a small system, use a monolith. You can still have encapsulation, just do it at the level of modules rather than services on a network.

## Conclusion

What's the common thread? When you encapsulate something behind an interface, you make it easy to change the implementation, but hard to change the interface.

If you know ahead of time that you need multiple implementations of something, or multiple clients, encapsulation is a no-brainer. Otherwise, unless you're confident that the interface will be very stable and will rarely need changing, you should be cautious about encapsulating.

Encapsulating behind an interface adds friction whenever the interface needs to change, and doubly so if that interface is interacted with over a network.

Some forms of encapsulation are harmless, like grouping related methods into a class, but some forms of encapsulation are more trouble than they're worth.

So when encapsulating, always ask yourself:
* What are the chances I'll want multiple implementations/clients?
* How frequently do I expect the interface to change?
* How painful will it be each time I need to change the interface?

Unfortunately, you are not an oracle. But with some foresight, you might just save yourself a lot of pain.

## Footnotes

¹: 'Encapsulation' is a loosely defined term. To get a sense of just how little consensus there among authoritative sources on the difference between abstraction, encapsulation, and information hiding, read [Edward V. Berard's post on the topic](https://www.tonymarston.co.uk/php-mysql/abstraction.txt). The post concludes:

> Like abstraction, the word "encapsulation" can be used to describe
either a process or an entity. As a process, encapsulation means the
act of enclosing one or more items within a (physical or logical)
container. Encapsulation, as an entity, refers to a package or an
enclosure that holds (contains, encloses) one or more items. It is
extremely important to note that nothing is said about "the walls of
the enclosure." Specifically, they may be "transparent," "translucent,"
or even "opaque." 
> ... 
> Programming languages have long supported encapsulation. For example,
subprograms (e.g., procedures, functions, and subroutines), arrays, and
record structures are common examples of encapsulation mechanisms
supported by most programming languages. Newer programming languages
support larger encapsulation mechanisms, e.g., "classes" in Simula
([Birtwistle et al. 1973]), Smalltalk ([Goldberg and Robson, 1983]),
and C++, "modules" in Modula ([Wirth, 1983]), and "packages" in Ada.

So putting all your strings into an i18n struct is an instance of encapsulation, even if those strings are all completely visible at runtime (and they need to be or the encapsulation would be useless). It's certainly not abstraction or information hiding, because you're not really protecting the client from any details. Wrapping up your backend into a RESTful API is also encapsulation, as is wrapping up functionality inside a microservice. In general, encapsulation creates an explicit interface (not necessarily an `interface` language construct but that is a common example).

The one case from this post that's more dubious is when you start with a class and you put it behind a stand-alone interface for the sake of testing. The class is the one doing the encapsulating, and it already has an interface by virtue of having a set of methods. Adding the separate stand-alone interface doesn't really encapsulate things further, yet doing so shares the exact same consequences as the other examples from this post (extra friction when changing the interface), which tells me that it's worthy of inclusion. Perhaps the example is so hard to talk about because it's not actually doing anything: the standalone interface is identical to the class's own interface. The only real benefit aside from testability is that you can compile the classes independently.

²: The backend and frontend may become more unified with the likes of Hotwired, HTMX, and React Server Actions but we're yet to see how much adoption it all gets.

³: I'm sure there are IDEs out there which fix this problem somehow, but when writing Go in VS Code, the editor is not smart enough to ignore the mock implementation and just take you straight to the concrete implementation.
