import 'dart:convert';
import 'dart:io';
import 'package:sass_tools/sass2scss.dart';

void test() {
  var sassInput = File('./test/input/brackets.sass').readAsStringSync();

//   var sassInput = '''
// \$font-stack: Helvetica, sans-serif
// \$primary-color: #333

// body
//   font: 100% \$font-stack
//   color: \$primary-color
// ''';

  // print(sassInput);
  // print("----------");
  print(sass2scss(sassInput));

  // print('---------');
  // print(sass
  //     .compileStringToResult(
  //       sassInput,
  //       syntax: sass.Syntax.sass,
  //     )
  //     .css);
}

String? readInputSync(Encoding encoding) {
  final List<int> input = [];
  while (true) {
    int byte = stdin.readByteSync();
    if (byte < 0) {
      if (input.isEmpty) return null;
      break;
    }
    input.add(byte);
  }
  return encoding.decode(input);
}

void main(List<String> arguments) {
  var a = readInputSync(Utf8Codec());
  if (a != null) stdout.write(sass2scss(a));
  // stdin.echoMode = false;
  // stdin.lineMode = false;
  // var subscription;
  // subscription = stdin.listen((List<int> data) {
  //   if (data.contains(4)) {
  //     // Ctrl+D
  //     stdin.echoMode = true;
  //     stdin.lineMode = true;
  //     subscription.cancel();
  //   } else {
  //     // Translate character codes into a string.
  //     var s = utf8.decode(data);

  //     // Capitalise the input and write it back to the screen.
  //     stdout.write(sass2scss(s));
  //   }
  // });
}
