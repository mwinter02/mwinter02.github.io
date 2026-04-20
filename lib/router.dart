import 'main.dart';
import 'pages/business_card/business_card.dart';
import 'pages/home/home_page.dart';
import 'pages/projects/page_view.dart';
import 'pages/projects/projects.dart';

export 'package:go_router/go_router.dart';

class Routes {
  Routes._();

  static const String homePath = '/';
  static const String projectsPath = '/projects';
  static const String contactPath = '/contact';


  static final List<GoRoute> projectRoutes = [
    zombies,
    pngchaser,
    collider,
    argo,
    airobic,
    terrain,
    urbanize,
    pacman,
    courses,
    subwayscholar,
  ];

  static final List<GoRoute> all = [
    home,
    projects,
    contact,
    ...projectRoutes,
  ];

  // router.dart or a helper function
  static Page<void> buildPage(BuildContext context, GoRouterState state, Widget child) {
    final isMobile = isMobileNotifier.value;

    if (isMobile) {
      return NoTransitionPage(key: state.pageKey, child: child);
    }

    return CustomTransitionPage(
      key: state.pageKey,
      child: child,
      transitionDuration: const Duration(milliseconds: 300),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(position: Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero).animate(animation), child: child);
      },
    );
  }

  static GoRoute getProjectRoute(Project project) {
    return GoRoute(path: project.route,

        pageBuilder: (context, state) => buildPage(
              context,
              state,
              ProjectPageView(markdownPath: project.markdownPath),
            ),

        // builder: (BuildContext context, GoRouterState state) =>
        // ProjectPageView(markdownPath: project.markdownPath)
    );
  }

  static GoRoute zombies = getProjectRoute(Projects.zombies);
  static GoRoute pngchaser = getProjectRoute(Projects.pngchaser);
  static GoRoute collider = getProjectRoute(Projects.collider);
  static GoRoute argo = getProjectRoute(Projects.argo);
  static GoRoute subwayscholar = getProjectRoute(Projects.subwayscholar);
  static GoRoute urbanize = getProjectRoute(Projects.urbanize);
  static GoRoute airobic = getProjectRoute(Projects.airobic);
  static GoRoute terrain = getProjectRoute(Projects.terrain);
  static GoRoute pacman = getProjectRoute(Projects.pacman);
  static GoRoute courses = getProjectRoute(Projects.courses);

  static GoRoute projects = GoRoute(
    path: projectsPath,
    builder: (BuildContext context, GoRouterState state) =>
        const ProjectsPage(),
  );

  static GoRoute contact = GoRoute(
    path: contactPath,
    builder: (BuildContext context, GoRouterState state) =>
        const ContactPage(),
  );

  static GoRoute home = GoRoute(
    path: homePath,
    builder: (BuildContext context, GoRouterState state) => const HomePage(),
    routes: <RouteBase>[projects, contact, ...projectRoutes],
  );
}

/// The route configuration.
final GoRouter appRouter = GoRouter(
  routes: <RouteBase>[Routes.home],
  redirect: (context, state) {
    if (!Routes.all.map((route) => route.path).contains(state.matchedLocation)) {
      return Routes.home.path;
    }
    return null;
  },
);
