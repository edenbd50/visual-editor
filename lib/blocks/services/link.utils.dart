import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../documents/models/nodes/node.model.dart';
import '../../documents/models/attributes/attributes.model.dart';

TextRange getLinkRange(NodeM node) {
  var start = node.documentOffset;
  var length = node.length;
  var prev = node.previous;
  final linkAttr = node.style.attributes[AttributesM.link.key]!;

  while (prev != null) {
    if (prev.style.attributes[AttributesM.link.key] == linkAttr) {
      start = prev.documentOffset;
      length += prev.length;
      prev = prev.previous;
    } else {
      break;
    }
  }

  var next = node.next;

  while (next != null) {
    if (next.style.attributes[AttributesM.link.key] == linkAttr) {
      length += next.length;
      next = next.next;
    } else {
      break;
    }
  }

  return TextRange(start: start, end: start + length);
}


TextRange getTagRange(NodeM node) {
  var start = node.documentOffset;
  var length = node.length;
  var prev = node.previous;
  final tagAttr = node.style.attributes[AttributesM.tag.key]!;

  while (prev != null) {
    if (prev.style.attributes[AttributesM.tag.key] == tagAttr) {
      start = prev.documentOffset;
      length += prev.length;
      prev = prev.previous;
    } else {
      break;
    }
  }

  var next = node.next;

  while (next != null) {
    if (next.style.attributes[AttributesM.tag.key] == tagAttr) {
      length += next.length;
      next = next.next;
    } else {
      break;
    }
  }

  return TextRange(start: start, end: start + length);
}
