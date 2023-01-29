import 'dart:io';

import 'package:fire_atlas_editor/screens/open_screen/widgets/atlas_options_container.dart';
import 'package:fire_atlas_editor/screens/open_screen/widgets/support_container.dart';
import 'package:fire_atlas_editor/screens/widgets/scaffold.dart';
import 'package:fire_atlas_editor/screens/widgets/toggle_theme_button.dart';
import 'package:fire_atlas_editor/services/storage/storage.dart';
import 'package:fire_atlas_editor/store/actions/atlas_actions.dart';
import 'package:fire_atlas_editor/store/actions/editor_actions.dart';
import 'package:fire_atlas_editor/store/store.dart';
import 'package:fire_atlas_editor/widgets/button.dart';
import 'package:fire_atlas_editor/widgets/container.dart';
import 'package:fire_atlas_editor/widgets/icon_button.dart';
import 'package:fire_atlas_editor/widgets/text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:slices/slices.dart';

class OpenScreen extends StatefulWidget {
  const OpenScreen({Key? key}) : super(key: key);

  @override
  State createState() => _OpenScreenState();
}

class _OpenScreenState extends State<OpenScreen> {
  List<LastProjectEntry> _projects = [];
  final _storage = FireAtlasStorage();

  @override
  void initState() {
    super.initState();

    _loadProjects();
  }

  Future<void> _loadProjects() async {
    final loadedProjects = await _storage.lastUsedProjects();

    setState(() {
      _projects = loadedProjects;
    });
  }

  Future<void> _importAtlas() async {
    final _store = SlicesProvider.of<FireAtlasState>(context);

    try {
      final loaded = await _storage.selectProject();
      await _storage.rememberProject(loaded);
      setState(() {
        _projects.add(loaded.toLastProjectEntry());
      });

      await _store.dispatchAsync(LoadAtlasAction(loaded.path!));
      Navigator.of(context).pushNamed('/editor');
    } catch (e) {
      debugPrint(e.toString());
      _store.dispatch(
        CreateMessageAction(
          message: 'Error importing atlas',
          type: MessageType.ERROR,
        ),
      );
    }
  }

  void _newAtlas() {
    final _store = SlicesProvider.of<FireAtlasState>(context);
    _store.dispatch(
      OpenEditorModal(
        AtlasOptionsContainer(
          onConfirm: (
            String atlasName,
            String imageData,
            double tileWidth,
            double tileHeight,
          ) async {
            _store.dispatch(CloseEditorModal());

            await _store.dispatchAsync(
              CreateAtlasAction(
                id: atlasName,
                imageData: imageData,
                tileWidth: tileWidth,
                tileHeight: tileHeight,
              ),
            );
            Navigator.of(context).pushNamed('/editor');
          },
          onCancel: () {
            _store.dispatch(CloseEditorModal());
          },
        ),
        600,
        600,
      ),
    );
  }

  @override
  Widget build(_) {
    final _store = SlicesProvider.of<FireAtlasState>(context);
    final children = <Widget>[];
    final containerChildren = <Widget>[];

    containerChildren.add(const FTitle(title: 'Recent projects:'));

    if (_projects.isEmpty) {
      containerChildren
          .add(const Center(child: FLabel(label: 'No projects created yet')));
    }

    _projects.forEach((p) {
      containerChildren.add(
        Container(
          margin: const EdgeInsets.only(left: 10, right: 10, top: 5),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(p.name),
                  FIconButton(
                    iconData: Icons.folder_open,
                    onPress: () async {
                      await _store.dispatchAsync(LoadAtlasAction(p.path));
                      Navigator.of(context).pushNamed('/editor');
                    },
                  ),
                ],
              ),
              const Divider(),
            ],
          ),
        ),
      );
    });

    children.add(
      Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 500,
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Image.asset('assets/Logo.png'),
                          ),
                          if (!kIsWeb && Platform.isMacOS)
                            Container(
                              width: 300,
                              child: _Buttons(
                                importAtlas: _importAtlas,
                                newAtlas: _newAtlas,
                              ),
                            ),
                        ],
                      ),
                      if (kIsWeb || !Platform.isMacOS)
                        FContainer(
                          width: 400,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: containerChildren,
                                  ),
                                ),
                              ),
                              _Buttons(
                                importAtlas: _importAtlas,
                                newAtlas: _newAtlas,
                              ),
                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 10,
            right: 10,
            child: FButton(
              label: 'Support this project',
              onSelect: () {
                _store.dispatch(
                  OpenEditorModal(
                    const SupportContainer(),
                    500,
                    300,
                  ),
                );
              },
            ),
          ),
          const Positioned(
            top: 10,
            right: 10,
            child: ToggleThemeButton(),
          ),
        ],
      ),
    );
    return FScaffold(
      child: Stack(children: children),
    );
  }
}

class _Buttons extends StatelessWidget {
  final VoidCallback importAtlas;
  final VoidCallback newAtlas;

  const _Buttons({
    required this.importAtlas,
    required this.newAtlas,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FButton(
          label: 'Open atlas',
          onSelect: importAtlas,
        ),
        const SizedBox(width: 10),
        FButton(
          label: 'New atlas',
          onSelect: newAtlas,
        ),
      ],
    );
  }
}
