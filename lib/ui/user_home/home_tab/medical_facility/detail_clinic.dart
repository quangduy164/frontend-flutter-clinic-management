import 'dart:typed_data';

import 'package:clinic_management/data/repository/clinic_repository.dart';
import 'package:clinic_management/ui/user_home/home_tab/specialty/doctor_component.dart';
import 'package:flutter/material.dart';

class DetailClinic extends StatefulWidget {
  final int clinicId;

  const DetailClinic({super.key, required this.clinicId});

  @override
  State<StatefulWidget> createState() {
    return _DetailClinicState();
  }
}

class _DetailClinicState extends State<DetailClinic> {
  List<dynamic> doctorClinic = [];//danh sách bác sĩ của phòng khám
  Uint8List? _image; // Dữ liệu ảnh dưới dạng byte
  String? _nameClinic;
  String? _addressClinic;
  String? _introduceClinic;
  String? _strengthsClinic;
  bool isLoading = true; // Trạng thái loading

  @override
  void initState() {
    super.initState();
    _getDetailInforClinic(); // lấy thông tin clinic
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
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _clinicDescription(),
              const SizedBox(height: 10,),
              _clinicIntroduction(),
              const SizedBox(height: 10,),
              _clinicStrengths(),
              const SizedBox(height: 10,),
              _getListDoctorClinic()
            ],
          ),
        ),
      ],
    );
  }

  Widget _clinicDescription(){
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.lightBlueAccent.withOpacity(0.4),
        border: Border.all(
          color: Colors.grey, // Màu viền
          width: 0.1, // Độ dày viền
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start, // Căn đầu hàng
        children: [
          _image != null
              ? Image.memory(
            _image!,
            height: 75,
            width: 90,
            fit: BoxFit.contain,
          )
              : Image.asset(
            'assets/images/user_avata.png',
            height: 75,
            fit: BoxFit.contain,
          ),
          const SizedBox(width: 15,),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // Căn trái cho text
              children: [
                Text('$_nameClinic',
                  style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5,),
                Text('$_addressClinic',
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: Colors.black54),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _clinicIntroduction(){
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white70,
        border: Border.all(
          color: Colors.grey, // Màu viền
          width: 0.1, // Độ dày viền
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 5,),
          const Text('GIỚI THIỆU',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.blueAccent),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5),
            child: Text('$_introduceClinic',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
            ),
          ),
        ],
      ),
    );
  }

  Widget _clinicStrengths(){
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white70,
        border: Border.all(
          color: Colors.grey, // Màu viền
          width: 0.1, // Độ dày viền
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10,),
          const Text('THẾ MẠNH CHUYÊN MÔN',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.blueAccent),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5),
            child: Text('$_strengthsClinic',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
            ),
          ),
          const SizedBox(height: 10,),
        ],
      ),
    );
  }

  Widget _getListDoctorClinic() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (doctorClinic.isEmpty) {
      return const Center(
        child: Text('Không tìm thấy bác sĩ.'),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: doctorClinic.map((doctor) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: DoctorComponent(
            doctorId: doctor['doctorId'],
          ),
        );
      }).toList(),
    );
  }

  Future<void> _getDetailInforClinic() async {
    setState(() {
      isLoading = true; // Bắt đầu trạng thái tải
    });
    try {
      // Gọi API lấy thông tin chi tiết
      final clinic = await ClinicRepository().getDetailClinicById(widget.clinicId);
      // Lấy ảnh từ API và kiểm tra tính hợp lệ
      Uint8List? image;
      if (clinic.containsKey('image') && clinic['image'] != null) {
        final List<int> imageData = List<int>.from(clinic['image']['data']);
        if (imageData.isNotEmpty) {
          setState(() {
            image = Uint8List.fromList(imageData);
          });
        } else {
          debugPrint('Dữ liệu hình ảnh rỗng.');
        }
      }
      setState(() {
        _image = image;
        _nameClinic = clinic['name'] ?? '';
        _addressClinic = clinic['address'] ?? '';
        _introduceClinic = clinic['introduce'] ?? '';
        _strengthsClinic = clinic['strengths'] ?? '';
        doctorClinic = clinic['doctorClinic'] ?? [];
      });
    } catch (e) {
      debugPrint('Lỗi khi tải thông tin detail clinic: $e');
    } finally {
      setState(() {
        isLoading = false; // Kết thúc trạng thái tải
      });
    }
  }
}
