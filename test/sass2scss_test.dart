import 'package:sass_api/sass_api.dart';
import 'package:dart_sass_convert/sass2scss.dart';
import 'package:test/test.dart';
import 'dart:io';
import 'package:sass/sass.dart' as sass;

void main() {
  var sassInput = File('./test/input/assets.sass').readAsStringSync();

  test('sass2scss results in same compressed css', () {
    var scssOutput = sass2scss(sassInput);
    var cssFromSass = sass
        .compileStringToResult(sassInput,
            syntax: Syntax.sass, style: OutputStyle.compressed)
        .css;
    var cssFromScss = sass
        .compileStringToResult(scssOutput,
            syntax: Syntax.scss, style: OutputStyle.compressed)
        .css;
    expect(cssFromScss, equals(cssFromSass));
  });

  test('sass2scss results in same expanded css', () {
    var scssOutput = sass2scss(sassInput);
    var cssFromSass = sass
        .compileStringToResult(sassInput,
            syntax: Syntax.sass, style: OutputStyle.expanded)
        .css;
    var cssFromScss = sass
        .compileStringToResult(scssOutput,
            syntax: Syntax.scss, style: OutputStyle.expanded)
        .css;
    expect(cssFromScss, equalsIgnoringWhitespace(cssFromSass));
  });
}
