import 'package:flutter/material.dart';

import '../../../rules/controllers/insert/auto-format-multiple-links.rule.dart';
import '../../../shared/models/editor-dialog-theme.model.dart';
import '../../../shared/translations/toolbar.i18n.dart';

class LinkDialog extends StatefulWidget {
  final EditorDialogThemeM? dialogTheme;
  final String? link;

  const LinkDialog({
    this.dialogTheme,
    this.link,
    Key? key,
  }) : super(key: key);

  @override
  LinkDialogState createState() => LinkDialogState();
}

class LinkDialogState extends State<LinkDialog> {
  late String _link;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _link = widget.link ?? '';
    _controller = TextEditingController(
      text: _link,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: widget.dialogTheme?.dialogBackgroundColor,
      content: TextField(
        keyboardType: TextInputType.multiline,
        maxLines: null,
        style: widget.dialogTheme?.inputTextStyle,
        decoration: InputDecoration(
          labelText: 'Paste a link'.i18n,
          labelStyle: widget.dialogTheme?.labelTextStyle,
          floatingLabelStyle: widget.dialogTheme?.labelTextStyle,
        ),
        autofocus: true,
        onChanged: _linkChanged,
        controller: _controller,
      ),
      actions: [
        TextButton(
          onPressed: _link.isNotEmpty &&
                  AutoFormatMultipleLinksRule.linkRegExp.hasMatch(_link)
              ? _applyLink
              : null,
          child: Text(
            'Ok'.i18n,
            style: widget.dialogTheme?.labelTextStyle,
          ),
        ),
      ],
    );
  }

  void _linkChanged(String value) {
    setState(() {
      _link = value;
    });
  }

  void _applyLink() {
    Navigator.pop(context, _link.trim());
  }
}

class TagDialog extends StatefulWidget {
  final EditorDialogThemeM? dialogTheme;
  final String? tag;

  const TagDialog({
    this.dialogTheme,
    this.tag,
    Key? key,
  }) : super(key: key);

  @override
  TagDialogState createState() => TagDialogState();
}

class TagDialogState extends State<TagDialog> {
  late String _tag;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _tag = widget.tag ?? '';
    _controller = TextEditingController(
      text: _tag,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: widget.dialogTheme?.dialogBackgroundColor,
      content: TextField(
        keyboardType: TextInputType.multiline,
        maxLines: null,
        style: widget.dialogTheme?.inputTextStyle,
        decoration: InputDecoration(
          labelText: 'Paste a tag'.i18n,
          labelStyle: widget.dialogTheme?.labelTextStyle,
          floatingLabelStyle: widget.dialogTheme?.labelTextStyle,
        ),
        autofocus: true,
        onChanged: _tagChanged,
        controller: _controller,
      ),
      actions: [
        TextButton(
          onPressed: _tag.isNotEmpty &&
              AutoFormatMultipleTagRule.tagRegExp.hasMatch(_tag)
              ? _applyTag
              : null,
          child: Text(
            'Ok'.i18n,
            style: widget.dialogTheme?.labelTextStyle,
          ),
        ),
      ],
    );
  }

  void _tagChanged(String value) {
    setState(() {
      _tag = value;
    });
  }

  void _applyTag() {
    Navigator.pop(context, _tag.trim());
  }
}
