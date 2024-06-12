---
layout: post
title: My interview with 'Uncle' Bob Martin
---

See the interview on youtube [here](https://www.youtube.com/watch?feature=shared&v=qdcamTUcuAQ).

In this interview I had the chance to ask Bob Martin various things that had been lingering in my mind for a while.

## Table of Contents

1. [Introduction](#introduction)
2. [Functional Design book](#functional-design-book)
   - [Why write a book on functional programming?](#why-write-a-book-on-functional-programming)
   - [Are there domains for which OO is better than FP?](#are-there-domains-for-which-oo-is-better-than-fp)
   - [Could FP have been popular from the start?](#could-fp-have-been-popular-from-the-start)
3. [SOLID principles](#solid-principles)
   - [Is the single responsibility principle supposed to be taken literally?](#is-the-single-responsibility-principle-supposed-to-be-taken-literally)
   - [Is the dependency inversion principle always useful?](#is-the-dependency-inversion-principle-always-useful)
   - [What is the most important principle that is not included in SOLID?](#what-is-the-most-important-principle-that-is-not-included-in-solid)
4. [Testing](#testing)
   - [Is a 100% test coverage goal a good idea?](#is-a-100-test-coverage-goal-a-good-idea)
   - [Is it okay to sometimes test private methods directly?](#is-it-okay-to-sometimes-test-private-methods-directly)
5. [Professionalism](#professionalism)
   - [Why aren't software engineers interested in becoming a profession?](#why-arent-software-engineers-interested-in-becoming-a-profession)
   - [What about people who aren't passionate about programming?](#what-about-people-who-arent-passionate-about-programming)
   - [Are calls for professionalism a form of gatekeeping?](#are-calls-for-professionalism-a-form-of-gatekeeping)
   - [Does professionalism come from individual choice or structural incentives?](#does-professionalism-come-from-individual-choice-or-structural-incentives)
6. [Bob Martin vs Martin Fowler](#bob-martin-vs-martin-fowler)
7. [Artificial Intelligence](#artificial-intelligence)
   - [Has AI changed how Bob programs?](#has-ai-changed-how-bob-programs)
   - [Are developer jobs threatened by AI?](#are-developer-jobs-threatened-by-ai)
   - [Will we achieve super-intelligent AI any time soon?](#will-we-achieve-super-intelligent-ai-any-time-soon)
   - [Would a super-intelligent AI programmer care about modularity?](#would-a-super-intelligent-ai-programmer-care-about-modularity)
8. [Wrapping up and what's next for Bob Martin](#wrapping-up-and-whats-next-for-bob-martin)

Below is the transcript. There's still some filler words in there so please forgive that.

## Introduction

**Jesse**: Okay, Bob Martin, aka Uncle Bob, it's great to have you on the podcast.

**Bob**: Thank you so much.

**Jesse**: It's great to meet you finally in person (virtually in person). All right, so quick introduction for the audience. Uncle Bob has been around for a while now. He's popularized many important principles that are very salient to many programmers today. Author of many books: Clean Code, Clean Coder, Clean Agile, Clean Architecture, and most recently, Functional Design: Principles, Patterns and Practices.

I've probably got the order of those three things wrong But I wanted to start a conversation on functional design. I'm interested to know: you've been around in mostly in the object oriented space for a while but you've recently transitioned over to Clojure and it seems like you've fallen in love with that language from some of your blog posts. I'm keen to know, what was the impetus behind writing this particular book?

## Functional Design book

### Why write a book on functional programming?

**Bob**: Okay, well the impetus for writing that book was the last 12 to 15 years of investigating functional programming. I started this process a decade and a half ago because somebody told me I should read a book and the title of that book was Structure and Interpretation of Computer Programs, which is a classic that I had not read.

And so I found a copy on eBay. It's a well-worn copy that somebody else had dog-eared. And I got it from there. And then it sat on my desk for about six months. And then at some point, I picked it up and I started reading. And I could not put this book down. It was one of those weird events where you read a book and a book is about software. And you know, I've been a software developer for a pretty long time. I didn't expect anything, you know, fundamentally different, but here I am reading this book and it's fun to read and I'm throwing the pages and just agreeing with everything. And we get about, I don't know, 200 and some odd pages in.

And the authors just slam on the brakes. And they say, now, wait a minute. We're about to introduce something to you that's going to ruin everything that we've just been doing. And what they introduced was an assignment statement. And it just absolutely floored me. I thought, wait a minute. There's been no assignment statement in any of this code that I've been reading for the last 200 pages. And I had to go back and look and check. And there was no assignment statement. And I thought, OK, this book has something to say. And I kept on reading it and kept on reading it and really enjoyed it. The language in the book is Scheme, which is a Lisp derivative.

And so I thought, I need to I need to learn Lisp. I had known about Lisp for 30 years, but it was always in the pejorative sense. Everybody who ever touched Lisp goes, oh, terrible language, too many parentheses, don't use Lisp. So I thought, well, okay, I'm never going to learn Lisp. And here I get this book and I've learned a little Lisp now reading this book. And I thought, okay. I've got to play with this. And it just so happened that Clojure was kind of new then. And Clojure sat on top of the JVM stack (the Java stack). And I thought, well, that's perfect for me because I spend most of my time doing Java anyway. So I know the libraries and I know the environment. Why not just start playing around with Clojure? And I did. I just started playing with Clojure and more and more and more. And it is now the language I use. It's my language of preference. I'll use it for anything.

And therefore, long story coming to an end, recently I thought, well, you know, I've learned enough about this language and enough about functional programming from an engineering point of view that I think I'm ready to write a book on it. And so I wrote this functional design book as a way to bridge the gap between object-oriented programmers and functional programming and tie everything together into a nice little bow.

At least that's what I hope.

**Jesse**: Yeah, that is exactly what I took away from it it. It felt very much like you were trying to write the book that could only be written by someone who had all this experience with object-oriented programming in the first place. Because a lot of people, they start off functional and they're like, haha, they're in this ivory tower. And it's like, we know better than the object-oriented guys. All these patterns, like the visitor pattern and the abstract factory, that's all outdated crap. We can just have functions to solve every problem now.

And in this book, you're saying, actually, no, the problems are still there and the solutions are still there. They're just encoded differently. Is that a fair characterization?

**Bob**: That's a very fair characterization, yes. And you're right. I mean, there has been this attitude amongst certain functional programming tribes. Where it's like, OK, everybody else is wrong. We're the only ones who are right. And those OO guys just got everything wrong. The OO is just awful. And all this design pattern stuff was nonsense. It was just put in there because they were bad languages. And so forget everything else and just write functions.

As if just writing functions isn't what we've been doing the whole time.

**Jesse**: All right. So, I purchased the book and I read the book and I highly recommend it to anyone who who's thinking of reading a book on functional programming.

**Bob**: Thank you

### Are there domains for which OO is better than FP?

**Jesse**: So, you say that, in mutable languages, behaviours flow through objects. Whereas in functional languages, objects flow through behaviors. And you give some examples in the book of showing side by side, an honest comparison. Here's the object-oriented approach. Here's the functional programming approach. And there's one example where there's a tie, but in all the other examples, functional programming seems to come out ahead.

And I'm wondering, Do you think there are domains for which object oriented programming is the superior a approach or is it that it's actually, it's not really domain specific. You can just pick either option in any case. Cause it seemed like by the end of the book, I was like, it sounds like what Bob Martin is saying is that functional programming is like pretty much just the better option.

**Bob**: What I'm hoping came through is that functional programming should be one of the tools in your toolkit.

And it it fits in a part of the of the programming domain, which is pretty high level. Let's start over at the start: structured programming lets us build up functions pretty much in the small. We can build up small little functions that have while loops and if statements and follow the the rules of functional programming. So I like to think of them as the bricks in some kind of a building.

The little functions that are done with structural structured programming that are the bricks in the building.

And then there's the architecture, the superstructure. The superstructure is done mostly with objects. Not the traditional you know a boat is an object and a car is an object and a house is an object, but instead the the dependency management principles of object-oriented design, where we can create boundaries between architectural components and control the dependencies across those boundaries.

That's the real power of object-oriented programming.

The rest of it is all just data structures and functions. But when you can take dependencies and turn them around and make sure that all the dependencies point in the right direction, then you have real architectural control.

And then functional programming is the plumbing that goes through all of that. It's the way the data moves. it the way we, instead of altering data, we flow data through these high level structures that transform the data from high level to low level and then back again. So that's the message I was trying to give with the book.

I hope I succeeded in that. What I don't want to see is anybody saying, well, I'm a functional programmer, so I don't do OO, or I'm an OO programmer, so I don't do functional.

Any good programmer should use all of these techniques all of the time. It's a stew, and we mix the whole stew together. And there are part times when we're doing functional programming and times when we're doing OO programming and times when we're doing procedural structured programming in making a nice mixture of what a good program ought to be, a good system ought to be.

### Could FP have been popular from the start?

**Jesse**: Okay. Now, so my my final question on the functional design book is, could there have been an alternative history where we just kind of went way heavier on functional programming from the beginning? I know it was popular at the beginning, but it seemed like everyone was doing OO and now it's kind of the pendulum swung back in the other the direction. Was that contingent on something?

**Bob**: Yes. Yeah, it was definitely contingent. To do functional programming well requires a lot of CPU cycles and a lot of memory. There's no escaping from that.

The functional mechanism is recursive in nature and it requires the ability to not modify data.

Which either means you're making copies or you're doing the clever thing that a lot of functional languages do, which is to create trees that have little branches for this and that, and you create this illusion of immutability. But but all of the older versions of a data structure still exist.

So that requires a lot of memory and it requires a lot of CPU cycles. And in the early days, and by that I mean going all the way up to like the 90s, that was just impractical. You could you could do Lisp, but you wouldn't do it seriously for anything.

A few people tried and it didn't work out very well. You could do functional programming in ML or or Haskell or something like that, but it was mostly academic.

It's only really become feasible in a a real engineering, real practical sense, because we've got just so damn much memory and so damn many CPU cycles that we can afford to spend a few for the convenience of living in this abstract functional world.

## SOLID principles

### Is the single responsibility principle supposed to be taken literally?

**Jesse**: Yep, that makes complete sense. All right. Okay, so now I want to transition to talk about this the solid principles which you've helped to popularize.

So first one is probably the most famous, the Single Responsibility Principle. And this is the idea that a class should have only one reason to change and you talk about how by reason to change talking about a person or a role who would be the source of that change.

So, I want to challenge this and I want to want to get your thoughts on this. So I think we can all agree that too many responsibilities is bad, but one is a very small number. And I sometimes wonder if it would make more sense to be called the like 'minimize responsibilities principle' or the 'be careful about too many responsibilities principle'. Because it seems to me if you really try to truly think about all the possible causes for a change, you can think about many possible causes.

One example to illustrate is, suppose you've got one guy who's in charge of all the copy in your app. So they get to decide the messages that are rendered to the to the user. You might decide that because that's one person and that's one reason to change, you should have all the text in your app moved out of the classes into some other file. And so maybe if you're doing internationalization, that's a really good idea.

But if you had a crystal ball and you were like, I'm never going to do internationalization because I'm doing some some app that's made for Australian taxes or something like that, that's very geographically specific. It seems to me like that's just a lot of friction to add if every time you want to make some change to something you've got some separate file that has all the English text and maybe at some point some new guy will come along and want to change all of that and his life will be very easy because it's all in one file but everyone else's life is really hard because they're constantly having to work across these two files so please respond to that challenge.

**Bob**: Okay, I'm gonna use the old Pirates of the Caribbean thing, you know, they're not really so much rules as guidelines. What you just described is perfect, right?

You've got to make a decision. You've got a judgment call here and you could look out there and say well, you know if I if I broke this up into literally single responsibilities I'd have a tiny bunch of whole bunch of little things and is that really going to help me?

So then you have to use judgment and say well, okay I know those guys over there are gonna change this a lot.

I know those guys over there are not I can just feel that that's your crystal ball, right?

Okay, so I don't need to protect those guys so much. But those guys over there, I'm cutting them up. I'm going to chop them up into little pieces. So when they make a change, I can focus it down into one narrow little piece. But those guys over there, man, they're going to change this thing once a year. I can tolerate that. I'll just put all their stuff in one big basket. Now, that that's kind of an exaggeration of what we would do. But yeah, you look at it, the principle is single. And then you look at that and think, well, you know, single is really like two or four or something like that.

Because they're not going to change very much. All the principles are that way. All the principles are that way. They're all guidelines. They're all stated as an ideal, and you barely ever get to the ideal.

### Is the dependency inversion principle always useful?

**Jesse**: Yeah okay. So I guess in that same light, I wanna touch on the another popular one, the dependency inversion principle.

This is the idea that concretions should depend on abstractions and not vice versa, and that runtime dependencies should be in the other direction as compile time dependencies.

So here's here's my question to you. Say you lived in a world where it's easy to mark out dependencies in tests without needing dependency injection and say that compilation is instantaneous and say that you're working on an application and not a library. So you are God, right? No one's depending on your code, but yourself. What's left for that principle when those three things are in play?

**Bob**: So the the principle is about source code dependencies. Which modules can depend on which other modules? And the basic idea of the principle is that high-level modules, modules that capture high-level policy, should not know about any of the details that they eventually end up using.

So we'd like the detailed modules pointing their dependencies at the high-level highlel modules. That's really the whole point. Get the low-level stuff to depend on the high-level stuff. That way, we can change the low-level stuff all we want. It doesn't affect the high-level stuff. High-level stuff can sit there fat and happy. never being bothered by whatever changes are going on at the low-level detail stuff. So if I were absolute power god and I could control everything and the compiles were absolutely instantaneous and there were no and problems with shipping modules here and there and no network overhead or anything like that, would I still follow that principle?

And the answer to that is, well, yeah, most of the time I probably still would because I want to be able to look at the problem from the high level without being bothered by the details.

Just from a human point of view, I want to be able to look at the high levels without all that gunk down there inserting itself at me. I don't want my high level code calling down into low level functions so that I then have to go follow the thread down to a low level function, figure out what's going on. Oh, then come back up. I would much rather the high-level stuff stay isolated, nicely encapsulated, stating its high-level policy in an abstract way that does not invoke any details directly.

And that would allow me to understand the problem a lot better, diagnose any problems that are going on, and just in general feel happy when I look at it.

**Jesse**: Okay, so I still wonder though, often I'll have applied this principle and I'll have this interface between some high level thing and some low level thing. And I want to get from my high level thing to the implementation because I want to know, okay, how is it actually going to work? I jumped to the definition of my editor and I'm i'm stranded in this interface in a random file and it's like okay now what do I do and you're gonna go and find okay? I'll jump from the interface to I'll go and find the actual implementation I think there is some friction that this adds and I'm wondering like how do you adjudicate when the friction is too much?

**Bob**: I think when you feel it, now, you know there are tools that help with this.

Like if If you're using an IDE that looks at the whole code base, for example, mine IntelliJ, if I'm looking at an abstract function, it'll it'll have a little widget off to the side that says, here's all the implementers. and I can just click on them and see them right away.

So the the pain of finding the implementation is significantly mitigated by a tool like that.

But look, maybe you're working in VI, you're transported back to the 1970s and you're working in VI and you're working in C++ plus plus and you're trying to figure out, well, 1980s, late 1980s for C++ okay.

And you're ah you're trying to figure out, well, what what derived class got called here? and There's virtual function up here. And I know it's dispatching down to this derived class. But I don't know which one it is. And yeah, that's a problem.

You have to put it in a debugger and then single step through to get to it. And that's a gigantic pain. So if you're feeling that kind of pain, and if there is no other reason to invert the dependency, then why wouldn't you get rid of that interface? Now, I actually do this the other way around.

I don't put the interfaces in until I need them.

**Jesse**: Right, you wait until it hurts.

**Bob**: So I look at every problem as a concrete problem. And then if I need the interface, I'm perfectly willing to put it in. But I have to see a reason for it before I put it in.

**Jesse**: Yeah, yeah, that's great. That's great. I'm glad to hear this. It means if someone comes comes up to me and says, hey, you know, Uncle Bob says you do this, I'm like, well, actually, I've talked to Uncle Bob and it's it's a bit more nuanced than that.

### What is the most important principle that is not included in SOLID?

**Jesse**: Okay, so ah my next question is still kind of in in the realm of solid.

I want to know, what do you think is like the most important principle the program the board that you follow, but which is not in that solid mnemonic.

**Bob**: Kent Beck long ago wrote a book called Extreme Programming in that he outlined four values. And the values were simplicity, communication, feedback, and courage.

When we're working in software, the most important part is simplicity. The second most is feedback. Make make sure you don't trust what you just did, but but you try it out and then it adjust. And the next one is feedback as is courage, because sometimes it takes a little bit of courage to try the next thing.

And if you're on a team, communication is absolutely essential. Now, I'm not sure i I've sorted those in the right priority, because I think in different contexts, you need them in a different order.

But I would certainly start with those four, just as a basic way of facing any programming problems, simplicity, feedback, courage, and communication.

And then below that are things like so the solid principles and the law of demeanor and all of these things that we use to try and keep our memory of design principles high.

**Jesse**: I like that. I like courage especially. I feel like i'm I'm often someone who's just like too scared to go and try and take on some scary refactoring because you're just scared of breaking things and it's it's important to know that like you can do it. It is possible.

## Testing

**Jesse**: Okay, so so this I want to transition to talking about testing. Now, I'm not going to ask you about TDD, because I suspect that any time anyone gets you on a podcast, they only want to talk about TDD.

### Is a 100% test coverage goal a good idea?

**Jesse**: What I do want to talk about is test coverage. So you ah have a tweet where you say that the only test coverage goal that makes any sense is 100%, but it's an asymptotic goal. You'll likely never get there.

But then you also say it's a very bad management metric and it's kind of a, it's a reprehensible release criterion and so on. And I'm trying to understand like the thing about 100% is it's actually really achievable if you just enforce it in CI from day one. And so I don't think, I don't, I don't, I think I share that your intuition that you shouldn't do that. But I also feel that there's a contradiction there that it's like, if the asymptotic goal is achievable, then shouldn't you just try to achieve it?

**Bob**: um my yes yes Clearly, if the goal is achievable, you should try to achieve it. Can you achieve it? Well, okay. For small things, you certainly can. right like If I wrote five lines of code, I could i could cover it all.

If I'm writing complicated systems that spawn other processes and communicate over sockets and do all these other things, there are probably stretches of code that I'm going to have a devil of a time covering.

There's also the problem of any any of the code that has to communicate across the boundary of the computer to the outside world. There's going to be some layer of code, very thin, hopefully, that needs to pump data outside of the computer to somewhere else. And those things are very difficult to test, if if not impossible to test. For example, you know how do you know if you put the right pixels on the screen?

And the best way to do that would be to set up a camera and have your test use the camera to look at the screen. But it's not particularly ah practical to do that.
And so at some point, you have to look at look at this thin layer of code and go, I can't test that. Now then later on, you think, ooh, I've got an idea. I could test some of it this way. And then you add another test, and you you feel very clever. And you've pushed your coverage up by 0.01%. Oh yes, I'm getting closer to 100. But in those kinds of systems, I think you are unlikely to achieve 100% coverage as long as it's a complicated enough system where you've got lots of external flows.

### Is it okay to sometimes test private methods directly

**Jesse**: Okay, now I'm glad you mentioned the pixels on the screen thing because this this brings me to my next question about testing which is testing private methods. Now, I believe that you that you believe that you shouldn't directly test private methods and that you should do it through public methods. And I want to pitch to you my case for the opposite, which is that there is some time.

So my, my basic argument is that privacy is relative. And so you you can, you can argue, you know, you mentioned pixels on the screen, right? Like if you write an application, the public interface is the photons coming off the screen into my eye and me typing onto a keyboard. And obviously, as you mentioned, it's very expensive to test that faithfully because you need to get a robot to actually type the things and that's all very expensive. And so you say, you know what? I'm going to go down a level ah just a little bit and I'm going to try and, you know, get a bit closer. ill I'll be a bit further away from the true surface.

But you get all these benefits because it's now faster, it's less vulnerable to functional things that are kind of irrelevant to the test. But the trade-off is it's now more vulnerable to structural changes in the code, right? Because if you refactor the code, the further down you are, the more likely it is that it's going to break your tests. And you might, you know, maybe they're testing something that's been refactored out of existence. sorry My case is that at any point in this, like, spectrum of encapsulation, the trade-off is the same. You can go a bit higher, and it's going to be a bit slower, but a bit more faithful. You can go a bit lower, it's going to be more brittle, but it's going to be faster, and it's going to be probably easier to write the test, arguably. And so, my argument is if this that that it's not a difference in type, it's a difference in degree.

And so the same rationale that would make you want to go one step down from the pixels on the screen is the same rationale that in some cases may make you want to go down to the private method. So yeah what do you think about that case?

**Bob**: Okay, so so let me pitch this. I'm going to tell the same story you just told, but I'm going to tell it a little bit differently.

We in the programming world have been convinced that there's only a few levels of encapsulation, public-private protected package, maybe a few others, but mostly our languages define this for us. That's absolute crap.

Because actually the levels of encapsulation are infinite, or at least they're unbounded.

So so we will we will create a context of code, which someone might call a class, somebody might call it something else, doesn't matter.

We'll create a context of code and the things inside that context are private to the context, but there's an interface that the next layer out will use. Now that layer also has a context and there's private things in there, but it has an interface which the things outside of that use.

**Jesse**: Exactly.

**Bob**: and This will go on like a set of of yeah Russian dolls until ah you finally reach the boundaries of the system. And at every point, there is an encapsulation boundary that we cannot specify with the syntax of our dumb languages.

Because our dumb languages say, well, public or private, and that's it. In that case, yes, you will be you will write tests at one level just outside of a context boundary for the internals of that context.
but You will write that, and you will be calling methods that are public to you, but are private to the next layer out.

**Jesse**: yeah Exactly. yep Yeah. Yeah. So, but but that, I think we're saying the same thing then.

**Bob**: I think we're saying the same thing, yes.

**Jesse**: So. Right. But by that logic, would you agree that, that sometimes then it is okay to test private methods because you're just going one level down just in the same way you did for any other high level of abstraction.

**Bob**: Yeah, and then the language gets in the way.

**Jesse**: Like is there, is there some fundamental difference?

**Bob**: You know, if you're doing Java or C sharp, it's hard to call a private method.

**Jesse**: Right.

**Bob**: You've got to do some trick.

**Jesse**: Right.

**Bob**: So then you kind of elevate it and make it protected instead or package scope instead.

**Bob**: And then that lets you call it as long as your test is in the right package, which is fine with me. I don't, I don't mind that, but there are people who would say, Oh, oh heavens no, you've made it package scope and it really should be private. Well, I can't call it if it's private.

**Jesse**: Right. Yeah.

**Bob**: So, yeah, okay.

**Jesse**: Yeah, I agree. Okay, okay, so that's good.

## Professionalism

**Jesse**: All right, so I want to move now to professionalism, which is a completely different topic, and it's it's probably the most fun topic I think we could be talking about here.

**Bob**: OK.

### Why aren't software engineers interested in becoming a profession?

**Jesse**: Okay, so why aren't software developers interested in becoming a profession akin to doctors and lawyers? Or do you do you refute the the the assumption of that claim?

**Bob**: I think the older a programmer is, the more interested they are in adopting some kind of professionalism standard. And I think that's true across the board of any industry. When you're very young, all you want to do is get in.

And then as you learn more and you learn more, you you start to feel the cost and the weight of responsibility.

And you start to think, you might you know we need to do something about our our level of professionalism. And eventually, you know the doctors and the lawyers, they all established ways of of pushing that level of professionalism down and measuring it and categorizing it and so on. We have not done that yet.

We don't have any standards. that are stated. We don't have any disciplines that we all adhere to. We don't have a ah broad body of ethics that we all swear to uphold. We don't do that yet. Now, I think that's going to have to happen. And I think as it as it happens over the next two or three decades, the younger people coming in will be taught these professionalism standards and ethics and disciplines and will just never have it out about

like you know young lawyers go to law school and they just have no doubt about it. Oh, this is the way it's done, okay. I think that's the way it's going to happen, but it'll it'll be a a long process. Like I said, probably about three decades, maybe more.

**Jesse**: Right. And and yeah how much of that is about just deciding on what the right patterns are, right? So for example, you you believe that TDD is like, should be bundled into this idea of professionalism, but ah you also have said in in a blog post that you could be wrong about that. It might be that we'll find out that that that some other testing approach is better and then you'll be, you know, it's like, that's fine. But I'm wondering like, something that concerns me is that if we were all to just decide now, okay, here's the rules,

We're going to follow these rules that we'd be losing out on innovation and experimentation that might be beneficial in the longer term.

**Bob**: Yeah. And there's this funny trade-off, right? Kent Beck used to like to make an X with his arms. Is this a video podcast? Are we going to be able to see this? Kent Beck used to like make his X with his arms.

And he said, you know, when one thing is going down, another thing is going up. And what you're really looking for is the crossover point. So the cost of a discipline, the cost of creating disciplines and standards is that you lose flexibility. right But the cost of of the of not having them, this innovation, eventually causes problems, problems that we really have to have to get our hands around because our entire civilization at this point rests on top of software.

And if that software goes squirrely on us, our civilization goes squirrely on us. So are we at that crossover point?

And I think we must be very close. And at some point, I've told this story before, but but at some point, there's going to be some horrible disaster. It'll be traced right to software. It'll be much worse than the 737 MAX. you know It'll be tens of thousands of people dead because of some stupid software error. And at that point, the world will get very serious about being at this crossover point. And OK, we've had enough of this innovation. Sorry, we're going to have to standardize things.

Something very, very similar happened to aviation. If you go to 1905, and airplanes were made out of wooden cloth and a little bit of wire, and they have lawnmower engines running in them, and these guys are flying around in these contraptions that are dangerous as hell.

But they're flying. They're still flying. And within 20 years, these machines are made out of metal, and they're screaming down out of the sky dropping bombs on cities.

And then another 20 years, and you've got jet power, and another 20 years, you are carrying hundreds of thousands of people in large wide-body jets across the ocean. And by now we've gotten to the 1960s. And then what? Well, we've still got wide-body jets, carrying hundreds of thousands of people over the Atlantic and over the Pacific. And if you look at an airplane from today and you look at an airplane from the 1960s, they look pretty much the same. There's a few differences. And the the the aviation part of it, the the aeronautical part of it is roughly the same. We've learned a few tricks about squashing down vortices and a few other little tricks. And our engines have gotten much more efficient. And we've loaded them up with a lot of electronics. So they're they're much better versions of the 1960 airplane. But they're still 1960s airplanes.

And I think that's going to happen to software. I think we've already hit the the Moore's law limit. The machines are not getting faster. I don't believe the density is going to increase much because we're down to 10 atoms. You know, probably can't get much denser than that. And maybe we'll solve a few problems along the way.

But I think the crazy exponential growth that happened in aviation and happened to us has stopped and we're gonna sit on the plateau. And as we sit on the plateau, that means we look at we look at that plateau and it's nice and flat and we think, okay, we need some standards and disciplines and ethics here because we've put too much of our society on top of that and we're going to have to get it under some kind of control.

**Jesse**: Do you think that there's a difference between aviation and programming in that? I think this is similar also with doctors where it's like, there's a lot of ways to write code, which is pretty innocuous, right? Like if I'm writing a video game and my friends are going to play that and it's probably not going to be used by millions of people, like is this some way to reconcile the gradations of seriousness with this call for professionalism?

**Bob**: Oh, I'm sure there is. So for for example, that that happens in aviation as well. Like if if you've got a better idea for an airplane, you can you can build that airplane.

**Jesse**: Right.

**Bob**: No reason you can't build it. No one can stop you from building it. They can stop you from flying it. So then you ah then you apply to the FAA and you say to the FAA, hey, I've got this experimental idea.

**Jesse**: Right.

**Bob**: And they come out and they look at it and think, well, you know if you don't mind killing yourself, sure, we'll give you an experimental certificate. I mean, from our point of view, it looks like you're not going to die right away anyway. And then you can go fly that thing around. And lot a lot of guys do that. They come up with really interesting ideas. And they can even sell the experimental model as long as somebody else is willing to buy an experimental model. And the rules for experimental experimental models are very different. like I own an airplane. It is not an experimental airplane. I am not allowed to change anything in that airplane.

unless I get a special type certificate from the FAA that says, yes, we approve that you can change that knob from blue to red. It's not quite that serious, but it's very, very serious. On the other hand, if you own an experimental aircraft, You can make changes to it. You can go in there and say, well, you know, think ill I think I'll change the way these valves see to me. Let me see if I can get more power out of it. They have a lot more leeway.

so And I think that's possible in software as well, because there are gradations of software, like the guys who are writing first-person shooters. you know They've got a whole different set of standards. you know Why would we impose some kind of ethical structure upon them and a set of disciplines that they must follow when they're trying to squeeze every last nanosecond out of the damn machine?

right So I think you know let them do that. Squeeze the nanoseconds, guys. on then On the other hand, if you've got a bunch of programmers working on financial software, you don't want those guys goofing around like that. yeah You want them following a set of standards, following a set of disciplines.

So I think that's how it's going to work out. At least I hope so.

### What about people who aren't passionate about programming?

**Jesse**: Okay. So another question on professionalism I have is some, so you have said that that to be a professional, you want to be spending maybe 20 hours of your week outside of your day job, just honing the craft. And my question is, what would you say to someone who just sees programming as a job and the They don't hate it, but it's just a job to them. And they, you know, they do their 40 hours. They're doing wholesome, completely unrelated things in their spare time, like baking. like what How do you feel about that person?

**Bob**: but I think that person, there's there's certainly a place for that person. They can be a programmer. That's fine. Programming is not going to be, for them, programming is not going to be the kind of thing where they can climb a ladder and gain greater and greater responsibility and make more and more money and so on. They're not going to go up that ladder.

But they can they can be a programmer for as long as they want to be and have a ah ah moderate and a positive impact on the profession. Nothing wrong with that. Now they're probably not going to write books on the topic. They're probably not going to go out and give talks on the topic. They're probably not going to make some kind of found fundamental change, but they can be a good programmer. Nothing wrong with that. If your goal, however, is to, is to have an impact. If your goal is to move the profession forward, you're going to have to take some time with your career.

There's another, there's another side to this.

You want to be a programmer. You just, it's just a job. You want to be a programmer. You learned some language like Java and you're perfectly happy doing that. Okay. That's fine. You can do that, but you must be careful because Java will find, will one day fall down like all other languages do and be replaced with some other language. And all the young kids were going to have, are going to have that language under their belt. And you might slide down where all the COBOL programmers live, which is not a great place to live right now.

I mean, it was in 2000, you know, or 99 actually, it was great in 99. But after that, it's like, yeah you probably don't want to be down there with the COBOL programmers because they're just not going to be paid much anymore. And there's not much COBOL to do anymore.
And so you have to watch out for that.

And, and that's going to take some of your time. outside of of work. Don't ever depend on your employer to take care of your career because your employer is not going to take care of your career.

**Jesse**: Yeah, it's funny, my first job, at well well, I was actually still in uni, but my first like full-time job programming was as a Perl developer. This was in 2017, right?

So this was very much on the tail end. And you know how it is with academics where they're kind of always a bit behind on the languages. And I saw firsthand that it's like, With the smaller number of people I was working with, there was this feeling in the air of like, this language is is on the decline and we're kind of in trouble here. And it was just interesting where, you know, ah if you are the kind of person who has not tried to stay on top of things, it's to your own detriment.

### Are calls for professionalism a form of gatekeeping?

**Jesse**: But I also wonder about like, uh, the, the, the choice of, of having this label of professionalism where it's like this very emotionally laden thing where it's like, if you do this, you're a professional, but if you don't do this, you're not a professional. I worry that it's kind of like, it's a two-sided coin where it's like on one side, it's very inspirational. It's like a call to arms.

Let's be professionals. Let's, let's, you know, let's, let's rise as a, as a group. But on the on the other hand, if you don't fit that category, you might feel a bit excluded by that. And what what you just outlined was a kind of dependency injection for goals, where it's like if you want to become a team lead, then you should do XYZ, right? And when you communicate it in that way, it kind of ah makes it a bit less incendiary, but you also lose the inspirational side as well. And I'm wondering like, is that a trade-off that's, that's, that you've made consciously where you've got those two different options. One's going to piss some people off because they're getting mad because you're kind of like, Oh, he's gatekeeping professionalism. But then on the other hand, if you do more, if you do the more, more descriptive way, it's kind of like not as inspirational. You know what I mean?

**Bob**: I think I know what you mean, yeah. So first of all, I don't mind gatekeeping. That's fine. i There's a certain amount of gatekeeping that you have to do.

I don't mind people getting upset because I'm being exclusive or the whole concept of is is exclusive because frankly it is, right? There are certain behaviors that we're not going to allow it in.

And there are other and behaviors that we want to promote.

So you know it's not like anything goes guys. yeah It's not like that. So I'm not too worried about the exclusive nature of it. Now, do we have a profession? And the answer to that is no. Is anybody a professional? No. Am I a professional? No, because I still don't have this set of ethics standards and disciplines that I can put on the wall and say, okay, that is my profession. What I do have are some skills and talents and principles and techniques that will eventually, hopefully one day build to a profession, but I don't have that profession yet. I don't have a way to do what the doctors did. I can't create a college and come up with a degree program and a training program that at one it eventually gives you the piece of paper that says you're a programmer, a real programmer, a professional programmer.

I don't have that. And so I'm just out there waving a flag saying, you know, we do kind of want that one day, guys.

And wouldn't it be a good idea if we thought about it? And then I'll say things like, you know, test-driven development, that's a heck of a good discipline for professionals. I think professionals probably ought to practice test-driven development. And if you're not going to practice test-driven development, are you really serious about being a professional? And then people get very angry and say, well, you're being exclusive. Well, OK. I mean, it's a good it's a good question to ask, I think. Now you mentioned earlier that there's other options for test-driven development.

And Kent Beck came up with another one a while ago. It was just test and commit or revert. I think that was an interesting idea.

**Jesse**: Yeah, that's a crazy idea. Like, I don't know. That's awesome. I've never done it myself, but it's like respect to anyone who does that.

**Bob**: Test-driven development is a very low stress discipline. And TCR is a really high stress discipline. Because you're going to lose it, man. You make one mistake. Revert. So, okay, fine. That might be another, another interesting discipline. And there are probably others that would satisfy just as well. The point is we ought to be looking and we ought to be, we ought to be looking at this category of testing and saying, okay, what are the disciplines that are going to satisfy this, this category?

And what are the behaviors that don't? And then, then the exclusives line comes in and say, okay, we're going to say, this is the line below that line. No, sorry. That's below our discipline standard and above the line is above our discipline standard. And we're still not close to that.

### Does professionalism come from individual choice or structural incentives?

**Jesse**: Okay, so I'm also keen to understand how much of what you're saying is about like individual agency versus incentives, right? Like how much of it is like, you know, as an individual, I'm gonna swear an oath and every day when I wake up in the morning, I'm gonna repeat the program as oath and then I'm gonna not ship bugs versus just having the incentive structure of being like, oh, if I if i fall short on this oath, then I'm gonna lose my license.

Does that make sense? Like how much of it's just like you want the individually better versus let's have an actual incentive to kind of in enforce these norms.

**Bob**: Oh, yeah. So i think I think you need both for that. and So for example, doctors do take an oath like that. And of course, they don't recite it every day in in the mirror when they wake up in the morning. But but they do have an oath like that, which I hope the medical profession takes seriously. Sometimes I have my doubts. But OK, I hope they do. And they do have an incentive structure. It's usually punitive. if you If you don't rise to the standards, they'll kick you out. You won't be a doctor anymore.

And usually there are legal consequences when you're a doctor as well. So there are those kinds of incentives. We as an industry have not faced that yet.
Well, not quite. There have been some programmers who have gone to jail for writing lying, cheating code, and that may increase the legal issues may start to increase more and more, as as society depends more and more on software.

So we may see that. And then the other side of it, the the the the definition of the standards will probably follow as a result of it.

## Bob Martin vs Martin Fowler

**Jesse**: Okay, so now I want to talk about thought leadership. So I think a lot about you and in in comparison to Martin Fowler.

You're both thought leaders who have a lot of shared history. You're both signatories of the Agile Manifesto. And the way I think about it is Martin Fowler is like an anthropologist who's kind of going into all these places and being like, yeah what's everyone doing? I'm going to try and surface that information in all of its complexity. Whereas you seem to be more like you want a theory of everything. And you're thinking about how can i how can I get some really simple principles that explain a bunch of different things.

**Bob**: Thank you.

**Jesse**: And I think about like Martin Fowler is kind of optimizing for precision, whereas you're optimizing for intuition, right? Because I'll read one of your blog posts and I'll think, you know, maybe programming is not so hard after all. And I mean, reading many of your blog posts, it actually does have that like aha moment. Whereas with Martin Fowler, I ah I'll appreciate the complexity, but I'll rarely come away from one of his blog posts thinking like, yeah, I've got this in the bag. It all makes sense now. I'm wondering, how do you respond to that, to that characterization?

**Bob**: Well, he's telling you the truth and I'm lying.

**Jesse**: Right.

**Bob**: That was a very interesting characterization. I hadn't heard that one before. you I think you you nailed Martin, right? he he likes He likes to get down into it, study it, be precise, you knowll look at the way certain teams behave and then he'll get some guys to write about how they how they behave and he'll help them get that published and so on. And I think that's very valuable. ah some of Some of the best work Some of the best work that Martin did, I think came in the early 90s, mid to early 90s.

He wrote a book, which i is my favorite of his books is Analysis Patterns. And that's at a time when he was behaving more like me.

You know, he was out there looking at at jobs that he'd done and oh look at I can do this and I can do that and I'm going to write this book and it's great and it's the kind of book that you know I would write today if I could.

And then as Martin got deeper into his career. He did the UML book. Eh, okay. You know, he did that because of whatever. And then, and then the refactoring book, which is spectacular, this refactoring, but just beautiful book. And then he did a number of other books.

He did the Patterns of Enterprise Architecture, which I thought was really, really good. And then as, as they go along, they kind of descend more and more into detail and more and more niche topics that are great. But they're not addressing the overall and programming environment.

Now, he just recently did a ah second edition of Refactoring, which is good. He redid it in JavaScript, which is great.

**Jesse**: That's cool

**Bob**: So yeah, i think I think the difference you've spotted is pretty good. you know Martin's a great guy. I love him to death. At some point, I'm going to have to go out and visit him and in the on the East Coast. I think he's made tremendous contributions.

And everything he writes is gold.

**Jesse**: Yeah, yeah, that's that's great.

## Artificial Intelligence

**Jesse**: All right, so now, I want to turn to artificial intelligence. And this is a topic for which I have no idea what your thoughts are on it, or even if you have thoughts on it. But I figured that someone like yourself who likes to think about things might have some things to say.

### Has AI changed how Bob programs?

**Jesse**: So first, I want to start by asking, has AI changed how you program?

**Bob**: Oh, has it changed how I program? No, no, not, not at all. Um, maybe in the slightest way I have used things like chat GPT to ask questions the way I would, I used to ask questions to stack overflow. Uh, and then I will get answers which are not as good as the answers I got on stack overflow, but at least their answers sometimes.

Um, but that's probably the, the, the most that I have been affected in my pro my programming career.

**Jesse**: Do you think, so presumably you're asking questions specific to Clojure?

I do wonder if the if ah if having a lack of training data there might give it worse answers because I'm writing a lot of Ruby these days and a lot of Go. Actually, Go would be a counter example, wouldn't it? Because there wouldn't be that much Go code compared to other things. Yeah, it's interesting. ah Because I find it very, I find it's changed my process a lot. I'm always pacing stuff in a chat GPT because it just seems to speed things up quite a bit. But it sounds like you are not really seeing the games because it's just, it's not accurate enough, not reliable enough.

**Bob**: Well, so I have used it in cases where I've got some API function from a framework. And it needs an argument. And I'm looking through the documents, and I can't find how what magic argument I have to give it.

There's some bit pattern I've got to put in there. And I can't find it in the docs anywhere. And looking around and going, OK, how do I call this? And I'll pose the question to chat TPT. And then like the answer will come back. And I'll try it, and it'll work. And I think, well, Okay, thanks chat GPT and then I'll ask chat GPT the question the question I really wanted answered Where did you find that information and it won't tell me? I don't know It's just something I know I don't know where I got that information from which I find very frustrating that that's kind of the limit now I've also done a few things like um
and get ah I'll get a ah function working. In Clojure, I've done this. I've got a function working.

Tests are all passing. Then I'll hand it to chat GPT or some other AI and say, refactor this, make it better. And it'll come back.

And sometimes it makes it better. Sometimes it makes it worse, in my view. But if it made it better, OK, I'll stick it in there and think, you know, I'm going to learn that trick because that's kind of a cool trick.

That's about the most I have done.

### Are developer jobs threatened by AI?

**Jesse**: Do you think that developer jobs are threatened by AI in the near or distant future?

**Bob**: No, no, no, not at all.

**Jesse**: No? Why is that?

**Bob**: Because the AIs are tools, and they're good tools, and they will help.

And as they get better, they can help us write code a little better, and they can help us write tests a little better. and all All of this stuff will get easier. And all that means is that there will be more for us to do. We'll have to do more. The the first programmers to get worried that they were going to lose their jobs for the programmers in the 1950s who watched Grace Hopper come up with a very primitive compiler called A0, which is a horrible thing.

But it it made it possible to write a program in a symbolic way as opposed to just raw numbers.

And the programmers of the era i thought, oh my God, we're all going to lose our jobs. the exact opposite happened. Not only did they not lose their jobs, we needed more people, because now all of a sudden we had more ability. With every advance like that, when we went from assembly language to compilers, when we went from compilers to object-oriented compilers, when we, every time we change technology, there is this fear, oh my God, all the programmers are going to go away. It happened with OO, it happened with C, happens it happened with logic languages, keeps on happening, and of course the exact opposite happens.

Because it makes more things possible, and we have to be able to take advantage of that.

So yeah, I'm not worried about that at all. I think it'll make our jobs easier and that will make it possible to hire even more people.

**Jesse**: That's really interesting. i think I think I agree with you in the sense that there's a lot of cases where we thought it was going to go bad and that actually the opposite happened. But there are also times where like you know horses didn't have that much to do after the car was invented, right? There was plenty of horse employment before the car was invented. And then it's just like, well, actually, they're not that useful beyond horse racing. And so I wonder, I think that there'll be a certain level of intelligence, if we ever reach it for AI, or at that point we go, Oh, okay, now it's getting tricky, because this is equivalent to a very intelligent human. And maybe there's there's just so much work to be done. And it just doesn't make that big of a difference.

### Will we achieve super-intelligent AI any time soon?

**Jesse**: But I suppose the next sensible question to ask is like, do you have any thoughts on the singularity or the idea that AI might become some self improving loop that then becomes like a super god AI that may or may not kill everyone? What's your thoughts on the singularity argument?

**Bob**: Well, I think you know it's Kurtzweil's great dream. i'm not I don't buy into the singularity argument for a real simple reason. Larry Niven long ago wrote a series of stories called The Magic Goes Away.

And in it's a set set way in the past, maybe in some other universe. And there were wizards who had magic and they could cast spells and do really interesting things. And one of these wizards got an idea. He says, well, you know what? I'm an um' going to make a set of spells that feed back on each other. And so each one is going to make the next one stronger and the next one stronger. And any he set up a system like that with a disk spinning in the air. And he made the disk go faster and faster and let the spells just run. And the disk was spinning and spinning and spinning. And then all of a sudden it slowed down and stopped. And the reason it slowed down and stopped, he had to work out, was that all the magic had been pulled out of that region of space. And the spells had no power to work with.

AI takes energy, takes a lot of energy. the more and The more we want it, the more energy it's going to use. If it ever did get into one of those feedback cycles, that energy usage would just go through the roof. And somebody's got to supply that energy. And right now, you know we're not doing all that great supplying energy. So number one, I think i think we'd have an energy top off, an energy limit. We just wouldn't be able to support it.

But from another point of view, I don't think it's theoretically sound. I don't think these machines are suddenly one day gonna wake up and then start designing better machines, you know like deep thought designing the machine that it's not worthy of calculating its but parameters. I don't think that's going to happen. I don't think the mice are ever going to get to figure out the meaning of the universe. So i don't I'm not worried about that. I think we are so far away from a human intelligence machine

We look at it now and we think, these things are really smart. No, they aren't. No, they aren't. They have the appearance of being smart in certain very narrow instances.

But these are not self-motivated, self-imagining things that can look out into space and wonder.

They don't do that. They just sit there waiting for you to probe at them. So I think we're very far away from that. I could go through some more numbers if you want to do it, but but it

### Would a super-intelligent AI programmer care about modularity?

**Jesse**: That's a very strong case. So i'm I'm keen to know, in a world where a super intelligent AI was created, let's assume that theoretically it is possible and it's just like super, super smart. Do you think that it if it was writing code, it would care about modularity in the same way that humans do?

**Bob**: But that's so wonderful. Yes, I believe it would care about it even more.

**Jesse**: Really?

**Bob**: If it's very, very smart, then things like modularity are going to be trivial. right It's just going to wash out. this that you know of A hyper-intelligent, super-intelligent computer writing code, all these principles that we have struggled for will be obvious. Oh, yeah, of course, single responsibility. I mean, why would you do it any other way? Of course. Oh Dependency inversion? Absolutely. you know why would all of that I'm going to go back to Larry Niven now. Have you ever read any of Larry Niven's protector series?

**Jesse**: No.

**Bob**: Okay, so, a little spoiler, a little spoiler.

**Jesse**: I clearly, I need to. Sounds like a pretty s smart guy.

**Bob**: Okay, so there's this planet out there somewhere in another galaxy and the the creatures on this planet are much like you know earth earth kind of biological creatures.

And there's one species that's hyper intelligent, hyper intelligent. yeah they they When they become conscious, they intuitively understand general relativity.
that's just It's just obvious, hyper intelligent.

But they become conscious from an earlier stage in their life when they were breeders. Now the breeders are not intelligent at all, they just breed. And then one day as the breeder achieves a certain kind of maturity, it gets a hunger for a fruit and they call the fruit tree of life. And if it eats the tree of life, it will engorge itself on the tree of life. And there's a ah biological agent in tree of life that puts the protector, it puts the breeder into a stupor and then changes occur in its body and its brain and it becomes the hyper intelligent protector. vctor but

**Jesse**: This is fantastic. I clearly need to read this book.

**Bob**: Oh, yeah no no you absolutely have to read just the the title of the first book is protector and You will love it and there you go this hyper intelligent being which does which the way Niven writes about it is that they are tinkerers and

They just tinker things together. Oh, and you know, a faster than light drive? Sure, tinker that together in the afternoon. No problem. ah You know, I need a telescope that can see across the galaxy. Well, I'll just build a black hole out there. And that's a nice gravitational lens. And then I'll use that to see what's going on outside of the galaxy. Very interesting, you know, machine and very interesting creatures, hyper intelligent creatures.

**Jesse**: That's really funny because I think it's, I've been thinking about, this is a weird thing to think about, but I've been thinking about puberty and how before puberty, I think about what the hell is puberty for, right? Like why not just from the get-go have fully matured sexual organs and so on. And I think about the mental effects and it seems like puberty is kind of there so that you have this period of just learning and just being purely like you're just absorbing information. It's all this intellectual stuff. And then you become self-conscious and you know you become an adult and all these things. And it's kind of like, to some extent, some of the best intellectuals are kind of childlike, if that makes sense. It's like they somehow maintain that childlike curiosity.

**Bob**: Yes. Yes.

**Jesse**: And it's funny how in in that story, you've got the breeders who are very, you start as the breeder, you're very uncurious, and then you eat the fruit. And it's like a puberty but in reverse, where it's like, okay, now I'm going to just focus on tinkering and curiosity. So that's really interesting.

**Bob**: Well, now that you have said that, you absolutely must read the book.

**Jesse**: Okay, maybe it's a maybe it's another plot twist.

## Wrapping up and what's next for Bob Martin

**Jesse**: All right, cool. Well, that's basically that's basically an hour. And that's all the questions that I had for you, Bob.

**Bob**: Oh, good.

**Jesse**: So yeah, I want to thank you for coming on the podcast.

**Bob**: Well, we fit that right in then. Of course.

**Jesse**: I want to recommend to my audience go and buy functional design. It was a fantastic book. I enjoyed reading it. And just as a closing thing, you know, where can people find you and what are you doing next?

**Bob**: Um, so you can find me on Twitter. I'm at uncle Bob Martin. You can find me on the web. I'm a clean coder.com or clean coders.com. Both of those work.

And the project that I am in the middle of right now is a book on software history. which goes all the way back to Charles Babbage and then crawls forward through Grace Hopper and people like Dykstra and all the way up to the guys who invented C, Dennis Ritchie and Ken Thompson and Brian Kernahan. and then goes through the things that I witnessed in my career and then a projection to the future.

So it's a book. I think the title is going to be We Programmers. It was just a blast for me to write it.

I did all this historical research and I i wrote these lovely little narratives for these people. The book is written for programmers, so it's a technical book. It gets into the structure of the machines and the problems they had, the technical problems they had. It's not one of those, you know, oh, well, computers were great back then kind of books. This is a a book for programmers to read, and they will appreciate.

**Jesse**: That sounds awesome. Well, I'm looking forward to reading that book. And yeah, thanks again for coming on. It's been great.

**Bob**: My pleasure. Good fun.

**Jesse**: All right.
