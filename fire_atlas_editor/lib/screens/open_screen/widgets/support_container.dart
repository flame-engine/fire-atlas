import 'package:fire_atlas_editor/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

final _patreonUrl = Uri.parse('https://www.patreon.com/bluefireoss');

class SupportContainer extends StatelessWidget {
  const SupportContainer({super.key});

  Future<void> _open(Uri url) async {
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(_) {
    return Column(
      children: [
        Container(
          height: 150,
          child: Image.asset('assets/Logo.png'),
        ),
        const FLabel(label: 'Fire Atlas, is, and will always be free.'),
        const FLabel(
          label: 'But if it is useful to you, consider supporting our work!',
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  _open(_patreonUrl);
                },
                child: Image.asset(
                  'assets/patreon_button.png',
                  width: 150,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
