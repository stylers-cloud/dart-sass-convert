import 'package:sass_api/sass_api.dart' as sass_api;

String sass2scss(String sassInput) {
  var visitor = Visitor();
  var stylesheet = sass_api.Stylesheet.parseSass(sassInput);
  stylesheet.accept(visitor);
  return visitor.output;
}

class Visitor implements sass_api.RecursiveAstVisitor {
  String output = '';
  int indentation = 0;

  String indent(String value) {
    return (('  ' * indentation) + value);
  }

  void writeL(String value) {
    output += indent(value);
  }

  void nextBlockChildren(List<sass_api.Statement>? children,
      [bool addNewline = true]) {
    if (children != null) {
      output += " {\n";
      indentation += 1;
      visitChildren(children);
      indentation -= 1;
      writeL("}");
    }
    if (addNewline) output += "\n";
  }

  void nextBlock(sass_api.ParentStatement node, [bool addNewline = true]) {
    var children = node.children;
    nextBlockChildren(children, addNewline);
  }

  @override
  void visitAtRootRule(sass_api.AtRootRule node) {
    writeL("@at-root(${node.query})");
    nextBlock(node);
  }

  @override
  void visitAtRule(sass_api.AtRule node) {
    writeL("@${node.name} ${node.value}");
    nextBlock(node);
  }

  @override
  void visitCallableDeclaration(sass_api.CallableDeclaration node) {
    writeL("${node.name}(${node.arguments})");
    nextBlock(node, false);
  }

  @override
  void visitChildren(List<sass_api.Statement> children) {
    for (var child in children) {
      child.accept(this);
    }
  }

  @override
  void visitContentBlock(sass_api.ContentBlock node) {
    if (node.arguments.arguments.isNotEmpty) {
      output += " using (${node.arguments.arguments})";
    }
    nextBlock(node);
  }

  @override
  void visitContentRule(sass_api.ContentRule node) {
    writeL("@content");
    visitArgumentInvocation(node.arguments);
    output += "\n";
  }

  @override
  void visitDebugRule(sass_api.DebugRule node) {
    writeL("@debug ");
    node.expression.accept(this);
  }

  @override
  void visitDeclaration(sass_api.Declaration node) {
    writeL("${node.name}: ");
    node.value?.accept(this);
    output += ";\n";
    nextBlock(node, false);
  }

  @override
  void visitEachRule(sass_api.EachRule node) {
    writeL("@each ${node.variables} in ");
    node.list.accept(this);
    nextBlock(node);
  }

  @override
  void visitErrorRule(sass_api.ErrorRule node) {
    writeL("@error ");
    node.expression.accept(this);
  }

  @override
  void visitExtendRule(sass_api.ExtendRule node) {
    writeL("@extend ${node.selector}");
  }

  @override
  void visitForRule(sass_api.ForRule node) {
    writeL("@for ${node.variable} from ");
    node.from.accept(this);
    output += node.isExclusive ? "to" : "through";
    node.to.accept(this);
    nextBlock(node);
  }

  @override
  void visitForwardRule(sass_api.ForwardRule node) {
    writeL("@forward ${node.url}");
  }

  @override
  void visitFunctionRule(sass_api.FunctionRule node) {
    writeL("@function ${node.name}(");
    output += node.arguments.arguments
        .map((e) =>
            "\$${e.name}${e.defaultValue != null ? ": ${e.defaultValue}" : ""}")
        .join(", ");
    output += ")";
    nextBlock(node, false);
    if (node.children.isEmpty) output += ";\n";
  }

  @override
  void visitIfRule(sass_api.IfRule node) {
    for (var clause in node.clauses) {
      if (clause == node.clauses.first) {
        writeL("@if ${clause.expression}");
      } else {
        writeL("@else if ${clause.expression}");
      }
      nextBlockChildren(clause.children);
    }
    if (node.lastClause != null) {
      writeL("@else ${node.lastClause}");
      nextBlockChildren(node.lastClause?.children);
    }
  }

  @override
  void visitImportRule(sass_api.ImportRule node) {
    writeL("@import ${node.imports.map((e) => e.span.text).join(', ')};\n");
  }

  @override
  void visitIncludeRule(sass_api.IncludeRule node) {
    writeL(
        "@include ${node.name}(${node.arguments.positional.join(", ")}${node.arguments.named.entries.map((e) => "${e.key}: ${e.value}").join(", ")})");
    if (node.content != null) {
      node.content?.accept(this);
    } else {
      writeL(";\n");
    }
  }

  @override
  void visitLoudComment(sass_api.LoudComment node) {
    writeL("${node.text}");
  }

  @override
  void visitMediaRule(sass_api.MediaRule node) {
    writeL("@media ${node.query}\n");
    nextBlock(node);
  }

  @override
  void visitMixinRule(sass_api.MixinRule node) {
    writeL(
        "@mixin ${node.name}(${node.arguments.arguments.map((e) => "\$" + e.name + (e.defaultValue != null ? ": ${e.defaultValue}" : "")).join(", ")})");
    nextBlock(node);
  }

  @override
  void visitReturnRule(sass_api.ReturnRule node) {
    writeL("@return ${node.expression}");
  }

  @override
  void visitSilentComment(sass_api.SilentComment node) {
    writeL(node.text);
  }

  @override
  void visitStyleRule(sass_api.StyleRule node) {
    writeL(node.selector.toString().trim());
    nextBlock(node);
  }

  @override
  void visitStylesheet(sass_api.Stylesheet node) {
    for (var child in node.children) {
      child.accept(this);
    }
  }

  @override
  void visitSupportsRule(sass_api.SupportsRule node) {
    writeL("@supports ${node.condition}");
    nextBlock(node);
  }

  @override
  void visitUseRule(sass_api.UseRule node) {
    var ns = node.namespace;
    writeL("@use ${node.url} ${ns != null ? ("as " + ns) : ""}");
  }

  @override
  void visitVariableDeclaration(sass_api.VariableDeclaration node) {
    writeL("\$${node.name}: ");
    node.expression.accept(this);
    output += ";\n";
  }

  @override
  void visitWarnRule(sass_api.WarnRule node) {
    writeL("@warn ");
    node.expression.accept(this);
  }

  @override
  void visitWhileRule(sass_api.WhileRule node) {
    writeL("@while ");
    node.condition.accept(this);
    nextBlock(node);
  }

  @override
  void visitArgumentInvocation(sass_api.ArgumentInvocation invocation) {
    output += (invocation.toString());
    // for (var element in invocation.positional) {
    //   element.accept(this);
    // }
  }

  @override
  void visitBinaryOperationExpression(sass_api.BinaryOperationExpression node) {
    node.left.accept(this);
    output += " ${node.operator.operator} ";
    node.right.accept(this);
  }

  @override
  void visitBooleanExpression(sass_api.BooleanExpression node) {
    output += node.value.toString();
  }

  @override
  void visitCalculationExpression(sass_api.CalculationExpression node) {
    output += "${node.name}(";
    for (var element in node.arguments) {
      element.accept(this);
    }
    output += ")";
  }

  @override
  void visitColorExpression(sass_api.ColorExpression node) {
    output += node.value.toString();
  }

  @override
  void visitExpression(sass_api.Expression expression) {
    output += expression.toString();
  }

  @override
  void visitFunctionExpression(sass_api.FunctionExpression node) {
    output += node.originalName;
    visitArgumentInvocation(node.arguments);
  }

  @override
  void visitIfExpression(sass_api.IfExpression node) {
    output += node.toString();
    visitArgumentInvocation(node.arguments);
  }

  @override
  void visitInterpolatedFunctionExpression(
      sass_api.InterpolatedFunctionExpression node) {
    output += node.name.contents.toString();
    visitArgumentInvocation(node.arguments);
  }

  @override
  void visitInterpolation(sass_api.Interpolation interpolation) {
    output += interpolation.asPlain!;
  }

  @override
  void visitListExpression(sass_api.ListExpression node) {
    if (node.hasBrackets) output += "[";
    for (var element in node.contents) {
      element.accept(this);
      if (element != node.contents.last) {
        output += node.separator.separator ?? "";
      }
    }

    if (node.hasBrackets) output += "]";
  }

  @override
  void visitMapExpression(sass_api.MapExpression node) {
    output += "(";
    for (var element in node.pairs) {
      element.item1.accept(this);
      output += ": ";
      element.item2.accept(this);
      if (element != node.pairs.last) output += ", ";
    }
    output += ")";
  }

  @override
  void visitNullExpression(sass_api.NullExpression node) {}

  @override
  void visitNumberExpression(sass_api.NumberExpression node) {
    output += "${node.value}${node.unit ?? ''}";
  }

  @override
  void visitParenthesizedExpression(sass_api.ParenthesizedExpression node) {
    output += "(";
    node.expression.accept(this);
    output += ")";
  }

  @override
  void visitSelectorExpression(sass_api.SelectorExpression node) {
    output += node.toString() + "selector";
  }

  @override
  void visitStringExpression(sass_api.StringExpression node) {
    if (node.hasQuotes) {
      output += "\"${node.text}\"";
    } else {
      output += node.text.toString();
    }
  }

  @override
  void visitSupportsCondition(sass_api.SupportsCondition condition) {
    output += condition.toString();
  }

  @override
  void visitUnaryOperationExpression(sass_api.UnaryOperationExpression node) {
    output += node.operator.operator;
    node.operand.accept(this);
  }

  @override
  void visitValueExpression(sass_api.ValueExpression node) {
    output += node.value.toString();
  }

  @override
  void visitVariableExpression(sass_api.VariableExpression node) {
    output += "\$${node.name}";
  }
}
