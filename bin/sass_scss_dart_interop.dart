@JS()
library callable_function;

import 'dart:io';

import 'package:js/js.dart';
import 'package:sass_scss_dart/sass2scss.dart';
import 'package:sass/sass.dart' as sass;

void test() {
  var sassInput = File('./test/input/brackets.sass').readAsStringSync();

//   var sassInput = '''
// \$font-stack: Helvetica, sans-serif
// \$primary-color: #333

// body
//   font: 100% \$font-stack
//   color: \$primary-color
// ''';

  print(sassInput);
  print("----------");
  print(sass2scss(sassInput));

  print('---------');
  print(sass
      .compileStringToResult(
        sassInput,
        syntax: sass.Syntax.sass,
      )
      .css);
}

/// Allows assigning a function to be callable from `window.functionName()`
@JS('dartSass2scss')
external set _dartSass2scss(String Function(String sassInput) f);

/// Allows calling the assigned function from Dart as well.
@JS()
external String dartSass2scss(String sassInput);

void main(List<String> arguments) {
  _dartSass2scss = allowInterop(sass2scss);
  test();
}
