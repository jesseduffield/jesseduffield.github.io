---
layout: post
title: More Lazygit Integration Testing (Dev Blog)
---

It's been a while since I wrote about Lazygit but rest assured things are ticking along in the background. I spent a chunk of my holidays on a PR to refactor some architectury things but that's a long way off being fit for merging. Today I want to give an update on the integration test migration that I kicked off *tugs at collar* a few months ago now. Unfortunately I'm only halfway through (120 integration tests all up, with 60 having been migrated across).

At any rate, here's how integration tests have changed since I last wrote about them.

## Context-Aware Inputs/Assertions

In the previous [post](https://jesseduffield.com/IntegrationTests/) I had the following test:

```go
var Commit = types.NewTest(types.NewTestArgs{
	Description:  "Staging a couple files and committing",
	SetupRepo: func(shell types.Shell) {
		shell.CreateFile("myfile", "myfile content")
		shell.CreateFile("myfile2", "myfile2 content")
	},
	Run: func(shell types.Shell, input types.Input, assert types.Assert, keys config.KeybindingConfig) {
		assert.CommitCount(0)

		input.Select()
		input.NextItem()
		input.Select()
		input.PushKeys(keys.Files.CommitChanges)

		commitMessage := "my commit message"
		input.Type(commitMessage)
		input.Confirm()

		assert.CommitCount(1)
		assert.HeadCommitMessage(commitMessage)
	},
})
```

There were some issues with this approach:
* `input` and `assert` were annoying to switch between and as I kept writing helper functions that could have belonged to either struct.
* There was a lack of awareness about which view was focused, causing race conditions where you press a key under the false assumption that you've already landed in another view
* It was hard to give the reader a good idea about what was actually going on

Here's a rewritten version of that test. It's got more assertions in it so it's longer than the original, but it's the same general flow.

```go
var Commit = NewIntegrationTest(NewIntegrationTestArgs{
	Description:  "Staging a couple files and committing",
	ExtraCmdArgs: "",
	Skip:         false,
	SetupConfig:  func(config *config.AppConfig) {},
	SetupRepo: func(shell *Shell) {
		shell.CreateFile("myfile", "myfile content")
		shell.CreateFile("myfile2", "myfile2 content")
	},
	Run: func(t *TestDriver, keys config.KeybindingConfig) {
		t.Views().Commits().
			IsEmpty()

		t.Views().Files().
			IsFocused().
			Lines(
				Contains("?? myfile").IsSelected(),
				Contains("?? myfile2"),
			).
			PressPrimaryAction(). // stage file
			Lines(
				Contains("A  myfile").IsSelected(),
				Contains("?? myfile2"),
			).
			SelectNextItem().
			PressPrimaryAction(). // stage other file
			Lines(
				Contains("A  myfile"),
				Contains("A  myfile2").IsSelected(),
			).
			Press(keys.Files.CommitChanges)

		commitMessage := "my commit message"

		t.ExpectPopup().CommitMessagePanel().Type(commitMessage).Confirm()

		t.Views().Files().
			IsEmpty()

		t.Views().Commits().
			Focus().
			Lines(
				Contains(commitMessage).IsSelected(),
			).
			PressEnter()

		t.Views().CommitFiles().
			IsFocused().
			Lines(
				Contains("A myfile"),
				Contains("A myfile2"),
			)
	},
})
```

Now `input` and `assert` are combined to form `t` (I'm not usually a fan of single-letter variable names but there's precedent for this in Go's testing framework) and the `shell` struct is accessible from that too.

To fix the race condition issue: you must now specify the view you're talking about before you do any key presses, and internally the test will wait for that view to get focus before continuing (failing if it never gets focus).

There's also the `Lines` method which lets you specify what you expect to see in a view. You could argue that it's being used a bit _too_ much here but I find it makes it easy to follow the test (at the cost of making it more brittle).

Also, you may have noticed the `Contains` function being used in a few places. That function is a Matcher, and allows you to make assertions on text content. Other matchers include `DoesNotContain`, `Equals` and `MatchesRegex`. Here's another example to illustrate the point:

```go
t.ExpectPopup().Confirmation().
	Title(Equals("Undo")).
	Content(MatchesRegexp(`Are you sure you want to hard reset to '.*'\? An auto-stash will be performed if necessary\.`)).
	Confirm()
```

## Code Generation

I'm surprised I haven't had to make use of Go's code generation until now (given how much I've complained about Go's type system). Nonetheless, as a testament to my own laziness, the straw that broke the camel's back was having to go and append to my list of tests everytime I added a new test file:

```go
var tests = []*components.IntegrationTest{
	bisect.Basic,
	bisect.FromOtherBranch,
	branch.CheckoutByName,
  ...
}
```

I have the memory of a goldfish so basically every time I created a new test and ran it I would see: 'MyNewTest not found: perhaps you forgot to add it to `tests.go`?'. Yes, younger version of myself, that's exactly what I forgot to do, and although I appreciate pointing me in the right direction, I don't appreciate having the tone! Okay, maybe I'm retroactively projecting condescension from my younger self but I'm emotionally fragile when I make dumb mistakes ;).

This is a conundrum I come across all the time: you have a bunch of files in a directory and they all export something and you want to dynamically maintain a list of all those things. In a statically typed language this is impossible without code generation.

So to save me precious seconds and to keep my younger self off my back I studied up on code generation and added my own generator for building up my list of tests from my nested test files. Here's the important part:

```go
func generateCode() []byte {
	// traverse parent directory to get all subling directories
	directories, err := ioutil.ReadDir("../tests")
	if err != nil {
		panic(err)
	}

	directories = lo.Filter(directories, func(file os.FileInfo, _ int) bool {
		// 'shared' is a special folder containing shared test code so we
		// ignore it here
		return file.IsDir() && file.Name() != "shared"
	})

	var buf bytes.Buffer
	fmt.Fprintf(&buf, "// THIS FILE IS AUTO-GENERATED. You can regenerate it by running `go generate ./...` at the root of the lazygit repo.\n\n")
	fmt.Fprintf(&buf, "package tests\n\n")
	fmt.Fprintf(&buf, "import (\n")
	fmt.Fprintf(&buf, "\t\"github.com/jesseduffield/lazygit/pkg/integration/components\"\n")
	for _, dir := range directories {
		fmt.Fprintf(&buf, "\t\"github.com/jesseduffield/lazygit/pkg/integration/tests/%s\"\n", dir.Name())
	}
	fmt.Fprintf(&buf, ")\n\n")
	fmt.Fprintf(&buf, "var tests = []*components.IntegrationTest{\n")
	for _, dir := range directories {
		appendDirTests(dir, &buf)
	}
	fmt.Fprintf(&buf, "}\n")

	return buf.Bytes()
}
```

Now I've got a VS-Code task which invokes that generator for me when I add a new test!

See the related PR [here](https://github.com/jesseduffield/lazygit/pull/2449/files).

## Visual Snapshot on failure

Anybody who's worked with integration tests before knows the classic problem of a failing CI test that doesn't fail when run locally. In cases like that you want as much information as possible to be logged in CI so that you can see what went wrong. A common issue with Lazygit's tests is that an unexpected error popup appears and now your keybindings do nothing and the test ends. Now we print a snapshot of the final Lazygit frame:

```
Final Lazygit state:
┌─Status─────────────────────────┐┌─Diff───────────────────────────────────────────────────────────┐
│✓ repo → master                 ││No changed files                                                │
└────────────────────────────────┘│                                                                │
┌─Files - Submodules─────────────┐│                                                                │
│                                ││                                                                │
│                                ││                                                                │
│                                ││                                                                │
│                                ││                                                                │
│                                ││                                                                │
│                                ││                                                                │
│                                ││                                                                │
│                                ││                                                                │
│                                ││                                                                │
│                                ││                                                                │
│                                ││                                                                │
│                                ││                                                                │
│                                ││                                                                │
│                                ││                                                                │
...
```

We're also logging more things in general so that you're not just depending on that visual snapshot.

See the related PR [here](https://github.com/jesseduffield/lazygit/pull/2450/files)

## Conclusion

So, hopefully I can smash through these remaining integration tests and return my focus to some of the more exciting things I want to achieve this year. I've still got more tech-debty stuff to work on (_not so smart now are you, younger self?_) but I'm looking forward to adding bulk-actions, github PR awareness, and many more cool features this year.

Thanks to all of you who are sponsoring me or who have donated, and thanks to the lazygit contributors! (special shout out to Luka Markušić, Ryoga, Stefan Haller who have each made various contributions recently and who've been keeping the [discord](https://discord.gg/ehwFt2t4wt) lively)

If you like Lazygit and would like to sponsor me, you can do so [here](https://github.com/sponsors/jesseduffield).

Also, if you would like more regular updates about Lazygit's progress, let me know! Thanks for reading.
