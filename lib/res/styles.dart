import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/res/res_index.dart';

class TextStyles {
  static TextStyle listTitle = TextStyle(
    fontSize: Dimens.font_sp16,
    color: Colours.text_dark,
    fontWeight: FontWeight.bold,
  );
  static TextStyle listContent = TextStyle(
    fontSize: Dimens.font_sp14,
    color: Colours.text_normal,
  );
  static TextStyle listExtra = TextStyle(
    fontSize: Dimens.font_sp12,
    color: Colours.text_gray,
  );
}

class Decorations {
  static Decoration bottom = BoxDecoration(
      border: Border(bottom: BorderSide(width: 0.33, color: Colours.divider)));
}

/// 间隔
class Gaps {
  /// 水平间隔
  static Widget hGap5 = new SizedBox(width: 5);
  static Widget hGap8 = new SizedBox(width: 8);
  static Widget hGap10 = new SizedBox(width: 10);
  static Widget hGap15 = new SizedBox(width: 15);
  static Widget hGap12 = new SizedBox(width: 12);
  static Widget hGap20 = new SizedBox(width: 20);
  static Widget hGap70 = new SizedBox(width: 70);

  /// 垂直间隔
  static Widget vGap5 = new SizedBox(height: 5);
  static Widget vGap8 = new SizedBox(height: 8);
  static Widget vGap10 = new SizedBox(height: 10);
  static Widget vGap12 = new SizedBox(height: 12);
  static Widget vGap15 = new SizedBox(height: 15);
  static Widget vGap20 = new SizedBox(height: 20);
}
