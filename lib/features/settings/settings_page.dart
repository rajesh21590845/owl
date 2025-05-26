import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../../data/providers/theme_provider.dart';
import '../../data/providers/auth_provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  File? _image;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadProfileImage();
  }

  void _loadUserData() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final currentUser = authProvider.currentUser;

    if (currentUser != null) {
      _nameController.text = currentUser.name;
      _emailController.text = currentUser.email;
    }
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _saveProfileChanges() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final newName = _nameController.text.trim();
    final newEmail = _emailController.text.trim();

    try {
      await authProvider.updateUser(name: newName, email: newEmail);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Profile updated!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to update profile: $e")),
      );
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      // Copy the file to app directory
      final appDir = await getApplicationDocumentsDirectory();
      final fileName = 'profile_pic_${DateTime.now().millisecondsSinceEpoch}.png';
      final savedImage = await File(pickedFile.path).copy('${appDir.path}/$fileName');

      // Save the path securely
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      await authProvider.saveProfileImagePath(savedImage.path);

      setState(() {
        _image = savedImage;
      });
    }
  }

  Future<void> _loadProfileImage() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final savedImagePath = await authProvider.getProfileImagePath();

    if (savedImagePath != null) {
      final imageFile = File(savedImagePath);
      if (await imageFile.exists()) {
        setState(() {
          _image = imageFile;
        });
      }
    }
  }
  void _exportData() {
    // Add export logic
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Export started...")),
    );
  }

  void _resetData() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Reset All Data"),
        content: Text("Are you sure you want to clear all sleep data?"),
        actions: [
          TextButton(
            child: Text("Cancel"),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: Text("Reset", style: TextStyle(color: Colors.red)),
            onPressed: () {
              Navigator.pop(context);
              // Add your reset logic here
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("All data reset.")),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: ListView(
                children: [
                  // Profile Avatar
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
                              child: Icon(Icons.edit, size: 20, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),
                  Text("Profile", style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 10),

                  // Username Field
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: "Username",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 15),

                  // Email Field
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: "Email",
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 15),

                  ElevatedButton.icon(
                    icon: Icon(Icons.save),
                    label: Text("Save Changes"),
                    onPressed: _saveProfileChanges,
                  ),

                  const SizedBox(height: 30),
                  Text("Preferences", style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 10),

                  // Theme Toggle
                  SwitchListTile(
                    title: Text("Dark Mode"),
                    value: themeProvider.isDarkMode,
                    onChanged: (_) => themeProvider.toggleTheme(),
                    secondary: Icon(Icons.dark_mode),
                  ),

                  const SizedBox(height: 30),
                  Text("Data", style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 10),

                  // Export Option
                  ListTile(
                    leading: Icon(Icons.import_export),
                    title: Text("Export Sleep Data"),
                    onTap: _exportData,
                  ),

                  // Reset Option
                  ListTile(
                    leading: Icon(Icons.delete_forever, color: Colors.red),
                    title: Text("Reset All Data"),
                    onTap: _resetData,
                  ),
                ],
              ),
            ),
    );
  }
}