---
layout: post
title: "The Perfect Developer Personality"
---

> Mauro, SHUT THE FUCK UP!
>
> _- [Linus Torvalds](https://lkml.org/lkml/2012/12/23/75)_

You can practice programming all day long and it won't change who you are as a person. Experience can be developed over time but no amount of Growth Mindset is going to turn an introvert into an extrovert.

This strikes me as important, because as I encounter more and more people who are both smart and experienced, it's dawning on me that personality is often a person's main differentiator. From the risk taking cowboy to the high blood-pressure nervous wreck, personality can make all the difference to the code that ends up in the hands of end users.

So, could there be a personality which is perfectly adapted to the art of software development?

I'm going to dig into this question using the Big Five Personality Traits. They are:

- Openness to experience (inventive/curious vs. consistent/cautious)
- Conscientiousness (efficient/organized vs. extravagant/careless)
- Extraversion (outgoing/energetic vs. solitary/reserved)
- Agreeableness (polite/compassionate vs. critical/judgmental)
- Neuroticism (sensitive/nervous vs. resilient/confident)

Let us now joyfully indulge in some sweeping generalisations as we construct the persona of the perfect developer.

## Openness to Experience

> Syntax highlighting is juvenile. When I was a child, I was taught arithmetic using [colored rods](http://en.wikipedia.org/wiki/Cuisenaire_rods). I grew up and today I use monochromatic numerals.
>
> _- [Rob Pike](https://groups.google.com/g/golang-nuts/c/hJHCAaiL0so/m/kG3BHV6QFfIJ), Go author_

> Avoid success at all costs
>
> _- Simon Peyton Jones, major Haskell contributor_

Being high in openness does not mean you simply enjoy travelling and camping, as the name suggests. Rather, it's about intellectual curiosity, appreciation of aesthetics, creativity, and affinity for abstractions.

People low in openness are more likely to refer to themselves as pragmatists than purists, and have an allergic reaction anytime somebody starts talking about philosophy by the water cooler.

How does this map on to software development? Consider one's choice of programming language. It's hard to imagine a Haskell developer choosing the language because they only care about 'delivering business value'. Conversely, Go developers have an almost pathological aversion to abstraction: there are still some who consider the addition of generics to be a mistake! Openness also relates to appreciation of aesthetics, so it should be no surprise that Rob Pike, one of Go's original authors, famously remarked that syntax highlighting is ['juvenile'](https://groups.google.com/g/golang-nuts/c/hJHCAaiL0so/m/kG3BHV6QFfIJ) and, to this day, Go's official [playground](https://go.dev/play/) lacks syntax highlighting.

But who would you rather have on your team? The Haskell developer who cares more about the beauty of higher kinded types than the nuts and bolts of the required functionality or the Go developer who couldn't care less about all that bullshit and just wants to ship a feature?

Low-openness individuals sure know how to Get Shit Done, but occasionally the Shit That Needs Doing requires some more creativity and ingenuity, and it's in those times that a high-openness individual can compensate for their over-engineering (and insufferable philosophical pontificating) by coming up with an elegant solution.

## Conscientiousness

Conscientiousness has two sub-facets which are worth addressing independently: industriousness and orderliness.

### Industriousness

> I choose a lazy person to do a hard job. Because a lazy person will find an easy way to do it.
>
> _- Bill Gates_

Individuals high in industriousness have a strong work ethic, self discipline, and show persistence in working towards goals.

Learning to code in the first place requires a lot of hard work, but even once you've learnt the basics, building anything worthwhile requires sustained effort and attention. It is not enough to simply know what you should do, you need to have the willpower to actually _do_ it. That means writing tests, refactoring, or doing some backwards compatibility gymnastics when the need arises. Many developers just [Can't Be Fucked](https://jesseduffield.com/Can't-Be-Fcked/), which leads to features which break everything upon deployment, or slowly decaying codebases which turn into an unmaintainable mess. Sometimes this is the result of temporary burnout, but different people have different baselines for how much willpower they have available to spend each day.

Being too high in industriousness can be a problem though: as Bill Gates says, often it takes a lazy person to look for an easier way to solve a problem, and the programming profession is unique in that there is effectively no limit to how much automation we can introduce to make our jobs easier.

### Orderliness

Orderly people like cleanliness, order, and consistency. They are usually more organised and like routine more than their disorderly counterparts.

Orderliness matters for creating a maintainable codebase. There are so many areas where it helps to care about consistency:

- consistent naming conventions
- consistent use of idioms
- consistent use of structures
- _logical_ consistency

One of the best ways to reduce inconsistencies is to create abstractions (such as extracting out multiple blocks of repeated code into a single function). It's for this reason that orderly individuals are big fans of the DRY (Don't Repeat Yourself) principle.

However, being too trigger-happy on abstractions can lead to the creation of [Wrong Abstractions](https://sandimetz.com/blog/2016/1/20/the-wrong-abstraction) which ends up creating a bigger mess than if you had left some duplicated code alone.

Orderliness also negatively correlates with creativity and flexibility, which can be a challenge if you're dealing with open-ended problems or frequent change. Also, while high orderliness protects against tech debt, sometimes in a competitive environment, taking on tech debt is necessary to be first-to-market.

## Extroversion/Introversion

> [Solitude is Bliss](https://www.youtube.com/watch?v=-F2e9fmYL7Y&ab_channel=tameimpalaVEVO)
>
> _- Tame Impala_

I'm the kind of introvert who makes a physical therapist faint when I tell them how long I spend sitting at a computer each day. I still go out and do things with friends but I'm in my happy place when I am doing something fun in solitude. Luckily for me, writing code can be done in solitude!

Unluckily for me, writing code is only one part of the software development process. If you're in a team, you need to review others' code, and other people need to review your code. You need to interview prospective hires, do standups, one on ones, retros, pairing, talking to vendors, talking to customers, so many things involving other human beings! Those guest lecturers in uni weren't kidding when they said soft skills were important. And who has better soft skills than extroverts?

If you're going to actually be working with code though, _hard skills_ do matter. Bob Martin [says](https://youtu.be/qdcamTUcuAQ?t=1764) that to be a _professional_, you need to spend 60 hours a week honing your craft, which means 20 hours outside of your day job. Regardless of whether you agree with his gatekeeping, it's a much easier sell if you're happy to spend those 20 hours reading programming blog posts or tinkering on with side projects in isolation.

Yet there are some extroverts who like programming, and they have some unique advantages. They're more likely to reach out to others for help, or to get a mentor, or participate in programmer discord groups or subreddits. These are the people who participate in a programming language or framework 'community', which has always been a bit of a foreign concept to me as somebody who obtains their information through non-communal means.

Where introverts develop a strong capacity for independence and self-reliance, extroverts develop a strong capacity for making the most of the humans around them. Nevertheless, I still consider introverts to have the advantage, given how many successful programmers are blatantly introverted.

## Agreeableness

> I'm a bastard. I have absolutely no clue why people can ever think otherwise. Yet they do.
>
> People think I'm a nice guy, and the fact is that I'm a scheming, conniving bastard who doesn't care for any hurt feelings or lost hours of work, if it just results in what I consider to be a better system.
>
> And I'm not just saying that. I'm really not a very nice person. I can say "I don't care" with a straight face, and really mean it.
>
> _- [Linus Torvalds](http://linuxmafia.com/faq/Kernel/linus-im-a-bastard-speech.html)_

Agreeable people are polite, compassionate, and care about harmony. Disagreeable people are more assertive, more likely to prioritise their needs over the needs of others, and more willing to engage in conflict.

Disagreeable people are absolutely essential for the success of a business. You simply need to have somebody who will call a spade a spade and who will resolve tensions as they arise rather than sweeping them under the rug in the name of harmony. Linus Torvalds, a notoriously disagreeable leader, does not mince words, and despite some episodes of harsh language, he is still widely revered for direct and clear about his standards.

Harmony is still important though, and a team works best when its members genuinely believe that their peers and superiors have their best interests at heart.

To specifically hone in on the two sub-facets of agreeableness: politeness and compassion, there's some evidence to suggest that low compassion corresponds to high interest in systems. John Carmack of Doom and Quake fame was sentenced to a year in a juvenile home after breaking into a school to steal computers, and was described by a psychological assessment as having 'no empathy for other human beings'. Though personality traits are fairly stable in adulthood, plenty can change in adolescence, and John himself admits he was a [jerk](https://games.slashdot.org/story/99/10/15/1012230/john-carmack-answers) at that age. But I still have a feeling that the more compassion somebody has for others, the less interested they'll be in immersing themselves with the nitty gritty of technology. Of course, you'll need _someone_ on the team who cares about human beings, given those are your end users.

## Neuroticism

> People with too much anxiety end up in the psychiatrist's office. People with too little anxiety end up in the morgue.
>
> _- a guy on a podcast I listened to, whose name I forget_

Fear is an intrinsic part of the developer experience. Few things in this world are more panic-inducing than running a database update command in a production console that's supposed to take a split second and watching the black abyss of the terminal as the command continues without any feedback for multiple seconds. Suffice it to say that in a Rails console, there is a world of difference between `tag.update(deleted_at: now)` and `Tag.update(deleted_at: now)`.

As my psychologist says, apparently when the fight-or-flight response kicks in, your judgement can become clouded, leading to poor decision making. But in the same way that paranoia is beneficial when the CIA actually _is_ after you, the curse of anxiety becomes a blessing if it means you're anticipating all the ways that your code could break, especially if all it takes is the wrong casing on a single character to delete an entire table.

A friend and former colleague of mine once woke up at 3am in the morning with a premonition that something had gone horribly wrong in our background job system, and upon checking, he was confirmed right, and was able to fix the problem before it became a _real_ problem. The man's supernatural paranoia saved the day.

On the other hand, my own fear of edge cases over the years has resulted in some unnecessarily complex logic that would have been much cleaner and more maintainable if I just chilled out a bit and spent more time thinking about whether the imagined edge cases were actually the show-stoppers I thought them to be.

Being too neurotic can also stop you from making the changes that need making, like when the legacy code at the heart of your product is tearing at the seams and needs a refactor. Sometimes it takes somebody low in _withdrawal_, one of the sub-facets of neuroticism, to go and do a big refactor to fix a problem that everybody else was too scared to fix.

My Lazygit co-maintainer Stefan will regularly go and argue with the git maintainers in the git mailing list for [changes](https://public-inbox.org/git/adb7f680-5bfa-6fa5-6d8a-61323fee7f53@haller-berlin.de/) to git's functionality; something I would never in a million years presume myself worthy of doing. Part of that is disagreeableness, industriousness, and perhaps some extroversion, but a lot of it is just having balls, aka low withdrawal.

The same neuroticism that can protect you from nasty bugs may hold you back from doing things that need doing, especially when those things have nothing to do with code.

## Diversity

We set out at the beginning of this post to construct the perfect developer personality, but what we've found along the way is that for each facet of personality, there are benefits to being high and low on the spectrum. Although I think that industriousness, orderliness, and introversion are all useful traits for a developer, there are counter-examples, and with other traits like agreeableness and neuroticism, it's not clear how large a dose you'd want.

So perhaps we should not be trying to define the perfect personality, but rather the perfect _team_.

Who is in our perfect team?

We need a down-to-earth, low-openness person who can content with the nitty-gritty details of the problem at hand and get shit done just as much as we need the blue-sky-thinking high-openness person who can think up clever solutions to hard problems.

We need the industrious hard-worker who will stop at nothing to get a job done, and we need the slightly less industrious worker who hates work so much that they'll come up with creative ways to automate their job.

We need the orderly worker who enforces consistent patterns in the codebase to keep it maintainable, and we need the less orderly worker who is adaptive and flexible.

We need the extrovert who loves interacting with people and can manage individuals and interface with vendors and clients, just as much as we need the introvert who likes nothing more than spending 8 hours a day glued to a computer screen.

We need an agreeable person who cares about harmony within the team, as well as a disagreeable person who will call a spade a spade.

And finally, we need not just a stress-head who takes very seriously the chance of a data breach, but the cool head who makes bold decisions and takes risks when necessary.

Different problem spaces will call for a different team makeup. If you're working on medical technology, it helps to be more cautious than if you're building a CRUD app. But with so many varied problems to solve, it helps to have the full range of traits covered.

Personality is a very broad topic and I've employed plenty of hand waving in this post, so I'd love to get your thoughts on the topic. How do you think personality influences a developer's output?

Till next time!
