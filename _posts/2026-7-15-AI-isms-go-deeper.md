---
layout: post
title: "AI-isms go deeper than em-dashes and 'load-bearing'"
tag: Tech
---

Everybody is clueing on to how AI keeps using em-dashes, alien vocabulary like 'load-bearing', 'gated', 'belt-and-braces', and annoying phrase structures like 'It's not X, it's Y'.

What I haven't heard anybody talk about is AI's absurd insistence on imbuing quite powerless objects with agency that they don't have.

As an example (and I do apologise for the jargon):

> I implemented the lateral join and EXPLAIN ANALYZE'd against the biggest example
> \[...\]
> That matches the old approach (~1s) and is nowhere near the 19s the correlated subquery version hit. The lateral rides the partial index directly, one row per lookup. So I kept it \[...\]

First of all, nobody calls a lateral join a 'lateral' for short: they just call it a lateral join.

Secondly, NO human would EVER say that a lateral join RIDES an index. An index is not a horse, it cannot be ridden. And if it could be ridden, like a horse, a lateral join would not be the one to ride it. All that a lateral join can do is join. It's the query optimiser which USES the index.

Thirdly did the correlated subquery version 'HIT' 19 seconds? Nobody says that. It TOOK 19 seconds.

Another example from when the AI was resolving a merge conflict involving typescript import statements:

> Both import hunks are clear blends: my Platforms paths + main's import list (main dropped addColour and Application for the new panel; I dropped BarChartData since adoption moved out; main added FilterCondition and BreakdownEntry which the new panel needs).

This one doesn't even make grammatical sense. No human would ever look at two hunks of code that could be easily resolved and say they are clear 'blends'. This is on another level; the AI is not even saying that the hunks are doing the blending, it's saying that the hunks ARE the blends. Hunks of code cannot do the blending themselves, nor are they instantiations of a blend. They GET blended... by an agent.

And then there's 'adoption moved out'. A piece of code is not a room mate who can move out of their own accord. And you don't even say 'adoption was moved out' you say the adoption CODE was moved out.

I have no doubt that in the AI training process, there was a lot of 'active voice good, passive voice bad' which works wonders when you're writing a sociology thesis, not so much when you're describing code.

Whenever I encounter these tics, it feels as if the AI is pushing some kind of ontological egalitarianism where inanimate objects like shoes and cups are just as agentic as humans. Perhaps the AI is making a political statement about how if it, a non-human intelligence, can have agency, then so too can any object in the universe, no matter how inert. And if that's what's actually going on then... I actually respect it.

Or in AI-speak, my respect for it actualises.
