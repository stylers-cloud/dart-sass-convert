import 'dart:io';
import 'package:dart_sass_convert/sass2scss.dart';

void main(List<String> arguments) {
  var inputString = File('./test/input/assets.sass').readAsStringSync();
  stdout.write(sass2scss(inputString));
}
