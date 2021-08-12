
title: A Usability Test for Dart: Static Site Generation.
description: Critiquing Dart when applying it to create low-maintainance, dynamic blogs, like this one, using Github Actions and Pages.
createdAt: 2021-08-10
tags: Dart, Web

---
Subscription-based services are already everywhere, and monthly costs can start to add up. I didn't want to exacerbate the issue by adding monthly infrastructure costs for simple websites, such as this blog, to the mix. That's when I started to seek a way to create dynamic sites, or at least, sites that could appear to be dynamic, using free services alone.

## In Search of "Dynamic Static Sites"
Many static file hosting platforms exist. They serve files out of a directory for no cost. However, since the files they serve are simple HTML/CSS/JS files, it's not possible to host pages that contain dynamic content. For example, the home page of this blog is somewhat dynamic, showing recent posts as they come in. On the other hand, posts themselves are static pages, not changing once they're published. To enable the creation of dynamic site generation, I turned to something that had been sitting right in front of me the whole time: [Github Actions](https://github.com/features/actions).  

Github Actions is a service that allows you to run a set of actions on your repositories. These actions can be anything from running a bash script to building, testing, and deploying your code. Taking Actions and then using it to run a static site generator is ideal for this project. Options for static site generators already exist namely Jekyll and Hugo. However, wanting to explore [Dart's](https://www.dart.dev/) usability in CLI applications, I decided to write a custom static site generator. Finally, once generated files are generated in an output directory, it's possible to push that directory alone to a `gh-pages` branch for hosting. This method has further advantages, being able to refresh the site content at intervals as short as [5 minutes](https://docs.github.com/en/actions/reference/events-that-trigger-workflows#scheduled-events).  

## Dart in Github Actions
For those unaware, [Dart](https://www.dart.dev/) is a programming language created by Google. It's mainly used in tandem with [Flutter](https://flutter.dev/), a framework for building mobile apps. However, the simplicity of Dart suggests itself towards being a great scripting language for command-line applications. Getting dart set up and running on Github Actions machines was as easy as deploying a compiled binary to a machine of the same architecture that the binary was compiled on. No dependencies are required. However, in the end, I opted towards using the Dart SDK Action, as the real speedup wasn't worth the hassle of the compilation step (At least in this case).  

Developing the [generator for this site](https://github.com/AmitPr/blog_gen) was a great learning experience, however, I can't say I'm a fan of the way that various aspects of this project work in Dart. Firstly is the mess that is the file path system in the built-in implementation. Dart's `FileSystemEntity` objects are notoriously annoying to work with, and instead one has to resort to using [package:path](https://pub.dev/packages/path). `package:path` *does* clean up many of the problems, but makes one beg to ask why the core SDK doesn't contain such an API for ease of use and more seamless functionality.
### File names aren't directly accessible
```dart
//Without package:path
var fileName = fileObject.uri.pathSegments.last;
//With package:path
var fileName = path.basename(fileObject.path)
```
### There isn't any way to easily create a path from two segments.
```dart
//Without package:path
//Fails when config.outputDirectory is a multi-segmented path.
var targetPath = Uri(
    pathSegments: [
        config.outputDirectory,
        ...entity.uri.pathSegments.sublist(1),
    ],
);
//With package:path
var p = path.Context(current: contentDirectory.absolute.path); //Set and used earlier
var targetPath = path.join(config.outputDirectory, p.relative(fileObject.absolute.path));
```
Still not nearly as pretty as I would like, but a huge improvement, especially considering it doesn't fail in non-trivial cases. The point is that in my (fairly limited) experience, the built-in API is lacking in many ways. Take this with a grain of salt, I'm not a Dart expert, but as far as I can see, there isn't a much better way of going about things without relying on a non-core library.  

The other *major* issue is the [lack of support for cross-compilation](https://github.com/dart-lang/sdk/issues/28617) in the SDK. This means that if you want to run the compiler on a machine with a different architecture (or operating system) than the one you're targeting, the compiled binary won't be able to be run on the target machine. For more information, check out the linked Github issue.  

Other more minor problems include limited documentation and support in the [markdown](https://pub.dev/packages/markdown) and [jinja](https://pub.dev/packages/jinja) packages, but none of this hindered the quality and ease of use of the generator.  


Reflecting on my thoughts, I'm not sure whether I would choose to create a static site generator in Dart if I were to start over. I'm going to stick with using and building upon the [base that I have right now](https://github.com/AmitPr/blog_gen), and I'm excited to see how Dart improves in the future.  
  
