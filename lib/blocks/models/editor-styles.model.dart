import 'package:flutter/material.dart';

import 'inline-code-style.model.dart';
import 'list-block-style.model.dart';
import 'text-block-style.model.dart';

class EditorStylesM {
  final TextBlockStyleM? h1;
  final TextBlockStyleM? h2;
  final TextBlockStyleM? h3;
  final TextBlockStyleM? paragraph;
  final TextStyle? bold;
  final TextStyle? italic;
  final TextStyle? small;
  final TextStyle? underline;
  final TextStyle? strikeThrough;
  final InlineCodeStyle? inlineCode;
  final TextStyle? sizeSmall;
  final TextStyle? sizeLarge;
  final TextStyle? sizeHuge;
  final TextStyle? link;
  final TextStyle? tag;
  final Color? color;
  final TextBlockStyleM? placeHolder;
  final ListBlockStyle? lists;
  final TextBlockStyleM? quote;
  final TextBlockStyleM? code;
  final TextBlockStyleM? indent;
  final TextBlockStyleM? align;
  final TextBlockStyleM? leading;

  EditorStylesM({
    this.h1,
    this.h2,
    this.h3,
    this.paragraph,
    this.bold,
    this.italic,
    this.small,
    this.underline,
    this.strikeThrough,
    this.inlineCode,
    this.link,
    this.tag,
    this.color,
    this.placeHolder,
    this.lists,
    this.quote,
    this.code,
    this.indent,
    this.align,
    this.leading,
    this.sizeSmall,
    this.sizeLarge,
    this.sizeHuge,
  });

  EditorStylesM merge(EditorStylesM other) => EditorStylesM(
        h1: other.h1 ?? h1,
        h2: other.h2 ?? h2,
        h3: other.h3 ?? h3,
        paragraph: other.paragraph ?? paragraph,
        bold: other.bold ?? bold,
        italic: other.italic ?? italic,
        small: other.small ?? small,
        underline: other.underline ?? underline,
        strikeThrough: other.strikeThrough ?? strikeThrough,
        inlineCode: other.inlineCode ?? inlineCode,
        link: other.link ?? link,
        tag: other.tag ?? tag,
        color: other.color ?? color,
        placeHolder: other.placeHolder ?? placeHolder,
        lists: other.lists ?? lists,
        quote: other.quote ?? quote,
        code: other.code ?? code,
        indent: other.indent ?? indent,
        align: other.align ?? align,
        leading: other.leading ?? leading,
        sizeSmall: other.sizeSmall ?? sizeSmall,
        sizeLarge: other.sizeLarge ?? sizeLarge,
        sizeHuge: other.sizeHuge ?? sizeHuge,
      );
}
