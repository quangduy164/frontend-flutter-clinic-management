import 'dart:typed_data';

import 'package:flutter/material.dart';

class ItemSpecialtySection extends StatefulWidget {
  final Function? function;
  final Uint8List? image;
  final String text;

  const ItemSpecialtySection(
      {super.key,
        required this.function,
        required this.image,
        required this.text});

  @override
  State<StatefulWidget> createState() {
    return _ItemSpecialtySectionState();
  }
}

class _ItemSpecialtySectionState extends State<ItemSpecialtySection> {
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
            height: 120,
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
                  widget.image != null && widget.image!.isNotEmpty
                      ? Image.memory(
                    widget.image!,
                    height: 75,
                    fit: BoxFit.contain,
                  )
                      : Image.asset(
                    'assets/images/user_avata.png',
                    height: 75,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 3),
                  Expanded(
                    child: Text(
                      widget.text,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
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
