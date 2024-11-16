import 'package:clinic_management/ui/user_home/home_tab/doctor/profile_doctor_component.dart';
import 'package:flutter/material.dart';

import '../doctor/doctor_extra_info_component.dart';
import '../doctor/doctor_schedule_component.dart';

class DoctorComponent extends StatefulWidget {
  final int doctorId;

  const DoctorComponent({
    super.key,
    required this.doctorId,
  });

  @override
  State<StatefulWidget> createState() {
    return _DoctorComponentState();
  }
}

class _DoctorComponentState extends State<DoctorComponent> {
  String? _price; // Biến để lưu giá từ callback của DoctorExtraInfoComponent

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        border: Border.all(
          color: Colors.grey, // Màu viền
          width: 0.2, // Độ dày viền
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1), // Màu bóng mờ
            blurRadius: 6, // Độ mờ của bóng
            offset: const Offset(0, 3), // Độ lệch của bóng (x, y)
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15.0),
        child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProfileDoctorComponent(
                  doctorId: widget.doctorId,
                  isShowDescriptionDoctor: true,
                  schedule: null,
                  date: null),
              DoctorScheduleComponent(
                doctorId: widget.doctorId,
                price: _price,
              ),
              DoctorExtraInfoComponent(
                doctorId: widget.doctorId,
                onPriceFetched: (price) {
                  setState(() {
                    _price = price;
                  });
                },
              ),
            ]),
      ),
    );
  }
}
