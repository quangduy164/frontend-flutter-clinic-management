import 'package:flutter/material.dart';

class ItemServiceSection extends StatefulWidget {
  final Function? function;
  final String image;
  final String text;

  const ItemServiceSection(
      {super.key,
      required this.function,
      required this.image,
      required this.text});

  @override
  State<StatefulWidget> createState() {
    return _ItemServiceSectionState();
  }
}

class _ItemServiceSectionState extends State<ItemServiceSection> {
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
            height: 70,
            width: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
              border: Border.all(
                color: Colors.grey, // Màu viền
                width: 1, // Độ dày viền
              ),
            ),
            child: Row(
              children: [
                const SizedBox(width: 10),
                Image.asset(
                  '${widget.image}',
                  height: 40,
                  fit: BoxFit.contain,
                ),
                const SizedBox(width: 3),
                Expanded(
                  child: Text(
                    widget.text,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2, // Giới hạn số dòng chữ
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
