import 'package:sass_scss_dart/sass2scss.dart';

void main() {
  var sassInput = '''
\$font-stack: Helvetica, sans-serif
\$primary-color: #333

body
  font: 100% \$font-stack
  color: \$primary-color
''';

  print(sass2scss(sassInput));
}
