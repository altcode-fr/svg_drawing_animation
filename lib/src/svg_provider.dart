import 'dart:io';

import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Provides SVG. Several constructors are provided for the various ways that
/// SVG can be obtained:
/// * [SvgProvider.string], for obtaining SVG from a [String].
/// * [SvgProvider.network], for obtaining SVG from a URL.
/// * [SvgProvider.file], for obtaining SVG from a [File].
/// * [SvgProvider.asset], for obtaining SVG from an [AssetBundle] using a key.
/// * [SvgProvider.future], for obtaining SVG from a [Future].
class SvgProvider {
  SvgProvider._(this.svg);

  final Future<PictureInfo> svg;

  Future<PictureInfo> resolve() => svg;

  // Network cache.
  static final Map<String, SvgProvider> _urlToProvider = {};

  /// Obtains SVG from a [Future].
  factory SvgProvider.future(Future<PictureInfo> svg) {
    return SvgProvider._(svg);
  }

  /// Obtains SVG from a [String].
  factory SvgProvider.string(String svgString) {
    return SvgProvider._(vg.loadPicture(SvgStringLoader(svgString), null));
  }

  /// Obtains SVG from a URL. Requests are cached.
  factory SvgProvider.network(String src, [Client? client]) {
    _urlToProvider.putIfAbsent(
        src,
        () => SvgProvider._(Future(() async {
              final response = await (client ?? Client()).get(Uri.parse(src));
              if (response.statusCode != 200) {
                return Future.error(
                    [if (response.reasonPhrase != null) response.reasonPhrase, response.body].join(': '));
              }
              return vg.loadPicture(SvgStringLoader(response.body), null);
            })));
    return _urlToProvider[src]!;
  }

  /// Obtains SVG from a [File].
  factory SvgProvider.file(File file) {
    return SvgProvider._(Future(() async {
      // For some reason, unit tests freeze if I use `await file.readAsString()`.
      final str = file.readAsStringSync();
      return vg.loadPicture(SvgStringLoader(str), null);
    }));
  }

  /// Obtains SVG from an [AssetBundle] using a key.
  factory SvgProvider.asset(String name) {
    return SvgProvider._(Future(() async => vg.loadPicture(SvgStringLoader(await rootBundle.loadString(name)), null)));
  }
}
