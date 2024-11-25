import 'package:flutter/material.dart';

import '../widgets/mobile_widget.dart';
import '../widgets/web_widget.dart';

class ResponsiveLoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 600) {
          // Render web/desktop version
          return WebLoginPage();
        } else {
          // Render mobile version
          return SafeArea(child: MobileLoginPage());
        }
      },
    );
  }
}


