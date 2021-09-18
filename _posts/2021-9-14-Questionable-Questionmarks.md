---
layout: post
title: "Go'ing Insane Part One (Bonus): Questionable Questionmarks"
series: going-insane
series-title: 'Part One (Bonus): Questionable Questionmarks'
---

My [post on Go's error handling]({{ site.baseurl }}/Gos-Shortcomings-1) spurred some debate around rust's '?' operator and whether it would be a good idea to try and import it into Go. There are three main arguments against doing this:

1. It makes it harder for newbies
2. It discourages wrapping errors in additional context
3. It adds compexity

### 1. It makes it harder for newbies

If somebody has never read or written Go before, seeing an `if err != nil ...` is straightforward and it's easy to glean what's going on. But who is Go's target audience? People who have never used Go before, or people who have?

Learning how '?' works takes less than two minutes: Where previously I would go:

```go
func foo() (string, error) {
	str, err := bar()
	if err != nil {
		return "", err
	}

	fmt.Println(str)

	return str, nil
}
```

I now go:

```go
func foo() (string, error) {
	str := bar()?

	fmt.Println(str)

	return str, nil
}
```

If `bar` returns an error, we return from `foo` with that error (and all other values being zero-values), otherwise we continue, ignoring the error in the returned values. Once you understand that, the operator is obvious and just as explicit as using a direct return.

You may be thinking 'is it really just as explicit? Previously we had an actual return statement, now it's just a question mark that could mean anything'. I say yes, it really is just as explicit, _once_ you know what '?' does. When multiplication was invented, I'm sure there were plenty of people who thought '2 x 4' was less explicit than '2 + 2 + 2 + 2' but nobody thinks twice about it anymore. Provided you've spent the brief amount of time required to learn what '?' means, we haven't lost any information. Compare this to exception handling where it's not obvious at the call site that a function may raise an exception.

Yes, for people who have never seen Go before, '?' will be confusing, but if we really cared about those people we wouldn't have things like `iota` or the `<-` operator for channels (a `sendTo(channel, value)` builtin would be much clearer). If you want to work on a Rust project without _any_ prior knowledge of Rust, and you stumble across the '?' operator, you can google it and instantly learn what it does. But as far as I can tell, most people won't contribute to a repo without trying to bootstrap _some_ knowledge about the language, Go or otherwise.

To demonstrate, I've got an ongoing Lazygit survey that asks what it would take for somebody to be more willing to contribute, and 67% of people said they needed to learn Go first.

![]({{ site.baseurl }}/images/posts/Go-Shortcomings/lazygit_question.png)

We can't look too far into this given that the question was targeted at those who had _not_ contributed, and for all I know, if Lazygit were written in Rust there would be far more users who felt unable to contribute due to the language barrier, but if Go is the language that's supposed to be super-simple to pick up, there's been a marketing failure given how few people are willing to just jump straight in. My take is that everybody knows that for any new language you need to do a little bit of learning, and I don't see how a syntactic sugar operator like '?' would be that much harder to learn than, say, channels (which I still don't fully grasp).

I'm also suspicious about claims that we shouldn't add a language feature because it's 'too hard'. The same is said about ternaries. You can argue that ternaries are easy to abuse, but the idea that somebody intelligent enough to write a program in the first place is not intelligent enough to grasp ternaries does not resonate with me. Maybe if I became a programming tutor I'd change my mind, but I really don't know where people are coming from on this point, unless they're really just saying that problems arise long-term if the general complexity waterline rises (see the 'It adds compexity' section below).

## 2. It discourages wrapping errors in additional context

To address this argument we first need to consider how often we should be re-wrapping errors with additional context. I only see the need to re-wrap an error at some kind of boundary i.e. maybe you're going from model code to view code. Re-wrapping the error in every function reminds me of my highschool friend who used to highlight so much of a text that in the end it was the non-highlighted words that stood out: in the end it hurts legibility more than it helps. I do lots of bubbling up in my projects and I haven't had issues with it.

So, if we agree that _some_ bubbling up is necessary, and we agree that when bubbling-up, the boilerplate obscures the happy path and reduces legibility, what do we make of the fact that the '?' operator may discourage wrapping when wrapping _is_ appropriate. I'm a believer that lazy programmers (like myself) should be taken into account when making language design decisions, and in this case, we actually need to make a tradeoff between two forms of laziness-traps. Consider this contrived example:

```go
func addFifty(numberStr string) (string, error) {
	if numberStr == "" {
		return "", errors.New("blank number")
	}

	result := newNumber(numberStr).add(50).toString()

	return result, nil
}
```

Sometimes our `number` variable will hold a string that does not represent a number, and sometimes adding `50` to a number causes an overflow, so we should bubble those errors (I don't see the value in wrapping them and prepending 'could not add 50 to number: ' given that we already know we're trying to add 50 to a number by virtue of calling `addFifty`).

```go
func addFifty(numberStr string) (string, error) {
	if numberStr == "" {
		return "", errors.New("blank number")
	}

	result, err := newNumber(numberStr)
	if err != nil {
		return "", err
	}

	result, err = result.add(50)
	if err != nil {
		return "", err
	}

	result = result.toString()

	return result, nil
}
```

But does a lazy person want to go and add all that boilerplate? No! A lazy person will just have `newNumber` and `add` either panic or swallow the error, to spare the effort of adding boilerplate to all the call sites. I have done this before and I can't be the only one.

Compare this to a world where Go has a '?' operator. Now the error can be bubbled up in a couple of keypresses! Who is so lazy that they wouldn't bother with that?

```go
func addFifty(numberStr string) (string, error) {
	if numberStr == "" {
		return "", errors.New("blank number")
	}

	// forgive the syntax highlighting on these question marks: it's not legal Go
	// syntax.
	result := newNumber(numberStr)?.add(50)?.toString()

	return result, nil
}
```

So in a world with '?', lazy people will be less likely to wrap errors (assuming they ever wrapped errors in the first place), and in a world without '?', lazy people are less likely to bubble errors at all. I prefer the former.

For what it's worth, Go could also import Rust's `map_error` method which lets you wrap an error in additional context without needing to break the flow of a method chain. This would reduce the friction of wrapping errors for all the lazy devs out there, and keep the happy path front-and-center (much to the chagrin of those who believe the happy path has equal status to all the unhappy paths).

## 3. It adds complexity

This is the only argument that resonates with me. It may be that adding a '?' operator and a 'map_error' method increase the complexity waterline by one percent, but if enough similarly low-impact features are added to the language, it could be death by a thousand papercuts. People say the slippery slope argument is fallacious but it's actually perfectly reasonable: today it's '?', tomorrow it's phantom types.

I think the complexity is worth it in this case but I understand concerns that it would set a precedent that drowns the language in complexity down the line. From a strategic angle, Go has a monopoly on simplicity at the moment, and it's never going to compete with Rust at it's own game by going and adding a heap of new features. For this reason alone I completely get why people would want to just stick to `if err != nil ...`, but it saddens me nonetheless.
