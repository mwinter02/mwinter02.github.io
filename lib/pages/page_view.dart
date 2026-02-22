import 'package:flutter/material.dart';
import 'package:website/router.dart';
import 'package:website/theme/text_theme.dart';
import 'package:website/widgets/site_widgets.dart';

class ProjectPageView extends StatelessWidget {
  final Column content;

  const ProjectPageView({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: siteAppBar(context),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            constraints: BoxConstraints(maxWidth: 800),
            child: content,
          ),
        ),
      ),
    );
  }
}
