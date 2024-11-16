import 'package:clinic_management/data/repository/specialty_repository.dart';
import 'package:clinic_management/ui/user_home/home_tab/specialty/doctor_component.dart';
import 'package:flutter/material.dart';

class DetailSpecialty extends StatefulWidget {
  final int specialtyId;

  const DetailSpecialty({super.key, required this.specialtyId});

  @override
  State<StatefulWidget> createState() {
    return _DetailSpecialtyState();
  }
}

class _DetailSpecialtyState extends State<DetailSpecialty> {
  List<dynamic> doctorSpecialty = [];//danh sách bác sĩ của chuyên khoa
  String? _nameSpecialty;
  String? _descriptionSpecialty;
  String? _selectedProvince;//Biến chọn location
  bool isLoading = true; // Trạng thái loading

  @override
  void initState() {
    super.initState();
    _selectedProvince = 'ALL';
    _getDetailInforSpecialty(); // lấy thông tin specialty
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
              _specialtyDescription(),
              const SizedBox(height: 10,),
              _buildSelectedProvince(),
              const SizedBox(height: 10,),
              _getListDoctorSpecialty()
            ],
          ),
        ),
      ],
    );
  }

  Widget _specialtyDescription(){
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Colors.grey, // Màu viền
          width: 0.1, // Độ dày viền
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$_nameSpecialty',
            style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5,),
          const Text('Tư vấn, khám và điều trị các bệnh',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: Text('$_descriptionSpecialty',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
            ),
          ),
          const SizedBox(height: 10,),
        ],
      ),
    );
  }

  Widget _buildSelectedProvince(){
    return SizedBox(
      height: 35,
      width: 150,
      child: DropdownButtonFormField<String>(
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 5,
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.cyan, width: 0.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.cyan, width: 1.0),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
        value: _selectedProvince,
        items: const [
          DropdownMenuItem(
            value: 'ALL',
            child: Text('Toàn quốc', style: TextStyle(fontWeight: FontWeight.w400, fontSize: 15)),
          ),
          DropdownMenuItem(
            value: 'PRO1',
            child: Text('Hà Nội', style: TextStyle(fontWeight: FontWeight.w400, fontSize: 15)),
          ),
          DropdownMenuItem(
            value: 'PRO2',
            child: Text('Hồ Chí Minh', style: TextStyle(fontWeight: FontWeight.w400, fontSize: 15)),
          ),
        ],
        onChanged: (value) {
          if (value != _selectedProvince) {
            setState(() {
              _selectedProvince = value; // Cập nhật giá trị tỉnh
            });
            _getDetailInforSpecialty(); // Gọi lại API để lấy danh sách bác sĩ
          }
        },
        icon: const Icon(
          Icons.keyboard_arrow_down_rounded,
          color: Colors.black, // Đổi màu biểu tượng
          size: 25, // Kích thước biểu tượng
        ),
        validator: (value) {
          return value == null ? 'Vui lòng điền thông tin' : null;
        },
      ),
    );
  }

  Widget _getListDoctorSpecialty() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (doctorSpecialty.isEmpty) {
      return const Center(
        child: Text('Không tìm thấy bác sĩ.'),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: doctorSpecialty.map((doctor) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: DoctorComponent(
            doctorId: doctor['doctorId'],
          ),
        );
      }).toList(),
    );
  }

  Future<void> _getDetailInforSpecialty() async {
    setState(() {
      isLoading = true; // Bắt đầu trạng thái tải
    });
    try {
      // Gọi API lấy thông tin chi tiết specialty
      final specialty = await SpecialtyRepository().getDetailSpecialtyById(
          widget.specialtyId,
          _selectedProvince!
      );

      setState(() {
        _nameSpecialty = specialty['name'] ?? '';
        _descriptionSpecialty = specialty['description'] ?? '';
        doctorSpecialty = specialty['doctorSpecialty'] ?? [];
      });
    } catch (e) {
      debugPrint('Lỗi khi tải thông tin detail specialty: $e');
    } finally {
      setState(() {
        isLoading = false; // Kết thúc trạng thái tải
      });
    }
  }
}
