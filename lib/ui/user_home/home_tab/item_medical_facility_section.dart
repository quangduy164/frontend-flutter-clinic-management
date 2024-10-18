import 'package:flutter/material.dart';

class ItemMedicalFacilitySection extends StatefulWidget {
  final Function? function;
  final String image;
  final String text;

  const ItemMedicalFacilitySection(
      {super.key,
        required this.function,
        required this.image,
        required this.text});

  @override
  State<StatefulWidget> createState() {
    return _ItemMedicalFacilitySectionState();
  }
}

class _ItemMedicalFacilitySectionState extends State<ItemMedicalFacilitySection> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        // Kiểm tra xem function có được cung cấp không trước khi gọi
        if (widget.function != null) {
          widget.function!(); // Gọi hàm khi được chạm vào
        }
      },
      child: Stack(
        children: [
          Container(
            height: 140,
            width: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
              border: Border.all(
                color: Colors.grey, // Màu viền
                width: 1, // Độ dày viền
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Column(
                children: [
                  const SizedBox(height: 5),
                  Image.asset(
                    '${widget.image}',
                    height: 65,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 3),
                  Expanded(
                    child: Text(
                      widget.text,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                      maxLines: 2, // Giới hạn số dòng chữ
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
