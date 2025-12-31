---
layout: post
title: "BYO Intelligence"
---

> Copy-paste functionality removed from major operating systems by 2027 or I eat my dick on national television
>
> - Sam Altman\*

In the beginning, you would ask ChatGPT how to write an SQL query to pull some data. It would give you a query, and you would copy-paste it into your SQL app of choice and execute it. And it wouldn't work because there was some error, so you copy-pasted the error into ChatGPT and then it would try again. And maybe it would ask for more context like what columns the tables have, etc.

As magical as LLMs are, that flow was terrible.

So then your SQL app released an update that included some LLM magic of its own, allowing you to get help writing queries, and the schema was loaded in as context automatically. Very cool! No more copy-pasting in and out of chat. Except that your SQL app had its own interface for this which differed from ChatGPT and also differed from every other platform's newfound LLM functionality which made context switching painful, and the copy-pasting wasn't over: you'd still end up pasting query results into Cursor so that it could help write the code to speed up a query.

So you thought: hang on, why don't I just give Cursor's AI agent read-only access to the database, and ask it to run the queries for me? This was amazing: you could tell Cursor about a slow part of your code, and watch it run that code, isolate the slow query, run an `EXPLAIN` on that query and then propose an index to add. Why stop there? Plug in GitHub to see which pull request added the query in the first place. Plug in AWS cloudwatch to see if there was a spike in DB load around that time. The AI can blitz through the data in seconds, all thanks to the fact that these platforms provide comprehensive API's.

But the copy-pasting continues because there are still many applications with no API, or with a limited API.

Here's what I'm noticing: companies think that to get the most out of AI, they need to infuse LLM functionality into their products. And in plenty of places this is useful. But the number one way that a product can use AI to be more useful to me is not by adding AI, it's by providing me with a good API, and letting _my_ AI handle the rest. By good API, I mean feature parity with the UI, and with the ability to restrict permissions based on my risk tolerance.

Although the top AI labs are working on Computer Use to circumvent all the platforms that don't provide a comprehensive API (or any API), I predict that market forces will lead to a big proliferation of API's such that computer use won't even be necessary.

I need a bike pump. Amazon has spent years optimising their website to make it as easy as possible to purchase an item. I could get a bike pump ordered to my house in under a minute. But for reasons unbeknownst to me I [can't be f\*cked](https://jesseduffield.com/Can't-Be-Fcked/) doing that through their website and if Amazon provided an API to my AI agent that allowed me to say 'order me a bike pump under 20 bucks' and hit send, that is something I would do in a heartbeat.

But Amazon makes money not just from buyers like myself, but also from suppliers who advertise on the platform. What happens if Amazon provides an API and forfeits control over buyers' eyeballs? I'm not sure. But mark my words: SOMEBODY will build an API for easy online shopping, and when they do, I will pay for it.

For the many products that aren't dependent on eyeballs for revenue, it's a much easier decision. Build the API, focus on your product's unique value-add, and let somebody else worry about the intelligence part. AI might still matter deeply in your backend. It just doesn't need to be the face of your product.

\* Not a real quote
