import 'package:clinic_management/data/repository/doctor_repository.dart';
import 'package:flutter/material.dart';

class DoctorExtraInfoComponent extends StatefulWidget {
  final int doctorId;
  final Function(String) onPriceFetched; // Thêm hàm callback

  const DoctorExtraInfoComponent({
    super.key,
    required this.doctorId,
    required this.onPriceFetched
  });

  @override
  State<StatefulWidget> createState() {
    return _DoctorExtraInfoComponentState();
  }
}

class _DoctorExtraInfoComponentState extends State<DoctorExtraInfoComponent> {
  String? _nameClinc; //tên phòng khám
  String? _addressClinic;
  String? _province;
  String? _price;
  String? _payment;
  String? _note;
  bool isShowDetailInfor = false; //chưa nhấn xem chi tiết
  bool isLoading = true; // Trạng thái loading

  @override
  void initState() {
    _fetchExtraInforDoctorById();
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
          const Divider(thickness: 0.5), // Giảm độ dày
          const Text('ĐỊA CHỈ KHÁM',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Colors.black54)),
          _buildAddressClinic(),
          const Divider(thickness: 0.5), // Giảm độ dày
          isShowDetailInfor ? _buildDetailDoctorPrice() : _buildDoctorPrice()
        ],
      ),
    );
  }

  Widget _buildAddressClinic(){
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_nameClinc == null || _nameClinc!.isEmpty) {
      return const Center(child: Text('Chưa có thông tin địa chỉ.'));
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(_nameClinc ?? '',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        Text( '${_addressClinic ?? ''}, ${_province ?? ''}',
            style: const TextStyle(fontSize: 14)),
      ],
    );
  }

  Widget _buildDoctorPrice() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_price == null || _price!.isEmpty) {
      return const Center(child: Text('Chưa có thông tin giá khám.'));
    }
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
      Text(
        '${_price ?? ''}đ',
        style: const TextStyle(fontSize: 14),
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
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_price == null || _price!.isEmpty) {
      return const Center(child: Text('Chưa có thông tin giá khám.'));
    }
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
          child: Wrap(
            children: [
              Row(
                children: [
                  const Text(
                    'Giá khám:',
                    style: TextStyle(fontSize: 14),
                  ),
                  const Spacer(),
                  Text(
                    '${_price ?? ''}đ',
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
              Text(_note ?? '', style: const TextStyle(fontSize: 13, color: Colors.black54))
            ],
          )
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
          child: Wrap(
            alignment: WrapAlignment.spaceBetween,
            children: [
              Text(
                  'Phòng khám có hình thức thanh toán chi phí tính bằng ${_payment ?? ''}',
                  style: const TextStyle(fontSize: 14)),
            ],
          ),
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

  Future<void> _fetchExtraInforDoctorById() async {
    try {
      // Lấy tất cả lịch khám theo ngày
      Map<String, dynamic> fetchedExtraInfor =
      await DoctorRepository().getExtraInforDoctorById(widget.doctorId);
      setState(() {
        _nameClinc = fetchedExtraInfor['nameClinic'] ?? '';
        _addressClinic = fetchedExtraInfor['addressClinic'] ?? '';
        _province = fetchedExtraInfor['provinceTypeData']['valueVi'] ?? '';
        _price = fetchedExtraInfor['priceTypeData']['valueVi'] ?? '';
        _payment = fetchedExtraInfor['paymentTypeData']['valueVi'] ?? '';
        _note = fetchedExtraInfor['note'] ?? '';

        widget.onPriceFetched(_price ?? ''); // Truyền giá trị giá vào callback
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
}
