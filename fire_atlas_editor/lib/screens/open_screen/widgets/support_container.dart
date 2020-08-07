import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../widgets/text.dart';

class SupportContainer extends StatelessWidget {
  void _open(String url) async {
    if (await canLaunch(url)) {
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
        FLabel(label: 'Fire Atlas, is, and will always be free.'),
        FLabel(
            label:
                'But if it is useful to you, considere supporting our work!'),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  _open('https://www.patreon.com/fireslime');
                },
                child: Image.asset(
                  "assets/patreon_button.png",
                  width: 150,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(width: 20),
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  _open('https://www.buymeacoffee.com/fireslime');
                },
                child: Image.asset(
                  "assets/coffee_button.png",
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
