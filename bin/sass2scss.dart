import 'dart:convert';
import 'dart:io';
import 'package:sass_tools/sass2scss.dart';

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
  var inputString = readInputSync(Utf8Codec());
  if (inputString != null) stdout.write(sass2scss(inputString));
}
