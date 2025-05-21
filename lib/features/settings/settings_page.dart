import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'dart:io';

import '../../data/providers/theme_provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  File? _image;
  String _userName = "Your Name";
  final TextEditingController _nameController = TextEditingController();

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _nameController.text = _userName;
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: _image != null
                        ? FileImage(_image!)
                        : AssetImage("assets/images/profile.jpg")
                            as ImageProvider,
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: PopupMenuButton<ImageSource>(
                      onSelected: _pickImage,
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: ImageSource.camera,
                          child: Text('Camera'),
                        ),
                        PopupMenuItem(
                          value: ImageSource.gallery,
                          child: Text('Gallery'),
                        ),
                      ],
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.grey.shade700,
                        child: Icon(Icons.edit, size: 20),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: "Username",
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                _userName = value;
              },
            ),
            const SizedBox(height: 20),
            SwitchListTile(
              title: Text("Dark Mode"),
              value: themeProvider.isDarkMode,
              onChanged: (_) => themeProvider.toggleTheme(),
            ),
          ],
        ),
      ),
    );
  }
}
