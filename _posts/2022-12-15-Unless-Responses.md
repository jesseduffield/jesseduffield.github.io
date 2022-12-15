---
layout: post
title: Don't Read This Follow-up Post 'Unless' You ARE A Non-Ruby Developer
---

My last post on Ruby's `unless` keyword was lucky (or unlucky) enough to get some attention in its own comments and on Hacker News. Thanks to everybody who took the time to read it and comment :)

In this post I'm going to address some of the themes I saw in the comments. The three bigs ones are:
* Who cares if a language is readable to people unfamiliar with the language?
* All language constructs can be abused, who cares?
* How hard is `unless` to read, really?

Alright, onto the first topic:

## Who cares if a language readable to people unfamiliar with the language?

In the post, I say:

> As a general rule I think that if a language has some feature for which there is already a commonly understood syntax across other languages, it should just use that syntax. If you’re introducing a complete paradigm shift, then that’s fine, but `unless` is not that: it’s just a different way to write `if !` and people jumping back and forth between ruby and, say, javascript, now have one extra idiosyncracy to keep in mind.

One commenter says:

> Personally, I don't think "readable by people that don't know the language" is a reasonable feature to optimize a language around.
- [HN](https://news.ycombinator.com/item?id=33974501)

Another commenter says:

> Matz has a very interesting and famous quote about the principle of least surprise: "it means the principle of least surprise after you learn Ruby very well."
- [HN](https://news.ycombinator.com/item?id=33978439)

I partially agree: if every language was bound by the principle of least surprise to never diverge from other languages, then what's the point of having multiple languages? I firmly believe that every developer should go through an gestation period with a language before making judgements about its readability.

On the other hand, when you need to switch back and forth between languages each day (e.g. jumping between a Ruby backend and Javascript frontend, as many do) small idiosyncracies in the language can be a pain. Of course, JS and Ruby have so many differences that you could argue that `unless` is the least of your problems, but I see `unless` as having sufficiently little value that removing it helps reduce that friction at a low cost. But this is my personal experience and if you find `unless` to be a great language feature, then the cost won't seem as low to you.

## All language constructs can be abused, who cares?

There were a couple of comments to this effect:

> All language can be abused if you try hard enough
- [HN](https://news.ycombinator.com/item?id=33969386)

> My point is that experienced engineers will use the language as it was intended to and not abuse its features.
- [HN](https://news.ycombinator.com/item?id=33976764)

I'm very sympathetic to this argument, given that I've criticised Go for leaving out constructs that I thought would be useful, even if there was a chance for abuse (e.g. ternaries). In fact, even within ruby there are constructs I find to be often abused that I think nonetheless are elegant enough that I like them. For example, ruby has post-if conditions:

```ruby
return if user.nil?
```

If you tack an if-condition at the end of a super long line, it tends to get buried and the reader might believe that the line of code is executed unconditionally:

```ruby
delete_all_database_tables || raise "Failed to delete all database tables. Check to ensure that your database instance is running" if Rails.env.test?
```

That's the kind of code that could make a person fall out of their chair if they didn't notice the if-condition at the end. And yet, I like that I can use a post-if for a one-liner guard clause and save some vertical space. As long as the `if` is in peripheral vision from the start of the line, I'm fine with it.

So I'm not an anti-abuse nazi (oxymoron I know), I just think that unlike post-if conditions, `unless` doesn't have enough of a benefit to justify the costs that I _personally_ perceive (more on that later).

Okay, so what if you have a linter rule that says you can't use unless with a negation (e.g. `unless !A`) and you can't use unless with a conjunction (e.g. `unless A || B`). Well then the capacity for abuse goes down dramatically. There are _still_ however, some things that a linter might fail to catch (depending on how sophisticated it is). For example:

```ruby
unless n < 0
```

can be converted to:
```ruby
if n >= 0
```

Which I find clearer because there's no negation (I'd be interested to know if any readers can think of cases where they prefer the first option). But let's say that you do find the second option clearer, and you _can_ write a linter to catch that case. Well then `unless` becomes pretty much impossible to abuse. Most people in the comments say that `unless` works best for simple guard clauses so I think there's a demand for such a linting rule, but alas no such rule currently [exists](https://github.com/rubocop/rubocop/issues/5388) (for understandable reasons if you take a read through that thread).

## How hard is `unless` to read, really?

The more I read through comments and see the arguments put forth, the more I realise there are basically two kinds of people: there are those who concede that unless can be abused but who personally find it to be a good feature, and there are those like me whose brain just breaks whenever they encounter `unless` and who need to waste time translating it to `if !`. Some examples (check the comments threads ([1](https://news.ycombinator.com/item?id=33965933), [2](https://jesseduffield.com/Unless/)) yourself to get a feel for the proportions):

> Just to offer my own $0.02: I've been working with Ruby professionally for ~8 years, through being a Homebrew maintainer for ~12 years and programming professionally (not just using Ruby) for ~14 years and: I find all cases of unless ... || or unless ... && (including the above) hard to mentally parse and, particularly, to accurately and consistent reverse the logic (by turning it into an if).
- [github](https://github.com/rubocop/rubocop/issues/5388#issuecomment-756026502)

> Weirdly, Ruby was one of the first languages I learned early in my career, and at the time I had no problem with `unless`. But after years of experience with other languages, I similarly feel that `if` statements now trigger the fast pattern matching circuits in my brain, while `unless` makes me do a double-take and basically translate it into `if not`
- [HN](https://news.ycombinator.com/item?id=33965933)

> ...But every time I read "unless" in code it's quite jarring. I have to consciously translate it to "if not", and even then seeing the "unless" keeps tripping me off, perhaps because it's awkward in English to start a sentence out of the blue with "unless".
- [HN](https://news.ycombinator.com/item?id=33971759)

> ...I love Ruby, but the 'if' variation always get immediately parsed by my brain, while the 'unless' variation requires many seconds of thinking.
- [HN](https://news.ycombinator.com/item?id=33975421)

> As a ruby dev of 5+ years, I still have an easier time with `if !ruby_dev`. I have to translate `unless` to `if !` every single time to grok something. Almost like an extra step in an algebraic expression being simplified.
- [HN](https://news.ycombinator.com/item?id=33985643)

> 'if !something' clicks instantly. for 'unless' I have to read out the statement in my head, and draw mental logic lines about what condition this is checking.
- [HN](https://news.ycombinator.com/item?id=33965933)

> 'I've written ruby everyday for the past 5 years. I still cannot read an unless statement and understand it first time. Most of the time i'm translating it to `if !` anyway'
- [HN](https://news.ycombinator.com/item?id=33966573)

> I've been doing Rails for 10+ years and `unless x` absolutely breaks my mind. I have to internally convert it to `if !x` and evaluate it in my head 90% of the time
- [HN](https://news.ycombinator.com/item?id=33973885)

My goal with the original post was to see just how small a minority I was in, and I'm pleasantly surprised to find I'm not as alone as I had thought. But if I had known that from the start, I probably wouldn't have spent so long trying to argue from the perspective of somebody who thinks `unless` helps readability _sometimes_. Instead I would just say 'loads of normal people really struggle with this keyword despite being familiar with it'.

So arguing about whether it can be abused, and by how much, seems to neglect the core of the issue (conveniently for me given that in the above section I concede that linting rules can reduce the risk of abuse). The core of the issue is that some people like `unless` _despite_ the potential for abuse, and some people dislike it _regardless_ of whether it's abused. How do you reconcile that?

Well obviously you just apply some utilitarian ethics and say that the suffering of the cohort who struggle to read `unless` outweighs the joy of those who like it and because you can't argue against lived experience, that means that now everybody has to do as I say! Ha, Take that! But of course you could argue that people like me are just refusing to take `unless` at face value and that our choice to translate it into `if !` is just a result of giving in to the paranoia that we're going to think the condition was `A` when it was actually `!A` and cost our company millions of dollars (I genuinely think that may be what's going on here and I wonder if people with OCD traits are overrepresented in the `unless` detractors). I generally don't like the idea that the self-professed suffering of a small cohort of people gets to take precedence over everybody else (before you cancel me, know that it depends on the kind of suffering!) and so in the original post I say:

> This post is not a call to arms to try and get any style guide to change, because reading through some of the comments on the topic, there are people who find unless more readable compared to if ! in the vast majority of cases. But my experience has been the exact opposite, ... I really just want to see if other people relate to my experience

Reading through the comments on the post it's now clear to me that there really are two sizable, incompatible cohorts of people, and one of the two has to just suck it up and deal with the fact that the other cohort's preferences won the day. I have no intention of pushing to remove `unless` in my own team because I'm in the minority who don't like it, but in another team where the `unless` detractors are in the majority, it would be cool to see what happens if the keyword is banned. Is hating `unless` and having to read it worse than loving `unless` and not being able to use it? That's one for the philosophers.
