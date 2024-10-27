import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; //để định dạng ngày

class DoctorSchedule extends StatefulWidget {
  final int doctorId;

  const DoctorSchedule({super.key, required this.doctorId});

  @override
  State<StatefulWidget> createState() {
    return _DoctorScheduleState();
  }
}

class _DoctorScheduleState extends State<DoctorSchedule> {
  String? _selectedDate; // Biến chọn ngày

  @override
  void initState() {
    _selectedDate = DateFormat('dd/MM/yyyy').format(DateTime.now());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8), // Khoảng cách bên trong container
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 158, // Thu hẹp chiều rộng của dropdown
            child: DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                isDense: true, // Thu gọn khoảng cách giữa các thành phần
                contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.black, // Màu của viền
                    width: 0.5, // Độ dày của viền mỏng hơn
                  ),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.black, // Màu khi được chọn
                    width: 0.5, // Độ dày nhẹ hơn khi focus
                  ),
                ),
              ),
              value: _selectedDate,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.blue, // Điều chỉnh cỡ chữ
              ),
              items: _getNext5Days(), //lấy 5 ngày tiếp theo
              onChanged: (value) {
                setState(() {
                  _selectedDate = value;
                });
              },
              dropdownColor: Colors.white, // Màu nền dropdown
              icon: const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: Colors.blue, // Đổi màu biểu tượng
                size: 24, // Kích thước biểu tượng
              ),
              iconSize: 24,
            ),
          ),
        ],
      ),
    );
  }

  // Hàm lấy 5 ngày tiếp theo từ hôm nay
  List<DropdownMenuItem<String>> _getNext5Days() {
    List<DropdownMenuItem<String>> items = [];
    for (int i = 0; i < 5; i++) {
      DateTime date = DateTime.now().add(Duration(days: i));
      String displayDate = DateFormat('EEEE - dd/MM').format(date); // Hiển thị
      String storageDate = DateFormat('dd/MM/yyyy').format(date); // Lưu trữ
      items.add(
        DropdownMenuItem(
          value: storageDate,
          child: Text(displayDate, style: const TextStyle(color: Colors.blue)),
        ),
      );
    }
    return items;
  }
}
