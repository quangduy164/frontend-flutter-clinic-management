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
  late TextEditingController _genderController;
  late TextEditingController _roleIdController;
  late TextEditingController _phoneNumberController;
  late TextEditingController _positionIdController;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController(text: widget.user['firstName']);
    _lastNameController = TextEditingController(text: widget.user['lastName']);
    _addressController = TextEditingController(text: widget.user['address']);
    _genderController = TextEditingController(text: widget.user['gender']);
    _roleIdController = TextEditingController(text: widget.user['roleId']);
    _phoneNumberController = TextEditingController(text: widget.user['phoneNumber']);
    _positionIdController = TextEditingController(text: widget.user['positionId']);
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _addressController.dispose();
    _genderController.dispose();
    _roleIdController.dispose();
    _phoneNumberController.dispose();
    _positionIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true, // Tránh tràn màn hình khi mở bàn phím
        appBar: AppBar(
          title: SizedBox(
            height: 50,
            width: 150,
            child: Image.asset(
              'assets/images/logo.png',
              fit: BoxFit.contain, // Đảm bảo hình ảnh vừa với kích thước
            ),
          ),
        ),
        body: _getBody()
      ),
    );
  }

  Widget _getBody(){
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _firstNameController,
                decoration: const InputDecoration(labelText: 'First Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập tên';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _lastNameController,
                decoration: const InputDecoration(labelText: 'Last Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập họ';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(labelText: 'Address'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập địa chỉ';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _genderController,
                decoration: const InputDecoration(labelText: 'Gender'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập giới tính';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _roleIdController,
                decoration: const InputDecoration(labelText: 'RoleId'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập vai trò';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _phoneNumberController,
                decoration: const InputDecoration(labelText: 'PhoneNumber'),
              ),
              TextFormField(
                controller: _positionIdController,
                decoration: const InputDecoration(labelText: 'PositionId'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _updateUser();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:Colors.lightGreen,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text('Cập nhật', style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _updateUser() async {
    // Gọi API để cập nhật người dùng ở đây
    try {
      final result = await UserRepository().updateUser(
          widget.user['id'],
          _firstNameController.text,
          _lastNameController.text,
          _addressController.text,
          _genderController.text,
          _roleIdController.text,
        _phoneNumberController.text,
        _positionIdController.text
      );

      if (result['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cập nhật người dùng thành công')),
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
    Navigator.pop(context);//khi cập nhật thành công, quay về màn hình trước
  }
}