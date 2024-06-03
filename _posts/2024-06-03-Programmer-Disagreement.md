---
layout: post
title: "Why Can't Programmers Agree on Anything?"
---

The more you read up on software engineering topics online, the more you appreciate just how little agreement there is within the profession.

Some examples of topics which are (often surprisingly) contentious:

- [use of a debugger](https://news.ycombinator.com/item?id=37015253)
- [use of syntax highlighting in IDEs](https://groups.google.com/g/golang-nuts/c/hJHCAaiL0so/m/kG3BHV6QFfIJ)
- [testing private methods](https://news.ycombinator.com/item?id=30600479)
- [how many unit tests to write](https://martinfowler.com/articles/2021-test-shapes.html)
- functional vs object-oriented programming
- static vs dynamically typed languages
- hooks in react (compare [Hooks are the best thing to happen to React](https://news.ycombinator.com/item?id=28954450) with [Hooks are the worst thing to ever happen to React](https://news.ycombinator.com/item?id=25453421))

Why is this? Some possibilities:

## 1. The profession is still young

I'm yet to see a youtube video titled 'Building a Bridge, You're Doing It Wrong!'. I assume engineers who build bridges have all decided on how best to build a bridge, and I assume that's because nothing has changed in bridge building for the last hundred years.

But the world of software is ever-changing. Moore's Law has seen us having faster and faster compute over time, and storage has gotten cheaper at an even faster rate. Approaches that made sense in the past may now be obsolete.

On the other hand, we're not as young a profession as say... the revered TikTok Influencer profession, and they all seem to act exactly the same, so I suspect there's more to the story.

## 2. People work in different contexts

A software engineer working on critical infrastructure for NASA is going to have a very different take on the importance of testing than somebody working on an fledgling CRUD app.

Likewise, if you work in a high-performance environment where abstractions can hinder performance, you're going to have less affinity for abstractions than somebody working in a high-level language for a low-scale website.

## 3. People have different experiences

Even within the same company, working on the same tool, two people can differ in their values. One senior dev may have firsthand experience with the perils of under-abstracting (think codebases rife with copy-pasted code and making a small change requires changing 50 files) while another may have firsthand experience of the perils of
_over_-abstracting (think huge generalised 'systems' that nobody understands that were built in anticipation of future use cases that never came to pass).

With various strategies, it's hard to find the sweet spot, and if you've only experienced one side of the spectrum, you can over-correct in the opposite direction as someone else.

## 4. People's Brains are Wired Differently

Okay, what if two people grew up in the same town, attended the same university, took the same graduate job, and have worked together side by side until the present moment? They too can have completely different views on various programming topics, simply because their brains are wired differently.

Three factors come to mind:

- [Openness to experience](https://en.wikipedia.org/wiki/Openness_to_experience): This terribly-named personality trait from the Big Five Personality Traits describes intellectual curiosity, aesthetic sensitivity, and philosophical-...ness. I think many debates between developers revolving around purism vs pragmatism can be explained by this personality trait (for example I suspect the that the typical Haskell developer is higher in openness than the typical Go developer who is content writing for-loops all day.
- Complexity tolerance: Some devs are capable of keeping a very complex system in working memory, and others are not. I suspect short-term memory has a lot to do with it. Those with a lower complexity tolerance are more likely to keep things simple and strip out unnecessary complexity, whereas those with a higher complexity tolerance are more able to properly comprehend a complex problem domain and build an appropriate solution for it. Both sides have their own failure modes (over-simplifying vs over-complicating)
- Mental glitches: The `unless` keyword in Ruby breaks my brain. It also breaks [other people's](https://jesseduffield.com/Unless-Responses/) brains, but most people have no issue with it.

## 5. Contrarians

Speaking of people being wired differently: some people are wired to be contrarian.

Does [Rob Pike](https://groups.google.com/g/golang-nuts/c/hJHCAaiL0so/m/kG3BHV6QFfIJ) really think that syntax highlighting in your code editor is juvenile? I don't know. But I do know that so long as humans walk the Earth, there will be high-status individuals with absolutely wild views (I'd say it to your face, Rob), and those views will enjoy some mind-share.

It doesn't help that for sociological reasons, it pays to be contrarian. There's no such thing as bad publicity, and one easy way to get attention online is to just propose some crazy viewpoint backed by tortured arguments and wait as hordes of Hacker News commenters rush in to set the story straight.

No matter how absurd the contention, there _will_ be a post online arguing it.

## 6. It's hard to test hypotheses

So, we have programmers with different viewpoints due to a combination of personality and experience, some of whom are cynical contrarians who just want attention. How do we decide who's right on a topic?

I have no idea!

The process of creating software is so complex, with so many inputs, that it's really hard to empirically test if one approach is better than another. In fact, my friend recently joked that if he had to extrapolate from all the companies he had worked at over his career, he'd have to conclude that a company's success _negatively_ correlates with the quality of its tech.

There are some research papers that try to get hard numbers on things but if you read them, it's hard to come away thinking you're any closer to the answer. Take [this paper](https://www.cs.auckland.ac.nz/~ewan/qualitas/studies/inheritance/TemperoYangNobleECOOP2013-pre.pdf) on use of class inheritance in Java (emphasis mine):

> Our conclusion is that there is generally opportunity for replacing inheritance with composition, with 22% or more uses of inheritance between classes needed for external reuse but not subtyping in half the systems we examined. For internal reuse edges only, there are many fewer opportunities for replacing inheritance with composition, but they do exist for 2% or more of such uses in half the systems. **We cannot say whether replacing inheritance with composition is worth the effort because we have no way to quantify the costs of not doing so**. We do believe, however, that the prevalence of this use of inheritance is high enough to justify **further research effort needed** to understand how to quantify the costs, and also to give greater emphasis in teaching to avoid such uses of inheritance.

It's unfortunate that the big questions are always one _further research effort_ away.

Lacking in hard, conclusive research, we're left with two choices: scour Reddit and Hacker News for anecdata, or if possible, run your own experiment. Either way, once you've formed your own opinion, it's not going to be easy to convince somebody _else_ that it's the right one.

## 7. We actually agree on almost everything

Here's a contrarian hot-take: what if programmers actually DO agree on almost everything and everything that I've written above is based on a false premise?

[Selection bias](https://jesseduffield.com/Selection/) creates the illusion of disagreement when in fact most developers agree about most things.

Nobody wastes their time talking about how important it is to test your code: pretty much everybody already concedes the importance of testing. Instead, we all like to spend time arguing about how best to test it (unit tests vs integration tests, etc).

So what about topics that are somewhat controversial? Even there, what you see online is not representative of normal people. A tiny fraction of people post online; an observation titled the [_1% Rule_](https://en.wikipedia.org/wiki/1%25_rule). Almost everybody lurks! The people who actually contribute to the conversation are [insane](https://www.reddit.com/r/slatestarcodex/comments/9rvroo/most_of_what_you_read_on_the_internet_is_written/) people (I can personally attest to this myself). And you don't get to see how many lurkers there are: all you witness is the insanity. In Hacker News, you also don't get to see how many people agreed with a comment, and rarely will somebody leave a comment to say 'I completely agree!'. So no matter how innocuous the topic: you'll inevitably see threads where people fight tooth and nail over some trivial technicality, showing what appears to be an even-split in sentiment, when one perspective may in fact be getting an overwhelming share of upvotes. Imagine if each and every upvote was rendered as its own '+1' comment alongside all the other comments. That would give you a much better feel where the concensus lies (at the cost of incentivising people to only express popular opinions).

The counterpoint to this is that I've never had a single real-life conversation with a developer on a programming topic that doesn't involve a disagreement about software practices at some point. So it's not just the internet where disagreements show up.

## Conclusion

Programmers disagree on various topics, for various reasons. Personally, I wouldn't have it any other way. I wouldn't want to live in a world where all of these software topics are settled and boring. Debates about programming are interesting and intellectually stimulating, and unlike debates about, say, politics, you're unlikely to lose any friends when you express your functional-programming hesitancy. Maybe, at the end of the day, that's the real reason there's so much disagreement among devs: because it's so _fun_.
