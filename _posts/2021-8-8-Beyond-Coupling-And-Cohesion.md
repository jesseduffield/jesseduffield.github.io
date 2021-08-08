---
layout: post
title: 'Beyond Coupling and Cohesion: Strategies For Un-F*cking Yourself'
---

The terms _Loose Coupling_ and _High Cohesion_ seem to go hand in hand: the two concepts were coined together and if you're talking about one, the other will typically come up as well. Similarly, the concepts of _DRY_ (Don't Repeat Yourself) and _Wrong Abstraction_ go hand in hand: for example one person says we should _DRY_ this code up and the other says they considered it but they don't want to create the _Wrong Abstraction_. I rarely hear these two sets of concepts in the same conversation, which surprises me because they are really talking about the same thing.

Allow me to explain. This is a box:

![]({{ site.baseurl }}/images/posts/dependencies/box.png)

It defines the boundary of the system that you have the power to change. The things you _can_ change go inside the box: the things you _can't_ go outside. The only reason something inside the box needs to change is for the sake of something on the outside: be that changes in external systems, new requirements from users, or a change in the domain that you're trying to model.

For example, say we have a function `foo()` that renders a box and every second week the UX team decides the box needs to change to some new colour. In effect we have a dependency pointing from `foo()` to our design team, because when the design team changes (their minds), `foo()` must change too. We'll colour these out-going dependency arrows green.

![]({{ site.baseurl }}/images/posts/dependencies/basic.png)

Alright we have our pieces in order. Let's use them to represent _Loose Coupling_:

## Loose Coupling

![]({{ site.baseurl }}/images/posts/dependencies/loose.png)

We're making this easy for ourselves by having no coupling at all: that is, we have two modules which each contain some service and those services change for completely different reasons. The finance reporter is only ever changed for the sake of the finance team, and the images downloader is used by customers. Our two services are unrelated in the domain, independent in our code, and separated into different modules.

What if moved our two services into the one module?. This would take us from _Loose Coupling_ to _Low Cohesion_

## Low Cohesion

![]({{ site.baseurl }}/images/posts/dependencies/low-cohesion.png)

They will continue to evolve separately because they're still both independent in the domain and independent in our code, but it's going to be harder for a developer to reason about that module given two conceptually unrelated services live inside it. If that module was a package we needed to independently deploy, we would now be redeploying our finance service whenever we made a change to our image downloader and vice versa, causing needless deploys.

## Cohesive + Non-Dry

What if we had two things that _would_ need to change for the same reasons? Consider the situation where we have a class with two functions, `foo()` and `bar()` and the two functions share significant overlap which would need to be updated in tandem. We'd consider this class to be cohesive, because the functions are tightly related, but we wouldn't call it _DRY_ because we're repeating code.

![]({{ site.baseurl }}/images/posts/dependencies/cohesive-not-dry.png)

We can fix this dryness issue by factoring out a common `baz()` function and we're left with a a _DRY_, _High Cohesion_ result that can't be faulted, just like our initial _Loose Coupling_ example.

## Cohesive + Dry

![]({{ site.baseurl }}/images/posts/dependencies/high-cohesion.png)

(Blue arrows are for dependencies _within_ the system)

## What's The Common Thread?

So we started off in a good state, and tweaking one thing at a time, eventually landed in another good state. Note that each step of the way we changed something different:

1. In the first step we changed the degree of _colocation_ (how close our code is) by moving our finance service and image service into the same module.
2. In the second step we changed the degree of _domain interdependence_ (green arrows) by considering an example where the two pieces of code needed to change for the same reasons
3. In the third step we changed the degree of _practical interdependence_ (blue arrows) by extracting out a common function and adding a couple of dependencies to that function in the code.

I contend that these three axes: _colocation_, _domain interdependence_, and _practical interdependence_, form a basis that covers _Coupling_, _Cohesion_, _DRYness_, and the _Wrong Abstraction_, as well as some other things too.

Given that each of our axes are independent of eachother, we end up with 8 (2^3) permutations, four of which we've already shown above. Let's see if you find the remaining four familiar.

Our last example was high-domain interdependence, high-practical interdependence, and high-colocation. Let's switch now to low-domain interdependence:

## Wrong Abstraction

![]({{ site.baseurl }}/images/posts/dependencies/wrong-abstraction.png)

(Red arrows also express practical interdependence, but are coloured to reflect the pain they cause)

This gives us the classical _Wrong Abstraction_ example: we have one function that tries to do everything, and within it lives code for handling two separate use cases, which each have different reasons to change (as signified by two separate out-going dependencies). The solution to this problem is to dismantle the abstraction and separate the use cases (that is, because domain interdependence is low, so should be practical interdependence and colocation).

## Tight Coupling

For the next example we'll switch to low-colocation. This is actually an issue I bumped into at work: we had a node app with a dependence on a package that included the code that the node app actually used (labeled A) as well as some code that was browser-specific (labeled B). We had inadvertently added some code to B which raised if there was no browser present, regardless of whether we explicitly imported it into our node app!

![]({{ site.baseurl }}/images/posts/dependencies/node.png)

The solution was to move A out of the package and into our node app (in our case nothing else depended on it).

Decreasing colocation has a tendency to exponentially compound problems because instead of depending directly on a few chunks of code, you're now dependent on the entire module/package housing those chunks of code. As was the case with our node app, sometimes the extra stuff in that module/package will crash your server.

## Microservices Destined To Be Together

For this example we'll set domain interdependence to high:

![]({{ site.baseurl }}/images/posts/dependencies/microservice.png)

Here we have two microservices which always need to change at the same time, meaning that unlike in the previous example, we would never have one service being updated on its own. This typically means that for each change, A needs to pass B some different parameters, or call a new endpoint. And _that_ means B needs to remain backwards compatible with A for the brief gap between their two deployments. The solution to this problem is to just combine the two microservices into one! Slightly less micro but still provides a service.

This demonstrates the importance of matching your colocation with your domain interdependence: if the domain determines that two things always change at the same time, the closer they are, the better. Not just closer lexically but physically closer by sharing a deployment.

## Dangerous Duplication

We've now looked at seven permutations meaning we're up to the final one. For this, we'll hold colocation low and domain-interdependence high but remove the practical interdependence (i.e. that angry red arrow). The classical example of this is having two duplicate functions living in completely separate modules, where we want to keep the functions in lockstep.

![]({{ site.baseurl }}/images/posts/dependencies/non-dry.png)

Given that the compiler has no idea we want to keep the functions in-sync, it's up to the developer to use his telepathic instincts when updating the method to search for the entire codebase for a potential duplicate function in case that should be updated too. The obvious solution here is to delete the duplicate function and redirect all of its callers to the original. If we had the same duplication but within a single file (i.e. much higher colocation) it wouldn't be such a big deal because it's easier to spot the resemblance, but as you decrease colocation from same-file, to same-module, to same-repo, the problem grows ever more pernicious.

## Conclusion

What can we learn after having traversed this 2x2x2 cube of conundrums? In each example, the solution was always to set our practical interdependence and colocation to whatever our domain interdependence was. That is, if two pieces of code change for completely different reasons, you should not only separate them but also minimise the dependencies in the code between them. Conversely, if two pieces of code change for the exact same reasons, you should not only move them close together, but also represent their interdependence in the domain with interdependence in the code, whether through sharing some common interface, calling eachother, or factoring out common code.

The _DRY Principle_ and the idea of the _Wrong Abstraction_ both care about domain interdependence and practical interdependence, but not much about colocation. Coupling cares about practical interdependence but only when there's low colocation, and Cohesion cares about domain interdependence but only when there's high colocation. These disparate concepts cover a lot of ground, but not enough to capture the full range of situations generated by their underlying axes. Hopefully this post has equipped you with a schema to reason through these dependency dilemmas when you face them in the wild.

Until next time!
