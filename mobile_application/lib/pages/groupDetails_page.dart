import 'package:flutter/material.dart';
import 'package:mobile_application/entities/group.dart';
import 'package:mobile_application/entities/player.dart';
import 'package:mobile_application/elements/customAlertDialog.dart';

import 'package:mobile_application/globalVariables.dart';

// Global lists
List<Group> allGroups = groups; // Your list of groups
List<Player> allPlayers = player; // Your list of all players

class GroupDetailsPage extends StatefulWidget {
  final int groupIndex;
  final VoidCallback onDelete;
  final Function(List) onSave;

  const GroupDetailsPage({
    Key? key,
    required this.onDelete,
    required this.groupIndex,
    required this.onSave,
  }) : super(key: key);

  @override
  _GroupDetailsPageState createState() => _GroupDetailsPageState();
}

class _GroupDetailsPageState extends State<GroupDetailsPage> {
  late List<bool> _selectedPlayers;
  late Group _group;

  @override
  void initState() {
    super.initState();
    _group = allGroups[widget.groupIndex];
    _selectedPlayers = List.generate(_group.player.length, (_) => true);
  }

  void _showDeleteConfirmationDialog() {
    showConfirmationDialog(
      context: context,
      title: 'Gruppe Löschen',
      message: 'Möchtest du diese Gruppe wirklich löschen?',
      onConfirm: _deleteGroup,
      onCancel: () {},
    ).then((confirmed) {
      if (confirmed) {
        _deleteGroup();
      }
    });
  } 

  void _deleteGroup() async {
    widget.onDelete();
    Navigator.pop(context);
  }

  void _saveSelectedPlayers() async {
    List<int> selectedPlayerIds = _group.player
        .asMap()
        .entries
        .where((entry) => _selectedPlayers[entry.key])
        .map((entry) => entry.value)
        .toList();
    
    widget.onSave(selectedPlayerIds);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Group Details'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: _showDeleteConfirmationDialog,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _group.player.length,
        itemBuilder: (context, index) {
          Player player = allPlayers.firstWhere((p) => p.id == _group.player[index]);
          return CheckboxListTile(
            title: Text(player.name),
            value: _selectedPlayers[index],
            onChanged: (bool? value) {
              setState(() {
                _selectedPlayers[index] = value!;
              });
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _saveSelectedPlayers,
        child: Icon(Icons.save),
        tooltip: 'Save Selected Players',
      ),
    );
  }
}
