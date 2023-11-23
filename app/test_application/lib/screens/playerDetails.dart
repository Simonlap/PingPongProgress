import 'package:flutter/material.dart';
import 'package:test_application/entities/player.dart';

class PlayerDetails extends StatefulWidget {
  final Player player;
  final Function(String) onNameChanged;
  final VoidCallback onDelete;

  const PlayerDetails({
    Key? key,
    required this.player,
    required this.onNameChanged,
    required this.onDelete,
  }) : super(key: key);

  @override
  _PlayerDetailsState createState() => _PlayerDetailsState();
}

class _PlayerDetailsState extends State<PlayerDetails> {
  late TextEditingController _nameController;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.player.name);
  }

  void _toggleEditing() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  void _acceptChanges() {
    // Save changes and notify parent
    if (widget.player.name != _nameController.text) {
      widget.player.name = _nameController.text;
      widget.onNameChanged(_nameController.text);
    }
    _toggleEditing();
  }

  void _deletePlayer() {
    widget.onDelete();
    Navigator.pop(context);
  }

  void _showDeleteConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Player'),
          content: Text('Are you sure you want to delete this player?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                _deletePlayer();
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Player Details'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: _showDeleteConfirmationDialog,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Name: ',
                  style: TextStyle(fontSize: 18),
                ),
                _isEditing
                    ? Expanded(
                        child: TextField(
                          controller: _nameController,
                          style: TextStyle(fontSize: 18),
                        ),
                      )
                    : Expanded(
                        child: Text(
                          widget.player.name,
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                IconButton(
                  icon: Icon(_isEditing ? Icons.done : Icons.edit),
                  onPressed: _acceptChanges,
                ),
              ],
            ),
            SizedBox(height: 16),
            Text(
              'Elo: ${widget.player.elo}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
