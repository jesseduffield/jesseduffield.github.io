---
layout: post
title: It all boils down to time
---

Building software is challenging, so us humans, endowed with brains better adapted to climbing trees and eating bananas than reasoning about complex systems, develop heuristics to help us navigate:

- YAGNI (You Ain't Gonna Need It: don't build things you don't need)
- DRY (Don't Repeat Yourself: avoid code duplication)
- SRP (Single Responsibility Principle: minimise the reasons that a piece of code has to change)
- And so on

It's easy to forget that heuristics _are_ heuristics: they are not the end-goal; they're just simple, imprecise rules that we can deploy in service toward our objective.

In chess, we've discovered that the human heuristic to trade pieces when you're at a material advantage is not taken nearly as seriously by AI players as it is with human players; AI players will more readily sacrifice a material advantage in order to close in on a check mate. The AI never forgets the objective: to win the game. If violating a a heuristic gets it closer to that objective, so be it.

So, as software engineers, what is the underlying objective that all of our heuristics have been built atop? In the context of an ambitious startup, it might be to sell the company for a billion dollars. In the context of an open source project, it might be to make a product that is used by millions of people and lasts for decades.

These objectives are lofty, and it can be hard to know how a single decision in the context of a codebase affects the course towards such an objective (because we are still only human).

## Time

So how about we go one level up: time. I have a limited number of hours in a week that I can spend working on a software project.

Why do I write tests? Because I want to save time. If I neglect to write a test covering an edge case, and that edge case creates a bug that I then need to spend time locally reproducing, debugging, and fixing, then I've wasted a bunch of time compared to having written the test.

On the flip side: if I write a unit test for something which is certain not to break (e.g. `expect(1+1=2)`), or if it does break, the time cost of identifying and fixing the problem is smaller than the time it would take to write the test in the first place, then writing that test would be a waste of my time.

Now, time is also an imperfect heuristic. The true bedrock is conscious experience: 10 seconds spent frustrated at a bug is not the same as 10 seconds spent delighted by a new feature. And it's the experience of your users which will decide the fate of your product. Also, depending on what you're building, cutting corners can lead to some very, very bad experiences.

But often, time itself really is the right thing to think about. For example, you're currently manually deploying your app and it takes a while to do and slows things down and it's going to take 8 hours to set up continuous deployment, but you probably won't gain those 8 hours back for a few weeks, and there's an important feature you need to get out by the end of this week. The heuristic 'Continuous Deployment Is A Good Thing To Have' is not going to satisfy your time-sensitive goals.

## My recent time-sink

As with many things, what motivated me to write this post is a recent, embarrassing encounter with docker. I wrote an end-to-end playwright test for my web app's signup flow, with simple steps:

- User visits sign up page, enters details
- Verification email is sent
- User clicks verification email link and lands in the dashboard

The verification email is sent via a background job. Rather than use an actual mail server (which is a bit of a pain), I used rails' `letter_opener` gem which stores emails in a temp directory and serves a simple email inbox to the browser. Now, to make my tests behave deterministically, I had the CI environment use inline background jobs, meaning that instead of having a separate background worker, the API controller itself would just run the background job synchronously before the response would be returned to the browser.

This was working fine, but I didn't feel great about it: in the real world, jobs are not performed synchronously, and if all my end-to-end tests bake-in the assumption that jobs _are_ performed synchronously, various bugs might slip through, and it would be impossible to test certain features like loading states.

So I used a heuristic: _make your CI environment as close as possible to production_. I added a background worker service to CI's docker compose config and updated the test to poll the email inbox rather than expect the email to come through immediately. Worked fine locally, but completely failed on CI. The email was never sent. How could this possibly be? I pulled down the playwright trace from the failed run and watched the recording as it showed the browser fruitlessly refreshing the email inbox to no avail. I mounted the logs directory of the background job service, re-ran CI, then pulled the logs, and verified that sure enough, the HTML email had been rendered and sent successfully. What the hell was going on? I updated my local docker compose to match CI in terms of aliased hostnames, environment variables, and what-not, but couldn't reproduce it. I was having a bad _time_.

Eventually with CI, you bite the bullet and use the exact docker compose config as well as the actual images that were used on CI to guarantee that you can reproduce the issue. As with most things in programming, the problem was between the chair and the keyboard. The API service and the background job service used the same image and the same code, but were otherwise completely isolated. The background job service would store an html email in its temp directory, while the API's temp directory would remain completely empty, so when the API served the email inbox to the browser, there were obviously no emails to show.! This was not a problem back when the API was the one running the jobs inline.

I don't want to admit how long I spent troubleshooting that, but it made me wonder: will the time gained from having CI tests more faithfully represent production (at least in terms of asynchronous background jobs) compensate me and my users for the time I just spent debugging that problem, at the expense of other things I could have been building? Because if the answer is no, it was wasted time.

And in the end, it all boils down to time!
