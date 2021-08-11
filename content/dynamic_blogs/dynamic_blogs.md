
title: Creating "Dynamic" Blogs using Dart and Github Actions
description: Using free tools like Github Actions and Pages, alongside Dart executables to create low-maintainance, dynamic blogs, like this one!
createdAt: 2021-08-08
tags: Web, Dart

---
Subscription-based services are already everywhere, and monthly costs can start to add up. I didn't want to excacerbate the issue by adding monthly infrastructure costs for a blog and simple website I wanted to create. That's why I sought out a way to create dynamic sites, or at least, sites that could appear to be dynamic, using free services alone.

## In Search of "Dynamic Static Sites"
Many static file hosting platforms exist. They serve files out of a directory for no cost. However, since the files they serve are simple HTML/CSS/JS files, it's not possible to host pages that contain dynamic content. For example, the home page of this very blog is a dynamic page, showing posts as they come in, while the posts themselves are static pages. Coming to save the day was [Github Actions](https://github.com/features/actions).

Github Actions is a service that allows you to run a set of actions on your repositories. These actions can be anything from running a bash script, to building, testing, and deploying your code. Running actions that act like static site generators, and then hosting the generated files in a `gh-pages` branch, is a great way dynamically update content whenever events like commits trigger an actions workflow. In fact, this method has further advantages, being able to refresh the site content at intervals as short as [5 minutes](https://docs.github.com/en/actions/reference/events-that-trigger-workflows#scheduled-events).  

## Dart in Github Actions
For those unaware, [Dart](https://www.dart.dev/) is a programming language created by Google. It's mainly used in tandem with [Flutter](https://flutter.dev/), a framework for building mobile apps. However, the simplicity of Dart makes it a great language for simple command line tools, such as the static site generator that this blog uses. 