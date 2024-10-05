import 'package:clinic_management/data/repository/user_repository.dart';
import 'package:flutter/material.dart';

class EditUserPage extends StatefulWidget {
  final Map<String, dynamic> user; // Dữ liệu người dùng cần chỉnh sửa

  EditUserPage({super.key, required this.user});

  @override
  _EditUserPageState createState() => _EditUserPageState();
}

class _EditUserPageState extends State<EditUserPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _addressController;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController(text: widget.user['firstName']);
    _lastNameController = TextEditingController(text: widget.user['lastName']);
    _addressController = TextEditingController(text: widget.user['address']);
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Chỉnh sửa người dùng'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _firstNameController,
                  decoration: InputDecoration(labelText: 'First Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập tên';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _lastNameController,
                  decoration: InputDecoration(labelText: 'Last Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập họ';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _addressController,
                  decoration: InputDecoration(labelText: 'Address'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập địa chỉ';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _updateUser();
                    }
                  },
                  child: Text('Cập nhật'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _updateUser() async {
    // Gọi API để cập nhật người dùng ở đây
    final updatedUser = {
      'id': widget.user['id'],
      'firstName': _firstNameController.text,
      'lastName': _lastNameController.text,
      'address': _addressController.text,
    };

    try {
      final result = await UserRepository().updateUser(
        updatedUser['id'],
        updatedUser['firstName'],
        updatedUser['lastName'],
        updatedUser['address'],
      );

      if (result['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Cập nhật người dùng thành công')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${result['message']}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
    Navigator.pop(context, updatedUser);//khi cập nhật thành công, quay về màn hình trước
  }
}