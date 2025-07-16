import 'package:flutter/material.dart';
import 'package:printnotes/utils/configs/data_path.dart';

class StyleHandler {
  static Future<bool> uploadBgImage() async {
    return await DataPath.uploadBgImage();
  }

  static Future<List<String>> getBgImageList() async {
    return await DataPath.getBgImages();
  }

  static BoxFit getBgImageFit(String fit) {
    switch (fit) {
      case 'contain':
        return BoxFit.contain;
      case 'fill':
        return BoxFit.fill;
      case 'scaleDown':
        return BoxFit.scaleDown;
      case 'fitHeight':
        return BoxFit.fitHeight;
      case 'fitWidth':
        return BoxFit.fitWidth;
      case 'none':
        return BoxFit.none;
      default:
        return BoxFit.cover;
    }
  }

  static ImageRepeat getBgImageRepeat(String repeat) {
    switch (repeat) {
      case 'repeat':
        return ImageRepeat.repeat;
      case 'repeatX':
        return ImageRepeat.repeatX;
      case 'repeatY':
        return ImageRepeat.repeatY;
      default:
        return ImageRepeat.noRepeat;
    }
  }

  static ShapeBorder getNoteTileShape(String shape,
      {BorderSide side = BorderSide.none, BorderRadiusGeometry? borderRadius}) {
    switch (shape) {
      case 'square':
        return BeveledRectangleBorder(
            side: side, borderRadius: borderRadius ?? BorderRadius.zero);
      default:
        return RoundedRectangleBorder(
            side: side,
            borderRadius:
                borderRadius ?? BorderRadius.all(Radius.circular(12)));
    }
  }
}
