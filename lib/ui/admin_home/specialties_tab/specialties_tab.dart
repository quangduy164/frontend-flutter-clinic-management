import 'dart:typed_data';

import 'package:clinic_management/data/repository/specialty_repository.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SpecialtiesTab extends StatefulWidget{
  const SpecialtiesTab({super.key});

  @override
  State<StatefulWidget> createState() {
    return _SpecialtiesTabState();
  }
}

class _SpecialtiesTabState extends State<SpecialtiesTab>{
  Uint8List? _image; // Dữ liệu ảnh dưới dạng byte
  late TextEditingController _nameSpecialtyController = TextEditingController();
  late TextEditingController _descriptionSpecialtyController = TextEditingController();

  late bool _isChooseImage;//Biến đã chọn ảnh hay chưa

  @override
  void initState() {
    _isChooseImage = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _getBody()
    );
  }

  Widget _getBody() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _getManageSpecialty()
            ],
          ),
        ),
      )
    );
  }

  Widget _getManageSpecialty(){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          const SizedBox(height: 10),
          const Text(
            'Management Specialty',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          _specialyDetailContent('Tên chuyên khoa', _nameSpecialtyController, 45),
          const SizedBox(height: 10),
          _specialyDetailContent('Mô tả chuyên khoa', _descriptionSpecialtyController, 100),
          const SizedBox(height: 15),
          _buttonUploadImage(),
          const SizedBox(height: 25),
          _buttonSaveInfoSpecialty(),
        ],
      ),
    );
  }

  Widget _specialyDetailContent(String title, TextEditingController controller, double heightTextField) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 5,),
        Text(title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const SizedBox(height: 5),
        _buildScrollableTextField(controller, heightTextField),
      ],
    );
  }

  Widget _buildScrollableTextField(
      TextEditingController controller, double heightTextField) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10,),
        SizedBox(
          height: heightTextField, // Cố định chiều cao để tránh tràn
          child: TextField(
            controller: controller,
            maxLines: null, // Cho phép nhiều dòng
            expands: true, // Giúp TextField mở rộng bên trong SizedBox
            textAlign: TextAlign.start, // Căn trái văn bản
            textAlignVertical: TextAlignVertical.center, // Căn văn bản lên giữa
            scrollPhysics: const BouncingScrollPhysics(),
            decoration: const InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 5,
              ),
              border: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey, width: 0.5),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.cyan, width: 1.0),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buttonUploadImage(){
    return Column(
      children: [
        ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0),
              ),
            ),
            onPressed: (){
              selectImage();
            },
            child: const Text(
              'Chọn ảnh chuyên khoa',
              style: TextStyle(fontSize: 14, color: Colors.black),
            )
        ),
        Text((_isChooseImage) ? 'Đã chọn ảnh' : 'Chưa chọn ảnh',
          style: TextStyle(
              color: (_isChooseImage) ? Colors.black : Colors.red,
              fontSize: 12,
              fontWeight: FontWeight.w500),
        )
      ],
    );
  }

  Widget _buttonSaveInfoSpecialty(){
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blueAccent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        onPressed: (){
          _saveInforSpecialty();
        },
        child: const Text(
          'Lưu thông tin',
          style: TextStyle(fontSize: 16, color: Colors.white),
        )
    );
  }

  // Hàm chọn ảnh từ thư viện
  void selectImage() async {
    Uint8List? img = await _pickImage(ImageSource.gallery);
    if (img != null) {
      setState(() {
        _image = img;
        _isChooseImage = true;
      });
    }
  }

  // Hàm mở ImagePicker và trả về ảnh dưới dạng Uint8List
  Future<Uint8List?> _pickImage(ImageSource source) async {
    final ImagePicker imagePicker = ImagePicker();
    XFile? file = await imagePicker.pickImage(source: source);
    if (file != null) {
      return await file.readAsBytes(); // Đọc ảnh dưới dạng byte
    }
    debugPrint('No Image Selected');
    return null;
  }

  void _saveInforSpecialty() async {
    // Gọi API để cập nhật người dùng ở đây
    try {
      final result = await SpecialtyRepository().createNewSpecialty(
          _nameSpecialtyController.text,
          _image!,
          _descriptionSpecialtyController.text
      );

      if (result['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Lưu thông tin chuyên khoa thành công')),
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
  }

}