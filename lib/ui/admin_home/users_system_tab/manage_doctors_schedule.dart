import 'package:clinic_management/data/repository/doctor_repository.dart';
import 'package:flutter/material.dart';

class ManageDoctorsSchedule extends StatefulWidget {
  const ManageDoctorsSchedule({super.key});

  @override
  _ManageDoctorsScheduleState createState() => _ManageDoctorsScheduleState();
}

class _ManageDoctorsScheduleState extends State<ManageDoctorsSchedule> {
  late TextEditingController _descriptionController = TextEditingController();
  late TextEditingController _contentController = TextEditingController();

  late Future<List<Map<String, dynamic>>> futureGetAllDoctors;
  final DoctorRepository _doctorRepository = DoctorRepository();
  String? _selectedDoctorId; // Biến chọn doctorId
  late String _action;//Biến chọn create/update data

  @override
  void initState() {
    futureGetAllDoctors = _doctorRepository.getAllDoctors();
    _action = 'CREATE';
    super.initState();
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _contentController.dispose();
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
          //xây dựng dropdownButton để chọn doctor dựa trên kết quả của Future là futureGetAllUsers
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
          _doctorDescription(),
          const SizedBox(height: 15),
          _doctorDetailContent(),
          const SizedBox(height: 15),
          _buttonSaveInforDoctor()
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
          //Lấy description và content từ api
          if (_selectedDoctorId != null) {
            _getDetailInforDoctor(int.parse(_selectedDoctorId!));
          } else {
            _descriptionController.clear();//nếu k chọn thì clear controller
            _contentController.clear();
          }
        });
      },
    );
  }

  Widget _doctorDescription() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Thông tin giới thiệu',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const SizedBox(height: 5),
        _buildScrollableTextField(_descriptionController),
      ],
    );
  }

  Widget _doctorDetailContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Thông tin chi tiết',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const SizedBox(height: 5),
        _buildScrollableTextField(_contentController),
      ],
    );
  }

  Widget _buildScrollableTextField(TextEditingController controller) {
    return SizedBox(
      height: 150, // Cố định chiều cao để tránh tràn
      child: TextField(
        controller: controller,
        maxLines: null, // Cho phép nhiều dòng
        expands: true, // Giúp TextField mở rộng bên trong SizedBox
        textAlign: TextAlign.start, // Căn trái văn bản
        textAlignVertical: TextAlignVertical.top, // Căn văn bản lên trên cùng
        scrollPhysics: const BouncingScrollPhysics(),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 15,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.grey, width: 1.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.blue, width: 1.2),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }

  Widget _buttonSaveInforDoctor(){
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: (_action == 'UPDATE') ? Colors.lightGreen : Colors.lightBlue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        onPressed: (){
          _saveInforDoctor(_action);
        },
        child: Text(
          (_action == 'UPDATE') ? 'Lưu thông tin' : 'Tạo thông tin',
          style: const TextStyle(fontSize: 16, color: Colors.white),
        )
    );
  }

  void _saveInforDoctor(String action) async {
    // Gọi API để cập nhật người dùng ở đây
    try {
      final result = await _doctorRepository.saveInforDoctor(
          int.parse(_selectedDoctorId!),
          _contentController.text,
          _descriptionController.text,
          _action
      );

      if (result['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Lưu thông tin bác sĩ thành công')),
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

  Future<void> _getDetailInforDoctor(int doctorId) async {
    try {
      // Gọi API lấy thông tin chi tiết doctor
      final doctor = await DoctorRepository().getDetailDoctorById(doctorId);
      // Cập nhật trạng thái bằng setState
      setState(() {
        _descriptionController = TextEditingController(text: doctor['Markdown']['description']);
        _contentController = TextEditingController(text: doctor['Markdown']['content']);
        _contentController.text.isNotEmpty ? _action = 'UPDATE' : _action = 'CREATE';
      });
    } catch (e) {
      debugPrint('Lỗi khi tải thông tin doctor: $e');
    }
  }

  // Làm mới danh sách user
  Future<void> _refreshListDoctors() async {
    setState(() {
      futureGetAllDoctors = _doctorRepository.getAllDoctors(); // Cập nhật lại future
    });
  }
}
