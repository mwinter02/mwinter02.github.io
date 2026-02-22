import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:website/links.dart';

import '../router.dart';
import '../theme/text_theme.dart';

AppBar siteAppBar(BuildContext context) {
  return AppBar(
    toolbarHeight: 80,
    title: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
          child: Text('mwinter02', style: AppTextTheme.display.copyWith(
            color: Colors.white

          )),
          onPressed: () => context.go(RouteNames.home),
        ),


        Row(
          children: [
            _linkedInButton(context),
            _emailButton(context)
          ],
        ),
      ],
    ),
    automaticallyImplyLeading: false,
  );
}

Widget _emailButton(BuildContext context) {
  return IconButton(
    iconSize: 48,
    hoverColor: Colors.transparent,
    onPressed: () => launchUrl(emailLaunchUri),
    icon: Icon(
      Icons.email_outlined,
      color: Colors.white,
    ),
  );
}

Widget _linkedInButton(BuildContext context) {
  return IconButton(
    iconSize: 40,
    hoverColor: Colors.transparent,
    onHover: (hovering) => (),
    onPressed: () => launchUrl(linkedInLaunchUri),
    icon: Icon(FontAwesomeIcons.squareLinkedin,
      color: Colors.white,
    ),
  );
}


