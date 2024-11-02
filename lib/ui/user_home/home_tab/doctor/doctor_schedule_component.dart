import 'package:clinic_management/data/repository/doctor_repository.dart';
import 'package:clinic_management/ui/user_home/home_tab/doctor/booking_modal.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; //để định dạng ngày

class DoctorScheduleComponent extends StatefulWidget {
  final int doctorId;
  final String? price;

  const DoctorScheduleComponent({
    super.key,
    required this.doctorId,
    required this.price
  });

  @override
  State<StatefulWidget> createState() {
    return _DoctorScheduleComponentState();
  }
}

class _DoctorScheduleComponentState extends State<DoctorScheduleComponent> {
  List<Map<String, dynamic>> schedules = [];//thời gian lịch khám
  List<Map<String, dynamic>> saveSchedules = [];//Lưu thời gian lịch khám
  bool isLoading = true; // Trạng thái loading
  String? _selectedDate; // Biến chọn ngày

  @override
  void initState() {
    _selectedDate = DateFormat('dd/MM/yyyy').format(DateTime.now());
    _fetchScheduleTimeByDate();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8), // Khoảng cách bên trong container
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSelectedDate(),
          const SizedBox(height: 15,),
          const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.calendar_month, size: 16,),
              SizedBox(width: 5,),
              Text('LỊCH KHÁM', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),),
            ],
          ),
          const SizedBox(height: 5,),
          _buildSchedulesTimeByDate(),
          const SizedBox(height: 5,),
          const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Chọn ', style: TextStyle(fontSize: 13)),
              Icon(CupertinoIcons.hand_thumbsup_fill, size: 15,),
              SizedBox(width: 5,),
              Text('và đặt (Phí đặt lịch 0đ)', style: TextStyle(fontSize: 13),),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSchedulesTimeByDate(){
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (schedules.isEmpty) {
      return const Center(child: Text('Không có lịch khám nào. Vui lòng chọn ngày khác'));
    }
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: schedules.map((schedule){
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: SizedBox(
              height: 32,
              width: 100,
              child: TextButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context) => BookingModal(
                        doctorId: widget.doctorId,
                        doctorName: '${schedule['doctorData']['lastName']} ${schedule['doctorData']['firstName']}',
                        schedule: schedule['timeTypeData']['valueVi'],
                        date: _selectedDate,
                        timeType: schedule['timeType'],
                        price: widget.price!,
                      )
                  ));
                },
                style: TextButton.styleFrom(
                  backgroundColor: Colors.grey.withOpacity(0.3),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  shape: const RoundedRectangleBorder(
                    side: BorderSide.none
                  ),
                ),
                child: Text(
                  schedule['timeTypeData']['valueVi'],
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.w500,
                      color: Colors.black
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSelectedDate(){
    return SizedBox(
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
            _fetchScheduleTimeByDate();
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

  Future<void> _fetchScheduleTimeByDate() async {
    try {
      // Lấy tất cả lịch khám theo ngày
      List<Map<String, dynamic>> fetchedSchedules =
      await DoctorRepository().getScheduleDoctorByDate(widget.doctorId, _selectedDate!);
      setState(() {
        //thêm trường isSelected cho mỗi schedule
        schedules = fetchedSchedules;
      });
    } catch (e) {
      // Xử lý lỗi nếu cần thiết
      debugPrint('Lỗi khi lấy danh sách lịch khám: $e');
    } finally {
      setState(() {
        isLoading = false; // Hoàn tất việc load dữ liệu
      });
    }
  }

}
