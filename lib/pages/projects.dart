import 'package:website/widgets/dynamic_widget.dart';
import 'package:website/router.dart';

class ProjectsPage extends DynamicWidget {
  const ProjectsPage({super.key});

  @override
  Widget desktopView(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Projects')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton(onPressed: () => context.go(RouteNames.zombies),
              child: const Text('To zombies')),
              ElevatedButton(onPressed: () => context.go(RouteNames.pngchaser),
                  child: const Text('To PNG chaser.')),

              ElevatedButton(onPressed: () => context.pop(),
                  child: const Text('Return home.')),
            ],
          ),
        ));
  }

  @override
  Widget mobileView(BuildContext context) {
    return const Text('Projects Page - Mobile');
  }
}