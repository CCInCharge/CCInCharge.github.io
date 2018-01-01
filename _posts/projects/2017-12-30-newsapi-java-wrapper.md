---
layout: post
title: "NewsApi Java Wrapper"
status: "Deployed"
excerpt: "A Java wrapper for NewsApi, a RESTful API"
categories: projects
tags: [Java, Travis, API, wrapper, Maven]
author: charles_chen
comments: true
share: true
modified: 2017-12-30 15:13:32 -0800
#image:
#  feature: 
#  credit: 
#  creditlink: 
---

[[Maven Central]](https://mvnrepository.com/artifact/io.github.ccincharge/newsapi) [[Source Code]](https://github.com/CCInCharge/NewsApi-Java-Wrapper)

Technologies: Java (Source Code), Travis (CI), Maven (packaging and deployment)

[NewsApi Java Wrapper](https://github.com/CCInCharge/NewsApi-Java-Wrapper) is a Java wrapper that wraps around the [NewsApi](https://newsapi.org/), a very useful REST API that allows you to search for news articles given certain search criteria.

#### Inspiration:
I was working on learning some tools that are useful in the data engineering space. Namely, I was trying to learn a bit more about Kafka, and needed some data to stream. Upon the way, I came across the NewsApi.

While API wrappers out there are very common, I realized there wasn't a Java wrapper for the NewsApi. I also wasn't very familiar with Java yet, having never done anything too substantial with it. As many of you can attest to, writing the source code for a projec is very different from deployment - deployment is often its own very large beast.

I wanted to learn a little bit more about Java, as well as deployment in general, so I made it a goal to write this wrapper in Java, and deploy it to Maven Central, a repository that is commonly used by Java developers to resolve external dependencies. I wanted to implement good OSS fundamentals, software engineering fundamentals. Additionally, I wanted to implement CI (Continuous Integration), even though I haven't used CI tools before. As a result, I ended up creating extensive documentation for this code (written in Javadoc), writing multiple unit tests and integration tests (using JUnit), and implemented Travis CI to run the build, run the tests, and track code coverage for every master commit. It was very fun to learn this all along the way!

#### Travis CI:
CI tools can help make sure that none of your commits break your build by running all included unit tests and attempting to compile your source code on every commit. They can do much more, as well, including automatic deployment of your project. It's a great way to have everything ready to go from a simple `git push`.

![Screenshot of Travis CI log]({{ "/images/Travis_CI_Log.png" | absolute_url }})

As you can see in the above screenshot, Travis has just successfully compiled and run tests for the latest build.

#### Code Coverage:
There are so many possibilities for tasks that you can run once you integrate Travis. One possibility is running a code coverage tool, if you have unit tests written. [Codecov](https://codecov.io/gh) is a tool that you can use to visualize the code coverage of your source code, and it automatically integrates with Travis.

![Sunburst from Codecov]({{ "/images/codecov_sunburst.png" | absolute_url }})

It provides a couple views - a sunburst view (above), as well as more detailed, line-by-line details of which code is covered by the tests:

![Line by line coverage from Codecov]({{ "/images/codecov_lines.png" | absolute_url }})

Pretty cool stuff!

#### In Conclusion:
I definitely learned a lot more about Java from working on this wrapper. In general, just picking up and learning Java is a great way to really solidfy your OOP skills.

Additionally, I learned quite a bit about some of the concepts and tools used in DevOps. Deployment is not an easy task, and trying to get my jar up on Maven Central was a big reminder of that. Additionally, tools like Travis are very useful (and cool!). It was amazing how easy it was to set up my .travis.yml configuration file, and go off to the races. I think that it's quite fair to claim that there is little reason not to use Travis (or other CI tools) for almost all of your repositories - it's quite easy to set up.
