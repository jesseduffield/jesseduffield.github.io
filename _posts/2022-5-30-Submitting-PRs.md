---
layout: post
title: Guide to Submitting Pull Requests
series: github-reviews
series-title: 'Guide to Submitting'
---

_I am not an authority on this topic: what follows is advice that works for me and for others who have taken the advice on board._

Most dev teams have a code review process where another dev has to approve your code before it can be merged into the master branch. You may think that once your code is pushed to the feature branch and a corresponding Pull Request (PR) is submitted, your work is done. It is not.

## Read your own code first

Before even assigning reviewers you should read your own PR's changes as if you were a reviewer. This will help you catch silly mistakes like commented out code, and `console.log` calls. As a reviewer, it's frustrating when you have to leave a comment telling your colleague to lose the stray `console.log` call. It's like cleaning somebody else's room for them!

Reading the diff will also give you a broader overview of your own changes, which might inspire some additional refactoring.

## Put effort into the description

Your description should contain the following (not necessarily in the following order):

- link(s) to the issue/ticket that the PR relates to, if any
- link(s) to related PRs
- a description of what has changed
- a description of the motivation behind the change

Once the reviewer has read through your description, they shouldn't be too surprised by anything they come across in the diff of changes.

## Guide the reader through the changes

### Explain why you are making a change

Comments that elucidate the intention behind the code belong in the code base. Comments that explain the _motivation_ behind a _change_ in the code from one commit to the next (or one PR to the next) belong on the PR. Comments like 'we're batching this now because the old way was super slow' aren't relevant within the codebase, but will be relevant to the person reviewing your code.

### Make copy/cut pastes explicit

There is nothing worse for a reviewer than reading and comprehending a huge block of code only to find that as you scroll down through a PR's changes, that huge block was simply cut and pasted from another file. If GitHub is displaying the addition before the removal, give the reviewer a heads up. If the removal comes first, and the addition is more than a flick of the scrollbar away, leave a comment saying you're just moving that code.

The far darker side of this coin is that if rather than cut and paste you _copy_ and paste a huge chunk of code, you'd better make that clear to the reviewer, because unlike with a cut-paste where the cut code is visible, the reviewer will only know that the code was copied by channeling their inner psychic powers. If you have copied a huge chunk of code without many modifications, that is a sign you need to DRY things up. If you are too lazy to do that, at least tell your colleagues that you're too lazy so that they can berate you for it on the review, or if there is a good reason why you don't want to DRY things up, make that clear.

### Guide the reviewer through the code

You don't really have a say in the order in which changes appear, so if the top-to-bottom flow is awkward, leave some comments giving additional context where necessary.

If the diff is easier to view without whitespace then say so.

If the code is easiest to follow on a commit-by-commit basis, then say so.

The goal is to make it as easy as possible for the reviewer to make sense of your changes and the motivations behind them.

## Managing commits

### Lay off the force-pushing after assigning reviewers

I like to keep my commits clean so I do a lot of `git commit amend`'s. Once I've assigned reviewers however, I need to hold off the force-pushes so that it's easier for them to see which new commits I've added on the back of their feedback.

### Squash your commits

Before merging, you should clean up your commits before merging to master. You don't need to squash everything into one commit, but typically you shouldn't have more than two or three commits to merge in the end. You should never have code that gets added in one commit and then removed in another commit under the one PR, because it makes it harder for others to read through the git log when something goes wrong down the line.

## Justify newly added dependencies

If you add a new dependency to a repo you should explain why you chose that specific dependency and why it's better to use that dependency than implementing the functionality yourself.

Here are some points worth capturing:

### How popular it is

E.g. number of GitHub stars or number of noteworthy orgs using the dependency.

### How well-maintained it is

If there haven't been any recent commits to master but the issues board is choc-a-bloc that's a red flag.

### The quality of the code itself

Skim through the code to get a feel for the health of the codebase. Well organised codebases not only have a better chance of adapting to new requirements, they also reflect conscientiousness and experience on the part of the maintainers.

### Its licence

If you're working on a closed-source codebase for a company you typically want to avoid copy-left licences like GPL. Check the licence and ensure its permissive (e.g. BSD, MIT, Apache).

### Any security concerns

This is the hardest one: check if anything stands out in the code as a security risk.

Another risk is if the maintainer is lazy and lets a contributor slip malicious code into the code base, or if the maintainer themselves goes postal one day and adds the malicious code themselves. These outcomes are basically impossible to predict so don't linger too long on them.

### The dependency's dependencies

Does the depdenency have other dependencies that fail on any of the above tests? If you really want to do your due diligence here it can take quite some time to recursively audit each dependency, but you get to choose your own risk tolerance depending on context.

## Vendor Lock-in

You may hesitate to commit (pun not intended) so heavily to Github, or any other git hosting service, given that if you switch services, the history of your PRs and all the contextual comments will be lost. You may instead want to keep all your comments within the git ecosystem system via commit messages and [git notes](https://git-scm.com/docs/git-notes). I don't have a strong opinion either way. If we get to a point where I can easily add comments to individual diff lines in a commit, with comment threads, and it's easy for me and everybody on my team to go back and understand why a particular change was made, then I'll advocate for that. But at the moment I don't believe that's a straightforward process outside of a particular vendor.
