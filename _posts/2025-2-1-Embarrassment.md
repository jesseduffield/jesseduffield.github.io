---
layout: post
title: "1 million Lazygit downloads, one embarrassment at a time"
---

![]({{ site.baseurl }}/images/posts/embarrassment/1mil.png)

[Lazygit](https://github.com/jesseduffield/lazygit) has cracked one million downloads (as far as the badge on github reports) and so I figured I'd use this opportunity to pontificate about software engineering and... embarrassment.

There is a world of difference between `>` and `>>`. The first one replaces a file, and the other merely appends to it. This distinction proved especially [important](https://github.com/jesseduffield/lazygit/issues/7) when I launched Lazygit now seven years ago, when in the docs I told people to add an alias for Lazygit to their shell configuration file via `echo "alias lg=lazygit" > ~/.zshrc`. That one missing character meant that anybody who followed my instructions when installing Lazygit were irretrievable deleting the one file on your computer that you _really_ don't want to delete.

That was quite embarrassing.

The embarrassment did not end there: Lazygit blatantly crashed constantly and if you left it open for more than a few minutes, you would hear your fans begin to blast as the program soaked up [100%](https://github.com/jesseduffield/lazygit/issues/131) of the computer's CPU.

Even the features were embarrassing: for a while, Lazygit didn't support staging files line by line and instead it would shamelessly shell out to the crude `git add -p`.

Yet despite the glaring problems, there was a kernel of value there: Lazygit made it easy to stage files and commit changes in the comfort of your terminal.

Paradoxically, the greater the value, the greater the embarrassment: if your product is useful enough to amass lots of users, a good chunk of those users are going to inform you about all the ways that your product is completely broken. And it's all very embarrassing.

But over time, you fix the bugs, you build the sorely lacking features, and like chipping away at a stone sculpture, you remove one embarrassment after another, etching closer and closer to the thing which was there all along, waiting to be brought into being.

(Admittedly sentimental words for a glorified git wrapper but it does describe my emotional experience!)

There are plenty of things left in Lazygit that make me cringe, and it's far from complete. But every time I see somebody name-drop it on Reddit or Hacker News I still get a warm fuzzy feeling. I owe a debt of gratitude to all the contributors who've participated in the joyful act of chipping away the embarrassments. Not least of whom is my co-maintainer [@stefanhaller](https://github.com/stefanhaller), whose conscientiousness, orderliness, and extremely high disagreeableness 😉 have greatly benefitted the project. Also shoutout to [@mark2185](https://github.com/mark2185), [@AzraelSec](https://github.com/AzraelSec), [@mjarkk](https://github.com/mjarkk), [@dawidd6](https://github.com/dawidd6), [@Ryooooooga](https://github.com/Ryooooooga), [@antham](https://github.com/antham), [@peppy](https://github.com/peppy), [@jbrains](https://github.com/jbrains) and countless [more](https://github.com/jesseduffield/lazygit/graphs/contributors).

Over in day-job land, I'm in the early stages of my new startup and so I'm experiencing plenty of embarrassment. But where I once recoiled at the feeling, I now embrace it, because if you're feeling embarrassed, that probably means a human being is actually using your product and getting some value out of it, and it is a great privilege to be able to create something that improves the lives of others.

So go forth and embrace embarrassment! And thanks for all the support.

PS: Thanks to everybody who's [donated](https://github.com/sponsors/jesseduffield) to me over the years, whether for Lazygit, or any of my other endeavours. If you're interested in supporting me but don't want to donate your money, consider donating your time by checking out my new project [Subble](https://www.subble.com/) and giving me feedback on it or convincing your boss to pay for it!

PPS: There are plenty of [open](https://github.com/jesseduffield/lazygit/issues?q=sort%3Aupdated-desc%20is%3Aissue%20is%3Aopen%20label%3A%22good%20first%20issue%22) issues in Lazygit and if you're looking to sink your teeth into an open source project, there's lots of low hanging fruit so please join us!
