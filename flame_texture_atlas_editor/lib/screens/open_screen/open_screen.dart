import 'package:flutter/material.dart';

import './widgets/atlas_options_container.dart';

class OpenScreen extends StatefulWidget {
  @override
  State createState() => _OpenScreenState();
}

class _OpenScreenState extends State<OpenScreen> {

  bool _showCreateAtlasModal = false;

  @override
  Widget build(_) {

    List<Widget> children = [];

    children.add(
        Center(
            child: RaisedButton(
                child: Text('New atlas'),
                onPressed: () {
                  setState(() {
                    _showCreateAtlasModal = true;
                  });
                }
            ),
        )
    );

    if (_showCreateAtlasModal) {
      children.add(Center(child: AtlasOptionsContainer()));
    }

    return Scaffold(
        body: Stack(children: children),
    );
  }
}
