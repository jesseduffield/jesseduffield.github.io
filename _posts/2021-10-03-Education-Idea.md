---
layout: post
title: Climbing Towards Correctness
---

Here's an idea I'd like to see in the education system: when teaching a new concept, before introducing a formula or equation that models some phenomenon, make the case for some simpler, but incorrect, alternatives first.

For example: let's say we want to express the relationship between speed (s), distance (d) and time (t). How might we do this? Let's think about some basic requirements first: for example, when distance increases, speed increases, and when time increases, speed decreases. So how about we use the following equation: `s = d - t`. So far so good, but what happens when we double the value of `d` in our equation? It does not necessarily double the value of `s`, yet we know in reality that when holding time constant, doubling distance will double speed. So we've found a chink in the armour of our equation. Likewise, when time approaches zero, and distance is positive, we should expect speed to approach infinity, but that's not what we see in our equation. And so, we switch gears and give `s = d / t` a try.

Another good example is the power rule in differentiation: we can start with the requirement that a diagonal line should differentiate into a flat line i.e. x becomes 1. So how about `x^n` differentiates to `x^(n-1)`. Then we can add more requirements (such as the rule being derivable from first principles) and eventually land on `nx^(n-1)`.

The point is to start from requirements first, slowly building intuition as we battle-test increasingly sophisticated prototypes capable of satisfying more requirements. This approach builds intuition better than starting with the end-result and working backwards, and speaks to a feature of our universe: most complexity is necessary rather than redundant.

When you think about it, this approach to teaching is just Test Driven Development repurposed for pedagogical intuition-pumps: you start with a simple test (like speed increases when distance increases) and come up with the simplest possible equation to satisfy that requirement, then slowly build upon the list of requirements, tweaking the equation whenever it falls short of a new requirement, until eventually you're left with the correct equation and a detailed explanation for _why_ it's correct, in the form of those requirements. Each inferior prototype remains in your memory as a stepping stone to the correct solution, meaning you can easily re-derive the solution in real-time in case you forget it.

I used this approach back in 2019 with my video [Trigonometry From Scratch](https://www.youtube.com/watch?v=t4JYeL6kN7Q&ab_channel=JesseDuffield) and despite the terrible recording quality, I'd say the video holds up well as a good demonstration of this idea.
