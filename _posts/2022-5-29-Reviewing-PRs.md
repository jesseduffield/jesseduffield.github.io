---
layout: post
title: Guide to Reviewing Pull Requests
---

_I am not an authority on this topic: what follows is advice that works for me and for others who have taken the advice on board._

It's much easier to be a lazy reviewer than it is to be a lazy developer: all you need to do is click the approve button. But it's much harder to be a good reviewer than to be a good developer. Not only do you need strong programming experience, you need to communicate that experience in a way that is clear, graceful, and sensitive to the submitter's dignity. You'll never need to fear your computer holding a grudge against you for how you go about writing code, but you should indeed fear the consequences of a tactless review.

## Understand the problem before looking at the solution

It's all too easy to write perfectly functioning, perfectly structured code which doesn't actually solve the problem needs solving. Read the PR description and if necessary read the linked ticket to understand the context around the changes, before diving into the code.

## Pull down the code

Sometimes a diff fails to capture what's really going on. It can help to pull down the code yourself and browse through the files directly. I don't always do this, but whenever I do, it helps me connect the dots.

## Try to cover everything in your first go

As a submitter, it's frustrating to address a reviewer's feedback only for them to give new feedback about something they could have mentioned in their initial review. To be honest, I find this to be the hardest part of reviewing code. As the structure of the code improves from one commit to the next, you might get a better grasp on the changes and gain new insights into how things could be structured even better. If you ever give additional feedback that could have been given earlier, you should do so with an apology baked in.

## Use normative language with care

Which of the following is better?

> Whenever you fix a bug, you must write a test to capture the fix

Or

> If you write a test whenever you fix a bug, it will verify that the bug is fixed and ensure it doesn't come back.

The first example uses _normative_ language (think _should_, _must_, _ought_). It's the language of morality and ethics. The second example uses _positive_ language, meaning it simply describes reality without suggesting some standard that people should live up to.

Normative language can be incendiary because:

- it asserts that you're in a position to tell the person what to do (may be true; still inflammatory)
- it pulls into question their own standards
- if the person disagrees, you're now fighting a war on moral grounds

One of the reasons people use normative language is because it spares them the effort of explaining the reasoning behind the norm they want to enforce. If Programming God himself came down from the heavens and said 'Indeed, you must always write a test to capture a bug fix' then you wouldn't be on such shaky ground by invoking the norm. But chances are there is some fairly easy-to-explain reason why a developer should do things in a certain way, and if you elide that reasoning in your review, the submitter learns nothing. Worse still, if you can't write down the reasoning in plain english, you may be enforcing a norm that you don't fully understand yourself, and which may not actually be very helpful.

Normative language is nonetheless powerful (I've employed it throughout this guide), and if you find that you need to wield that power to get a message across, be sure to explain the _why_ behind your suggestion.

## Capture repeated advice in code standards

If you follow the previous guideline of avoiding normative language and now find yourself having to re-explain why it's important to add tests in every review, then it's time to enshrine the advice as a code standard. Code standards should be the result of consensus agreement about which standards should be followed, meaning you should propose a code standard, get feedback, and with the help of the team, land on something that everybody agrees on. Now you can link to the code standard in a PR review and say 'as per this code standard, a spec is required upon fixing a bug'. The submitter can't be mad at you, nor can they refuse you, because the team as a whole agreed on the standard.

## Attack the code, not the developer

There is a big difference between 'This code does not work' and 'Your code does not work'. The purpose of a code review is not to evaluate the quality of a developer but the quality of their code. Leave the former for performance reviews that happen in private. In the public sphere, developers typically don't respond well to direct attacks.

I try to stick to inclusive language like 'let's add a spec for this' or 'could we add a spec here?' to emphasise the fact that the resulting PR is the result of a collaboration between the original submitter and the reviewers.

With that said, although you should not attack the submitter, you should attack bad code. If bad code goes uncriticised you now have two problems: the code itself makes it into your codebase and the person who wrote it will write similarly bad code again. Never hold back from speaking your thoughts about the code for the sake of protecting somebody's self esteem. Negative feedback is a part of everybody's life. It's up to them how they deal with it.

## Hold the submitter to your standard

Giving feedback can be uncomfortable. If you have a particular idea about how things should be done, it can be uncomfortable to tell somebody else to pour more effort into a PR when they might think it's already good enough. Nonetheless, you need to hold others to your own standard. Either the submitter will agree with your advice and learn something from it, or they will disagree and challenge you on it, potentially causing you to rethink your principles. These are all good things. If you find yourself quibbling over stylistic things and have no luck getting a wider consensus on how things should be done, then you should tone that feedback down in future reviews. But the reason you're assigned as a reviewer in the first place is so that you can give _your_ perspective on the submitter's code. So don't hold back.

One of the benefits of holding others to a high standard is that now you're forced to hold yourself to that high standard, because nothing makes you look more hypocritical than demanding high test coverage from others and shipping code yourself that's barely tested.

Here are some general areas where you shouldn't hold back:

### English

If you're lucky enough to have a strong command of the English language in a world where English is the lingua franca in tech, you should use that gift when reviewing code from those less fortunate. If you spot spelling/grammar mistakes in variable names, test names, or comments, you should suggest changes. It's important to make the code as readable as possible and correct spelling/grammar goes a long way. Furthermore, I can't think of a time that the submitter hasn't been grateful for the feedback.

### Tests

If a test case is missing, you should say so. If a test isn't tight enough, and might produce a false positive, you should say so.

### Code structure

If you would break up a 50-line function in your own code, you should ask others to do the same.

### PR readability

If you are struggling to follow the diff of changes because the submitter hasn't given an adequate description or hasn't added comments that help the reading experience, you should say so.

## Offer to pair

If you find yourself requesting a change on nearly every line of code, or you think that the general approach that the PR takes is wrong, it might be better to simply organise a time to pair with the submitter to work through the suggestions in real-time. They will learn much more that way than trying to tick off a bunch of suggestions you've made without much context.

Likewise, if you simply don't understand what the code does, it might be easier to jump on a call and have the submitter explain everything in real time. Afterwards you can make suggestions around making the PR more comprehensible for the next reviewer.

## Implement improvements in your own branch (sometimes)

If it's not feasible to pair with somebody, it can help to implement your suggestions on a separate branch and invite the submitter to take a look and merge it in if they want. However, be very careful here: if you're proposing your own branch because you're too lazy to pair with somebody or give detailed feedback, you should just do that instead. If you are going to propose your own branch you should make it very clear why you're making the changes you're making so that the submitter can learn from them. If the submitter agrees to merge your changes in, you should ensure that another reviewer checks the code given your bias for it.

## Show good-faith

Whenever you leave feedback that will take effort to implement, make it clear that they can reach out to you for clarification or assitance. If you're willing to put in extra effort for them in the form of giving assistance, then they'll feel better about putting in extra effort for you.

## Use the private channel if necessary

If you have torn somebody's code to pieces in a review, it can help to send them a private message along the lines of 'hey just reviewed your code, I left a fair bit of feedback so just reach out if you have any questions :)' (I overdo the smiley's but they've served me well). A private message can re-affirm your personal respect for the person outside of the public sphere, which is reassuring to anybody who's just taken a beating in a review.

Likewise, a message like 'I've noticed you've neglected tests in your PRs a few times now. Please be more careful in future' is simply too personal for the public sphere, but if a developer isn't getting the message, it's fine to make yourself clear privately.

## Give examples

Sometimes it helps get a message across by adding a snippet of pseudo-code (or real code) in your comment. Likewise, if you know of another part of the codebase that captures what you're getting at, link it in your comment.

## It's okay to not know

Sometimes you know there's a problem but you don't immediately know how to fix it. Perhaps it's a variable name that doesn't quite fit, but nothing better comes to mind. You're allowed to leave a comment saying that you feel that it doesn't fit, but you must also state that you can't think of anything better at the moment. If the submitter also can't think of anything better, then you shouldn't withhold an approval on that point alone. You should only withhold an approval for things where you currently know a better way or believe that collaboratively the two of you can discover a better way. Feel free to tag others for their advice in these situations as well.
