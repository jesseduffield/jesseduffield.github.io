---
layout: post
title: "Coding Controversies: Hard Wrap vs Soft Wrap"
---

![]({{ site.baseurl }}/images/posts/coding-controversies/logo.png)

* [Spotify episode](https://open.spotify.com/episode/6jheVqfnjVH3yJJ4LV9gMe)
* [Apple Podcasts episode](https://podcasts.apple.com/us/podcast/hard-wrap-vs-soft-wrap/id1705644083?i=1000626632329)
* [RSS episode](https://anchor.fm/s/e7fba968/podcast/play/75142491/https%3A%2F%2Fd3ctxlq1ktw2nl.cloudfront.net%2Fstaging%2F2023-8-2%2F05317026-c9bf-48a2-69ae-43ac16783da7.mp3)
* [RSS feed](https://anchor.fm/s/e7fba968/podcast/rss)

Coding Controversies is my new podcast where in each episode I explore a debate in the world of software engineering. These are the notes (effectively a transcript) of the podcast for those who prefer reading to listening.

## Introduction

Today's topic is Soft wrap vs Hard wrap. Even though this podcast is called Coding Controversies, this episode is less about code and more about prose. So by prose I mean commit messages, plaintext documentation, markdown docs, that kind of stuff.

## Definitions

Okay so let's define our terms
It's useful to start by considering what happens when you're writing a document with _no_ wrapping: each paragraph ends up just being one very long line, where you need to scroll horizontally to see more of it.

Importantly, with no wrapping, each paragraph occupies one line in the document (also known as a logical line) and one line on your screen (also known as a screen line). The distinction between logical lines and screen lines is going to be crucial throughout this debate so we'll revisit those terms many times.
Anyway, we all have better things to do with our time than to scroll horizontally so we want our text to wrap once it reaches some margin.
The question is how.

With hard wrapping, we pick a margin that we want our text to stay within, for example 80 characters, and each time we're about to exceed that margin, we hit the enter key to add a line break and then continue with our paragraph on the next line. So the wrapping is done by the author and is encoded in the document itself in the form of line breaks. With hard wrapping, each logical line appears as a single screen line.

So what about soft wrapping? Soft wrapping is purely presentational: rather than encode the wrapping in the document itself you leave it to the editor to render logical lines across multiple screen lines, based on when the line reaches the edge of the window or some configured margin. So, with soft wrapping if you expand the width of your window, the lines will stretch out to fill the available space, whereas with hard wrapping nothing changes because the wrapping is set in stone within the document.

So to recap: a hard-wrapped paragraph occupies multiple logical lines, but each logical line appears as a single screen line, whereas a soft-wrapped paragraph occupies a single logical line but appears as multiple screen lines. You can tell the difference by looking at the gutter in your text editor: if you can see gaps between the numbers then you're using soft wrapping, whereas if there are no gaps then the document is hard-wrapped. That's because those line numbers represent logical lines, not screen lines.

## Debate

So now that we've defined hard wrap and soft wrap, the question becomes, which one should you use?

I'm going to break this debate up into four different topics:
* editing
* viewing
* diffing
* reviewing

Where in each topic there are pros and cons to both approaches.

## Editing

So, to start let's talk about editing.

With soft wrapping, zero mainenance is required because you don't need to manage the wrapping yourself: it's not encoded in the document so you can just type away and write your paragraphs without needing to keep track of whether you're exceeding the margin.

On the other hand, with hard wrapping, you do need to put some effort in. Most people who hard wrap don't actually hit enter when they reach the margin but instead rely on their editor (or a plugin in their editor) to insert the line break automatically when they reach the margin. Installing a plugin to do this is a one-time cost, but there is still some overhead: sometimes you'll need to edit the middle of an existing paragraph and if your tool isn't smart enough to handle the overflow in a way that preserves the wrapping of the whole paragraph, you'll need to manually trigger that rewrap yourself. 

Hard wrapping is also harder to enforce: if you're collaborating on a document with others, you need to ensure that they recognise the desired margin and actually adhere to it, whereas with soft wrapping, it's impossible to get it wrong.

But Hard wrapping _does_ has a slight edge when it comes to navigating a document. When hard wrapping, logical lines are 1:1 with screen lines, which means you don't need to keep the distinction between the two kinds of lines front of mind.

For example Vim, a popular editor, has a separate keybinding for moving to the next logical line and moving to the next screen line, and the default for moving to the next screen line is two whole keypresses, which is a pain in the ass! Granted, this is just the default, there's nothing stopping you from swapping those keybindings around so that you can easily move up and down screen lines, but it's still the case that if everything is logical lines, navigating is easier.

I use VSCode whose defaults are less hostile to soft wrapping, but even there I can get tripped up: pressing command left takes you to the start of the screen line, but you have to press command left again to get to the start of the logical line. Although this is straightforward, I do occasionally find myself forgetting about it when I'm using multicursors for example if I want to convert a numberered list to a bullet point list, I may accidentally add an asterisk to the middle of a sentence where I expected it to be added to the start.  

So so far we see that, soft wrapping is easier to maintain, but hard wrapping is easier to navigate.

### Semantic Line Breaks

But we're not quite done on the topic of editing. There's another subtopic here to explore which is Semantic Line Breaks, a specific flavour of hard wrapping.

You may have found yourself confused when you added a line break to some prose in an html file and found that when it rendered in your browser that line break was replaced with a space. And it's not just html: markdown and latek also share this behaviour. 

In these languages single line breaks are for your eyes only so you can add them wherever you want and the end-user won't know about it. You can add a line break after each sentence, or after each clause in a sentence, or after each item in a comma-separated list. The sky is the limit.
This flavour of hard wrapping is called 'semantic line breaks', and for people who utilise this super power, hard wrapping is not just a way to prevent text from exceeding a margin, it's a way of life.

Semantic line breaks may sound esoteric, but they can actually make it easier for the writer to comprehend their document and to manipulate it, for example: rearranging items in a comma-separated list is trivially easy if it's just a matter of swapping lines around in your editor. 

When you think about it, we all agree that it's a good thing for source code and compiled code to have different formats. The format of source code is optimised for easy maintenance and the format of compiled code is optimised for easy processing. Yet despite the exact same dichotomy existing with prose, most of us write prose in the same format that it will be read. For those comfortable with semantic line breaks, maintaining a document without them is like maintaining minified javascript: technically doable but needlessly complicated!

So, what are the arguments against semantic line breaks?

First of all, the reason source code is different to compiled code is that compiled code is read by a computer which only speaks fluent binary. So if your goal is to produce content to be read by another human, why not just use the format that the document will be read in, that is, paragraphs?

Semantic line breaks might help _you_ make sense of your document, but the goal is to make the document make sense to the _reader_. So if your document is too complicated to understand without semantic line breaks, maybe you should just make the content less complicated.

Semantic Line Breaks can also be problematic when multiple people are collaborating on a document, because just like when programming, different people have different styles.

So, _You_ might use line breaks sparingly but your _collaborator_ might use them so frequently that their output starts to look less like flowing prose and more like haiku poems. It can be jarring to maintain a document with a mix of styles and _enforcing_ a consistent style has its own overhead. Whereas if you do away with semantic line breaks and just stick with writing everything in paragraphs, all that complexity goes away.

So it's hard to give a clear verdict on the value of semantic line breaks, but I recommend giving it a go and seeing how you like it.

Okay, so, that's editing. Now let's talk about viewing.

## Viewing

I just talked about the situation where single line breaks are ignored when the text is rendered but here I'm going to focus on the situation where line breaks are preserved, which is the case with plaintext email, git commit messages, and any document that's hard wrapped and viewed directly in an editor, like markdown documentation in a codebase.

The major disadvantage with hard wrapping is that if it's viewed on a narrow viewport you get staggering. So if a document has been hard wrapped at 80 characters but I'm viewing it on my phone which can only fit 70, then I'll get a spillover of 10 characters on each line, effectively doubling the size of the document and resulting in really ugly text that's hard to follow. In effect this is what happens with a hard wrapped document doesn't realise it's going to be rendered in a soft-wrapped window. If you've ever had to review a PR from your phone while on the go, you'll know what I'm talking about.

On the flipside, with soft wrapping if the viewer is using an ultra-wide monitor, each paragraph can end up as one long line and you injure your neck trying to navigate from the end of one line to the start of the next one.

So hard wrapping is bad when the viewport is too small and soft wrapping is bad when the viewport is too wide. But soft wrapping has the advantage that at least the owners of ultra-wide monitors can just resize their window or configure their own margin to prevent the awkwardness of super wide text, whereas mobile users can't do much to compensate for hard wrapping unless they want to really squint their eyes.

## Separating Content From Presentation

Another angle to consider is the separation of content from presentation.

Soft wrapping separates content from presentation, allowing the width of the content to be decided later, and importantly allows the reader to use a margin that's comfortable for them. Remember the fiasco when wikipedia updated its layout so that text wasn't so wide. People lost their shit, myself included! And although studies exist showing that there is an optimal margin for reading text, studies also exist saying there is no optimal margin and different people have different preferences. Soft wrapping gives readers the power to satisfy those preferences.

Having said that, when we're dealing with plaintext documents, sometimes we want to render different parts with different margins. For example, you might be writing a commit message where you want prose to be capped at 80 characters but you need to include a stack trace or an ascii art diagram which needs more room, say 120 characters.

With a plaintext document there's no way to specify these margins other than enforcing them directly with hard wrapping. When you rely on soft wrapping you're stuck with a single margin applied to everything in the document. So if the end user has their margin set to 80 characters your _prose_ will look fine but you'll get staggering on the stack trace. But if they set their margin to 120 characters the _stack trace_ will look fine but now the prose will be stretched thin.

With hard wrapping you spare the reader this conundrum by deciding on margins upfront. This is the reason Linus Torvalds (creator of git and linux) argues for hard wrapping in commit messages.

So separation of presentation and content is great IF you can encode it, but with plaintext documents with granular presentational needs, hard wrapping is the only choice.

## Diffs

So we've talked about editing and viewing and now we're shifting our gaze to focus on the version control side of things.

First let's talk about diffs.

Remember how hard wrapping has multiple logical lines per paragraph but soft wrapping only has one? That's a critical distinction when it comes to diffing, which is basically always line-based and by that I mean logical line based.

With soft wrapping if you've got a 10 line paragraph and you change one word, that's going to show up in git as you having changed the whole paragraph because the paragraph is just one logical line. Now, any half-decent diff renderer is going to highlight within that paragraph the actual word that you changed, but it is just a fact that with a hard wrapped document, the diffs will be more granular out of the box.

The downside with hard wrapping is that _if_ you've had to re-wrap a 10 line paragraph because you added a few words to the first line and each subsequent lines exceeded the margin, you're going to see a 10 line change in the diff where git won't be able to tell you 'here's the semantic change that actually happened'.

### Merge Conflicts

This ties into merge conflicts. Consider again the 10 line paragraph. If I change one word at the start of it, and my colleague changes one line at the end, then if we're using soft wrapping, we're going to get a merge conflict because the whole paragraph is still just one logical line.

With hard wrapping, because the changes occur on different logical lines, you won't get a conflict. But is this a good thing? You could argue that a paragraph is supposed to represent a single coherent idea, and if there are two independent changes to a paragraph, they could semantically conflict with eachother in a way that reduces the coherence of the paragraph. So for a contrived example, a paragraph about coding advice could mention the DRY principle in a couple places and two independent edits could add in parentheses 'DRY (which stands for 'Don't Repeat Yourself)' and if that made it through to the final version, the reader wouldn't know if the acronym was explained twice by accident or if it was an ingenius self-referential joke.

So in that case, a merge conflict would help alert you to the problem, but it's a question of how sensitive you want your merges to be: too sensitive and you have to resolve a bunch of conflicts that aren't really conflicts. Not sensitive enough and things can slip through the cracks. Regardless of where you think the sweet spot is, the reality is that you'll get more merge conflicts with soft wrapping.

## Reviews

Now onto the final topic: pull request reviews.

The distinction between logical lines and screen lines once again forms the crux of the topic. This time around, it's about leaving comments on a pull request. In popular version control sites like github and gitlab, as a reviewer you can leave a comment on a line of code, but only on a _logical_ line, not a screen line. So if you're using soft wrapping, you can't just click on the 5th line in a 10 line paragraph to give direct feedback on that. You instead have to leave the comment against the paragraph as a whole and verbally describe the section that you're talking about.

With hard wrapping this isn't a problem because each line in the paragraph is a logical line, so you can just click on the 5th line in a paragraph and leave a direct comment.

Where soft wrapping has the edge is that it's easier to write suggestion snippets: yes your snippet may be 10 lines long even if you only want to suggest a one-word change, but it's trivially easy for the pull request submitter to apply the suggestion.

On the other hand, with hard wrapping, it's fine if you're only dealing with a one word change, but anything more substantial may require a rewrap which can be a hassle, especially if you're used to using a rewrap tool that only exists in your editor.

## Summary

Okay now that we've talked through editing, viewing, diffing, and reviewing, let's summarise the debate: 
* Hard wrapping generally requires more effort when you're constructing a document, because you need to modify the content in order to add wrapping
* But depending on your editor, soft wrapping can make it harder to navigate the lines
* In some contexts like with latek and html, Semantic Line Breaks, a flavour of hard wrapping, lets you layout your document in a way that is far easier to maintain than typical prose.

* Soft wrapping separates content and presentation, giving the reader more power to decide on how they want to view content.
* Whereas Hard wrapping gives the author more power over presentation which is especially helpful in plaintext documents where there's no other way to encode different margins for different elements.
* Hard wrapping can cause staggering on narrow windows but soft wrapping can stretch too wide on wide windows.

* Soft wrapping results in less granular diffs but doesn't suffer from rewrapping issues. Soft wrapping also results in more merge conflicts which may be good or bad depending on the situation
* Soft wrapping makes it harder to point out code in reviews, but easier to provide suggestion snippets

Some of these points are fundamental, and some are specific to current technology. For example, you could imagine that diffing algorithms could become popular which are far more semantic as opposed to being line-based, which would give soft wrapping a greater advantage.

## Verdict

So what's the verdict?

The two forms of wrapping both have their strengths and weaknesses. 
If you're working on a document like latek where single line breaks compile to spaces, I recommend experimenting with semantic line breaks to better manage the structure of the text, but if all you want is to adhere to a margin, I much prefer soft wrapping. It's lower maintenance and gives more control to the reader.

## Wrapping up

So there you have it. I hope you enjoyed this episode.
If you know of an argument that this episode neglected, or you would like to suggest a topic for another episode, I'd love to hear from you. Check the show notes for the best way to reach out.

Thanks for listening. I'm Jesse Duffield and I'll see you next time for another Coding Controversy.

## Reference links:

https://martin-ueding.de/posts/hard-vs-soft-line-wrap/

https://www.gnu.org/software/emacs/manual/html_node/emacs/Visual-Line-Mode.html

https://github.com/torvalds/linux/pull/17#issuecomment-5661185

https://about.gitlab.com/blog/2016/10/11/wrapping-text/
