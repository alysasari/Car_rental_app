import 'dart:io' as dart_io;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:car_rental_project/services/auth_service.dart';
import 'package:car_rental_project/utils/session_manager.dart';
import 'package:car_rental_project/database/database_helper.dart';
import 'package:permission_handler/permission_handler.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _usernameController = TextEditingController();
  String? _photoPath;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    _usernameController.text = prefs.getString('userName') ?? '';
    setState(() {
      _photoPath = prefs.getString('profile_photo');
    });
  }

  Future<void> _pickPhotoFrom(ImageSource source) async {
    // request runtime permission first
    final ok = await _requestPermissionFor(source);
    if (!ok) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Izin tidak diberikan')));
      return;
    }

    final picker = ImagePicker();
    final picked = await picker.pickImage(source: source, imageQuality: 80);

    if (picked != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('profile_photo', picked.path);

      setState(() {
        _photoPath = picked.path;
      });
    }
  }

  Future<bool> _requestPermissionFor(ImageSource source) async {
    try {
      if (source == ImageSource.camera) {
        final status = await Permission.camera.request();
        return status.isGranted;
      } else {
        // gallery
        if (dart_io.Platform.isIOS) {
          final status = await Permission.photos.request();
          return status.isGranted;
        } else {
          // Android: request storage (legacy) and try photos/read media images
          final storageStatus = await Permission.storage.request();
          if (storageStatus.isGranted) return true;
          final photosStatus = await Permission.photos.request();
          if (photosStatus.isGranted) return true;
          // as fallback try manage external storage (may need special access)
          final manageStatus = await Permission.manageExternalStorage.request();
          return manageStatus.isGranted;
        }
      }
    } catch (e) {
      return false;
    }
  }

  Future<void> _showPickOptions() async {
    if (!mounted) return;

    showModalBottomSheet<void>(
      context: context,
      builder: (ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Camera'),
                onTap: () {
                  Navigator.of(ctx).pop();
                  _pickPhotoFrom(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () {
                  Navigator.of(ctx).pop();
                  _pickPhotoFrom(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.close),
                title: const Text('Cancel'),
                onTap: () => Navigator.of(ctx).pop(),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    final newName = _usernameController.text.trim();
    await prefs.setString('userName', newName);

    final idStr = prefs.getString('id');
    if (idStr != null) {
      final id = int.tryParse(idStr);
      if (id != null) {
        try {
          await DatabaseHelper.instance.updateUserName(id, newName);
        } catch (_) {
        }
      }
    }

    if (!mounted) return;
    Navigator.of(context).pop(true);
  }

  Future<void> _confirmAndDeleteAccount() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus Akun'),
        content: const Text('Aksi ini akan menghapus akun Anda secara permanen. Lanjutkan?'),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Batal')),
          TextButton(onPressed: () => Navigator.of(ctx).pop(true), child: const Text('Hapus', style: TextStyle(color: Colors.red))),
        ],
      ),
    );

    if (confirm != true) return;

    final prefs = await SharedPreferences.getInstance();
    final idStr = prefs.getString('id');
    if (idStr == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Tidak dapat menemukan akun saat ini.')));
      return;
    }

    final id = int.tryParse(idStr);
    if (id == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('ID pengguna tidak valid.')));
      return;
    }

    final ok = await AuthService.deleteAccount(id);
    if (ok) {
      await prefs.remove('profile_photo');
      await SessionManager.clearSession();
      if (!mounted) return;
      Navigator.pushNamedAndRemoveUntil(context, '/login', (r) => false);
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Gagal menghapus akun.')));
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 12),
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: 56,
                        backgroundImage: _photoPath != null && dart_io.File(_photoPath!).existsSync()
                          ? FileImage(dart_io.File(_photoPath!)) as ImageProvider
                          : const AssetImage('assets/images/profile.png'),
                    ),
                    InkWell(
                      onTap: _showPickOptions,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.camera_alt, color: Colors.white, size: 18),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: TextField(
                    controller: _usernameController,
                    decoration: const InputDecoration(
                      labelText: 'Username',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _save,
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 14),
                      child: Text('Save', style: TextStyle(fontSize: 16)),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: 200,
                  child: ElevatedButton(
                    onPressed: _confirmAndDeleteAccount,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      minimumSize: const Size.fromHeight(44),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Text('Hapus Akun', style: TextStyle(fontSize: 15, color: Colors.white)),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
