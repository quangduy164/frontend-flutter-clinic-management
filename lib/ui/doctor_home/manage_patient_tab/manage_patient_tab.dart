import 'package:clinic_management/data/repository/doctor_repository.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ManagePatientTab extends StatefulWidget {
  final int doctorId;

  const ManagePatientTab({super.key, required this.doctorId});

  @override
  _ManagePatientTabState createState() => _ManagePatientTabState();
}

class _ManagePatientTabState extends State<ManagePatientTab> {

  List<Map<String, dynamic>> patients = [];//thời gian lịch khám
  bool isLoading = true; // Trạng thái loading
  DateTime? _selectedDate;//biến chọn ngày

  @override
  void initState() {
    _selectedDate = DateTime.now();//đặt ngày hiện tại
    _fetchAllPatientsByDate();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _getBody(),
    );
  }

  Widget _getBody() {
    return RefreshIndicator(
      onRefresh: _refreshListPatients,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _getPatientsList(),
            ],
          ),
        ),
      )
    );
  }

  Widget _getPatientsList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          const SizedBox(height: 10),
          const Text(
            'Management Patient',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 35),
          _buildSelectedDate(),
          const SizedBox(height: 15,),
          _buildListPatientByDate()
        ],
      ),
    );
  }

  Widget _buildListPatientByDate() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (patients.isEmpty) {
      return const Center(child: Text('Không có bệnh nhân đặt lịch.'));
    }
    return Column(
      children: patients.map((patient) {
        final name = patient['patientData']['firstName'] ?? '';
        final timeType = patient['timeTypeDataPatient']['valueVi'] ?? '';
        final gender = patient['patientData']['genderData']['valueVi'] ?? '';
        final address = patient['patientData']['address'] ?? '';
        return Padding(
          padding: const EdgeInsets.only(bottom: 5.0),
          child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.lightBlueAccent.withOpacity(0.1),
                border: Border.all(
                  color: Colors.grey, // Màu viền
                  width: 0.1, // Độ dày viền
                ),
              ),
              child: patientComponent(name, timeType, gender, address)
          )
        );
      }).toList(),
    );
  }

  Widget patientComponent(String name, String timeType, String gender, String address){
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Căn trái cho text
          children: [
            Text(name,
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 3,),
            Text('Lịch khám: $timeType',
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w400, color: Colors.cyan),
            ),
            const SizedBox(height: 3,),
            Text(gender,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.black54),
            ),
            const SizedBox(height: 3,),
            Text(address,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.black54),
            ),
          ],
        ),
        Expanded(
          child: Column(
            children: [
              TextButton(
                  onPressed: (){},
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.all(10), // Khoảng cách bên trong nút
                    backgroundColor: Colors.orangeAccent,
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(color: Colors.grey, width: 1), // Viền cho TextButton
                      borderRadius: BorderRadius.circular(10), // Bo góc
                    ),
                  ),
                  child: const Text('Xác nhận', style: TextStyle(fontSize: 12, color: Colors.white),)
              ),
              TextButton(
                  onPressed: (){},
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.all(10), // Khoảng cách bên trong nút
                    backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(color: Colors.grey, width: 1), // Viền cho TextButton
                      borderRadius: BorderRadius.circular(10), // Bo góc
                    ),
                  ),
                  child: const Text('Gửi hóa đơn', style: TextStyle(fontSize: 12, color: Colors.white))
              )
            ],
          ),
        )
      ],
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
          _refreshListPatients(); // Gọi lại API để lấy danh sách patients
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

  Future<void> _fetchAllPatientsByDate() async {
    try {
      patients = await DoctorRepository().getListPatientForDoctorByDate(
        widget.doctorId,
        DateFormat('dd/MM/yyyy').format(_selectedDate!), //Định dạng lại ngày
      ); // Lấy tất cả patient
    } catch (e) {
      // Xử lý lỗi nếu cần thiết
      debugPrint('Lỗi khi lấy danh sách patient: $e');
    } finally {
      setState(() {
        isLoading = false; // Hoàn tất việc load dữ liệu
      });
    }
  }

  //format DateTime thành DD/mm/yyyy
  String _formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}/"
        "${date.month.toString().padLeft(2, '0')}/"
        "${date.year}";
  }

  // Làm mới danh sách
  Future<void> _refreshListPatients() async {
    setState(() {
      _fetchAllPatientsByDate();
    });
  }
}
