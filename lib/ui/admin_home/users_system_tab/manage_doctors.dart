import 'package:clinic_management/data/repository/doctor_repository.dart';
import 'package:clinic_management/data/repository/specialty_repository.dart';
import 'package:clinic_management/data/repository/user_repository.dart';
import 'package:flutter/material.dart';

import '../../../data/repository/clinic_repository.dart';

class ManageDoctors extends StatefulWidget {
  const ManageDoctors({super.key});

  @override
  _ManageDoctorsState createState() => _ManageDoctorsState();
}

class _ManageDoctorsState extends State<ManageDoctors> {
  late TextEditingController _descriptionController = TextEditingController();
  late TextEditingController _contentController = TextEditingController();
  late TextEditingController _nameClinicController = TextEditingController();
  late TextEditingController _addressClinicController = TextEditingController();
  late TextEditingController _noteController = TextEditingController();

  late Future<List<Map<String, dynamic>>> futureGetAllDoctors;
  late Future<List<Map<String, dynamic>>> futureGetAllPrices;
  late Future<List<Map<String, dynamic>>> futureGetAllPayments;
  late Future<List<Map<String, dynamic>>> futureGetAllProvinces;

  late Future<List<Map<String, dynamic>>> futureGetAllSpecialties;
  late Future<List<Map<String, dynamic>>> futureGetAllClinics;

  String? _selectedDoctorId; // Biến chọn doctorId
  String? _selectedPrice;//Biến chọn giá khám
  String? _selectedPayment;//Biến chọn phương thức thanh toán
  String? _selectedProvince;//Biến chọn tỉnh

  String? _selectedSpecialty;//Biến chọn chuyên khoa
  String? _selectedClinic;//Biến chọn phòng khám

  late String _action;//Biến chọn create/update data

  @override
  void initState() {
    futureGetAllDoctors = DoctorRepository().getAllDoctors();
    futureGetAllPrices = UserRepository().getAllCode('PRICE'); // Lấy tất cả giá khám
    futureGetAllPayments = UserRepository().getAllCode('PAYMENT');
    futureGetAllProvinces = UserRepository().getAllCode('PROVINCE');

    futureGetAllSpecialties = SpecialtyRepository().getAllSpecialties();
    futureGetAllClinics = ClinicRepository().getAllClinics();

    _action = 'CREATE';
    super.initState();
  }

  @override
  void dispose() {
    _nameClinicController.dispose();
    _addressClinicController.dispose();
    _noteController.dispose();
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
            'Management Doctors',
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
          _buildSelectedDoctorInfor(futureGetAllPrices, 'Chọn giá:', 'selectedPrice'),
          const SizedBox(height: 5,),
          _buildSelectedDoctorInfor(futureGetAllPayments, 'Chọn phương thức thanh toán:', 'selectedPayment'),
          const SizedBox(height: 5,),
          _buildSelectedDoctorInfor(futureGetAllProvinces, 'Chọn tỉnh thành:', 'selectedProvince'),
          const SizedBox(height: 5,),
          _buildSelectedSpecialty(futureGetAllSpecialties, 'Chọn chuyên khoa:', 'selectedSpecialty'),
          const SizedBox(height: 5,),
          _buildSelectedClinic(futureGetAllClinics, 'Chọn phòng khám:', 'selectedClinic'),
          const SizedBox(height: 5),
          _doctorDetailContent('Tên phòng khám', _nameClinicController, 50),
          _doctorDetailContent('Địa chỉ phòng khám', _addressClinicController, 50),
          _doctorDetailContent('Ghi chú', _noteController, 50),
          const SizedBox(height: 15),
          _doctorDetailContent('Thông tin giới thiệu', _descriptionController, 150),
          _doctorDetailContent('Thông tin chi tiết', _contentController, 150),
          const SizedBox(height: 15),
          _buttonSaveInforDoctor()
        ],
      ),
    );
  }

  Widget _buildSelectedDoctorInfor(
      Future<List<Map<String, dynamic>>> futureGetAllInfors,
      String title, String selectedInfor){
    return Row(
      children: [
        Text(title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const SizedBox(width: 10),
        FutureBuilder<List<Map<String, dynamic>>>(
          future: futureGetAllInfors,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Text('Lỗi: ${snapshot.error}');
            } else {
              final infors = snapshot.data!;
              return _buildDropdownButtonDoctorInfor(infors, selectedInfor);
            }
          },
        ),
      ],
    );
  }

  Widget _buildDropdownButtonDoctorInfor(List<Map<String, dynamic>> infors, String? selectedInfor) {
    return Expanded(
      child: DropdownButtonFormField<String>(
        decoration: const InputDecoration(
          isDense: true,
          contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black,
              width: 0.5,
            ),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black,
              width: 0.5,
            ),
          ),
        ),
        //Kiểm tra và khởi tạo giá trị hợp lệ hoặc null cho selectedInfor tránh lỗi dropdown ở trạng thái chưa chọn
        value: selectedInfor == 'selectedPrice'
            ? _selectedPrice
            : selectedInfor == 'selectedPayment'
            ? _selectedPayment
            : _selectedProvince, // Gán đúng giá trị
        items: infors.map((infor) {
          return DropdownMenuItem<String>(
            value: infor['keyMap'],
            child: Center(
                child: selectedInfor == 'selectedPrice'
                    ? Text('${infor['valueVI']} VND', textAlign: TextAlign.center,)
                    : Text('${infor['valueVI']}', textAlign: TextAlign.center,)
            ), // Hiển thị infor api
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            if(selectedInfor == 'selectedPrice'){
              _selectedPrice = value;// Cập nhật biến _selectedPrice
            } else if(selectedInfor == 'selectedPayment'){
              _selectedPayment = value;
            } else if(selectedInfor == 'selectedProvince'){
              _selectedProvince = value;
            }
          });
        },
        validator: (value) => value == null ? 'Vui lòng chọn' : null, // Kiểm tra nếu chưa chọn
        alignment: Alignment.center, // Căn giữa toàn bộ dropdown
        isExpanded: true, // Giúp dropdown chiếm toàn bộ chiều rộng
      ),
    );
  }

  Widget _buildSelectedSpecialty(
      Future<List<Map<String, dynamic>>> futureGetAllInfors,
      String title, String selectedInfor){
    return Row(
      children: [
        Text(title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const SizedBox(width: 10),
        FutureBuilder<List<Map<String, dynamic>>>(
          future: futureGetAllInfors,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Text('Lỗi: ${snapshot.error}');
            } else {
              final infors = snapshot.data!;
              return _buildDropdownButtonSpecialty(infors, selectedInfor);
            }
          },
        ),
      ],
    );
  }

  Widget _buildDropdownButtonSpecialty(List<Map<String, dynamic>> infors, String? selectedInfor) {
    return Expanded(
      child: DropdownButtonFormField<String>(
        decoration: const InputDecoration(
          isDense: true,
          contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black,
              width: 0.5,
            ),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black,
              width: 0.5,
            ),
          ),
        ),
        //Kiểm tra và khởi tạo giá trị hợp lệ hoặc null cho selectedInfor tránh lỗi dropdown ở trạng thái chưa chọn
        value: infors.any((infor) => infor['id'].toString() == _selectedSpecialty)
            ? _selectedSpecialty
            : null, // Gán đúng giá trị
        items: infors.map((infor) {
          return DropdownMenuItem<String>(
            value: infor['id'].toString(),
            child: Center(
                child: Text('${infor['name']}', textAlign: TextAlign.center,)
            ), // Hiển thị infor api
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            _selectedSpecialty = value;
          });
        },
        validator: (value) => value == null ? 'Vui lòng chọn' : null, // Kiểm tra nếu chưa chọn
        alignment: Alignment.center, // Căn giữa toàn bộ dropdown
        isExpanded: true, // Giúp dropdown chiếm toàn bộ chiều rộng
      ),
    );
  }

  Widget _buildSelectedClinic(
      Future<List<Map<String, dynamic>>> futureGetAllInfors,
      String title, String selectedInfor){
    return Row(
      children: [
        Text(title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const SizedBox(width: 10),
        FutureBuilder<List<Map<String, dynamic>>>(
          future: futureGetAllInfors,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Text('Lỗi: ${snapshot.error}');
            } else {
              final infors = snapshot.data!;
              return _buildDropdownButtonClinic(infors, selectedInfor);
            }
          },
        ),
      ],
    );
  }

  Widget _buildDropdownButtonClinic(List<Map<String, dynamic>> infors, String? selectedInfor) {
    return Expanded(
      child: DropdownButtonFormField<String>(
        decoration: const InputDecoration(
          isDense: true,
          contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black,
              width: 0.5,
            ),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black,
              width: 0.5,
            ),
          ),
        ),
        //Kiểm tra và khởi tạo giá trị hợp lệ hoặc null cho selectedInfor tránh lỗi dropdown ở trạng thái chưa chọn
        value: infors.any((infor) => infor['id'].toString() == _selectedClinic)
            ? _selectedClinic
            : null, // Gán đúng giá trị
        items: infors.map((infor) {
          return DropdownMenuItem<String>(
            value: infor['id'].toString(),
            child: Center(
                child: Text('${infor['name']}', textAlign: TextAlign.center,)
            ), // Hiển thị infor api
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            _selectedClinic = value;
            // Cập nhật `nameClinic` và `addressClinic` dựa trên lựa chọn
            final selectedClinic = infors.firstWhere(
                  (infor) => infor['id'].toString() == value,
              orElse: () => {},
            );
            // Cập nhật controller
            _nameClinicController.text = selectedClinic['name'] ?? '';
            _addressClinicController.text = selectedClinic['address'] ?? '';
          });
        },
        validator: (value) => value == null ? 'Vui lòng chọn' : null, // Kiểm tra nếu chưa chọn
        alignment: Alignment.center, // Căn giữa toàn bộ dropdown
        isExpanded: true, // Giúp dropdown chiếm toàn bộ chiều rộng
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
            _nameClinicController.clear();
            _addressClinicController.clear();
            _noteController.clear();
            _descriptionController.clear();//nếu k chọn thì clear controller
            _contentController.clear();
          }
        });
      },
    );
  }

  Widget _doctorDetailContent(String title, TextEditingController controller, double heightTextField) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 5,),
        Text(title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const SizedBox(height: 5),
        _buildScrollableTextField(controller, heightTextField),
      ],
    );
  }

  Widget _buildScrollableTextField(TextEditingController controller, double heightTextField) {
    return SizedBox(
      height: heightTextField, // Cố định chiều cao để tránh tràn
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
      final result = await DoctorRepository().saveInforDoctor(
          int.parse(_selectedDoctorId!),
          _contentController.text,
          _descriptionController.text,
          _action,
        _selectedPrice!,
        _selectedPayment!,
        _selectedProvince!,
          int.parse(_selectedSpecialty!),
          int.parse(_selectedClinic!),
        _nameClinicController.text,
        _addressClinicController.text,
        _noteController.text
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
        // Sử dụng keyMap để đảm bảo đúng giá trị cho dropdown
        _selectedPrice = doctor['Doctor_Infor']['priceId'];
        _selectedPayment = doctor['Doctor_Infor']['paymentId'];
        _selectedProvince = doctor['Doctor_Infor']['provinceId'];
        _selectedSpecialty = doctor['Doctor_Infor']['specialtyId'].toString();
        _selectedClinic = doctor['Doctor_Infor']['clinicId'].toString();

        // Gán trực tiếp vào controller
        _nameClinicController.text = doctor['Doctor_Infor']['nameClinic'] ?? '';
        _addressClinicController.text = doctor['Doctor_Infor']['addressClinic'] ?? '';
        _noteController.text = doctor['Doctor_Infor']['note'] ?? '';
        _descriptionController.text = doctor['Markdown']['description'] ?? '';
        _contentController.text = doctor['Markdown']['content'] ?? '';

        _contentController.text.isNotEmpty ? _action = 'UPDATE' : _action = 'CREATE';
      });
    } catch (e) {
      debugPrint('Lỗi khi tải thông tin doctor: $e');
    }
  }

  // Làm mới danh sách user
  Future<void> _refreshListDoctors() async {
    setState(() {
      futureGetAllDoctors = DoctorRepository().getAllDoctors(); // Cập nhật lại future
      futureGetAllPrices = UserRepository().getAllCode('PRICE');
      futureGetAllPayments = UserRepository().getAllCode('PAYMENT');
      futureGetAllSpecialties = SpecialtyRepository().getAllSpecialties();
      futureGetAllSpecialties = ClinicRepository().getAllClinics();
    });
  }
}
