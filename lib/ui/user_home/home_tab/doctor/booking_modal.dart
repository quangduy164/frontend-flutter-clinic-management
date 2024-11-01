import 'package:clinic_management/ui/user_home/home_tab/doctor/profile_doctor_component.dart';
import 'package:flutter/material.dart';

class BookingModal extends StatefulWidget {
  final int doctorId;
  final String schedule;
  final String? date;
  final String? price;

  const BookingModal({
    super.key,
    required this.doctorId,
    required this.schedule,
    required this.date,
    required this.price
  });

  @override
  State<StatefulWidget> createState() {
    return _BookingModalState();
  }
}

class _BookingModalState extends State<BookingModal> {
  late TextEditingController _nameController = TextEditingController();

  bool isLoading = true; // Trạng thái loading

  @override
  void initState() {
    super.initState();
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
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProfileDoctorComponent(
                doctorId: widget.doctorId,
                isShowDescriptionDoctor: false,
                schedule: widget.schedule,
                date: widget.date,
              ),
              const SizedBox(height: 5,),
              _buildPrice(),
              _bookingDetail(),
              _buildPayment(),
              _buttonConfirmBooking()
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPrice(){
    return Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.orangeAccent, // Màu viền
            width: 1, // Độ dày của viền
          ),
        ),
        child: Center(
          child: Column(
            children: [
              const Icon(Icons.check_circle_rounded, size: 16, color: Colors.blueAccent,),
              Text(
                'Giá khám ${widget.price ?? ''}đ',
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
    );
  }

  Widget _bookingDetail(){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Thông tin bệnh nhân',
            style: TextStyle(fontSize: 13,
                fontWeight: FontWeight.w500, color: Colors.indigo),),
          _buildScrollableTextField('Họ tên', _nameController, 45),
          _buildScrollableTextField('Giới tính', _nameController, 45),
          _buildScrollableTextField('Số điện thoại', _nameController, 45),
          _buildScrollableTextField('Địa chỉ email', _nameController, 45),
          _buildScrollableTextField('Địa chỉ liên hệ', _nameController, 45),
          _buildScrollableTextField('Đặt cho ai', _nameController, 45),
          _buildScrollableTextField('Lý do khám', _nameController, 45),
        ],
      ),
    );
  }

  Widget _buildScrollableTextField(
      String title, TextEditingController controller, double heightTextField) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10,),
        SizedBox(
          height: heightTextField, // Cố định chiều cao để tránh tràn
          child: TextField(
            controller: controller,
            maxLines: null, // Cho phép nhiều dòng
            expands: true, // Giúp TextField mở rộng bên trong SizedBox
            textAlign: TextAlign.start, // Căn trái văn bản
            textAlignVertical: TextAlignVertical.center, // Căn văn bản lên trên cùng
            scrollPhysics: const BouncingScrollPhysics(),
            decoration: InputDecoration(
              hintText: title,
              hintStyle: const TextStyle(
                fontSize: 14, // Giảm kích thước của hintText
                color: Colors.grey,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 5,
              ),
              border: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey, width: 0.5),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.cyan, width: 1.0),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPayment(){
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check_circle_rounded, size: 16, color: Colors.blueAccent,),
          Text(
            'Thanh toán tại cơ sở y tế',
            style: TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buttonConfirmBooking(){
    return Center(
      child: TextButton(
          onPressed: (){},
          style: TextButton.styleFrom(
            backgroundColor: Colors.orangeAccent,
            shape: const RoundedRectangleBorder(
                side: BorderSide.none
            ),
        ),
          child: const Text('Xác nhận đặt khám', style: TextStyle(color: Colors.white),),
      ),
    );
  }

}
