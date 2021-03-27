---
layout: post
title: Golang Gotcha of the Day
---

![]({{ site.baseurl }}/images/posts/2020-2-26-Golang-Gotcha-Of-The-Day/1.png)

This one has bitten me in the ass probably three times in the last month. The most recent bite occured just last night as I was debugging the rebase logic in lazygit. I had noticed that after selecting the 'abort' option in my rebase menu the rebase was not aborting, but instead moved along a couple of commits and then got stuck at some more conflicts.

Were not all aborts created equal? Maybe sometimes in order to abort you need to go forward first, and git was hitting conflicts along the way? I wasn't quite ready to give up my understanding of how rebasing works, so I took a look at the code

```go
func (gui *Gui) handleCreateRebaseOptionsMenu(g *gocui.Gui, v *gocui.View) error {
	options := []string{"continue", "abort"}

	if gui.State.WorkingTreeState == "rebasing" {
		options = append(options, "skip")
	}

	menuItems := make([]*menuItem, len(options))
	for i, option := range options {
		menuItems[i] = &menuItem{
			displayString: option,
			onPress: func() error {
				return gui.genericMergeCommand(option)
			},
		}
	}
	...
```

_Can you spot the bug?_

The logic was simple: create a slice of strings representing the different options available, and then create menu items to show in the GUI, where if you pressed say 'abort', lazygit would run `git rebase --abort`.

I checked for an off-by-one error on the index: perhaps the menu items started counting from 1 instead of zero? Nope.

Turns out lazygit actually ran 'git rebase --skip', which explained why it would continue the rebase and then stop again. And then it struck me: skip was the last string in the slice. It just so happens that when a function inside a loop closes over a loop variable, it ends up referring to the final value of that variable, because on each iteration of the loop the loop variable's value is reassigned. In this case, the last value was the last item in the `options` slice, i.e. 'skip'.

So I added a variable which was scoped to the inside of the loop, to assign the value of the loop variable for that iteration. Unlike closures which work on references, direct assignments just take the value of the variable at the time of assignment, meaning its value wasn't going to change no matter what happened in future iterations.

```go
func (gui *Gui) handleCreateRebaseOptionsMenu(g *gocui.Gui, v *gocui.View) error {
	options := []string{"continue", "abort"}

	if gui.State.WorkingTreeState == "rebasing" {
		options = append(options, "skip")
	}

	menuItems := make([]*menuItem, len(options))
	for i, option := range options {
		// note to self. Never, EVER, close over loop variables in a function
		option := option // shadowing outer variable, I'll explain later
		menuItems[i] = &menuItem{
			displayString: option,
			onPress: func() error {
				return gui.genericMergeCommand(option)
			},
		}
	}
```

And voilà! The bug was fixed, and lazygit's questionable reputation as a reliable git GUI was preserved for another day.

Lesson learnt: Never, EVER\*, close over loop variables in a function definition!

## Ever\* ever?

After posting this on [Reddit](https://www.reddit.com/r/golang/comments/f9sayq/go_gotcha_of_the_day_never_close_over_loop/) I found that some people believed this only to be a problem with reference variables like pointers, maps and slices. However, strings are immutable, and testing on ints I found the same behaviour:

```go
package main

import "fmt"

func main() {
	options := []int{1, 2, 3}
	funcs := make([]func(), len(options))
	for i, v := range options {
		funcs[i] = func() {
			fmt.Println(v)
		}
	}
	for _, f := range funcs {
		f()
	}
}
```

https://play.golang.org/p/d0ixiBV5wPn

This prints 3, 3, 3.

I briefly came to the conclusion that when a function closed over a variable, its value was copied across, meaning that the bug was only an issue for reference variables. Not so! The closure really does keep a reference to the variable itself, so its value can be anything and the bug persists.

## Why shadow the outer variable?

The first edition of this post did the following:

```
innerOption := option
```

My reasoning was that it's bad to shadow an outer variable. Others suggested instead leaving `option` out of the loop definition and instead doing this:

```
for i := range options {
	option := options[i]
}
```

I like this approach, but it turns out the FAQ actually prefers shadowing:

```
    for _, v := range values {
        v := v // create a new 'v'.
        go func() {
            fmt.Println(v)
            done <- true
        }()
    }
```

Given that shadowing outer variables is generally seen as bad in programming, I wonder why they made that choice? Just below the example, they write:

> This behavior of the language, not defining a new variable for each iteration, may have been a mistake in retrospect. It may be addressed in a later version but, for compatibility, cannot change in Go version 1.

I think that's the clue. If in a later version of Go they change this behaviour so that the loop variable is redefined on each iteration, and we've all used the shadow approach, that `v := v` line becomes redundant and we can remove it without any issues, as opposed to the other two approaches which require that little bit more tinkering.
