import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:web/web.dart' as web;

import '../../sources.dart';
import '../../theme/text_theme.dart';
import '../../widgets/site_widgets.dart';
import '../shared/dynamic_widget.dart';
import '../shared/text_box.dart';

/// Triggers a browser "Save As" download for the bundled resume asset.


class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: siteAppBar(context),
      body: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 860),
            child: const Column(
              children: [
                BusinessCard(
                  name: 'Marcus Winter',
                  title: 'Software Engineer',
                  education:
                      'M.Sc. Computer Science, Brown University',
                  interests: [
                    'Game Development',
                    'Computer Graphics',
                    'Machine Learning',
                    'Full-Stack',
                  ],
                  profileImage: AssetImage('assets/images/profile.jpg'),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(32, 0, 32, 40),
                  child: _QrSection(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class BusinessCard extends StatelessWidget {
  final String name;
  final String title;
  final String education;
  final List<String> interests;
  final ImageProvider profileImage;

  const BusinessCard({
    super.key,
    required this.name,
    required this.title,
    required this.education,
    required this.interests,
    required this.profileImage,
  });

  static BoxDecoration _boxDecoration() {
    return BoxDecoration(
      gradient: const LinearGradient(
        colors: [Color(0xFF1A0533), Color(0xFF311B92)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(
        color: Colors.deepPurpleAccent.withValues(alpha: 0.6),
        width: 1.5,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 800, minWidth: 320),
        child: Container(
          decoration: _boxDecoration(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 4),
              _CardHeader(
                name: name,
                title: title,
                education: education,
                interests: interests,
                profileImage: profileImage,
              ),
              const _CardDivider(label: 'Contact Details'),
              const SizedBox(height: 8),
              _ContactInfo(),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _CardHeader
// ─────────────────────────────────────────────────────────────────────────────

class _CardHeader extends DynamicWidget {
  final String name;
  final String title;
  final String education;
  final List<String> interests;
  final ImageProvider profileImage;

  const _CardHeader({
    required this.name,
    required this.title,
    required this.education,
    required this.interests,
    required this.profileImage,
  });

  @override
  Widget desktopView(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(28, 28, 28, 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: _ProfileDetails(
              name: name,
              title: title,
              education: education,
              interests: interests,
            ),
          ),
          const SizedBox(width: 28),
          // Right column: tap hint above the avatar
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // _TapToFlip(),
              // const SizedBox(height: 10),
              _ProfileAvatar(image: profileImage),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget mobileView(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _ProfileAvatar(image: profileImage, radius: 62),
          const SizedBox(height: 14),
          _ProfileDetails(
            name: name,
            title: title,
            education: education,
            interests: interests,
            centerNameOnly: true,
            centerTitleOnly: true,
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _ProfileAvatar
// ─────────────────────────────────────────────────────────────────────────────

class _ProfileAvatar extends StatelessWidget {
  final ImageProvider image;
  final double radius;

  const _ProfileAvatar({required this.image, this.radius = 80});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const SweepGradient(
          colors: [
            Colors.deepPurpleAccent,
            Colors.purpleAccent,
            Colors.deepPurpleAccent,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.deepPurpleAccent.withValues(alpha: 0.6),
            blurRadius: 16,
            spreadRadius: 1,
          ),
        ],
      ),
      child: CircleAvatar(
        radius: radius,
        backgroundImage: image,
        backgroundColor: const Color(0xFF1A0533),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _ProfileDetails
// ─────────────────────────────────────────────────────────────────────────────

class _ProfileDetails extends StatelessWidget {
  final String name;
  final String title;
  final String education;
  final List<String> interests;
  final bool centerNameOnly;
  final bool centerTitleOnly;

  const _ProfileDetails({
    required this.name,
    required this.title,
    required this.education,
    required this.interests,
    this.centerNameOnly = false,
    this.centerTitleOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Name
        Align(
          alignment: centerNameOnly ? Alignment.center : Alignment.centerLeft,
          child: Text(
            name,
            textAlign: centerNameOnly ? TextAlign.center : TextAlign.left,
            style: AppTextTheme.displayName.copyWith(fontSize: 26),
          ),
        ),
        const SizedBox(height: 4),
        // Title chip
        Align(
          alignment: centerTitleOnly ? Alignment.center : Alignment.centerLeft,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            decoration: BoxDecoration(
              color: Colors.deepPurpleAccent.withValues(alpha: 0.25),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: Colors.deepPurpleAccent.withValues(alpha: 0.6),
              ),
            ),
            child: Text(
              title,
              style: AppTextTheme.displaySubtitle.copyWith(fontSize: 13),
            ),
          ),
        ),
        const SizedBox(height: 14),
        _DetailRow(icon: Icons.school_outlined, text: education),
        const SizedBox(height: 8),
        _DetailRow(icon: Icons.interests_outlined, text: interests.join(' · ')),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _CardDivider
// ─────────────────────────────────────────────────────────────────────────────

class _CardDivider extends StatelessWidget {
  final String label;

  const _CardDivider({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 1,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    Colors.deepPurpleAccent.withValues(alpha: 0.7),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              label,
              style: AppTextTheme.labelField.copyWith(
                fontSize: 11,
                color: AppTextColors.accent,
                letterSpacing: 2.5,
              ),
            ),
          ),
          Expanded(
            child: Container(
              height: 1,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.deepPurpleAccent.withValues(alpha: 0.7),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _ContactInfo
// ─────────────────────────────────────────────────────────────────────────────

class _ContactInfo extends DynamicWidget {
  const _ContactInfo();


  @override
  Widget desktopView(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final narrow = constraints.maxWidth < 400;
        final hPad = narrow ? 16.0 : 28.0;
        final gap = narrow ? 10.0 : 16.0;

        return Padding(
          padding: EdgeInsets.fromLTRB(hPad, 8, hPad, 8),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: _Channel(
                      icon: Icons.mail_outline,
                      text: Sources.email,
                      accentColor: const Color.fromARGB(255, 255, 139, 139),
                      launchUri: Sources.emailLaunchUri,
                    ),
                  ),
                  SizedBox(width: gap),
                  Expanded(
                    child: _Channel(
                      icon: FontAwesomeIcons.linkedin,
                      text: 'linkedin.com/in/mwinter02',
                      accentColor: AppTextColors.linkedIn,
                      launchUri: Sources.linkedInLaunchUri,
                    ),
                  ),
                ],
              ),
              SizedBox(height: gap),
              Row(
                children: [
                  const Expanded(
                    child: _Channel(
                      icon: Icons.phone,
                      text: Sources.phone,
                      accentColor: AppTextColors.terminal,
                      copyText: Sources.phone,
                    ),
                  ),
                  SizedBox(width: gap),
                  const Expanded(
                    child: _Channel(
                      icon: Icons.file_download_outlined,
                      text: 'resume_marcus_winter.pdf',
                      accentColor: AppTextColors.amber,
                      onTap: Sources.downloadResume,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget mobileView(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final narrow = constraints.maxWidth < 400;
        final hPad = narrow ? 16.0 : 28.0;
        final gap = narrow ? 10.0 : 16.0;

        return Padding(
          padding: EdgeInsets.fromLTRB(hPad, 8, hPad, 8),
          child: Column(
            children: [
              _Channel(
                icon: Icons.mail_outline,
                text: Sources.email,
                accentColor: const Color.fromARGB(255, 255, 139, 139),
                launchUri: Sources.emailLaunchUri,
              ),
              SizedBox(height: gap),
              _Channel(
                icon: FontAwesomeIcons.linkedin,
                text: 'linkedin.com/in/mwinter02',
                accentColor: AppTextColors.linkedIn,
                launchUri: Sources.linkedInLaunchUri,
              ),
              SizedBox(height: gap),
              const _Channel(
                icon: Icons.phone,
                text: Sources.phone,
                accentColor: AppTextColors.terminal,
                copyText: Sources.phone,
              ),
              SizedBox(height: gap),
              const _Channel(
                icon: Icons.file_download_outlined,
                text: 'resume_marcus_winter.pdf',
                accentColor: AppTextColors.amber,
                onTap: Sources.downloadResume,
              ),
            ],
          ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _DetailRow  (icon + text line)
// ─────────────────────────────────────────────────────────────────────────────

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _DetailRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: Colors.deepPurpleAccent.shade100),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: AppTextTheme.bodySmall.copyWith(fontSize: 13.5),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _Channel  — icon + link text, optional copy-on-tap or launch-on-tap
// ─────────────────────────────────────────────────────────────────────────────

class _Channel extends StatefulWidget {
  final IconData icon;
  final String text;
  final Color accentColor;

  /// Tapping copies this string to the clipboard and shows "COPIED".
  final String? copyText;

  /// Tapping launches this URI.
  final Uri? launchUri;

  /// Custom tap handler (e.g. trigger a download).
  final VoidCallback? onTap;

  const _Channel({
    required this.icon,
    required this.text,
    required this.accentColor,
    this.copyText,
    this.launchUri,
    this.onTap,
  }) : assert(
         (copyText != null ? 1 : 0) +
                 (launchUri != null ? 1 : 0) +
                 (onTap != null ? 1 : 0) ==
             1,
         '_Channel requires exactly one of copyText, launchUri, or onTap',
       );

  @override
  State<_Channel> createState() => _ChannelState();
}

class _ChannelState extends State<_Channel> {
  bool _hovered = false;
  bool _copied = false;

  Future<void> _onTap() async {
    if (widget.copyText != null) {
      await Clipboard.setData(ClipboardData(text: widget.copyText!));
      setState(() => _copied = true);
      await Future.delayed(const Duration(milliseconds: 1800));
      if (mounted) setState(() => _copied = false);
    } else if (widget.launchUri != null) {
      launchUrl(widget.launchUri!);
    } else {
      widget.onTap!();
    }
  }

  @override
  Widget build(BuildContext context) {
    final accent = widget.accentColor;

    final iconBox = Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: accent.withValues(alpha: 0.25), width: 1),
      ),
      child: Icon(widget.icon, size: 15, color: accent.withValues(alpha: 0.8)),
    );

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: _onTap,
        child: Row(
          children: [
            iconBox,
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                _copied ? 'COPIED //' : widget.text,
                overflow: TextOverflow.ellipsis,
                style: AppTextTheme.monoData.copyWith(
                  color: _hovered || _copied ? accent : AppTextColors.secondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _QrSection
// ─────────────────────────────────────────────────────────────────────────────

class _QrSection extends StatelessWidget {
  const _QrSection();

  @override
  Widget build(BuildContext context) {
    return PageTextBox(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
        child: Column(
          children: [
            Text(
              'Scan to share',
              style: AppTextTheme.labelField.copyWith(
                fontSize: 11,
                color: AppTextColors.accent,
                letterSpacing: 2.5,
              ),
            ),
            const SizedBox(height: 20),
            // ── Swap AssetSources.qrCode for your generated QR image file ──
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                AssetSources.qrCode,
                width: 180,
                height: 180,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => Container(
                  width: 180,
                  height: 180,
                  decoration: BoxDecoration(
                    color: Colors.deepPurpleAccent.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.deepPurpleAccent.withValues(alpha: 0.3),
                      width: 1.5,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.qr_code_2_rounded,
                        size: 64,
                        color: Colors.deepPurpleAccent.withValues(alpha: 0.4),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'qr_code.png',
                        style: AppTextTheme.bodySmall.copyWith(
                          color: AppTextColors.subtle,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

