import 'dart:typed_data'; // Sử dụng Uint8List cho ảnh

import 'package:clinic_management/ui/user_home/pesonal_tab/item_section.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../data/repository/user_repository.dart';


class PesonalTab extends StatefulWidget {
  final String email;
  const PesonalTab({super.key, required this.email});

  @override
  State<StatefulWidget> createState() {
    return _PesonalTabState();
  }
}

class _PesonalTabState extends State<PesonalTab> {
  Uint8List? _imageAvatar; // Dữ liệu ảnh dưới dạng byte

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _getBody(),
    );
  }

  Widget _getBody() {
    return Stack(
      children: [
        Container(
          color: Colors.lightBlueAccent,
        ),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _imageAvatar != null
                  ? CircleAvatar(
                radius: 54,
                backgroundImage: MemoryImage(_imageAvatar!),
              )
                  : const CircleAvatar(
                radius: 54,
                backgroundImage: AssetImage('assets/images/user_avata.png'),
              ),
              const SizedBox(height: 20),
              ItemSection(
                function: selectImage, // Gọi hàm chọn ảnh khi bấm
                icon: Icons.add_a_photo,
                text: 'Thêm ảnh đại diện',
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Hàm chọn ảnh từ thư viện
  void selectImage() async {
    Uint8List? img = await _pickImage(ImageSource.gallery);
    if (img != null) {
      setState(() {
        _imageAvatar = img;
      });

      // Gọi API cập nhật ảnh
      try {
        final result = await UserRepository().updateUserImage(widget.email, img);
        if (result['success']) {
          debugPrint("Cập nhật ảnh thành công");
        } else {
          debugPrint("Lỗi: ${result['message']}");
        }
      } catch (e) {
        debugPrint("Lỗi khi cập nhật ảnh: $e");
      }
    }
  }

  // Hàm mở ImagePicker và trả về ảnh dưới dạng Uint8List
  Future<Uint8List?> _pickImage(ImageSource source) async {
    final ImagePicker imagePicker = ImagePicker();
    XFile? file = await imagePicker.pickImage(source: source);
    if (file != null) {
      return await file.readAsBytes(); // Đọc ảnh dưới dạng byte
    }
    print('No Image Selected');
    return null;
  }
}
