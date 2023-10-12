---
layout: post
title: "Can't Be F*cked: Underrated Cause of Tech Debt"
---

> _Can't Be Fucked_ 
>
> Aussie slang for not wanting to, or not having the energy and motivation to do something. 
>
> "Man, i really can't be fucked changing the channel, let's just watch Springer." 
>
> _- Urban Dictionary_

I used to think that if I could just learn a bunch of things about programming, that would make me a better programmer. Sure, the learning I've done so far _has_ made me a better programmer, but the person I was striving to become was a little more... admirable. Whether it's at work or in my open source travels, I routinely come across developers who are the real deal: they're conscientious and judicious in an unwavering way. They set a standard for themselves and do not compromise on it. Whether that's a deliberate thing or whether they're just built that way, it's humbling to witness. If there's a flaky test, they investigate it and fix it. If there's a bug they spot in the wild, they make a ticket, and maybe even fix it then-and-there. If a new feature doesn't gel well with the existing code, they refactor the code first rather than hacking the feature in. They'll dive as far down the stack as necessary to get to the bottom of something. None of these things are necessary but great developers know that if they don't address a problem early, and properly, it will only cost them more time in the long run.

'But,', you say, 'premature optimisation is the root of all evil! Duplication is better than the wrong abstraction! Don't be an architecture astronaut!'

The developers I'm thinking about already know of all those takes and have internalised them long ago. They know that sometimes 'good enough' _is_ the right choice given the constraints of a project. They know that sometimes you need to cut scope to stay on-track. They know that sometimes it's better to wait to learn more about a domain before rearchitecting a system. And yet in spite of those constraints their output remains golden. These are hard working motherf*ckers whose diligence and perseverance put other devs to shame.

Other devs... like me.

Sometimes, I just CBF. I spent months (part time, of course) building out an end-to-end test system for my open source project Lazygit, and every day I think of all the regressions that system has prevented and how much harder it would be to add that system now given how many tests have been written since. I know for a fact it was worth the effort. So why haven't I added end-to-end tests to my other project, Lazydocker? Because I CBF.

I raised an issue in somebody else's open source repo and they asked me to present them with a minimal repro git repo. Why haven't I done that yet? Because I CBF.

Why do I still have so much of my code living in a God Struct? If I could just finish that big refactor I started over a year ago, my codebase will be far easier to navigate and contribute to. The answer, dear reader, is that I CBF.

Is it burnout? Maybe. Is it a lack of Growth Mindset? Hard to say. Is it just the reality of my personality? Who knows.

As I continue my journey as a developer I learn more about myself, and one of the things I've learnt is that my motivation ebbs and flows. I'll have a good run, inhabiting the persona of the developers I look up to, however imperfectly, until I once again find myself with the constraint that trumps all the extrinsic constraints of the project at hand: a deficiency of motivation.

I've also learnt that knowledge only gets you so far. I'm still just scratching the surface of all the developer-y things there are to be learnt, but even for the topics I consider myself knowledgeable, knowing what's right and doing what's right are two very different things. Knowing the long-term pain of tech debt is certainly a motivator for avoiding it, but it's no guarantee.

And sometimes knowledge can be wielded impiously: 'I'd add more tests but too many tests creates a maintenance burden'. 'I _could_ refactor this but I want to wait a little to see how other features affect things'. 'Keep It Simple, Stupid'. 'Premature optimisation', 'Cut scope aggressively', etc. These maxims can be deployed for evil just as well as good. Have you ever hid behind one of these lines to hide the fact that in reality you just CBF?

Maybe you don't have the energy to write perfect code, but honesty requires less creativity than lying. It's a breath of fresh air when a contributor admits some element of their pull request is lacking because they're lazy. At least then you have the opportunity to judge for yourself whether their laziness exceeds your own standards or whether their time is indeed better spent working on the next thing. That's a much easier game to play than bandying software engineering maxims.

So, if you find that you CBF, don't be dismayed; it happens to everyone (except those very special people we all aspire to). If in the moment you don't have the strength to overcome it, at least be honest. And if you've been going 100% for too long, maybe it's time to take that holiday.

I'd like to end this post with an exploration about how laziness evolved for a reason and that despite us all wishing we had more motivation, there are benefits to being frugal with our energy, but... I CBF ;)
