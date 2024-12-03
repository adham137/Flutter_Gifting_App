import 'package:flutter/material.dart';
import '../controllers/controller_home_screen.dart';


class AddFriendModal extends StatefulWidget {
  final String userId;

  AddFriendModal({required this.userId});

  @override
  _AddFriendModalState createState() => _AddFriendModalState();
}

class _AddFriendModalState extends State<AddFriendModal> {
  final TextEditingController _friendEmailController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _sendRequest() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await FriendService.sendFriendRequest(widget.userId, _friendEmailController.text.trim());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Friend request sent!')),
      );
      Navigator.pop(context); // Close modal on success
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Add Friend',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _friendEmailController,
              decoration: InputDecoration(
                hintText: 'Enter friend\'s email',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            if (_errorMessage != null)
              Text(
                _errorMessage!,
                style: TextStyle(color: Colors.red),
              ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isLoading ? null : _sendRequest,
              child: _isLoading ? CircularProgressIndicator() : Text('Send Request'),
            ),
          ],
        ),
      ),
    );
  }
}
