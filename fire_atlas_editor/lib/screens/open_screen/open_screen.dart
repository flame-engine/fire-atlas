import 'package:flutter/material.dart';

import '../../vendor/micro_store/micro_store.dart';
import '../../store/store.dart';
import '../../store/actions/atlas_actions.dart';
import '../../services/storage.dart';
import '../../widgets/icon_button.dart';
import '../../widgets/button.dart';
import '../../widgets/container.dart';

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

    List<Widget> containerChildren = [];

    containerChildren.add(Text('Recent projects:'));

    FireAtlasStorage.listProjects().forEach((p) {
      containerChildren.add(
          Container(
              margin: EdgeInsets.only(left: 10, right: 10, top: 5),
              child: Column(
                  children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(p),
                          FIconButton(
                              iconData: Icons.folder_open,
                              onPress: () {
                                Store.instance.dispatch(LoadAtlasAction(p));
                                Navigator.of(context).pushNamed('/editor');
                              }
                          ),
                        ],
                    ),
                    Divider(),
                  ]
              ),
          ),
      );
    });

    children.add(
        Center(child: Column(
            children: [
              // Logo of some sort
              SizedBox(height: 10),
              Container(width: 200, height: 200, color: Color(0xFFFF0000)),
              SizedBox(height: 10),
              Expanded(child: FContainer(
                      width: 400,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(children: containerChildren),
                            FButton(
                                label: 'New atlas',
                                onSelect: () {
                                  setState(() {
                                    _showCreateAtlasModal = true;
                                  });
                                }
                            )
                          ]
                      ),
              )),
              SizedBox(height: 20),
            ],
        ))
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
