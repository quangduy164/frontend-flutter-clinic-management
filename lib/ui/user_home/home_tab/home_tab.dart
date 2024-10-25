import 'dart:typed_data';

import 'package:clinic_management/data/repository/doctor_repository.dart';
import 'package:clinic_management/ui/user_home/home_tab/detail_doctor.dart';
import 'package:flutter/material.dart';

import 'item_handbook_section.dart';
import 'item_medical_facility_section.dart';
import 'item_outstanding_doctor_section.dart';
import 'item_service_section.dart';
import 'item_specialty_section.dart';

class HomeTab extends StatefulWidget{
  const HomeTab({super.key});

  @override
  State<StatefulWidget> createState() {
    return _HomeTabState();
  }

}

class _HomeTabState extends State<HomeTab>{

  final DoctorRepository doctorRepository = DoctorRepository();
  List<Map<String, dynamic>> doctors = [];//bác sĩ nổi bật
  bool isLoading = true; // Trạng thái loading

  @override
  void initState() {
    super.initState();
    _fetchOutstandingDoctors(); //Gọi API khi widget được tạo
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _getBody()
        ],
      ),
    );
  }

  Widget _getBody(){
    return ListView(
      children: [
        _headerSection(),
        _getService(),
        _getSpecialty(),
        _getMedicalFacility(),
        _getOutstandingDoctor(),
        _getHandBook()
      ],
    );
  }

  Widget _headerSection() {
    return Stack(
      children: [
        Container(
          height: 140,
          color: const Color.fromRGBO(146, 215, 238, 1.0),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Center(
            child: Column(
              children: [
                const Text('Nơi khởi nguồn sức khỏe',
                    style: TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 20)),
                _searchBar(),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget _getHandBook(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 15, left: 15),
          child: Text('Cẩm nang',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14),
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                ItemHandbookSection(
                    function: (){},
                    image: 'assets/images/handbook/phong-kham-san-phu-khoa-gan-day.png',
                    text: 'Tổng hợp phòng khám sản phụ khoa gần đây theo quận Hà Nội'
                ),
                ItemHandbookSection(
                    function: (){},
                    image: 'assets/images/handbook/phong-kham-san-phu-khoa-gan-day.png',
                    text: 'Tổng hợp phòng khám sản phụ khoa gần đây theo quận Hà Nội'
                ),
                ItemHandbookSection(
                    function: (){},
                    image: 'assets/images/handbook/phong-kham-san-phu-khoa-gan-day.png',
                    text: 'Tổng hợp phòng khám sản phụ khoa gần đây theo quận Hà Nội'
                ),
                ItemHandbookSection(
                    function: (){},
                    image: 'assets/images/handbook/phong-kham-san-phu-khoa-gan-day.png',
                    text: 'Tổng hợp phòng khám sản phụ khoa gần đây theo quận Hà Nội'
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget _getOutstandingDoctor() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (doctors.isEmpty) {
      return const Center(child: Text('Không có bác sĩ nổi bật.'));
    }
    return Stack(
      children: [
        SizedBox(
          height: 270,
          child: Image.asset(
            'assets/images/outstanding_doctor/background-outstanding-doctor.png',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 15, left: 15),
              child: Text(
                'Bác sĩ nổi bật',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  children: doctors.map((doctor) {
                    final name =
                        '${doctor['lastName']} ${doctor['firstName']}';
                    final position = doctor['positionData']['valueVi'] ?? '';
                    // Lấy ảnh từ API và kiểm tra tính hợp lệ
                    Uint8List? image;
                    if (doctor.containsKey('image') && doctor['image'] != null) {
                      final List<int> imageData = List<int>.from(doctor['image']['data']);
                      if (imageData.isNotEmpty) {
                        setState(() {
                          image = Uint8List.fromList(imageData);
                        });
                      } else {
                        debugPrint('Dữ liệu hình ảnh rỗng.');
                      }
                    }
                    return Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: ItemOutstandingDoctorSection(
                        function: () {
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context) => DetailDoctor(doctorId: doctor['id'],)
                          ));
                        },
                        image: image, // Có thể là null nếu k có dữ liệu
                        text: '$position, $name',
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _getMedicalFacility(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 15, left: 15),
          child: Text('Cơ sở y tế',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14),
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              children: [
                ItemMedicalFacilitySection(
                    function: (){},
                    image: 'assets/images/medical_facility/logo-viet-duc.jpg',
                    text: 'Bệnh viện Hữu nghị Việt Đức'
                ),
                const SizedBox(width: 15,),
                ItemMedicalFacilitySection(
                    function: (){},
                    image: 'assets/images/medical_facility/logo-bvcr.jpg',
                    text: 'Bệnh viện Chợ Rẫy'
                ),
                const SizedBox(width: 15,),
                ItemMedicalFacilitySection(
                    function: (){},
                    image: 'assets/images/medical_facility/logo-doctor-check.jpg',
                    text: 'Doctor Check - Tầm Soát Bệnh Để Sống Thọ Hơn'
                ),
                const SizedBox(width: 15,),
                ItemMedicalFacilitySection(
                    function: (){},
                    image: 'assets/images/medical_facility/logo-y-duoc-1.jpg',
                    text: 'Phòng khám Bệnh viện Đại học Y Dược 1'
                ),
                const SizedBox(width: 15,),
                ItemMedicalFacilitySection(
                    function: (){},
                    image: 'assets/images/medical_facility/logo-benhvien108.jpg',
                    text: 'Bệnh viện Trung ương Quân đội 108'
                ),
                const SizedBox(width: 15,),
                ItemMedicalFacilitySection(
                    function: (){},
                    image: 'assets/images/medical_facility/logo-hung-viet.jpg',
                    text: 'Bệnh viện Ung bướu Hưng Việt'
                ),
                const SizedBox(width: 15,),
                ItemMedicalFacilitySection(
                    function: (){},
                    image: 'assets/images/medical_facility/logo-medlatec.png',
                    text: 'Hệ thống y tế MEDLATEC'
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget _getSpecialty(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 15, left: 15),
          child: Text('Chuyên khoa',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14),
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              children: [
                ItemSpecialtySection(
                    function: (){},
                    image: 'assets/images/specialty/co-xuong-khop.png',
                    text: 'Cơ xương khớp'
                ),
                const SizedBox(width: 15,),
                ItemSpecialtySection(
                    function: (){},
                    image: 'assets/images/specialty/than-kinh.png',
                    text: 'Thần kinh'
                ),
                const SizedBox(width: 15,),
                ItemSpecialtySection(
                    function: (){},
                    image: 'assets/images/specialty/tieu-hoa.png',
                    text: 'Tiêu hóa'
                ),
                const SizedBox(width: 15,),
                ItemSpecialtySection(
                    function: (){},
                    image: 'assets/images/specialty/tim-mach.png',
                    text: 'Tim mạch'
                ),
                const SizedBox(width: 15,),
                ItemSpecialtySection(
                    function: (){},
                    image: 'assets/images/specialty/tai-mui-hong.png',
                    text: 'Tai mũi họng'
                ),
                const SizedBox(width: 15,),
                ItemSpecialtySection(
                    function: (){},
                    image: 'assets/images/specialty/cot-song.png',
                    text: 'Cột sống'
                ),
                const SizedBox(width: 15,),
                ItemSpecialtySection(
                    function: (){},
                    image: 'assets/images/specialty/y-hoc-co-truyen.png',
                    text: 'Y học cổ truyền'
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget _getService(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 15, left: 15),
          child: Text('Dịch vụ toàn diện',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            children: [
              ItemServiceSection(
                  function: (){},
                  image: 'assets/images/services/iconkham-chuyen-khoa.png',
                  text: 'Khám chuyên khoa'
              ),
              const Spacer(),
              ItemServiceSection(
                  function: (){},
                  image: 'assets/images/services/iconkham-tu-xa.png',
                  text: 'Khám từ xa'
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            children: [
              ItemServiceSection(
                  function: (){},
                  image: 'assets/images/services/iconkham-tong-quat.png',
                  text: 'Khám tổng quát'
              ),
              const Spacer(),
              ItemServiceSection(
                  function: (){},
                  image: 'assets/images/services/iconxet-nghiem-y-hoc.png',
                  text: 'Xét nghiệm y học'
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            children: [
              ItemServiceSection(
                  function: (){},
                  image: 'assets/images/services/iconsuc-khoe-tinh-than.png',
                  text: 'Sức khỏe tinh thần'
              ),
              const Spacer(),
              ItemServiceSection(
                  function: (){},
                  image: 'assets/images/services/iconkham-nha-khoa.png',
                  text: 'Khám nha khoa'
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            children: [
              ItemServiceSection(
                  function: (){},
                  image: 'assets/images/services/icongoi-phau-thuat.png',
                  text: 'Gói phẫu thuật'
              ),
              const Spacer(),
              ItemServiceSection(
                  function: (){},
                  image: 'assets/images/services/iconsong-khoe-tieu-duong.png',
                  text: 'Sống khỏe tiểu đường'
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            children: [
              ItemServiceSection(
                  function: (){},
                  image: 'assets/images/services/iconbai-test-suc-khoe.png',
                  text: 'Bài test sức khỏe'
              ),
              const Spacer(),
              ItemServiceSection(
                  function: (){},
                  image: 'assets/images/services/icony-te-gan-ban.png',
                  text: 'Y tế gần bạn'
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _searchBar() {
    return Padding(
      padding: const EdgeInsets.only(top: 8, left: 15, right: 15, bottom: 12),
      child: TextField(
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search, color: Colors.grey),
          contentPadding: const EdgeInsets.symmetric(vertical: 20), //Chiều cao thanh tìm kiếm
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none
          ),
          filled: true, // Cho phép màu nền
          fillColor: Colors.white, // Màu nền là màu trắng
          hintText: 'Tìm kiếm...',
        ),
      ),
    );
  }

  Future<void> _fetchOutstandingDoctors() async {
    try {
      List<Map<String, dynamic>> fetchedDoctors =
      await doctorRepository.getOutstandingDoctor(7); // Lấy 5 bác sĩ
      setState(() {
        doctors = fetchedDoctors;
      });
    } catch (e) {
      // Xử lý lỗi nếu cần thiết
      debugPrint('Lỗi khi lấy danh sách bác sĩ: $e');
    } finally {
      setState(() {
        isLoading = false; // Hoàn tất việc load dữ liệu
      });
    }
  }
}