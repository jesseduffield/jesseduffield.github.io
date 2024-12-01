---
layout: post
title: "My notes from deciding against AWS Lambda"
---

At the start of the year I did a deep dive on AWS lambda to know whether it was worth using in a new codebase for a web app. These are the notes I wrote before making the decision against lambda, and I hope they can help somebody else with the same dilemma.

## Elevator pitch

The idea with serverless infrastructure (like AWS Lambda) is that you can deploy your code and have it serve requests without actually needing to stand up a persistent server. When some trigger occurs (e.g. a request from AWS API Gateway), your lambda code is executed on a cloud server somewhere in some sandboxed way and you pay for the compute time.

## Concepts

### Lambda Service

 This is the lambda service itself, which includes managing the execution environment, polling SQS if necessary, etc.

### Lambda function

This is your actual code that runs. It could be a simple python file containing some init code (e.g. imports at the top of the file) and a handler function (typically named 'lambda_handler'). The terms _Lambda Function_ and _Lambda Handler_ are often used interchangeably but the distinction matters when it comes to cold starts vs warm starts.

### Cold starts

The reason lambda can be so cost effective is that you're not paying for an EC2 server that's spending a bunch of time idle. A lambda only runs when it's needed to run. But, the downside is that there is some time required to spin up your lambda before it can run your code. That's referred to as a 'cold start'. AWS will keep your lambdas warm for a time after they run so that they can be re-used without requiring another cold start. Cold starts reportedly happen around 1% of the time (though depends on load: spiky load will result in more cold starts).

[AWS docs on cold starts](https://docs.aws.amazon.com/lambda/latest/operatorguide/execution-environments.html)

* Lambdas have a few stages:
	1. download code (from s3 or ECR)
	2. start new execution environment
	3. execute initialisation code
	4. execute handler code
* The first two stages are considered part of the cold start. You don't get charged for that. But from a runtime perspective, the third step is part of the cold start, because if a lambda is reused, only the fourth step happens.
* Global variables like database connections can persist from one lambda invocation to the next, because the lambda may be retained and re-used.
* If you have a warmer function to keep a lambda warm by pinging it every minute, it only helps you if a single lambda is needed. If you get a bunch of requests in at once, new execution environments will be needed for the new lambdas and each of those lambdas will have a cold start.
* There's no guarantee that a lambda will be re-used if there are two requests in quick succession, because the lambda service may want to balance things out and invoke your lambda function in another availability zone

[Guide on managing cold starts](https://lucvandonkersgoed.com/2022/04/08/lambda-cold-starts-and-bootstrap-code/)

* AWS doesn't document this (and so it may no longer be true), but apparently init code (i.e. stuff happening before your lambda handler like imports and global variables) is executed with more CPU than the lambda code itself, so that it happens faster
* This means you should try to have as much happening in your init code as possible so that warm lambdas are as fast as possible
* The downside of course is that, the more that happens in your init code, the slower your cold starts

## Considerations

### Pros:
* you only pay for time spent running your lambda functions so if you rarely need to call lambda functions, you'll save money. Compare this to an EC2 instance that is costing you money at 2am when it's not being used.
* there is a free tier which you may very well remain under
* auto-scaling and load balancing is handled for you, so there's less work involved in deployment
* Able to configure granular IAM permissions and CPU/memory resources on a per-lambda basis
* Scales up much faster than containers in ECS
* Highly reliable. Lambda basically never goes down

### Cons:
* The per-second cost of lambda is higher than for EC2, so if you have a consistent load, it will be more expensive
* Cold starts can hinder the user experience if using lambda in a web app
* It's impossible to test locally: you'll rely on lots of mocking, or depend on a cloud environment
* There are hard limits to lambda duration (15 minutes) which is bad for long-running jobs
* There are hard limits to lambda package size which may require you to break up an otherwise sensible system
* Logic that would otherwise live in your application now lives in AWS which has pros and cons.
* IO-bound workloads are expensive because you're paying by the second and because you can't benefit from intra-process concurrency like you can with a dedicated web server managing many connections at once

## Monolambdas vs Microlambdas

There are two main ways you can approach lambdas:
* **Monolambdas (or lambdaliths or lambda monoliths)**: with Monolambdas, you have a single lambda that you use for everything. For example, one lambda that contains your entire web API, and all requests go to that lambda. Or one lambda that contains your entire background job worker code, and all background jobs from SQS go to that.
* **Microlambdas**: with Microlambdas, you have many lambdas. It could be one per API endpoint, or in the case of background jobs, one per worker.

### Advantages of Monolambdas

* You can encapsulate the lambda part e.g. using zappa with flask, or using a single entrypoint for your background workers, which means:
    *  it's easy to migrate off lambda in future if you want to
    * it's easy to test locally (e.g. using `flask run`)
* You only need to worry about deploying a single thing
* Re-using shared code is trivially easy
* Cold starts will be less frequent because the same lambda will be re-used a lot more
* Deployments are faster because there's a single target
* Provisioned Concurrency (basically paying extra to keep lambdas warm) is easier/cheaper to apply because there's a single target

### Advantages of Microlambdas:

* Smaller package size guaranteed, so you won't need to worry about exceeding the limit
* Cold starts will be faster because there is less code to import/initialise
* Granular permissions can be set
* Granular resource requirements can be set
* No chance of deploying a lambda which crashes everything
* Different teams can be responsible for different lambdas, without treading on eachother's toes

### Links

[AWS docs really don't want you using a monolambda](https://docs.aws.amazon.com/lambda/latest/operatorguide/monolith.html)

> In many applications migrated from traditional servers, EC2 instances or Elastic Beanstalk applications, developers “lift and shift” existing code. Frequently, this results in a single Lambda function that contains all of the application logic that is triggered for all events. For a basic web application, a monolithic Lambda function would handle all API Gateway routes and integrate with all necessary downstream resources.
> ...
> This approach has several drawbacks:
>
> - **Package size**: the Lambda function may be much larger because it contains all possible code for all paths, which makes it slower for the Lambda service to download and run.
>
> - **Hard to enforce least privilege**: the function’s IAM role must allow permissions to all resources needed for all paths, making the permissions very broad. Many paths in the functional monolith do not need all the permissions that have been granted.
>
> - **Harder to upgrade**: in a production system, any upgrades to the single function are more risky and could cause the entire application to stop working. Upgrading a single path in the Lambda function is an upgrade to the entire function.
>
> - **Harder to maintain**: it’s more difficult to have multiple developers working on the service since it’s a monolithic code repository. It also increases the cognitive burden on developers and makes it harder to create appropriate test coverage for code.
>
> - **Harder to reuse code**: typically, it can be harder to separate reusable libraries from monoliths, making code reuse more difficult. As you develop and support more projects, this can make it harder to support the code and scale your team’s velocity.
>
> - **Harder to test**: as the lines of code increase, it becomes harder to unit all the possible combinations of inputs and entry points in the code base. It’s generally easier to implement unit testing for smaller services with less code.
>
>
> The preferred alternative is to decompose the monolithic Lambda function into individual microservices, mapping a single Lambda function to a single, well-defined task. In this simple web application with a few API endpoints, the resulting microservice-based architecture can be based upon the API Gateway routes.

[Here's a post refuting the AWS best practices point-by-point](https://rehanvdm.com/blog/should-you-use-a-lambda-monolith-lambdalith-for-the-api)

> The argument to limit the blast radius on a per route level by default is too fine-grained, adds bloat and optimizes too early. The boundary of the blast radius should be on the whole API/service level, just as it is and always has been for traditional software.
>
> Use a Lambalith if you are not using any advance features of AWS REST API Gateway and you want the highest level of portability to other AWS gateways or compute layer. There are also many escape hatches to fill some of the promises that single-purpose functions offer.

[HN Comment](https://news.ycombinator.com/item?id=38084482)

> Yes, you should. Especially if you want to scale up without tons of extra work.
>
> The model of "every function should be a separate Lambda" is just moronic - I've seen people run into hard limits on AWS going all-in on this model.
>
> Instead Build a single executable/library and deploy it as a Lambda function.
>
> Now you have automatic versioning, just push and it's a new version. You can label versions and call them based on labels.
>
> Deploying to prod is just swapping the prod label to a new function. Want to roll back? Swap it back.
>
> Credentials: ran a top10 mobile game backend on AWS Lambda with zero issues using a C# monolith.

[Another post comparing the two options; very balanced](https://blog.symphonia.io/posts/2022-07-20_lambda_event_routing)

> The one question that remains is what happens when you add the _second_ event type to your simple, single-responsibility, Lambda app. Should you stick with the default MonoLambda, or should you immediately embrace multiple functions?
>
> I would suggest that **if your team on the whole are still fairly new to Lambda, and if the second event type can be satisfied by the operational constraints of using a MonoLambda, then go with a MonoLambda**. You can always change the decision later once the team are more comfortable with the platform.
>
> On the other hand if the team are already largely experienced with Lambda then I'd recommend you make the choice based on _wider_ operational factors - **will any of the next few event types have different operational preferences** - security, performance, logging, etc., - from your first event type? **Would combining any of the next few event types into one function cause consequential deployment or startup performance impact**? If the answer to either of these questions is “yes” then introduce multiple Lambda functions, otherwise stick with a MonoLambda until your performance or operational requirements drive you to a mixed design.

### Something in-between

#### One lambda per API namespace

[What about one lambda per API namespace?](https://news.ycombinator.com/item?id=38091633)
> There is a third approach besides "lambdalith" and "one lambda per route", it's making one lambda for a group of routes, for example you could group them by first segment of their path (all routes starting with /users/* in one lambda, all /orders/* in another, etc). Then, inside the lambda handler, you can use a routing library to select the right method.
>
> This worked for us because it mitigated the shortcomings of the other two approaches for example:
>
> - one lambda per route: very long build times and long deploy times (due to the high number of lambdas)
>
> - lambdalith: lack of permission granularity (as opposed to creating different IAM roles for different lambdas); lack of granularity for memory/cores configuration means you are missing out on cost optimisation; also, as the API grows, it soon becomes necessary to adopt some framework like Express or Fastify to keep things tidy.

#### Monolambda with multiple targets

This would address the granular permissions point: have the same code being deployed to different lambdas and tweak the permissions on each lambda to restrict what it can do. This is not as strong a separation as having  _code_ isolated, given that all code is still shared, but it's still something.

## Hard to test locally

One issue with AWS lambda is that none of the stuff can be easily mocked out locally, making local development hard. Here's a [HN comment](https://news.ycombinator.com/item?id=25103390):

> I recently migrated part of a platform over to a distributed architecture with a heavy reliance on serverless functions. We had very specific reasons for doing it that I wont get into, but I can confirm that its an unbelievably bad experience from a development standpoint. We tried all the usual tools like localstack and SAM local and it all just suuuuucked. Something that would have been a day or twos worth of work with a tranditional api endpoint would stretch out to weeks. We ended up getting fed up and put all the calls to our serverless functions behind interfaces. Then, when running locally, we swapped out the transport layer to call a simple webserver that can call the the functions directly. We've been leveraging that approach for a few months now and its smoothed out a lot of issues for us. The downside of course is that you aren't using the same networking as whats deployed but so far it hasn't been as much of a problem as I was afraid it would be and our velocity has increased quite a bit.

[Another comment](https://news.ycombinator.com/item?id=30938970)

> My previous company had thousands of lambda functions and api gateway integrations and near impossible to do anything with confidence when you starting integrating with all the other cloud offerings. My current environment is similar scale, but all containers it's night and day difference when it comes to confidence. We can move 100x faster when you can reproduce environments locally or separate account in seconds or minutes with everything baked in. I don't think I could move back, but hey at least this might eliminate a few API Gateway integrations.

> My work is heavy serverless and nobody I work with has had any luck with Localstack, myself included. It's just too limited, fragile, and buggy to work for anything we do. Our stack isn't anything particularly unusual either, it's just that if you are using Lambdas heavily they are probably tied in with a whole bunch of other AWS services in ways that are hard to replicate locally; and Localstack just isn't up to the task.
>
> While there are some nice benefits to serverless workloads on AWS, local development and reproing production bugs are major weak points.

[https://news.ycombinator.com/item?id=25101071](https://news.ycombinator.com/item?id=25101071)

> The impossible to replicate the production environment I think was referred to impossible to replicate locally, on your machine.
>
> At my job I use AWS serverless services and I get a lot of frustration not being able to test and debug code offline. Having each time to upload some code to debug it is time consuming. Also you have to rely only on logs to debug, you obviously cannot use a debugger, and thus the solution is to insert a ton of print statements in the code and remove them, which is not a problem to me (I usually do that even in code that I debug locally) but the service to read these logs (ColoudWatch) is not great at all, you don't even have all your logs in one place, it's a mess.
>
> I think serverless is overrated, sure it maybe the right tool for a simple project, but when the complexity grows it's best to use other more classical solutions.

[Reddit thread about local testing vs cloud dev](https://www.reddit.com/r/aws/comments/y90xca/do_some_developers_actually_really_have_no_local/)

> Our company has completely avoided mocking cloud services with things like localstack, from day 1. For everything we develop locally, we use the real service right away.
>
> There's really no good reason not to, it's not expensive and everyone always has an internet connection. Why bother? I don't see the benefit other than small cost savings potentially.

> I'm in a low resources high needs environment and long ago abandoned a local dev env. My best manner of coping is developing against unit tests and then sucking it up on targeting a dev cloud formation stack to see if everything works. We (as in me and a colleague) tried frameworks to abstract us away in a bid to not have to directly worry about AWS details and that just made us worry about those frameworks and AWS details.
>
> So yeah, I have no local dev env and about once a year I spend several hours debugging my code changes to only find it was and AWS issue. So that and cloudformation overhead are the only material troubles when needing to smoke test/integrate.

[Another thread on cloud vs local dev](https://www.reddit.com/r/programming/comments/zfpiil/dev_environments_in_the_cloud_are_a_halfbaked/)

> Leave it on the cloud. If the cloud is down then management can only blame themselves for that one.
>
> I also like the clean environment my computer has now rather than multiple client crud, having to run postgres or mongo SB and all that shit
>
> Separation is also better now that we work remotely. I login to the cloud do my shit and log off. All the slack teams outlook remain there and don't leak into my personal work when I log off

[Another thread](https://www.reddit.com/r/ExperiencedDevs/comments/12r0j3t/what_setup_do_you_prefer_local_dev_env_or_remote/)

> As someone who loves working on developer infrastructure, I can definitely see why your company would make the move.
>
> Local dev environments are great IFF you’re a dev with solid “computering” skills. Moving to a remote dev environment is much, much easier to maintain at scale because you get to stop spending a bunch of time fixing everyone’s broken local environments.
>
> I personally much prefer working in a local dev environment, but I immediately saw the value of a remote dev setup as soon as I started supporting a team with mixed skill levels. Even supporting installing / running Docker for a totally containerized local development environment on the extremely limited machine choice of an M1 or an Intel Mac got painful quickly.
>
> I’m sorry for your loss. Your company is never going back to local dev environments. It’s just so much cheaper / easier to have one team do all of the work to manage the environment remotely and free up all of the other teams to focus on product delivery. Your company already decided that the potential productivity loss from any network latency was smaller than the potential productivity gain of consolidating the system administration work.

## Lambda can be expensive

[Serverless To Monolith – Should Serverless Lovers Be Worried?](https://beabetterdev.com/2023/05/20/serverless-to-monolith-should-serverless-lovers-be-worried/)

> Amazon’s Prime Video Tech blog recently released [an article](https://www.primevideotech.com/video-streaming/scaling-up-the-prime-video-audio-video-monitoring-service-and-reducing-costs-by-90) that has gotten some internet attention. The article examines a team that was able to reduce their infrastructure cost by up to 90% by moving from a serverless to “monolithic” architecture.
>
> It’s not every day you hear about moving from Serverless **to** Monolith. So rightfully, this article has gotten quite a few second glances. Some of the takes though are dubious at best claiming “See, even Amazon is saying serverless sucks!”.
>
> That’s…. not what they’re saying it all, and shouldn’t be your main takeaway. So let’s dig into this article and understand why its making such a fuss.

## Lambda can be very cheap

[HN Comment on how lambda saves money](https://news.ycombinator.com/item?id=30937826)
We aren't a company that uses Lambda at scale but we have exposure to a few thousand AWS customers' cloud costs and I definitely say that the customers who are all-in using Lambda are saving a lot of money relative to their container/EC2 counterparts. That being said, I see _very_ few companies "all in" on Lambda these days at an organizational level. It's still the exception - I think you need to be very intentional with its use at an organizational level architecture wise...but I see a lot of companies with sprinkles of Lambda usage here and there.

[More on lambda being cheaper](https://news.ycombinator.com/item?id=29579855)
> I have worked with many teams and found lambda to be by far more cost effective. Did your calculations include the time lost waiting to deploy solutions while infrastructure gets spun up, the payment for staff or developers spending time putting infrastructure together instead of building solutions, the time spent maintaining the infrastructure, the cost of running servers at 2am when there is no traffic. Perhaps even the cost of running a fat relational database scaled for peak load that needs to bill you by the hour, again even when there is no traffic.
>
> Serverless as an architectural pattern is about more than just Lambda and tends to incorporate a multitude of managed services to remove the cost of managment and configuration overhead. When you use IaC tools like Serverless Framework that are built to help developers put together an application as opposed to provisioning resources, it means you can get things up fast and ready to bill you only for usage and that scales amazingly.

## More case studies

[Moving my serverless project to Ruby on Rails](https://frantic.im/back-to-rails/)

> In reality, writing the simple Lambda functions turned out to be only 10% of the work.
>
> Time passed and my backend started getting more complex: I needed to store some state for each [puzzle](https://hacker.gifts/products/space-invaders), send confirmation emails, show an order details page. What started as a simple function, grew into a bunch of serverless functions, SNS topics, S3 buckets, DynamoDB tables. All bound together with plenty of YAML glue, schema-less JSON objects passed around and random hardcoded configs in AWS console.
> ...
> When the building blocks are too simple, the complexity moves into the interaction between the blocks.
> And the interactions between the serverless blocks happen _outside_ my application. A lambda publishes a message to SNS, another one picks it up and writes something to DynamoDB, the third one takes that new record and sends an email…
> ...
> Tracing errors was a challenge, there’s no single log output I can look into.
> With serverless, I was no longer dealing with my project's domain, I was dealing with the distributed system's domain.
> ...
> Drawbacks of serverless (for hobby projects):
> - Hard to follow information flow
- Impossible to replicate production environment locally
- Slow iteration speed
- Lack of end-to-end testing
- Immature documentation (dominated by often outdated Medium posts)
- No conventions (have to make hundreds of unessential decisions)

[Reddit thread discussing downsides of lambda](https://www.reddit.com/r/devops/comments/mutsj0/why_we_moved_from_lambda_to_ecs/)

> At a large enterprise we attempted to make "everything" a Lambda. The mantra was "if it can run in Lambda, make it a Lambda".
>
> The problem is our engineering org has thousands of engineers across hundreds of teams. Using a Lambda here and there was no big deal as long as each team was disciplined enough to manage their dependencies and keep state out of their functions. The problem is, domains can get complex, teams switch around, dependency management and compliance all become issue, etc.
>
> Before long, we had a few problems crop up:
>
> - Testing was pretty difficult in general. Not necessarily because of the tooling but because of the overall nature of how serverless architectures tend to work: if you're not already on an event-driven (or at least async) architecture it's much more difficult to do. If you have sync processes with multiple dependencies, it's difficult to orchestrate testing.
>
> - Some teams would attempt to stick entire microservices in a single Lambda. This could be a 1,000+ lines of code. I'm not saying this is or isn't a problem, but it's probably not what it was meant for.
>
> - Many of our Lambdas wound up running 100% of the time either because of warm-up problems or because we're dealing with extremely high traffic scenarios.
>
> - Like others have said, there are some concurrency limitations and other issues we would run into with regards to accessing VPC-only resources. Conversely, we would run into issues when trying to deploly across regions. All of this is compounded by the fact we had to be SOC2/PCI/DSS/GDPR compliant.
>
> - Some teams decided to get more granular with their "microservices". They would have dozens of Lambdas for one "service". This is what I'm calling the _nanoservice_ anti-pattern.
>
> - Keeping track of dependencies became a problem. It became next to impossible to share code or libraries because a single shared library meant updating potentially hundreds of Lambdas.
>
> - Along with dependency management problems we started to run into _versioning_ problems: keeping track of which Lambdas were running which versions of what code was a nightmare.
>
> - Along the same lines of dependency and versioning, just keeping track of the code repositories was a nightmare. Something as simple as _naming_ them became a problem.
>
> - As teams shifted and changed over time, the problems became compounded. Some people have differing opinions, new tech comes out, pressure from product causes one ripple to echo through the ecosystem, etc.
>
> - Eventually some teams needed state in their services. Originally Step Functions weren't really a thing. More teams started to adopt Step Functions but this create a paradox in which teams would start to rely on state-based approaches. Adopting Step Functions has its own problems.
>
> - Managing different types of triggers made our overall data ecosystem overly complex and incongruent. We wound up with a ton of custom pipeline stuff just to get data into common formats and sink them to where we needed it to go. Monitoring, reporting, and analytics was a nightmare and certainly inefficiently designed (and expensive).
>
>
> We eventually standardized on containerization through Kubernetes and slowly migrated away from using Lambda for _everything_. They still have their place, but it's very limited in scope.

[A Reddit commentor on the topic of local development](https://www.reddit.com/r/aws/comments/160gloe/comment/jxq5mr0/?utm_source=reddit&utm_medium=web2x&context=3)

> I find developing locally for docker is much easier than lambda deployments, the feedback loop is fast and there's tons of tooling around "traditional" web servers, APIs and such. Lambda once you are on a larger team takes a lot of tooling investment, segmented developer AWS accounts and more just to get productive. The overhead is large, the payoff might be worth it for a lot of people but we've found that it generally slows us down.

[Reddit post of a guy asking if lambda makes sense for basic CRUD web apps](https://www.reddit.com/r/aws/comments/yxyyk3/without_saying_its_scalable_please_convince_me/)

> Hi there –
>
> I have many years of experience developing traditional, serverful web apps.
>
> About six months ago, I made the leap to serverless development (in Python, using AWS Lambda and related services).
>
> I see the advantages in terms of scalability. And scalability is obviously a valid concern.
>
> But everything _else_ about it feels like a huge step backward. There's _so_ much more overhead and complexity. It's _so_ much harder to introspect, follow the application flow, etc. The resource constraints of the Lambda runtime limit the way I can write my code. I have to think way too much about dependencies between different stacks and layers. And so on.
>
> Serverless evangelists always say "it frees you up from patching and maintaining servers!" – and that's true. But it just seems to replace that overhead with a bunch of _other_ grunt work.
>
> Clearly, a lot of people are confident that serverless is the way of the future. And I want to keep an open mind. But after six months, I still haven't seen anything that makes serverless _worth_ all of this.
>
> So:
>
> **Other than scalability,** what do you see as the advantages of the serverless paradigm (as compared to a traditional serverful app, using a framework such as Django, Rails, Laravel, etc.)?
>
> _Are_ there any advantages other than scalability? Or are we accepting all of these disadvantages as the price we have to pay to get that delicious autoscaling?
>
> This is a sincere question, so if you're inclined to downvote, please consider leaving a constructive answer instead. I would genuinely like to learn. Thank you.
>
> **ETA:** Thank you for all of the answers (and please keep them coming!)
>
> One thing is becoming clear:
>
> People are using Lambda (and other AWS services) in a lot of different ways. That makes sense – they're general-purpose tools, which can be used to solve a wide variety of different problems.
>
> But I'm coming from a very specific background. I'm not an "engineer" – I'm a "web developer". I build websites. 98% of what I'm concerned with is handling HTTP requests coming from a web browser.
>
> It sounds like many of you are dealing with rather different problems, which probably accounts for a lot of our confusion.
>
> Also, it sounds like many of you work for large organizations – which need to handle heavy traffic loads, and integrate between a lot of random systems. Again, this isn't really my situation.
>
> Until recently, I've spent most of my career working for web agencies. It works like this: Some company needs a website (or a "web app", if you want to be fancy about it). They hire our agency to build it. That site might be a custom ticketing system for internal use, or an e-learning system, or a portal for members of a professional organization, or a platform which helps a national youth sports league to coordinate games and track scores. It will probably integrate with other systems, to some extent – but at the end of the day, it's essentially just an HTTP-enabled CRUD GUI for a database. And maybe some simple cron jobs.
>
> There will probably be a built-in limit on the amount of traffic that it will ever need to handle. (There are only so many employees who need to use that ticketing system, and so many teams in that youth sports league.) The vast majority of the sites I've worked on fit comfortably on a single EC2 instance and a single RDS instance.
>
> I can see how the scalability of serverless would be vital for larger organizations, but that advantage is mostly theoretical to me. Scalability has simply never been a significant problem for any project that I've worked on. For the few sites which _have_ strained a single EC2 instance, we simply spin up two or three instances, and put them behind a load balancer. (And since I'm a developer – not DevOps – I'm happy to let someone _else_ set that up 🙂)
>
> As hard as it seems for many engineers to believe, there are still plenty of organizations out there whose problems are like this. They aren't trying to build the next viral app, or streaming media platform. They're just trying to use the web to help their stakeholders communicate and coordinate.
>
> I'm not writing off serverless – far from it. I intend to keep exploring it. But I _am_ starting to doubt the serverless evangelists who insist that any other architecture is hopelessly backward in 2022. Organizations have widely varying needs, and every architecture comes with tradeoffs.

[Lots of praise on reddit for lambda](https://www.reddit.com/r/aws/comments/lz1uim/what_regrets_have_you_had_writing_aws_serverless/)

> No regrets at all with serverless, it has been amazing. The ability to immediately stand up a test environment at next to no cost at all is incredible.

[Case study moving from serverless to monolith](https://news.ycombinator.com/item?id=30828528)

> I've worked on a major project that went all in on AWS Serverless and all AWS latest and greatest, What a pain the amount of CDK code 1:1 to application code, Number of pipelines and speed of deploy abysmal. Dev experience sucked. In a rare one to one comparison we had to reimplement a major subset of the project as a mostly monolithic app running in a single container. (On prem version). Was done by 4 people in 2 month. Orders of magnitude productivity boost.

## Containers on serverless

Your lambdas can be docker containers, and it doesn't incur any startup time penalty:

[From HN](https://news.ycombinator.com/item?id=25271256)
> Hi, I work in the AWS Serverless Team. Just to say, the performance of running a container image is pretty much the same as a function packaged as a zip function. We cache the container images near where the function runs so startup time isn't any worse than ZIP.

Docker images can be up to [10gb](https://aws.amazon.com/blogs/compute/working-with-lambda-layers-and-extensions-in-container-images)

## Number crunching

[AWS cost analysis comparing lambda, ec2, and fargate]()https://blogs.perficient.com/2021/06/17/aws-cost-analysis-comparing-lambda-ec2-fargate/

[Post comparing lambda to fargate and showing break-even point](https://nuvalence.io/insights/modeling-analyzing-lambda-vs-fargate-breakeven/)

> 1. **Lambda is nearly always cheaper at moderate scale, but more expensive at scale:** In most cases where you’re exposing APIs to the outside world, you’ll likely use Lambdas behind API Gateway or Fargate behind NLB. In these cases, Lambda is nearly always cheaper at low and mid monthly request volumes, but can be 2x to 2.5x as expensive at mid to high monthly request volumes when compared to Fargate. Have good estimates for monthly request volume.

## Performance tuning

[This](https://github.com/alexcasalboni/aws-lambda-power-tuning) is a service you can deploy to AWS for optimising the speed/cost of lambdas.

## Man-hours

You don't need to manually configure load balancers with lambda, but you typically do need to configure some kind of cloud dev environment.

There's also the fact that much of the web ecosystem revolves around long-running services, and lambda is fairly new so there's limited support for it. For example:
* How do you do a cron? If you're using long-running processes you can just use celery's periodic tasks or sidekiq's cron. But with lambda, you'll need to use AWS Scheduled Events which you cannot run locally.
* How do you export logs from a lambda for the sake of observability? I'm not clear on which is harder: setting up a datadog daemonset in k8s or creating a subscription filter on cloudwatch logs to route through to datadog.
* How do you get a framework that was intended to be a long-running service and deploy it to lambda? Python has zappa but who knows how good that is and what the implications are.

Okay, many of these things are actually perfectly doable: I suppose I'm just not experienced with any of them. I don't know how easily I can use Scheduled Events. I do know for certain I can't test it locally.

I also wonder, how hard is it to 'manage' these things if you've got a good pulumi config, and if you can use chatGPT to help you make that pulumi config? I feel like in terms of configuring things, it's not obvious lambda is any easier.

But it does rely on high-reliability services, so you'll never need to be paged at 2am to find that lambda has gone down.

## Background tasks

Looking online, it seems different people have different approaches for asynchronously invoking lambdas. Some approaches:
* Lambda async invoke
* SQS queue
* SNS queue
* SNS -> SQS

### Lambda async invoke

The lambda async invoke approach involves a queue that is internal to the lambda service. This is the simplest approach, because you don't need to create your own queue, but it has a couple of drawbacks:

From the [AWS docs](https://docs.aws.amazon.com/lambda/latest/dg/invocation-async.html):

> Even if your function doesn't return an error, it's possible for it to receive the same event from Lambda multiple times because the queue itself is eventually consistent. If the function can't keep up with incoming events, events might also be deleted from the queue without being sent to the function. Ensure that your function code gracefully handles duplicate events, and that you have enough concurrency available to handle all invocations.

So events could be randomly deleted and lost.

Apparently, the internal queue is also hard to get visibility on compared to your own SQS queue.

### SQS queue

This is what I would expect to be the default choice, given that an SQS queue is a literal queue system:

[Comparison to SNS](https://ably.com/topic/aws-sns-vs-sqs)

> 1. SNS supports A2A and A2P communication, while SQS supports only A2A communication.
>
> 2. SNS is a pub/sub system, while SQS is a queueing system. You'd typically use SNS to send the same message to multiple consumers via topics. In comparison, in most scenarios, each message in an SQS queue is processed by only one consumer.
>
> 3. With SQS, messages are delivered through a [long polling](https://ably.com/topic/long-polling) (pull) mechanism, while SNS uses a push mechanism to immediately deliver messages to subscribed endpoints.
>
> 4. SNS is typically used for applications that need realtime notifications, while SQS is more suited for message processing use cases.
>
> 5. SNS does not persist messages - it delivers them to subscribers that are present, and then deletes them. In comparison, SQS can persist messages (from 1 minute to 14 days).
>
> #### When to use AWS SNS
>
> You can use SNS for a variety of purposes, including:
>
> - Sending email, SMS, and push notifications to end-users in realtime. Note that you can send push notifications to Apple, Google, Fire OS, and Windows devices.
>
> - Broadcasting messages to multiple subscribers (for example, fanning out the same push notifications to all users of your app).
>
> - Workflow systems. For example, you can use SNS to pass events between distributed apps, or to update records in various business systems (e.g., inventory changes).
>
> - Realtime alerts and monitoring applications.
>
>
> [](https://ably.com/topic/aws-sns-vs-sqs#when-to-use-aws-sqs)
>
> #### When to use AWS SQS
>
> SQS is helpful for:
>
> - Asynchronous processing workflows.
>
> - Processing messages in parallel (by using multiple SQS queues).
>
> - Decoupling and scaling microservices, distributed systems, and serverless applications.
>
> - Sending, storing, and receiving events with reliable messaging guarantees (ordering & exactly-once processing).

It literally says 'Asynchronous processing workflows'! Yet, I'm seeing another article online titled [SNS to Lambda or SNS to SQS to Lambda, what are the trade-offs?](https://theburningmonk.com/2023/07/sns-to-lambda-or-sns-to-sqs-to-lambda-what-are-the-trade-offs)

Okay so in that article it's talking about a situation where you happen to start in SNS anyway:

> “I’m reacting to S3 events received via an SNS topic and debating the merits of having the Lambda triggered directly by the SNS or having an SQS queue. I can see the advantage of the queue for enhanced visibility into the processing and “buffering” events for the Lambda but is there a reason not to use a queue in this situation?”

Some interesting points here:

> It used to be that you’d always use SNS with SQS in case there was a problem with delivery to the target, so you don’t lose data. But now that SNS supports Dead-Letter Queues (DLQs) natively, you don’t need to do it for resilience anymore. There are still reasons to use SQS here, namely for cost efficiency and performance.
>
> The main consideration here is that SQS is a batched event source for Lambda so you can process the same number of messages with fewer invocations. If the processing logic is IO-heavy (e.g. waiting for API responses) then you can even process messages in parallel and make more efficient use of the CPU cycles. This often leads to better throughput and lower Lambda costs when processing a large number of messages.

So there are various points to consider:
* SQS supports batching messages sent to a worker which is great for IO-bound work
* SNS is push-based whereas SQS is pull-based and you will be charged for the polling of SQS by the lambda service (though apparently it's insanely cheap, like 3 bucks a year)

## Conclusion

Like I said at the start of this post, I ended up deciding against AWS lambda, opting for docker containers on ECS with fargate instead. The main considerations were:
1) Having an environment that I can run locally is very important to me for shortening the feedback loop and I just don't believe anybody who says that a remote dev env is preferable.
2) My app would be very much IO-bound, which is a bad fit for lambda
3) Cold starts would suck for users using my app in real-time
4) I fundamentally reject the idea of a microservices architecture unless your dev team is so big that it's impossible to have everybody coordinate on a single monolith, and my dev team is small and will remain small for a while. Independently deployed lambdas are basically microservices.
5) The technology is too new and most frameworks/libraries for producing web applications are associated with monolithic frameworks like django, rails, .NET, etc. Perhaps one day this lambda stuff will be so far along that it will enjoy the same ecosystem of tooling but for now it's just too bleeding edge.
