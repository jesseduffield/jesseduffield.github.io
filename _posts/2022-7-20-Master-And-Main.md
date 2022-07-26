---
layout: post
title: Master vs Main
---

_The following is a fictional conversation between two developers of different political persuasions. This is really just my way of thinking out loud about the different perspectives on the topic, and if I've done my job properly, you'll have no idea which of two fictional developers I agree with more. I intend to unlist this post in the future just because of how controversial the topic is._

R: So, remember how GitHub changed the default branch name from master to main?

**L: Yeah.**

R: Well now they've removed the option to change the branch from the repo create page entirely.

**L: Is that so bad? You can still call the branch whatever you want from within git.**

R: Obviously, but it's still a pain in the ass this is even a thing in the first place.

**L: I know there's a rant coming so just get it over and done with.**

R: Okay so this all started because somebody tweeted the CEO of GitHub suggesting to change the name and he was like 'that sounds great!' without considering the actual repercussions it would have.

**L: I suspect there's more to the story than a twitter exchange, but putting that aside, what repercussions are you talking about?**

R: For example the fact that years of stack overflow answers have now been made redundant because of the word change. People's aliases and scripts for regular git tasks will now stop working for certain repos that have switched to the new branch name, and in general there's just going to be a lot of confusion. All for the sake of sparing some descendants of slaves, who weren't even consulted, from feeling uncomfortable about a word.

**L: So let me get this straight: you _aren't_ concerned about the feelings of a minority who feel discomfort at a word that literally evokes the legacy of slavery, but you _are_ concerned about a bunch of people having to replace one word before pasting a command from stack overflow into their terminal? And this in the context of the one industry where change is the only constant, stack overflow posts become redundant on a daily basis, and frameworks and tooling are constantly evolving. Developers are well equipped to deal with change; it's basically all we ever deal with. What am I missing?**

R: Well the first thing you're missing is that developers tolerate change when it actually improves things on net. If I go from react classes to react hooks, yeah it's a pain in the ass to learn the new API, but it's much better than the old one.

**L: Here we're talking about an improvement to the wellbeing of a minority. Why is that so different?**

R: That's my second point: The word 'master' was never actually intended in terms of a master-slave relationship, but instead as a master copy. I happen to not see any issue with master-slave terminology given that the metaphor makes complete sense in a bunch of contexts, but if the reason you have beef with git's master branch naming is because of the master-slave relationship, then you're mistaken.

**L: Well actually bitkeeper which git is based on did itself refer to master and slave repos**

R: Repos yes, but not branches. The guy who coined the term 'master' in the context of a git branch himself has stated he was thinking of it as a master copy.

**L: This is probably the kind of thing where looking at different evidence will lead you different conclusions, but would you agree that the actual origin is besides the point and that the modern day interpretation of the word is more important?**

R: Well it's not like anybody is using the term 'slave branch' in the modern day.

**L: But I mean the interpretation from people with a history of slavery in their family.**

R: And I'm saying they're interpreting it wrong! Why can't there just be a big PSA to tell everybody 'it's a false alarm, the word master wasn't actually used in relation to slaves! You don't need to be offended anymore!'

**L: Because even if we did that, it wouldn't change the fact that some people feel uncomfortable with the word just purely by association.**

R: So all it takes is a few people getting offended by a word because of its meaning in a completely separate context for everybody else to have to stop using that word. If we set the bar that low, there will always be some new word that nobody previously cared about that all of a sudden becomes 'problematic' and the dance will begin again.

**L: You've used the word 'offended' a couple times now and I want to be clear that this is not just about being offended by a word, it can be as simple as feeling uncomfortable or distracted by it.**

R: Great so it's not just offence, it's that every time somebody gets _distracted_ by a word we all have to change it. You don't see a problem with that?

**L: Not really. The term 'moron' used to be the clinical term for somebody with an intellectual disability. Soon enough it was used as a pejorative and so we moved on to a new word. I don't see anybody today complaining about 'moron' having been discountinued by the psychology profession.**

R: Come back to me in 10 years time and I guarantee to you that 'intellectually disabled' will also be labeled a 'hurtful pejorative', if it hasn't already. The euphemism treadmill is such a pointless process because there is no shortage of pain that can be attributed to words, except that when you change the words, the pain's still there. That's why it never ends.

**L: I'm not claiming the process ends, I'm just claiming that the alternative is worse: sticking to the existing terminology for everything, regardless of how it makes people feel. Who would want to live in that kind of world?**

R: Me, for one. I just find it absurd that if you have anxiety and see a therapist the first thing they're going to teach you is how to recognise when you're overreacting to something and how to take context into account. They're never going to tell you that 'yes your interpretation of that thing is the correct one and everybody else should have to take on that same interpretation!'. But that's what we're doing when we allow for these pointless language changes.

**L: Okay let's try this from another angle: say that you were driving home from work and there was a big billboard that showed some super disgusting gory image, say of somebody who has been beheaded and mutilated. Something straight out of liveleak. Would that make you uncomfortable?**

R: Yes.

**L: And would you want that billboard to be replaced?**

R: Yes.

**L: Now let's say you live in a world where the majority of people just don't care about gory images. They don't get distracted by them, they pay them zero attention, and they can't even begin to imagine how somebody could take issue with them. When you tell them about how this billboard is distracting and just not what you want to see on your drive home from work, they tell you that you need to toughen up. The billboard wasn't intended to give that effect, so you have no need to feel bad about it anymore. Except of course, you do still feel bad, and that's never going to change.**

R: That's a compelling hypothetical, except that if I really was the odd one out, and the majority of people couldn't care less about that billboard, then I wouldn't feel entitled to force my own gore-aversion onto everybody else. I would find a way to live with it because at that point it's clearly my problem, not theirs.

**L: That's very noble of you, but I would prefer to live in a world where the majority actually listens to the concerns of the minority and makes society as welcoming and pleasant as possible to all kinds of people.**

R: Get real: this isn't about a minority: it's about a minority of a minority. What about the members of the minority who find the language change to be a slap in the face because it's infantilising, obviously performative, and makes no real impact on genuine societal problems. Why can't we factor in their suffering along with the suffering of the people the change was intended for?

**L: These are all things that need to be taken into consideration, but I don't see how saying no to all language changes is a better alternative.**

R: I'm not against all language change. Recently git introduced the `git switch` command which is specifically for switching branches, because `git checkout` was doing a little too much (for example checking out old versions of files). That's a language change I'm in favour of if it makes git easier to understand, but the difference between that change and the change from master to main is that if I continue using git checkout out of habit, nobody's going to label me a bigot.

**L: Okay so we've finally arrived at the real reason you're mad.**

R: If we want to talk about things that make you uncomfortable, I'm happy to admit I'm deeply uncomfortable about the fact that every six months somebody decides that a perfectly good word is now problematic and so I'm forced to choose between sticking to the word out of principle and being called a bigot or falling in line and keeping my mouth shut.

**L: Nobody's calling you a bigot, we're just trying to use more inclusive language so that people feel welcome.**

R: So if I make a new repo and use 'master' instead of 'main' for the master branch, you don't think anybody's going to call me a bigot?

**L: The internet is a big place so the chances are that somebody will probably get mad, but it's basically impossible to say or do anything on the internet without somebody getting mad, so what makes this any different? As for me, I won't call you a bigot, but I am going to take note of the fact that you're not doing your best to be inclusive.**

R: So you're going to morally judge me?

**L: Yes, but I'm not going to report you to the police or anything.**

R: Do you realise how crazy it is that we're even having this conversation? One day everybody's going about their lives using innocuous language, and all of a sudden that language is deemed harmful, and we have to pick which side of the political fight we want to be on, knowing that given the progressive nature of the industry, if you stand your ground against the progressive side, you'll be jeapordising your career?

**L: You left out the part where the original language was _not_ innocuous to everybody. And if you think that expressing disagreement about a language change is a threat to your career, maybe you need to go back to that anxiety therapist and recap the lesson about blowing things out of proportion.**

R: I wouldn't be the first to lose my job after expressing discontent at an ideology.

**L: Is it really an ideology to care about other people's feelings or is that just what it means to be a good person?**

R: Caring about people's feelings so much that you ignore the long term repercussions and stir up this fiasco we're in now, yeah that sounds like an ideology to me.

**L: I still prefer that over the never-change-anything-in-case-dissenters-are-ostracised ideology. Pick any progressive movement in history and your arguments still apply. The abolition of slavery, the civil rights movement, you name it.**

R: How about the Soviet Russia?

**L: I have a strange suspicion that occasional changes in language used by the tech industry won't lead to Soviet-style gulags.**

R: My bet is that twenty years from now we're going to be looking back on a lot of these language wars regretting the precedent that we set.

**L: My bet is that two years from now we'll look back in astonishment at how much backlash there was for a simple name change.**

R: I'll take that bet.

**L: I look forward to talking again then.**
