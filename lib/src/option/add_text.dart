part of 'edit_options.dart';

/// Add text to image.
class AddTextOption implements Option {
  AddTextOption();

  /// The items of added texts.
  final List<EditorText> texts = <EditorText>[];

  /// Add [text] to [texts].
  void addText(EditorText text) {
    texts.add(text);
  }

  @override
  bool get canIgnore => texts.isEmpty;

  @override
  String get key => 'add_text';

  @override
  Map<String, Object> get transferValue {
    return <String, Object>{
      'texts': texts.map((e) => e.toJson()).toList(),
    };
  }
}

/// Descript of a text.
class EditorText {
  const EditorText({
    required this.text,
    required this.offset,
    this.fontSizePx = 14,
    this.textColor = Colors.black,
    this.fontName = '',
  });

  /// The text.
  final String text;

  /// The offset of text.
  final Offset offset;

  /// The font size of text.
  final int fontSizePx;

  /// The color of text.
  final Color textColor;

  /// The font name of text, if fontName is empty string, the text will use system font.
  final String fontName;

  int get y {
    if (Platform.isAndroid) {
      return offset.dy.toInt() + fontSizePx;
    }
    return offset.dy.toInt();
  }

  Map<String, Object> toJson() {
    return <String, Object>{
      'text': text,
      'fontName': fontName,
      'x': offset.dx.toInt(),
      'y': offset.dy.toInt(),
      'size': fontSizePx,
      'r': textColor.red,
      'g': textColor.green,
      'b': textColor.blue,
      'a': textColor.alpha,
    };
  }
}
