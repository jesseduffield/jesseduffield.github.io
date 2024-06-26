---
layout: post
title: 'Still No Consensus On Testing Private Methods'
---

Yesterday, while running a session at work on Rust, I offhandedly remarked 'I think we can all agree that when writing unit tests, private methods shouldn't be directly tested except in some special situations' and to my suprise, I had thought wrong. A mini-debate erupted where various people argued mutually incompatible viewpoints. We quickly moved on from the debate but I was left a little embarrassed that I had misjudged the developer zeitgeist.

Surely in the developer profession at large there's a viewpoint that most people have agreed upon by now, right? Guess again. If you want to get a feel for just how little consensus there is on this topic, have a read through these Stack Overflow posts: [here](https://stackoverflow.com/questions/9122708/unit-testing-private-methods-in-c-sharp), [here](https://stackoverflow.com/questions/48011295/how-to-unit-test-this-private-method), [here](https://stackoverflow.com/questions/34571/how-do-i-test-a-class-that-has-private-methods-fields-or-inner-classes), and [here](https://stackoverflow.com/questions/5601730/should-private-protected-methods-be-under-unit-test). Some people say we should always test private methods directly and some people say we should never test private methods directly. They can't both be right! Is there a viewpoint on offer that's best adapted to the realities of software development?

There are five prevailing viewpoints on the topic of testing private methods:

- Don't Use Private Methods In The First Place
- Always Test Private Methods
- Never Test Private Methods
- Test Private Methods Sometimes
- Extract Private Methods Into A Separate Class

In this post I'm going to talk through each viewpoint and then synthesise them into my own rule of thumb, that hopefully most people can agree on. Note that we'll be talking in terms of classes and methods, but the same viewpoints are equally applicable to plain old functions in a functional language.

## Viewpoint 1: Don't Use Private Methods In The First Place

I'll get this viewpoint out of the way because most people intuitively find it a little extreme and if correct it completely invalidates the rest of the debate!

This viewpoint is not so much an attack on testing private methods as it is an attack on trying to predict the future. The idea is that when writing library code you couldn't possibly know what method your clients will want to use ahead of time, and defaulting to private methods will cause more problems for you and your clients than defaulting to public (or protected). This strain of thought appears to be unique to library developers (see [here](https://osoco.es/thoughts/2018/10/the-case-against-private-methods/), [here](https://stackoverflow.com/questions/8353272/private-vs-protected-visibility-good-practice-concern)), given that application developers can easily make methods public with a few keypresses whereas clients of libraries either need to fork the library or raise an issue and wait for a response.

This viewpoint has downsides: promoting a private method to public is easy, but demoting from public to private is a breaking change. Furthermore, your public API communicates to clients how you expect them to use your libary. By bloating your public API with would-be private methods for the sake of hypothetical use cases, you're making life harder for all your clients who just want to know how to satisfy known use cases. These downsides are entwined: clients mistakenly use the wrong methods to interact with your library which in turn makes refactoring harder.

## Viewpoint 2: Always Test Private Methods

Although this is an unpopular viewpoint, there are still [some](https://oli.me.uk/test-private-methods/) proponents out there. There are three main arguments:

- When doing Test Driven Development (TDD) you need to write the test before you write the code, so you may as well do that on a per-method basis, regardless of whether your method is public or private.
- By testing each method in isolation (regardless of access modifiers) you make it clear to the reader the expected behaviour of each individual method so that they can then better appreciate the roles each method plays in the larger picture.
- The obvious alternative to testing private methods directly is to test them via public methods, but this requires setup code in the test which takes longer to write, and may result in tests that take longer to run. If your priority is to save dev time, and you believe that the up-front cost of writing public method tests is higher than the ongoing costs of rewriting private method tests when refactoring, then it makes sense to just write private method tests in the first place and deal with the ongoing costs when they arise.

Some languages facilitate testing private methods better than others. If your language makes you jump through hoops to test a private method, you are probably not on board with this viewpoint.

## Viewpoint 3: Never Test Private Methods

Diametrically opposed to the prior viewpoint, the main argument for this viewpoint is that clients of your class can only interact with the class through its public interface (that is, the set of public methods on the class), so why should your tests be any different? If a private method can't be accessed through a public method, then it's dead code and should be deleted. If it _can_ be accessed through a public method, then you _should_ test the private method through that public method, because what are tests for if not to emulate the clients who'll be using your code?

That's the philosophical argument, but the practical argument is an easier sell: if your tests depend only the public interface of a class, then you can refactor the internals of that class to your heart's content without needing to change any of the tests. If you don't need to update the tests, then you can know for certain that a failing test means you've actually broken something, and a fully green test suite means you've successfully preserved the class's original behaviour.

Conversely, if the class's tests depend on private methods and your refactor deletes or changes the signature of any of those methods, you'll need to rewrite those tests to handle the new internal structure, but now you've lost confidence in your tests because the test rewrite is just as likely to be error prone as the code rewrite in the first place!

Secondary to this is the fact that even if you could rewrite tests with sufficient care that the exact same behaviour is captured as before, it's still a laborious, time-consuming process, and therefore deters refactors that could improve the health of the codebase. Where the prior viewpoint places more emphasis on the up-front costs of testing private methods via public methods, this viewpoint cares more about the ongoing costs of refactors.

## Viewpoint 4: Test Private Methods Sometimes

The prior viewpoint cares a great deal about the 'public interface', but this new viewpoint calls into question what is truly public, and what is truly a unit. If you're writing an application (where a binary is run) as opposed to a library (where code is exported for use in other codebases) there is only one truly public interface and that's the interface to the application itself, for example consisting of a user's keypresses and mouse clicks. If you wanted to maximise refactor-ability as the prior viewpoint advocates, the best approach is to have every single test open up the application and imitate a user's clicks and keypresses. That way there is zero dependence on any internal code, and you can confidently refactor the code without having to rewrite any of the tests.

There are rare instances where end-to-end tests are the most sensible option, for example when you've inherited a system that's nigh impossible to unit test and you're about to refactor the entire codebase, or when you're building to a reference implementation and want to run the tests against both implementations for feature/bug compatibility. In most cases though, foregoing all unit tests and instead writing tens of thousands of end-to-end tests that virtually imitate a real user is absurd. There are several reasons why a test suite comprising only end-to-end tests is problematic:

- it takes too long to run a given test
- it takes too long to write a given test
- the complexity of each test obscures its intent, diminishing the test's ability to act as documentation.
- changing a feature may break tests that care about another unrelated feature

It's for these very reasons that unit tests exist in the first place. As developers, we compromise by encroaching deeper into our application's code and selecting 'units' that we deem worthy of testing in isolation. We do so knowing that if a refactor leads to one such unit being obliterated out of existence, we'll need to rewrite its tests somewhere else, with all the abovementioned costs.

As soon as we start testing code that is public with respect to our other code but private with respect to end-users, we must acknowledge the inherent arbitrariness of our 'unit' selecting process. The difference between testing a private method in a class and testing a class in an application is only a difference in degree, not kind.

This gives us a spectrum of encapsulation starting at the application itself and moving down through modules, classes, and finally to private methods, as we dial down the level of encapsulation to smaller and smaller slices. The higher the level of encapsulation, the harder to test, but the lower the level of encapsulation, the harder to refactor.

This viewpoint posits that if a private method is sufficiently self-contained and it's a sufficient pain in the ass to test it through a public interface, it can be tested directly without shame or guilt, and that it's a double-standard to assert otherwise.

## Viewpoint 5: Extract Private Methods Into A Separate Class

This viewpoints builds on the previous one to say that if you find yourself wanting to test a private method, that's a sign that your class may have too many responsibilities and therefore violates the Single Responsibility Principle (SRP).

In _Working With Legacy Code_, author Michael Feathers states:

> If we need to test a private method, we should make it public. If making it public bothers us, in most cases, it means that our class is doing too much and we ought to fix it.

(Personally, I can't imagine _not_ being bothered by making a method public purely for the sake of testing, but you get the idea)

In _Practical Object Oriented Design in Ruby_, Sandi Metz also suggests that private methods yearning to be tested are a code smell for SRP violations.

Where the previous viewpoint argues that the choice of a 'unit' is arbitrary, this viewpoint disagrees. If you want to test some private code, that suggests you've stumbled across an abstraction boundary that has not been made explicit in the code. Perhaps you want to test some algorithm that directly maps onto the problem domain, in which case it deserves to be promoted into its own abstraction.

By extracting a private method into a separate class, we can now test that class via its public interface, and we have the bonus benefit of injecting the new class as a dependency into the original class, allowing us to easily mock out the new class's behaviour so that both the code and the tests maintain the separation of responsibilities.

If wrapping a single function in a class feels a little extreme, and your language allows functions to live outside of a class, then presumably this viewpoint has no problem with extracting the private method out into its own stand-alone function, provided you can sever its dependencies on any instance variables.

## Discussion

We started with a viewpoint making the radical proposition that no methods should be private in the first place. Certainly simplifies the testing process, but the lack of encapsulation can make life miserable.

We then considered two completely contradictory viewpoints, one wanting no testing of private methods, the other wanting testing of all methods both public and private. Then the third viewpoint came along and proposed that no matter where you are on the spectrum of encapsulation, there are pros and cons to testing at a higher (e.g. class) or lower (e.g. private method) level, and that if the pros outweigh the cons, there's no shame in writing the test.

Then the fourth viewpoint comes along and throws a spanner in the works by proposing that private methods in need of testing are themselves a code smell that the class has too many responsibilities.

A proponent of Viewpoint 3 which emphasises sticking to the class's public API might say the following about Viewpoint 5: Hang on! So far we've been arguing about refactoring and encapsulation, but you've moved the goalposts to focus on the SRP! Moving a private method into a private class does nothing to reduce the burden when refactoring: we're just as likely to need to trash/change the private class as we were the private method, meaning in either case, tests will still need to be rewritten. And this assumes your language supports private classes because if not you've just expanded your public API to include a class that you don't actually want clients using! And does it really make sense to take a private method that's a pure function and move it into a completely separate file when it's only used by the one class? How does that aid readability?

A proponent of Viewpoint 5 could argue back saying that the desire to test a private method is evidence that there is an independent abstraction you've failed to recognise and that the abstraction is less likely to need refactoring than some random private method that you don't feel the need to directly test.

## My Proposal

Here's the approach I propose: try to have as slim a public interface as possible in your classes, by defaulting every method to private. If you find yourself wanting to test a set of private methods directly, seriously consider extracting a class (or standalone function), but only if it makes sense independent of your testing desires. If you want to test a single private method and don't see the point in extracting it out of the class, convert it into a pure function (no references to instance variables) and test that method. That way, if later on you decide to move the function somewhere else, moving the tests is as simple as copy+paste.

Have I missed or misrepresented any perspectives in this debate? Do you disagree with my proposal? Am I over-generalising? Let me know. Till next time!

## Links

- [Should Private Methods Be Tested?](https://anthonysciamanna.com/2016/02/14/should-private-methods-be-tested.html) - Anthony Sciamanna
- [Testing Private Methods with JUnit and SuiteRunner](https://www.artima.com/articles/testing-private-methods-with-junit-and-suiterunner) - Bill Venners
- [Testing private methods (don't do it)](https://fishbowl.pastiche.org/2003/03/28/testing_private_methods_dont_do_it) - Charles Miller
- [Test private methods](https://oli.me.uk/test-private-methods/) - Oliver Caldwell
- [The case against private methods](https://osoco.es/thoughts/2018/10/the-case-against-private-methods/) - José san leandro
