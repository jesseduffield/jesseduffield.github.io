---
layout: post
title: How Not to Develop a Ruby Gem
---

Over the last couple of days I've been working on [LazyMigrate](https://github.com/jesseduffield/lazy_migrate), a gem which provides a little UI for handling migrations in rails. Because it's a gem that depends on your Rails app's code, it can't really be tested in isolation (unless I went and mocked out a heap of stuff which would erode my confidence that things were working correctly). I was vaguely aware that I could have made a Rails [plugin](https://guides.rubyonrails.org/plugins.html), which sets you up with a mock rails app for testing, but I wanted to be able to run the gem from outside rails as well.

This means that in order to test my gem I needed to reload the gem with bundler from within my Rails app and then open up the console again. I started off by specifying the gem in my Gemfile like so:

```ruby
gem 'lazy_migrate'
```

This meant that for each change I made to the gem, I would need to push it to RubyGems like so:

```
# bump the version manually in version.rb
module LazyMigrate
  VERSION = "0.1.5"
end

...

# on command line
$ gem build lazy_migrate
$ gem push lazy_migrate-0.1.5.gem

...

# in my rails app
bundle update lazy_migrate

```

Without the version bump, RubyGems would not let me push the gem. This is obviously a terrible setup! Every time I want to experiment with a single line change of code I need to bump my version and build/push the gem, then run a `bundle update` in my rails app.

Given my gem lived in a repo on GitHub, I decided to switch to the git approach in my Gemfile:

```ruby
gem 'lazy_migrate', git: 'https://github.com/jesseduffield/lazy_migrate.git'
```

This way I didn't need to bump my version or build/push to RubyGems, I could just push to my repo. This approach supports specifying a branch as well but given it's early days I've been pushing directly to master.

This approach was faster but still not quite right: it was strange to push experimental changes in commits and then have to go and revert or drop those commits if I didn't like the changes. So I switched to using the local path approach:

```ruby
gem 'lazy_migrate', path: '/Users/jesseduffieldduffield/repos/lazy_migrate/'
```

(Why my username is `jesseduffieldduffield`, I have no idea and I'm too lazy to fix it up, much to the schadenfreude of my friends and colleagues.)

This would seem to be the best approach because you don't need to even be connected to the internet, yet my changes weren't coming through at all. Previously a new commit on the git repo would tell bundler that we needed to checkout the new gem code when running `bundle update` but not so when using the local path approach.

I soon discovered that my gem code was being cached by Spring. Spring is a rails background process which maintains a bunch of preloaded code so that you don't need to reload everything every time you run a rails command like `rails console`. Unfortunately this means that your stale gem code can be cached behind the scenes.

The solution:

```ruby
DISABLE_SPRING=true rails console
```

But this got me wondering whether I could do this even faster. What if I didn't even need to restart my rails console to load my gem's code? Inside the rails console I tried `load` on the file that I changed in my gem:

```
irb(main):020:0> load '/Users/jesseduffieldduffield/repos/lazy_migrate/lib/lazy_migrate/migrator.rb'
/Users/jesseduffieldduffield/repos/lazy_migrate/lib/lazy_migrate/migrator.rb:11: warning: already initialized constant Class::MIGRATE
/Users/jesseduffieldduffield/repos/lazy_migrate/lib/lazy_migrate/migrator.rb:11: warning: previous definition of MIGRATE was here
/Users/jesseduffieldduffield/repos/lazy_migrate/lib/lazy_migrate/migrator.rb:12: warning: already initialized constant Class::ROLLBACK
/Users/jesseduffieldduffield/repos/lazy_migrate/lib/lazy_migrate/migrator.rb:12: warning: previous definition of ROLLBACK was here
... (more warnings about redefining stuff)
=> true
```

This worked! But only for reloading individual files. What if I wanted to reload my whole gem with a single command? Doing

```ruby
load 'lazy_migrate'
```

Does nothing, because the load command requires us to specify a file extension (and therefore is only made for files, not gem names). `require` _does_ support passing a gem's name as the argument, however once the gem is loaded once, `require` will simply early-exit and return `false` on subsequent calls.

I settled on what is admittedly a bit of a hack, which is to simply call `load` on all the files in my gem. I defined a `reload_gem!` method like so inside my console session:

```ruby
def reload_gem!
  Gem.loaded_specs['lazy_migrate'].full_require_paths.each { |path|
    Dir["#{path}/**/*.rb"].each { |f| load(f) }
  }
end
```

What's happening here? `Gem` gives us access to stuff relating to gems, and

```ruby
Gem.loaded_specs['lazy_migrate'].full_require_paths
```

returns

```ruby
["/Users/jesseduffieldduffield/repos/lazy_migrate/lib"]
```

That is, the base directory for my gem's code. I then obtain all the ruby files in that directory using `Dir["#{path}/**/*.rb"]` and load each file individually.

There are no doubt caveats to this approach, given that we aren't properly unloading anything before reloading our files, but I'm yet to bump into one! If I was to start this whole process again I would just include all my gem's files inside the rails app and then only split it out once I felt ready, but if you're like me and you're too lazy to go and move all the files back into your rails app, hopefully this post has given you some pointers on how to save time. Thanks for reading!
