import 'package:flutter/material.dart';

class ItemOutstandingDoctorSection extends StatefulWidget {
  final Function? function;
  final String image;
  final String text;

  const ItemOutstandingDoctorSection(
      {super.key,
        required this.function,
        required this.image,
        required this.text});

  @override
  State<StatefulWidget> createState() {
    return _ItemOutstandingSectionState();
  }
}

class _ItemOutstandingSectionState extends State<ItemOutstandingDoctorSection> {
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
          SizedBox(
            height: 180,
            width: 150,
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Column(
                children: [
                  const SizedBox(height: 5),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(57),
                    child: Image.asset(
                      '${widget.image}',
                      height: 114,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: Text(
                      widget.text,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
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
