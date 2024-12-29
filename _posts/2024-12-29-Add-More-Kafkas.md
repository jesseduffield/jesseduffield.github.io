---
layout: post
title: "Add More Kafkas"
---

I knew from day one that if we didn't add Rust, Kafka, and Microservice to [Clipbox](https://clipbox.carrd.co/)'s architecture, we were _f\*cked_.

In an increasingly competitive world of software engineering, accelerated by recent advances in AI coding assitants, we needed to stand apart from the crowd, so I got my engineering team in a room in the first week of development and said:

> guys (and girls, obviously) we are going to really architect the sh\*t out of this product. It's going to be hard: some of you won't be able to endure the long hours, the random bugs, or (let's face it) my own occasional mood swings, but there is no greatness without sacrifice, and I promise you all that if we can pull this off, Clipbox is going to propel all of you into greatness, both in your careers, and your personal lives.

I received a long round of applause; so long in fact I had to eventually raise a hand to silence it so that I could explain the specific terms:

> Provided that we eventually get acquired for over 100 million dollars, I will award ten thousand dollars for every Kafka we put in the system.

Candice, one of our top engineers, raised her hand and asked:

> So if I put 5 kafka's in the system, and we sell for over 100 mil, you'll give me 50k?

I crunched the numbers in my head like lightning and responded almost immediately:

> Yes, that's right.

There was a brief silence in the room, followed by energised whispers among the engineers, excited for the chance to prove their software development chops while making some handsome cash on the side. That is the sound of motivation.

Fast-forward to today. 20 millions users, and a prospective big-tech buyer who's looking to purchase us for 2 billion (I'll give you a hint, his first name is 'Mark').

Rome wasn't built in a day, but when it did eventually get completed, it had a striking resemblance to Clipbox's own architecture:

* complex sewer system that carries material out from the core to various other places (think Microservice)
* defensive structures to prevent infiltration from barbarians (Security)
* use of complex but precise language (Rust)
* competent, stoic emperors who pontificate on various topics

It wasn't all smooth sailing; we had some very close calls. One night before a very important beta launch we were having issues with one of our core services: it wasn't able to keep up with the memory requirements of our core clipboard feature. The team told me that they had exhausted all options. I knew how important this launch was so there was no time for hesitation. 'Double the kafkas' I said. There was resistance, of course. 'I don't think any company has ever had that many', one of my senior devs protested. But then Jake, a junior frontender, chimed in:

> We didn't make this company so that we could follow in the footsteps of our predecessors. If we need to double the kafkas, then let's do it

Wise words from a young guy. There was fierce debate: a couple engineers stormed off in anger. But we doubled the kafkas in the end and the launch went ahead without a hitch. This was just one of many decisions we made along the way that got us to where we are today.

I'd love to take credit for all the accomplishments but the reality is that leaders don't make great products: _teams_ do. It's true, I'm the leader of the team and I probably worked the longest hours out of anybody and if any individual member of the team handed me their keyboard and asked me to do their job for them I likely would have outperformed them even in their specialised role, but that's not important: what's important is that the team came together and weathered the challenges, setbacks, and sheer panic that comes with building something great, and in the end, executed.

As for the architecture we ended up building? Solid as a rock. I had a guy from AWS fly out to do an in-person review and he had tears in his eyes as he said that he had never seen an architecture so beautiful. He full-on started sobbing, I actually briefly wondered if he had other issues going on in his life because it was not at all obvious that they were tears of joy but he assured me he's happily married with kids and was just taken by surprise at the architecture diagram, so it was a real treat for the team who had poured so much effort in over the years to have an outsider give such a heartfelt commendation.

As for the cash bonuses I mentioned earlier? Let's just say Candice is going to be enjoying a very early retirement (that's not a threat: I'm hinting at how much money she's going to make).

Gotta cut this short: 'Mr Z' as I like to call him is trying to call me right now. If you take one thing away from this post it's to believe in your team and to not shy away from using state of the art technology to give your architecture a competitive advantage. Until next time :)
