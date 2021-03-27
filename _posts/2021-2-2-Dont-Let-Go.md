---
layout: post
title: Don't Let Go
published: false
---

These days I start work by reviewing a mountain of pull requests and if I'm lucky I'll manage to get through them by lunch time. Although it can be a real grind, there is something deeply satisfying about seeing the myriad ways in which a problem can be tackled. What's more satisfying is when, by repeated exposure, you build an intuition for why certain approaches are better than others.

This is the internet so no doubt this post's contention is out there already and it probably has a more catchy name than I can give it, but here it is anyway: Don't Let Go. Don't let go of what? Let's take an example:

I work in email marketing so everything revolves around Campaigns. Put simply, a Campaign can be in a `draft` state, a `running` state, and a `finished` state. This corresponds to a `status` column in our database's `campaigns` table. Each state transition has its own special logic. For example, we should be able to go back and forth between `draft` and `running`, for example if the user pauses the campaign, but once we're at the 'finished' state we can't go back. What's more, after finishing the campaign, we want to send a message to the user telling them about how successful it was.

Sounds complicated! Let's neatly encapsulate that into an update_status method like so:

```ruby
class Campaign
  def update_status(new_status)
    if !['draft', 'running', 'finished'].include?(new_status)
      raise("unknown status: #{new_status}")
    end

    case self.status
    when 'draft'
      case new_status
      when 'running'
        self.update(status: new_status)
      else
        raise("Can't transition from #{self.status} to #{new_status}"
      end
    when 'running'
      case new_status
      when 'draft'
        self.update(status: new_status)
      when 'finished'
        self.update(status: new_status)
        Notifier.notify_finished_campaign(campaign: self)
      else
        raise("Can't transition from #{self.status} to #{new_status}"
      end
    when 'finished'
      raise("can't update status when campaign already finished")
    end
  end
end
```

Alright... it's a little messy but of course it is, there's a lot of permutations it needs to handle!

Now let's make use of this in our controller:

```ruby
class CampaignsController
  def activate
    @campaign.update_status('running')
  end

  def pause
    @campaign.update_status('draft')
  end

  def finish
    @campaign.update_status('finished')
  end
end
```

Well, the model code sure was ugly, but our controller looks so slim and clean!

Okay, what's wrong with this picture? The problem is that we have separate endpoints for setting a campaign to draft, running, and finished, meaning that we never actually receive a param at runtime called 'status'. We know exactly what argument we're going to pass to our `update_status` method at _compile time_. Yes this is ruby and so there's no such thing as compile time but you get what I mean: we are treating static information, the kind of information you get just from looking at your editor, as dynamic. We made the mistake of Letting Go of statically defined information about how our code behaves, inviting in all the awkwardness of handling arbitrary runtime values.

From within our model's `update_status` method, we have no idea what value our `new_status` argument might have. Who knows what's calling our method? Who knows what it wants to achieve? Maybe it's user input from a request? We can't know! So we defend against unexpected values:

```ruby
def update_status(new_status)
  if !['draft', 'running', 'finished'].include?(new_status)
    raise("unknown status: #{new_status}")
  end
```

Of course, were this a typed language you could specify that `new_status` needs to be one of the three valid values, but even then, this method has problems. The value of `new_status` completely changes which code is executed inside the method. You might argue that the validation code at the top is shared among all the code paths, but that validation code only exists in the first place because of our decision to jam three loosely related responsibilities into the one place. In effect, we're funnelling our three use cases into an argument only to then immediately expand back out into our original use cases.

Here's one way we could approach this differently:

```ruby
class Campaign
  def activate!
    expect_status!(['draft'])
    self.update!(status: 'running')
  end

  def pause!
    expect_status!(['running'])
    self.update!(status: 'draft')
  end

  def finish!
    expect_status!(['draft', 'running'])
    self.update!(status: 'finished')
    Notifier.notify_finished_campaign(campaign: self)
  end

  private

  def expect_status!(statuses)
    if !statuses.include?(self.status)
      raise("unexpected status: #{self.status}")
    end
  end
end

...
class CampaignsController
  def activate
    @campaign.activate!
  end

  def pause
    @campaign.pause!
  end

  def finish
    @campaign.finish!
  end
end
```

If you thought the controller looked slim before, check it out now. There are no doubt other ways we could have tackled this: perhaps we could express the permitted state transitions in some centralised way. But the important change in this refactor is that we are now honouring the information we have at compile time: just by looking at the editor I can know that when a user hits the '/activate' endpoint, we're going to call an `activate` model method on our campaign, and that is going to update the status to running so long as it's a permitted state transition. There is no need to combine our logic for activating, pausing, and finishing campaigns because we don't have a use case for that. If we were to introduce a '/change_status' endpoint, then we would have a good reason to introduce an `update_status!` method like so:

```ruby
def update_status!(status)
  validate_status!(status)

  case status
  when 'draft'
    self.pause!
  when 'running'
    self.activate!
  when 'finish'
    self.finish!
  when
end
```

But right now there is _absolutely_ no need.

Runtime data is a night out in the city: lots of surprises, and sometimes people try to attack you. Static data is a night in watching old movies: kind of boring, but satisfyingly predicable. In the world of programming, the more predictable your code, the better, so when you know something at compile time about how your code will behave, Don't Let Go!

This ties into a broader topic about general and specific code. Quite often I find that code is much cleaner when specific code calls general code than when general code calls specific code. If the behaviour of your specific code is sufficiently uniform, then you should be able to implement some kind of polymorphism, in which case general code calling specific code works great. If not, and you're seeing switch statements all over the place, consider either bypassing the middle-man altogether (in the same way that we deleted our `update_status` method) or factoring out common code into a method which can be called by the specific code (e.g. our `expect_status!` method). I'm aware that that this ties into the concept of Inversion Of Control, but that term is typically invoked when proposing to go in the other direction. If anybody knows the term for this please let me know!
