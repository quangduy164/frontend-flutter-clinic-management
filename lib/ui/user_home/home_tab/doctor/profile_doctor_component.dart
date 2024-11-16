import 'dart:typed_data';

import 'package:clinic_management/data/repository/doctor_repository.dart';
import 'package:flutter/material.dart';

import 'detail_doctor.dart';

class ProfileDoctorComponent extends StatefulWidget {
  final int doctorId;
  final bool isShowDescriptionDoctor;
  final bool isShowSeeMore;
  final String? schedule;
  final String? date;
  const ProfileDoctorComponent({
    super.key,
    required this.doctorId,
    required this.isShowDescriptionDoctor,
    required this.isShowSeeMore,
    required this.schedule,
    required this.date
  });

  @override
  State<StatefulWidget> createState() {
    return _ProfileDoctorComponentState();
  }
}

class _ProfileDoctorComponentState extends State<ProfileDoctorComponent> {
  Uint8List? _imageAvatar; // Dữ liệu ảnh dưới dạng byte
  String? _nameDoctor;
  String? _positionDoctor;
  String? _descriptionDoctor;

  @override
  void initState() {
    super.initState();
    _getProfileInforDoctor(); // lấy thông tin doctor
  }

  @override
  Widget build(BuildContext context) {
    return widget.isShowDescriptionDoctor ? _doctorDescription() : _scheduleInfor();
  }

  Widget _scheduleInfor(){
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
        const SizedBox(width: 25,),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // Căn trái cho text
            children: [
              const Text('ĐẶT LỊCH KHÁM',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black54
                  )
              ),
              Text('$_positionDoctor, $_nameDoctor',
                style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.cyan),
              ),
              const SizedBox(height: 5,),
              Text('${widget.schedule!} - ${widget.date}',
                style: const TextStyle(fontSize: 14),),
              const Text('Miễn phí đặt lịch',
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 5,),
            ],
          ),
        )
      ],
    );
  }

  Widget _doctorDescription(){
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start, // Căn đầu hàng
      children: [
        Column(
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
            const SizedBox(height: 15,),
            widget.isShowSeeMore ?
            TextButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) => DetailDoctor(doctorId: widget.doctorId,)
                ));
              },
              child: const Text('Xem thêm',
                  style: TextStyle(fontSize: 14, color: Colors.cyan))
            )
                : const Text('')
          ],
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

  Future<void> _getProfileInforDoctor() async {
    try {
      // Gọi API lấy thông tin chi tiết doctor
      final doctor = await DoctorRepository().getProfileDoctorById(widget.doctorId);
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
      });
    } catch (e) {
      debugPrint('Lỗi khi tải profile doctor: $e');
    }
  }
}
