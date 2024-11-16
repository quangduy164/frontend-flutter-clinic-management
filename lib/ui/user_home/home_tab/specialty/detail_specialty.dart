import 'package:flutter/material.dart';

import 'doctor_component.dart';

class DetailSpecialty extends StatefulWidget {
  final int specialtyId;

  const DetailSpecialty({super.key, required this.specialtyId});

  @override
  State<StatefulWidget> createState() {
    return _DetailSpecialtyState();
  }
}

class _DetailSpecialtyState extends State<DetailSpecialty> {
  List<int> doctor = [47, 49];

  @override
  void initState() {
    super.initState();
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
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _specialtyDescription(),
              DoctorComponent(doctorId: 47,),
              const SizedBox(height: 10,),
              DoctorComponent(doctorId: 49,),
            ],
          ),
        ),
      ],
    );
  }

  Widget _specialtyDescription(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Cơ xương khớp',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 5,),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5.0),
          child: Text('Mô tả',
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
          ),
        ),
      ],
    );
  }
}
