import 'package:flutter/material.dart';

class DoctorExtraInfoComponent extends StatefulWidget {
  final int doctorId;

  const DoctorExtraInfoComponent({super.key, required this.doctorId});

  @override
  State<StatefulWidget> createState() {
    return _DoctorExtraInfoComponentState();
  }
}

class _DoctorExtraInfoComponentState extends State<DoctorExtraInfoComponent> {
  bool isShowDetailInfor = false; //chưa nhấn xem chi tiết
  bool isLoading = true; // Trạng thái loading

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      // Khoảng cách bên trong container
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(thickness: 0.5), // Giảm độ dày và khoảng cách
          const Text('ĐỊA CHỈ KHÁM',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Colors.black54)),
          Text('Phòng khám đa khoa meditec',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          Text('52 Bà Triệu - Hoàn Kiếm - Hà nội',
              style: TextStyle(fontSize: 14)),
          const Divider(thickness: 0.5), // Giảm độ dày
          isShowDetailInfor ? _buildDetailDoctorPrice() : _buildDoctorPrice()
        ],
      ),
    );
  }

  Widget _buildDoctorPrice() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
      const Text(
        'GIÁ KHÁM:',
        style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black54),
      ),
      const SizedBox(
        width: 5,
      ),
      const Text(
        '500000đ',
        style: TextStyle(fontSize: 14),
      ),
      SizedBox(
        height: 35,
        child: TextButton(
            onPressed: () {
              setState(() {
                isShowDetailInfor = true;
              });
            },
            child: const Text(
              'Xem chi tiết',
              style: TextStyle(color: Colors.cyan),
            ),
        ),
      )
    ]);
  }

  Widget _buildDetailDoctorPrice() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 3,),
        const Text('GIÁ KHÁM: ',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Colors.black54)),
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.1), // Nền xám nhạt
            border: Border.all(
              color: Colors.grey, // Màu viền
              width: 0.5, // Độ dày của viền
            ),
          ),
          child: Row(
            children: [
              const Text(
                'Giá khám:',
                style: TextStyle(fontSize: 14),
              ),
              const Spacer(),
              Text(
                '500000đ',
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3),
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.3), // Nền xám nhạt
            border: Border.all(
              color: Colors.grey, // Màu viền
              width: 0.5, // Độ dày của viền
            ),
          ),
          child: const Text(
              'Phòng khám có hình thức thanh toán chi phí tính bằng tiền mặt và ATM',
              style: TextStyle(fontSize: 14)),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: SizedBox(
            height: 35,
            child: TextButton(
                onPressed: () {
                  setState(() {
                    isShowDetailInfor = false;
                  });
                },
                child: const Text(
                  'Ẩn bảng giá',
                  style: TextStyle(color: Colors.cyan),
                  textAlign: TextAlign.end,
                )),
          ),
        )
      ],
    );
  }
}
