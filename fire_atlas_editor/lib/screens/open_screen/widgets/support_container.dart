import 'package:fire_atlas_editor/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SupportContainer extends StatelessWidget {
  const SupportContainer({Key? key}) : super(key: key);

  Future<void> _open(String url) async {
    // TODO(luan): fix
    // ignore: deprecated_member_use
    if (await canLaunch(url)) {
      // TODO(luan): fix
      // ignore: deprecated_member_use
      await launch(url);
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
                  _open('https://www.patreon.com/bluefireoss');
                },
                child: Image.asset(
                  'assets/patreon_button.png',
                  width: 150,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 20),
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  _open('https://www.buymeacoffee.com/bluefire');
                },
                child: Image.asset(
                  'assets/coffee_button.png',
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
