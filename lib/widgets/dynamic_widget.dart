import 'package:flutter/material.dart';
export 'package:flutter/material.dart';


abstract class DynamicWidget extends StatelessWidget {
  const DynamicWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < 600) {
      // Mobile layout
      return mobileView(context);
    } else {
      // Desktop layout
      return desktopView(context);
    }
  }

  Widget mobileView(BuildContext context);
  Widget desktopView(BuildContext context);
}

abstract class DynamicStatefulWidget extends StatefulWidget {
  const DynamicStatefulWidget({super.key});
  @override
  DynamicState createState();
}

abstract class DynamicState<T extends StatefulWidget> extends State<T> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < 600) {
      // Mobile layout
      return mobileView(context);
    } else {
      // Desktop layout
      return desktopView(context);
    }
  }

  Widget mobileView(BuildContext context);
  Widget desktopView(BuildContext context);
}