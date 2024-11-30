import 'package:animated_snack_bar/animated_snack_bar.dart';

AnimatedSnackBar customSnackBar(String text, {String? type, int? durationMil}) {
  // To avoid importing animated_snack_bar into every file
  AnimatedSnackBarType snackBarType;
  switch (type) {
    case "success":
      snackBarType = AnimatedSnackBarType.success;
      break;
    case "info":
      snackBarType = AnimatedSnackBarType.info;
      break;
    case "warning":
      snackBarType = AnimatedSnackBarType.warning;
      break;
    case "error":
      snackBarType = AnimatedSnackBarType.error;
      break;
    default:
      snackBarType = AnimatedSnackBarType.info;
  }
  return AnimatedSnackBar.material(
    text,
    type: snackBarType,
    mobileSnackBarPosition: MobileSnackBarPosition.bottom,
    desktopSnackBarPosition: DesktopSnackBarPosition.bottomRight,
    duration: Duration(milliseconds: durationMil ?? 2000),
  );
}
