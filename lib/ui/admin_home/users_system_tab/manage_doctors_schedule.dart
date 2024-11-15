import 'package:clinic_management/data/repository/doctor_repository.dart';
import 'package:clinic_management/data/repository/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ManageDoctorsSchedule extends StatefulWidget {
  const ManageDoctorsSchedule({super.key});

  @override
  _ManageDoctorsScheduleState createState() => _ManageDoctorsScheduleState();
}

class _ManageDoctorsScheduleState extends State<ManageDoctorsSchedule> {

  late Future<List<Map<String, dynamic>>> futureGetAllDoctors;
  List<Map<String, dynamic>> schedules = [];//thời gian lịch khám
  List<Map<String, dynamic>> saveSchedules = [];//Lưu thời gian lịch khám
  bool isLoading = true; // Trạng thái loading
  final DoctorRepository _doctorRepository = DoctorRepository();
  String? _selectedDoctorId; // Biến chọn doctorId
  DateTime? _selectedDate;//biến chọn ngày

  @override
  void initState() {
    futureGetAllDoctors = _doctorRepository.getAllDoctors();
    _fetchAllScheduleTime();
    super.initState();
  }

  @override
  void dispose() {
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
        body: _getBody(),
      ),
    );
  }

  Widget _getBody() {
    return RefreshIndicator(
      onRefresh: _refreshListDoctors,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _getDoctorsList(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _getDoctorsList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          const SizedBox(height: 10),
          const Text(
            'Management Doctors Schedule',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          //xây dựng dropdownButton để chọn doctor dựa trên kết quả của Future là futureGetAllDoctors
          FutureBuilder<List<Map<String, dynamic>>>(
            future: futureGetAllDoctors,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Text('Lỗi: ${snapshot.error}');
              } else {
                final doctors = snapshot.data!;
                return _buildDropdownButton(doctors);
              }
            },
          ),
          const SizedBox(height: 15),
          _buildSelectedDate(),
          const SizedBox(height: 15,),
          _buildAllScheduleTime(),
          const SizedBox(height: 15,),
          _buttonSaveInforDoctor()
        ],
      ),
    );
  }

  Widget _buildAllScheduleTime() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (schedules.isEmpty) {
      return const Center(child: Text('Không có lịch khám nào.'));
    }
    return Container(
      padding: const EdgeInsets.all(8), // Khoảng cách trong Container
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 1),
        borderRadius: BorderRadius.circular(5),
      ),
      child: GridView.builder(
        shrinkWrap: true, // Thu gọn kích thước theo nội dung
        physics: const NeverScrollableScrollPhysics(), // Tắt cuộn bên trong GridView
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // 2 phần tử mỗi hàng
          mainAxisSpacing: 8, // Khoảng cách dọc giữa các hàng
          crossAxisSpacing: 8, // Khoảng cách ngang giữa các phần tử
          childAspectRatio: 3, // Tỉ lệ giữa chiều rộng và chiều cao của mỗi nút
        ),
        itemCount: schedules.length,
        itemBuilder: (context, index) {
          final schedule = schedules[index];
          bool isSelected = schedules[index]['isSelected'] ?? false; // Lấy trạng thái isSelected
          return TextButton(
            onPressed: () {
              // Chuyển đổi trạng thái isSelected
              setState(() {
                schedules[index]['isSelected'] = !isSelected;
              });
            },
            style: TextButton.styleFrom(
              backgroundColor: isSelected ? Colors.lightBlueAccent : Colors.white,
              padding: const EdgeInsets.all(10),
              shape: RoundedRectangleBorder(
                side: const BorderSide(color: Colors.grey, width: 1),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              schedule['valueVI'],
              style: TextStyle(
                  fontSize: 12, fontWeight: FontWeight.w500,
                  color: isSelected ? Colors.white : Colors.black
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSelectedDate() {
    return TextButton(
      onPressed: () async {
        final DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime(2026),
        );
        if (pickedDate != null) {
          setState(() {
            // Format ngày thành chuỗi dễ đọc
            _selectedDate = pickedDate;// Lưu dưới dạng DateTime
          });
        }
      },
      style: TextButton.styleFrom(
        padding: const EdgeInsets.all(10), // Khoảng cách bên trong nút
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Colors.grey, width: 1), // Viền cho TextButton
          borderRadius: BorderRadius.circular(10), // Bo góc
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // Căn chỉnh các phần tử trong dòng
        children: [
          const Text(
            'Chọn ngày',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: Colors.black,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5), // Khoảng cách trong Container
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey, width: 1), // Viền cho Container
              borderRadius: BorderRadius.circular(5), // Bo góc nhẹ
            ),
            child: Text(
              _selectedDate != null
                  ? _formatDate(_selectedDate!)  // Hiển thị dạng DD/MM/YYYY
                  : 'Chưa chọn ngày',
              style: const TextStyle(color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownButton(List<Map<String, dynamic>> doctors){
    return DropdownButtonFormField<String>(
      decoration: const InputDecoration(
        icon: Icon(Icons.person),
        labelText: 'Chọn bác sĩ',
      ),
      value: _selectedDoctorId,
      items: doctors.map((doctor) {
        // Tạo DropdownMenuItem từ mỗi bác sĩ trong danh sách
        return DropdownMenuItem<String>(
          value: doctor['id'].toString(), // Dùng ID làm giá trị
          child: Text('${doctor['lastName']} ${doctor['firstName']}'), // Hiển thị tên bác sĩ
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedDoctorId = value;
        });
      },
    );
  }

  Widget _buttonSaveInforDoctor(){
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.lightGreen,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        onPressed: (){
          _saveBulkCreateSchedule();
        },
        child: const Text(
          'Lưu thông tin',
          style: const TextStyle(fontSize: 16, color: Colors.white),
        )
    );
  }

  Future<void> _fetchAllScheduleTime() async {
    try {
      List<Map<String, dynamic>> fetchedSchedules =
      await UserRepository().getAllCode('TIME'); // Lấy tất cả lịch khám
      setState(() {
        //thêm trường isSelected cho mỗi schedule
        schedules = fetchedSchedules.map((schedule){
          return {
            ...schedule,
            'isSelected': false,
          };
        }).toList();
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

  void _saveBulkCreateSchedule() async {
    if (_selectedDoctorId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng chọn bác sĩ')),
      );
      return;
    }

    if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng chọn ngày')),
      );
      return;
    }

    saveSchedules.clear(); // Đảm bảo danh sách rỗng trước khi thêm mới

    // Thêm lịch khám đã chọn vào danh sách
    schedules.forEach((schedule) {
      if (schedule['isSelected'] ?? false) {
        saveSchedules.add({
          'doctorId': _selectedDoctorId,
          'date': DateFormat('dd/MM/yyyy').format(_selectedDate!), //Định dạng lại ngày
          'timeType': schedule['keyMap'],
        });
      }
    });

    try {
      final result = await _doctorRepository.saveBulkCreateSchedule(saveSchedules);

      if (result['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Lưu thông tin lịch khám thành công')),
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

  //format DateTime thành DD/mm/yyyy
  String _formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}/"
        "${date.month.toString().padLeft(2, '0')}/"
        "${date.year}";
  }

  // Làm mới danh sách user
  Future<void> _refreshListDoctors() async {
    setState(() {
      futureGetAllDoctors = _doctorRepository.getAllDoctors(); // Cập nhật lại future
      _fetchAllScheduleTime();
    });
  }
}
