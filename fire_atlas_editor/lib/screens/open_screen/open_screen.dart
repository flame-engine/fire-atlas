import 'package:flutter/material.dart';

import '../../vendor/micro_store/micro_store.dart';
import '../../store/store.dart';
import '../../store/actions/atlas_actions.dart';

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

            Store.instance.dispatch(
                SetAtlasAction(
                    id: atlasName,
                    imageData: imageData,
                    tileSize: tileSize,
                ),
            );
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
            store: Store.instance,
            builder: (ctx, store) => Stack(children: children),
        )
    );
  }
}
