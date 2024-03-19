---
layout: post
title: Should Open Source Developers Get Paid?
unlisted: true
---

Recently, I was lucky enough to be chosen as a Pioneer in [Codacy's Pioneers Program](https://www.codacy.com/pioneers), which offers mentoring and funding for open source developers. During a promotional interview with the Codacy team, I was asked whether I believe open-source developers should be paid for their work.

I would love to say that I had a reasonable and charming answer up my sleeve, but the truth is that I completely botched it. I would give an answer, retract it, think again, then give another answer. I did this a few times.

To the team's credit, I was given plenty of time to sort out my thoughts but the truth is, the question was too big for me to tackle in real time.

Which is why it's so good to be back in the cosy comfort of the written form, where I have all the time in the world to think things through. This post is my attempt to properly answer the question: _should open source developers get paid?_

"Should" is a magical word: it takes a topic from the boring world of pragmatism and incentives and elevates it into the world of _ethics_, where internet thought leaders wage daily battles over what we're morally obligated to do.

People generally don't like being told that they're falling short of their moral obligations (just ask my dad what he thinks about vegetarians), so when somebody says 'We should definitely be paying open source developers more!' it's bound to ruffle some feathers.

So what do our thought leader overlords have to say?

## What Others Are Saying

[David Heinemeier Hansson (DHH)](https://en.wikipedia.org/wiki/David_Heinemeier_Hansson), creator of hugely successful open source project Ruby on Rails, [decries](https://world.hey.com/dhh/i-won-t-let-you-pay-me-for-my-open-source-d7cf4568) the encroachment of market-based thinking into open source. Instead, he advocates for keeping money out of it so that open source developers don't feel indebted to their users (or donors):

> Open source, as seen through the altruistic lens of the MIT gift license, has the power to break us free from this overly rational cost-benefit analysis bull\*\*\*\* that’s impoverishing our lives in so many other ways.

DHH sees open source development as a pure form of self expression which can only be tarnished by introducing money into the equation. He believes you have two choices: introduce money and become a slave to your customers (be it sponsors or paying users), or eschew money and retain complete freedom.

It's a deliberately provocative dichotomy, but I have to say it does resonate. Burnout is a big thing in open source and most burnout happens when you start to feel like you're working because you _have_ to, and not because you _want_ to. If you accept money for your open source product, it's often with strings attached like providing support or prioritising tickets, which can be dull and unsatisfying work.

But hang on, accepting money in exchange for dull and unsatisfying work: isn't that the typical day job? Indeed it is, with the difference being that unless you're [Linus Torvalds](https://en.wikipedia.org/wiki/Linus_Torvalds), the typical day job pays much better than an open source income.

Let's contrast DHH's thoughts against those of [Salvatore Sanfilippo](http://invece.org/), creator of the world's de-facto standard distributed key-value store, [Redis](https://redis.com). Salvatore believes that given the amount of value that open source projects create for companies, it's unfair that they are compensated so poorly:

> In my opinion instead what the open source does not get back in a fair amount is money, not patches. The new startups movement, and the low costs of operations of many large IT companies, are based on the existence of so much open source code working well. Businesses should try to share a small fraction of the money they earn with the people that wrote the open source software that is a key factor for their success, and I think that a sane way to redistribute part of the money is by hiring those people to just write open source software (like VMware did with me), or to provide donations.

Salvatore also claims that if you could compensate open source devs better, the increased output from open source would have a far better impact on the economy than whatever they produce at their day job.

> Many developers do a lot of work in their free time for passion, only a small percentage happens to be payed for their contribution to open source. Some redistribution may allow more people to focus on the code they write for passion and that possibly has a much \[more\] _important effect_ on the economy compared to what they do at work to get the salary every month. And unfortunately it is not possible to pay bills with pull requests, so why providing help to the project with source contributions is a good and sane thing to do, it is not enough in my opinion.

As you can see, DHH and Salvatore have little overlap in their perspectives. DHH sees money as a corrupting force which gets in the way of self actualisation, whereas Salvatore sees money as a means of giving devs the freedom to work on their open source projects in the first place. DHH believes that so long as an open source dev has not asked for money, no money is owed, whereas Salvatore believes that the creation of value by open source projects is sufficient to obligate companies to compensate the devs.

## Ethics and Incentives

So there are two separate questions in play: the ethical question of whether open source devs deserve more money, and the practical question of whether more money actually incentivises better outcomes.

The ethical question, at its root, is a question about _desert_. Not desert as in camels and sand dunes, but desert as in 'does X deserve Y?'.

This is probably a good time to mention that I don't believe in free will, and this has a huge impact on how I approach ethical questions. I don't think that anybody deserves anything, good or bad! I don't think the worst possible criminals deserve punishment, or that the best possible heroes deserve medals. But (bear with me) I do think it's great that criminals are punished and heroes are rewarded because it incentivises good behaviour.

This brings us to the practical question: regardless of whether open source devs deserve more money, does money actually incentivise open source devs to create more value?

At a basic level, if money couldn't incentivise hard work, there would be no point in companies paying high salaries to attract talent. By this logic money should have the power to create more open source value.

Open source tools like [Magit](https://magit.vc/) would not be where they are today were it not for its maintainer [Jonas Bernoulli](https://twitter.com/magit_emacs?lang=en) running a [successful kickstarter campaign](https://news.ycombinator.com/item?id=15312288) to fund a year of full-time work on the project. And, to this day, he continues working on his open source work full-time.

The burnout we typically associate with open source is not from a developer working on open source, but from a developer balancing open source with a demanding full-time job, which is only needed to pay the bills because open source work can't.

## My Open Source Experience

I'm an above-average earner from open source—which is not hard when the median is zero dollars. And yet if you consider the time I've poured into [Lazygit](https://github.com/jesseduffield/lazygit) over the last five years I'm easily being paid less hourly than an minimum wage worker!

I don't consider this an injustice at all: I've had a complete blast working on the project and it's my proudest achievement in life so far. Even if it doesn't pay proper salary, every time I'm notified that somebody has sponsored me, I get a warm feeling that really does motivate me to continue maintaining and improving the project.

And as I'm moving into a new role where I'll be making zero dollars from my day job (at least for the next year), Lazygit is (absurdly) now my main source of income. This creates an even larger incentive for me to continue maintaining it.

But can I honestly say that if all donations stopped I would stop working on Lazgit? As much as it contradicts the above, the answer is a resounding _no_. Humans do things for many reasons, and money is only one of them.

For one, I'm an avid Lazygit user (as you can imagine), so I directly benefit from every improvement to it. But more generally, working on Lazygit is _fun_. Fun encapsulates various things like problem solving, creativity, street cred, self expression, and utility—all of which can be found in the world of open source development.

Perhaps it is tragic that most of the fun things in life pay the worst, but that doesn't stop them from being fun.

## Conclusion

To me, the important question is not 'Should open source devs get paid?', it's 'Why do open source devs work without pay in the first place?' and the answer is that there is much to love about the experience of open source work that has nothing to do with money: creative problem solving, collaboration, personal utility from the tool you're building, the list goes on.

I don't see money as a corrupting force like DDH does, nor do share Salvatore Sanfilippo's perspective that the lack of money in open-source is _unfair_. I see money as a nice bonus on top of the existing perks of working on an open-source project.

So, I'm all in favour of open source devs being paid more, but I expect that things will continue chugging along just fine whether or not society finds ways to channel more money to the open source cause.

As for me, I'll continue working on Lazygit until it stops being _fun_.
