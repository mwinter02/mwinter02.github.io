import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../links.dart';
import '../router.dart';
import '../theme/theme.dart';
import '../theme/text_theme.dart';

// ─────────────────────────────────────────────────────────────────────────────
// NavConfig — tells siteAppBar what to render in the centre slot.
//
//   HomeNav(...)      — ABOUT · PROJECTS · CONTACT scroll-anchor links
//   BreadcrumbNav(…)  — ← LABEL back link
//   NoNav()           — empty centre (default for simple pages)
// ─────────────────────────────────────────────────────────────────────────────

sealed class NavConfig {
  const NavConfig();
}

/// Home page: scroll-to-section links.
class HomeNav extends NavConfig {
  final ScrollController scrollController;
  final GlobalKey aboutKey;
  final GlobalKey projectsKey;
  final GlobalKey contactKey;

  const HomeNav({
    required this.scrollController,
    required this.aboutKey,
    required this.projectsKey,
    required this.contactKey,
  });
}

/// Sub-pages: a single back-link breadcrumb.
class BreadcrumbNav extends NavConfig {
  final String label;
  final String route;
  const BreadcrumbNav({required this.label, required this.route});
}

/// No centre content.
class NoNav extends NavConfig {
  const NoNav();
}

// ─────────────────────────────────────────────────────────────────────────────
// siteAppBar
// ─────────────────────────────────────────────────────────────────────────────

AppBar siteAppBar(BuildContext context, {NavConfig nav = const NoNav()}) {
  return AppBar(
    toolbarHeight: 80,
    flexibleSpace: _AppBarBackground(),
    titleSpacing: 0,
    automaticallyImplyLeading: false,
    title: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          // ── Logo ──────────────────────────────────────────────────────────
          TextButton(
            onPressed: () => context.go(Routes.home.path),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                'mwinter02',
                style: AppTextTheme.display.copyWith(color: Colors.white),
              ),
            ),
          ),
          // ── Centre slot ───────────────────────────────────────────────────
          Expanded(
            child: switch (nav) {
              HomeNav n     => _HomeNavLinks(nav: n),
              BreadcrumbNav n => _Breadcrumb(nav: n),
              NoNav()       => const SizedBox.shrink(),
            },
          ),
          // ── Social icons — always present ─────────────────────────────────
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _linkedInButton(context),
              _emailButton(context),
            ],
          ),
        ],
      ),
    ),
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// _HomeNavLinks — ABOUT · PROJECTS · CONTACT scroll-anchor links
// Hidden on narrow screens to prevent overflow.
// ─────────────────────────────────────────────────────────────────────────────

class _HomeNavLinks extends StatelessWidget {
  final HomeNav nav;
  const _HomeNavLinks({required this.nav});

  void _scrollTo(GlobalKey key) {
    final ctx = key.currentContext;
    if (ctx == null) return;
    Scrollable.ensureVisible(
      ctx,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOutCubic,
      alignment: 0.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      // Hide nav links when the centre slot is too narrow to fit them.
      if (constraints.maxWidth < 280) return const SizedBox.shrink();
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _NavLink(label: 'ABOUT',    onTap: () => _scrollTo(nav.aboutKey)),
          _NavDot(),
          _NavLink(label: 'PROJECTS', onTap: () => _scrollTo(nav.projectsKey)),
          _NavDot(),
          _NavLink(label: 'CONTACT',  onTap: () => _scrollTo(nav.contactKey)),
        ],
      );
    });
  }
}

class _NavLink extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  const _NavLink({required this.label, required this.onTap});

  @override
  State<_NavLink> createState() => _NavLinkState();
}

class _NavLinkState extends State<_NavLink> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit:  (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.label,
                style: TextStyle(
                  fontFamily: 'Electrolize',
                  fontSize: 11,
                  letterSpacing: 2,
                  color: _hovered ? Colors.white : Colors.white54,
                  fontWeight: _hovered ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
              const SizedBox(height: 3),
              // Underline that grows in on hover
              AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                height: 1.5,
                width: _hovered ? 32.0 : 0.0,
                decoration: BoxDecoration(
                  color: ThemeColors.appBarAccent,
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavDot extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Text(
        '·',
        style: TextStyle(
          color: Colors.white24,
          fontSize: 14,
        ),
      );
}

// ─────────────────────────────────────────────────────────────────────────────
// _Breadcrumb — ← LABEL back link for sub-pages
// ─────────────────────────────────────────────────────────────────────────────

class _Breadcrumb extends StatefulWidget {
  final BreadcrumbNav nav;
  const _Breadcrumb({required this.nav});

  @override
  State<_Breadcrumb> createState() => _BreadcrumbState();
}

class _BreadcrumbState extends State<_Breadcrumb> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hovered = true),
        onExit:  (_) => setState(() => _hovered = false),
        child: GestureDetector(
          onTap: () => context.go(widget.nav.route),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedSlide(
                  duration: const Duration(milliseconds: 180),
                  offset: _hovered
                      ? const Offset(-0.15, 0)
                      : Offset.zero,
                  child: Icon(
                    Icons.arrow_back_ios_rounded,
                    size: 13,
                    color: _hovered
                        ? ThemeColors.appBarAccent
                        : Colors.white38,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  widget.nav.label,
                  style: TextStyle(
                    fontFamily: 'Electrolize',
                    fontSize: 11,
                    letterSpacing: 2,
                    color: _hovered
                        ? ThemeColors.appBarAccent
                        : Colors.white38,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _AppBarBackground
// ─────────────────────────────────────────────────────────────────────────────

class _AppBarBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [ThemeColors.appBarStart, ThemeColors.appBarEnd],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
          ),
        ),
        Container(
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
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Icon buttons
// ─────────────────────────────────────────────────────────────────────────────

Widget _emailButton(BuildContext context) => _GlowIconButton(
      icon: Icons.email_outlined,
      iconSize: 40,
      glowColor: const Color(0xFFFF39F5),
      onPressed: () => launchUrl(emailLaunchUri),
    );

Widget _linkedInButton(BuildContext context) => _GlowIconButton(
      icon: FontAwesomeIcons.squareLinkedin,
      iconSize: 36,
      glowColor: const Color(0xFF0E7AE3),
      onPressed: () => launchUrl(linkedInLaunchUri),
    );

class _GlowIconButton extends StatefulWidget {
  final IconData icon;
  final double iconSize;
  final Color glowColor;
  final VoidCallback onPressed;

  const _GlowIconButton({
    required this.icon,
    required this.iconSize,
    required this.glowColor,
    required this.onPressed,
  });

  @override
  State<_GlowIconButton> createState() => _GlowIconButtonState();
}

class _GlowIconButtonState extends State<_GlowIconButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit:  (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: _hovered
                  ? [
                      BoxShadow(
                        color: widget.glowColor.withValues(alpha: 0.65),
                        blurRadius: 18,
                        spreadRadius: 2,
                      ),
                    ]
                  : [],
            ),
            child: Icon(
              widget.icon,
              size: widget.iconSize,
              color: _hovered ? widget.glowColor : Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
