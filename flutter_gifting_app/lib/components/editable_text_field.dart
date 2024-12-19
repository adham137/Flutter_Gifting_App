import 'package:flutter/material.dart';
import 'package:flutter_gifting_app/utils/colors.dart';
import 'package:flutter_gifting_app/utils/fonts.dart';

class EditableTextField extends StatefulWidget {
  final String initialValue;
  final String label;
  final Function(String) onSave;

  const EditableTextField({
    Key? key,
    required this.initialValue,
    required this.label,
    required this.onSave,
  }) : super(key: key);

  @override
  _EditableTextFieldState createState() => _EditableTextFieldState();
}

class _EditableTextFieldState extends State<EditableTextField> {
  late TextEditingController _controller;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: TextFormField(
              controller: _controller,
              enabled: _isEditing,
              decoration: InputDecoration(
                labelText: widget.label,
                labelStyle: AppFonts.t4,
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
              ),
              onFieldSubmitted: (val) {
                if (_isEditing) {
                  _saveValue();
                }
              },
            ),
          ),
          IconButton(
            icon: Icon(_isEditing ? Icons.save : Icons.edit),
            onPressed: () {
              if (_isEditing) {
                _saveValue();
              } else {
                setState(() {
                  _isEditing = true;
                });
              }
            },
          ),
        ],
      ),
    );
  }

  void _saveValue() {
    widget.onSave(_controller.text);
    setState(() {
      _isEditing = false;
    });
  }
}
