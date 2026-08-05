---
layout: post
title: "Negative-interest tech debt"
tag: Tech
---

Here's the story so far:

Tech debt is the word used to describe limitations in your codebase that make future iteration harder.

You pay down the debt by addressing those limitations, often in the form of refactoring.

Like financial debt, tech debt comes with an interest rate. High interest rate tech debt becomes more much expensive to pay down the longer you leave it. For example, a bad modelling decision that a bunch of code depends on, and all new code also depends on, is going to be much harder to reverse the longer you leave it. Conversely, low-interest rate tech debt can be left unaddressed for a long time without it being any harder to fix down the line, such as a poorly structured class that nothing depends on.

Obviously, you should prioritise your tech debt from highest-to-lowest interest rate, and you should try your best not to introduce high interest tech debt.

At least, that's the story so far.

We're in a strange world now, where AI in 12 months time could be as big an improvement compared to now as the AI of now is compared to 12 months ago (recalling that November 2025 was a big moment for agentic coding).

If most of your code is being written by AI, what does that do to the interest rate of tech debt? It brings it down. Not only will that bad modelling decision be easier to fix in six months than it is today, it may be easier even after a tonne of new code has come to depend on it.

That is, with sufficient AI progress, the interest on your tech debt is sub-zero.

How should you behave if you believe that to be true?

You should probably spend less time worrying about tech debt, and spend more time shipping new features.

Many companies are doing just that.

But it's a gamble. We don't know how much better AI will get, nor whether it can improve fast enough to undo the mess that was made in anticipiation of its improvement.

Some companies are betting that the interest rate is well below zero, and it's possible those companies will come out ahead. It's also possible they'll time it wrong and get stuck in a quagmire of debt with no salvation, completely incapable of shipping new features.

So just what is the interest rate? We are all going to find out very soon.
