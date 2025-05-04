---
layout: post
title: "AI is stupid, just like me"
---

Everybody is fascinated with the many ways that modern-day AI differs from humans.

- AIs contain almost all human publicly available information in their head, but have dysmal sample efficiency, meaning they need to observe something many times to infer a rule, whereas humans learn much faster.
- Humans can work towards long-term goals over long periods of time whereas AI gets stuck if it has to work for more than a few minutes on a task.
- AIs can quickly synthesise information to produce tax legislation in the style of Shakespeare in less than a second, whereas humans lack the motivation to even read Shakespeare let alone humourously reproduce it.
- Humans can tie their own shoelaces with ease whereas AIs lack a body and if they had a body they would lack the fine motor control to even pick up a shoelace off the ground.

This is all very interesting. But the more I work with AI, the more I see myself in it.

Let's consider my own capacity to achieve simple goals. When people remark that AI is doing something that's impressive, but it's not _intelligence_, I wonder if those people would make the same remark if some of my own thought loops were recorded and presented as a ChatGPT session.

As an example: I go to buy a game on steam and I'm asked to enter my credit card details. I don't have my physical card on me so I pick up my phone to find my card details in my banking app. But upon unlocking my phone I see a notification about a random email I should really get back to, so I do that, and then satisfied with the outcome, I put my phone away again and get back to whatever I was working on on my computer... which is, ah yes, trying to buy this steam game. The whole point of me picking up the phone was to get my card details, so back to the phone!

Reflecting on my own scatter-brained attempts at achieving goals allows me to empathise when I see an LLM struggle with the goals I assign it. When an LLM in Cursor tries to fix a bug for me, it throws shit at the wall to see what sticks, being kept on-track by linting errors and failing tests, and every time I see it make that embarrassing refrain 'Ah, silly me, let's fix that up' I think _it's just like me!_

Here's another similarity: AI will often make some blunder when trying to make a change to my codebase. And I think 'you know what, if I gave a human coder the exact same task with the same context, they would have made the exact same mistake'. Maybe some shared function isn't advertised loudly enough so the AI goes and makes its own from scratch, or some convention isn't followed when writing tests. My solution is to go and update the documentation which (guess what) HUMANS end up reading and benefitting from!

I've noticed I'm much more anal about good commit messages now because I think that although humans may one day need to look back on the commit to understand why the change was made, AI is _definitely_ going to be looking back at some point and I want to make sure it has all the information it needs without having to ask me if I can remember the change I made five years ago and why I made it (which is a regular, awkward interaction in the Lazygit github repo owing to the fact that up until 2 years ago I put zero effort into my commit messages)

Speaking of giving clear context: for all the talk of prompt engineering, if you look at the typical highly-engineered prompt and remove the upcased words, it basically looks like something that you would give to a human. In fact for all we know, maybe those upcased words would _improve_ the outcome if you were to assign human workers to the same task.

What about hallucinations? AI will happily make shit up just so that it can tell us what we want to hear. Hmm... where have I seen that same behaviour in humans? Oh yeah, I saw it in myself in the 15 years I spent in the education system.

So yes, AI is a bit stupid at the moment in some areas, but _so are humans!_ Perhaps in the future AI will be so smart that it doesn't even need to read documentation to understand anything, but for now, so many of AI's blunders reflect not how distinct from humans it is, but rather how human it has already become.
