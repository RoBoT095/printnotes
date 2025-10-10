import 'package:printnotes/oss_licenses.dart';

class Library {
  final String name;
  final String publisher;
  final String url;
  final String license;

  Library(
      {required this.name,
      required this.publisher,
      required this.url,
      required this.license});
}

final List<Library> libraries = dependencies.map((lib) {
  return Library(
      name: lib.name,
      publisher: getPublisher(lib),
      url: lib.repository ?? lib.homepage ?? '',
      license: getLicense(lib));
}).toList();

String getPublisher(Package lib) {
  String publisher = '...';
  if (lib.authors.isNotEmpty) {
    publisher = lib.authors.join(', ');
  } else if (lib.homepage != null) {
    if (lib.homepage?.contains('flutter.dev') ?? false) publisher = 'flutter';

    if (lib.homepage?.contains('github.com') ?? false) {
      Uri? uri = Uri.tryParse(lib.homepage!);
      if (uri != null) publisher = uri.pathSegments.first;
    }
  } else if (lib.repository != null) {
    Uri? uri = Uri.tryParse(lib.repository!);
    if (uri != null) publisher = uri.pathSegments.first;
  }
  return publisher;
}

String getLicense(Package lib) {
  if (lib.spdxIdentifiers.isNotEmpty) {
    return lib.spdxIdentifiers.join(', ');
  } else {
    return 'Check library for license';
  }
}
