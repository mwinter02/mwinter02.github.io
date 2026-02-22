import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:website/widgets/dynamic_widget.dart';
import 'package:website/router.dart';
import 'package:website/widgets/project_card.dart';
import 'package:website/widgets/site_widgets.dart';

class MyHomePage extends DynamicStatefulWidget {
  const MyHomePage({super.key});

  @override
  DynamicState<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends DynamicState<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget desktopView(BuildContext context) {
    return Scaffold(
      appBar: siteAppBar(context),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Display the SVG asset
            SvgPicture.asset('assets/images/logo.svg', width: 120, height: 120),
            const SizedBox(height: 24),
            const Text('You have pushed the button this many times:'),
            ElevatedButton(
              onPressed: () => context.go(RouteNames.projects),
              child: const Text("To projects page"),
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            _projectsBanner(context),
          ],
        ),
      ),
    );
  }

  @override
  Widget mobileView(BuildContext context) {
    return desktopView(context);
  }


  Widget _projectsBanner(BuildContext context) {
    List<Widget> projectCards = [
      ProjectCard(
        route: RouteNames.zombies,
        imagePath: 'assets/images/banners/zombies.png',
        title: 'Zombies',
      ),
      ProjectCard(
        route: RouteNames.pngchaser,
        imagePath: 'assets/images/banners/pngchaser.png',
        title: 'PNG Chaser',
      ),
      // Add more project cards here as needed
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 8.0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 500,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 16 / 9,
        ),
        itemCount: projectCards.length,
        itemBuilder: (context, index) => projectCards[index],
      ),
    );
  }

  Widget _profilePicture(BuildContext context) {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          image: AssetImage('assets/images/profile_picture.png'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
