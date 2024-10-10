import 'package:clinic_management/ui/home/user_home/home_tab/item_service_section.dart';
import 'package:flutter/material.dart';

class HomeTab extends StatelessWidget{
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _getBody()
    );
  }

  Widget _getBody(){
    return ListView(
      children: [
        Stack(
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
                          fontWeight: FontWeight.w600,
                          fontSize: 20)
                    ),
                    _searchBar()
                  ],
                ),
              ),
            )
          ],
        ),
        _getService()
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
                  image: 'assets/images/iconkham-chuyen-khoa.png',
                  text: 'Khám chuyên khoa'
              ),
              const Spacer(),
              ItemServiceSection(
                  function: (){},
                  image: 'assets/images/iconkham-tu-xa.png',
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
                  image: 'assets/images/iconkham-tong-quat.png',
                  text: 'Khám tổng quát'
              ),
              const Spacer(),
              ItemServiceSection(
                  function: (){},
                  image: 'assets/images/iconxet-nghiem-y-hoc.png',
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
                  image: 'assets/images/iconsuc-khoe-tinh-than.png',
                  text: 'Sức khỏe tinh thần'
              ),
              const Spacer(),
              ItemServiceSection(
                  function: (){},
                  image: 'assets/images/iconkham-nha-khoa.png',
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
                  image: 'assets/images/icongoi-phau-thuat.png',
                  text: 'Gói phẫu thuật'
              ),
              const Spacer(),
              ItemServiceSection(
                  function: (){},
                  image: 'assets/images/iconsong-khoe-tieu-duong.png',
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
                  image: 'assets/images/iconbai-test-suc-khoe.png',
                  text: 'Bài test sức khỏe'
              ),
              const Spacer(),
              ItemServiceSection(
                  function: (){},
                  image: 'assets/images/icony-te-gan-ban.png',
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
}