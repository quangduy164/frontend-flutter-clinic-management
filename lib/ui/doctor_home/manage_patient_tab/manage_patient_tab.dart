import 'dart:typed_data';

import 'package:clinic_management/data/repository/doctor_repository.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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
  Uint8List? _image; // Dữ liệu ảnh dưới dạng byte
  late bool _isChooseImage;//Biến đã chọn ảnh hay chưa
  String? emailPatient;
  String? namePatient;
  String? tokenBooking;//mã lịch hẹn
  String? timeType;
  String? genderPatient;
  String? addressPatient;

  @override
  void initState() {
    _selectedDate = DateTime.now();//đặt ngày hiện tại
    _isChooseImage = false;
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
        setState(() {
          tokenBooking = patient['token'] ?? '';
          namePatient = patient['patientData']['firstName'] ?? '';
          emailPatient = patient['patientData']['email'] ?? '';
          timeType = patient['timeTypeDataPatient']['valueVi'] ?? '';
          genderPatient = patient['patientData']['genderData']['valueVi'] ?? '';
          addressPatient = patient['patientData']['address'] ?? '';
        });
        return Padding(
          padding: const EdgeInsets.only(bottom: 5.0),
          child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.lightBlueAccent.withOpacity(0.1),
                border: Border.all(
                  color: Colors.grey, // Màu viền
                  width: 0.1, // Độ dày viền
                ),
              ),
              child: patientComponent()
          )
        );
      }).toList(),
    );
  }

  Widget patientComponent(){
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Căn trái cho text
          children: [
            Text(namePatient!,
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 3,),
            Text('Lịch khám: $timeType',
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w400, color: Colors.cyan),
            ),
            const SizedBox(height: 3,),
            Text(genderPatient!,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.black54),
            ),
            const SizedBox(height: 3,),
            Text(addressPatient!,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.black54),
            ),
          ],
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextButton(
                  onPressed: (){
                    _confirmPatient(context);
                  },
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
            ],
          ),
        ),
        const SizedBox(width: 5,)
      ],
    );
  }

  // Hộp thoại xác nhận gửi hóa đơn
  void _confirmPatient(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true, // Đóng modal khi nhấn ra ngoài
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15), // Bo góc modal
              ),
              title: const Text(
                'Gửi hóa đơn khám bệnh',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Email: nguyenvana@gmail.com'),
                  const SizedBox(height: 5),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () async {
                          Uint8List? img = await _pickImage(ImageSource.gallery);
                          if (img != null) {
                            setState(() {
                              _image = img;
                              _isChooseImage = true;
                            });
                          }
                        },
                        style: TextButton.styleFrom(
                          shape: const RoundedRectangleBorder(
                            side: BorderSide(color: Colors.grey, width: 1), // Viền cho TextButton
                          ),
                        ),
                        child: const Text(
                          'Chọn hóa đơn bệnh nhân',
                          style: TextStyle(color: Colors.cyan),
                        ),
                      ),
                      Text(
                        (_isChooseImage) ? 'Đã chọn ảnh' : 'Chưa chọn ảnh',
                        style: TextStyle(
                          color: (_isChooseImage) ? Colors.black : Colors.red,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 5),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    _sendRemedy();
                    setState(() {
                      _image = null;
                      _isChooseImage = false;
                    });
                    Navigator.pop(context); // Đóng modal
                  },
                  child: const Text('Xác nhận', style: TextStyle(color: Colors.blue)),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _image = null;
                      _isChooseImage = false;
                    });
                    Navigator.pop(context); // Đóng modal
                  },
                  child: const Text('Hủy bỏ', style: TextStyle(color: Colors.red)),
                ),
              ],
            );
          },
        );
      },
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

  void _sendRemedy() async {
    // Gọi API để cập nhật người dùng ở đây
    try {
      final result = await DoctorRepository().sendRemedy(
          widget.doctorId,
          emailPatient!,
          namePatient!,
          _image!,
          tokenBooking!
      );

      if (result['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gửi hóa đơn thành công')),
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

  // Làm mới danh sách
  Future<void> _refreshListPatients() async {
    setState(() {
      _fetchAllPatientsByDate();
    });
  }
}
