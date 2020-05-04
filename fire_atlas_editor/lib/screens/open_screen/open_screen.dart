import 'package:flutter/material.dart';

import '../../vendor/micro_store/micro_store.dart';
import '../../store/store.dart';
import '../../models/fire_atlas.dart';

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
      children.add(Center(child: AtlasOptionsContainer(
          onConfirm: (String atlasName, int tileSize, String imageData) {
            Navigator.of(context).pushNamed('/editor');
            setState(() {
              _showCreateAtlasModal = false;
            });

            store.setState((_) {
              final atlas = FireAtlas()
                  ..id = atlasName
                  ..imageData = imageData
                  ..tileSize = tileSize;

              return FireAtlasState()
                  ..currentAtlas = atlas;
            });
          },
          onCancel: () {
            setState(() {
              _showCreateAtlasModal = false;
            });
          },
      )));
    }

    return Scaffold(
        body: MicroStoreProvider(
            store: store,
            child: Stack(children: children),
        )
    );
  }
}
