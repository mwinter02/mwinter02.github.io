import 'package:flutter/cupertino.dart';

import '../../theme/theme.dart';

class PageTextBox extends StatelessWidget {
  final Widget child;

  const PageTextBox({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      // no padding
      decoration: _decoration(),
      child: child,
    );
  }

  static Container divider({double width = 1}) {
    return Container(
      height: width,
      width: double.infinity,
      color: ThemeColors.textBoxDivider,
    );
  }

  static BoxDecoration _decoration() {
    return BoxDecoration(
      color: ThemeColors.boxBackground,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(
          color: ThemeColors.boxBorder,
          width: 1
      ),
      boxShadow: [
        BoxShadow(
          color: ThemeColors.boxShadow,
          blurRadius: 24,
          offset: const Offset(0, 8),
        ),
      ],
    );
  }
}