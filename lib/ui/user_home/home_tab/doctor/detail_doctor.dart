import 'dart:typed_data';

import 'package:clinic_management/data/repository/doctor_repository.dart';
import 'package:clinic_management/ui/user_home/home_tab/doctor/doctor_schedule_component.dart';
import 'package:flutter/material.dart';

class DetailDoctor extends StatefulWidget {
  final int doctorId;

  const DetailDoctor({super.key, required this.doctorId});

  @override
  State<StatefulWidget> createState() {
    return _DetailDoctorState();
  }
}

class _DetailDoctorState extends State<DetailDoctor> {
  Uint8List? _imageAvatar; // Dữ liệu ảnh dưới dạng byte
  String? _nameDoctor;
  String? _positionDoctor;
  String? _descriptionDoctor;
  String? _detailContentDoctor;

  @override
  void initState() {
    super.initState();
    _getDetailInforDoctor(); // lấy thông tin doctor
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
        body: _getBody(),
      ),
    );
  }

  Widget _getBody() {
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _doctorDescription(),
              DoctorScheduleComponent(doctorId: widget.doctorId),
              _doctorDetailContent()
            ],
          ),
        ),
      ],
    );
  }

  Widget _doctorDetailContent(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(),
        const Text('Khám và điều trị',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 5,),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5.0),
          child: Text('$_detailContentDoctor',
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
          ),
        ),
      ],
    );
  }

  Widget _doctorDescription(){
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start, // Căn đầu hàng
      children: [
        _imageAvatar != null
            ? CircleAvatar(
          radius: 34,
          backgroundImage: MemoryImage(_imageAvatar!),
        )
            : const CircleAvatar(
          radius: 34,
          backgroundImage: AssetImage('assets/images/user_avata.png'),
        ),
        const SizedBox(width: 15,),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // Căn trái cho text
            children: [
              Text('$_positionDoctor, $_nameDoctor',
                style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5,),
              Text('$_descriptionDoctor',
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.black54),
              ),
            ],
          ),
        )
      ],
    );
  }

  Future<void> _getDetailInforDoctor() async {
    try {
      // Gọi API lấy thông tin chi tiết doctor
      final doctor = await DoctorRepository().getDetailDoctorById(widget.doctorId);
      //lấy thông tin doctor
      _nameDoctor = '${doctor['lastName']} ${doctor['firstName']}';
      _positionDoctor = doctor['positionData']['valueVi'] ?? '';
      // Lấy ảnh từ API và kiểm tra tính hợp lệ
      Uint8List? image;
      if (doctor.containsKey('image') && doctor['image'] != null) {
        final List<int> imageData = List<int>.from(doctor['image']['data']);
        if (imageData.isNotEmpty) {
          setState(() {
            image = Uint8List.fromList(imageData);
          });
        } else {
          debugPrint('Dữ liệu hình ảnh rỗng.');
        }
      }
      // Cập nhật trạng thái bằng setState
      setState(() {
        _imageAvatar = image;
        _nameDoctor = '${doctor['lastName']} ${doctor['firstName']}';
        _positionDoctor = doctor['positionData']['valueVi'] ?? '';
        _descriptionDoctor = doctor['Markdown']['description'] ?? '';
        _detailContentDoctor = doctor['Markdown']['content'] ?? '';
      });
    } catch (e) {
      debugPrint('Lỗi khi tải thông tin doctor: $e');
    }
  }
}
