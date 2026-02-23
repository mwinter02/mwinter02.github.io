import 'package:google_fonts/google_fonts.dart';
import '../router.dart';
import '../theme/theme.dart';
import '../widgets/about_section.dart';
import '../widgets/dynamic_widget.dart';
import '../widgets/profile_card.dart';
import '../widgets/project_gallery.dart';
import '../widgets/site_widgets.dart';
import 'projects.dart';

// ─────────────────────────────────────────────────────────────────────────────
// HomePage
// ─────────────────────────────────────────────────────────────────────────────

class HomePage extends DynamicStatefulWidget {
  const HomePage({super.key});

  @override
  DynamicState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends DynamicState<HomePage> {
  // Show only the first 6 projects on the home page.
  static const int _featuredCount = 6;

  // One ScrollController drives both the page scroll and the nav anchors.
  final ScrollController _scrollController = ScrollController();

  // Section keys — attached to the first widget in each section so
  // Scrollable.ensureVisible can find and scroll to them.
  final GlobalKey _projectsKey = GlobalKey();
  final GlobalKey _aboutKey    = GlobalKey();
  final GlobalKey _contactKey  = GlobalKey();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  List<Project> get _featured => Projects.all.take(_featuredCount).toList();

  @override
  Widget desktopView(BuildContext context) => _buildPage(context);

  @override
  Widget mobileView(BuildContext context) => _buildPage(context);

  Widget _buildPage(BuildContext context) {
    return Scaffold(
      appBar: siteAppBar(
        context,
        nav: HomeNav(
          scrollController: _scrollController,
          projectsKey: _projectsKey,
          aboutKey:    _aboutKey,
          contactKey:  _contactKey,
        ),
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Profile card ───────────────────────────────────────────────
            const Center(child: ProfileCard()),

            // ── Accent divider ─────────────────────────────────────────────
            _accentDivider(),

            // ── Featured projects ──────────────────────────────────────────
            // Key on a zero-height SizedBox so the anchor sits at the very
            // top of the section without affecting layout.
            SizedBox(key: _projectsKey, height: 0),
            ProjectGallery(
              projects: _featured,
              showFilters: false,
              showHeader: true,
            ),

            // ── View all button ────────────────────────────────────────────
            _ViewAllButton(),

            // ── Accent divider ─────────────────────────────────────────────
            _accentDivider(),

            // ── About + Contact (dossier) ──────────────────────────────────
            SizedBox(key: _aboutKey, height: 0),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 0),
              child: const AboutSection(),
            ),

            // The KnownProfilesPanel inside AboutSection contains the contact
            // panel; we attach _contactKey to a zero-height anchor just above
            // the bottom padding so CONTACT scrolls to the profile panel.
            SizedBox(key: _contactKey, height: 0),
            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }

  Widget _accentDivider() => Container(
        height: 1.5,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.transparent,
              ThemeColors.appBarAccent,
              Colors.transparent,
            ],
          ),
        ),
      );
}

// ─────────────────────────────────────────────────────────────────────────────
// _ViewAllButton
// ─────────────────────────────────────────────────────────────────────────────

class _ViewAllButton extends StatefulWidget {
  @override
  State<_ViewAllButton> createState() => _ViewAllButtonState();
}

class _ViewAllButtonState extends State<_ViewAllButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 48),
      child: Center(
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          onEnter: (_) => setState(() => _hovered = true),
          onExit:  (_) => setState(() => _hovered = false),
          child: GestureDetector(
            onTap: () => context.go(Routes.projectsPath),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: _hovered
                      ? Colors.deepPurpleAccent
                      : Colors.white.withValues(alpha: 0.25),
                  width: 1.2,
                ),
                color: _hovered
                    ? Colors.deepPurpleAccent.withValues(alpha: 0.15)
                    : Colors.transparent,
                boxShadow: _hovered
                    ? [
                        BoxShadow(
                          color: Colors.deepPurpleAccent.withValues(alpha: 0.3),
                          blurRadius: 16,
                          spreadRadius: 0,
                        ),
                      ]
                    : [],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'VIEW ALL PROJECTS',
                    style: GoogleFonts.electrolize(
                      fontSize: 13,
                      letterSpacing: 2.5,
                      color: _hovered ? Colors.white : Colors.white60,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 10),
                  AnimatedSlide(
                    offset: _hovered ? const Offset(0.2, 0) : Offset.zero,
                    duration: const Duration(milliseconds: 180),
                    child: Icon(
                      Icons.arrow_forward,
                      size: 16,
                      color: _hovered ? Colors.deepPurpleAccent : Colors.white38,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
