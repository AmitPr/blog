import 'package:blog_gen/src/config.dart';
import 'dart:io';

import 'package:blog_gen/src/post.dart';

void prepareOutputDirectory(CONFIG config) {
  var outputDirectory = Directory(config.outputDirectory);
  if (outputDirectory.existsSync()) {
    outputDirectory.deleteSync(recursive: true);
  }
  outputDirectory.createSync();
}

List<Post> processPosts(CONFIG config) {
  var contentDirectory = Directory(config.contentDirectory);
  var posts = <Post>[];
  for (var entity in contentDirectory.listSync(recursive: true)) {
    if (!config.ignoredFiles.contains(entity.uri.pathSegments.last)) {
      if (entity is File && entity.uri.pathSegments.last.endsWith('.md')) {
        var path = Uri(
          pathSegments: entity.uri.pathSegments.sublist(
            1,
            entity.uri.pathSegments.length - 1,
          ),
        ).toFilePath();

        var post = Post(
          entity.readAsStringSync(),
          path,
        );
        posts.add(post);
      } else if (entity is File) {
        var path = Uri(
          pathSegments: [
            config.outputDirectory,
            ...entity.uri.pathSegments.sublist(1)
          ],
        ).toFilePath();
        File(path).createSync(recursive: true);
        entity.copySync(path);
      }
    }
  }
  posts.forEach(
    (p) {
      var output = File(
          Uri(pathSegments: [config.outputDirectory, p.path, 'index.html'])
              .toFilePath());
      output.createSync(recursive: true);
      output.writeAsStringSync(
        config.jinjaEnv.getTemplate('post_template.html').render(
              CONFIG: config.config,
              post: p.attributes,
            ),
      );
    },
  );
  return posts;
}

void generateIndex(config, posts) {
  var indexOutput =
      File(config.outputDirectory + Platform.pathSeparator + 'index.html');
  indexOutput.createSync(recursive: true);
  indexOutput.writeAsStringSync(
    config.jinjaEnv.getTemplate('index_template.html').render(
          CONFIG: config.config,
          posts: posts.map((p) => p.attributes),
        ),
  );
}
