import 'package:flutter/material.dart';

class ItemSection extends StatefulWidget {
  final Function? function;
  final IconData icon;
  final String text;

  const ItemSection(
      {super.key,
        required this.function,
        required this.icon,
        required this.text});

  @override
  State<StatefulWidget> createState() {
    return _ItemSectionState();
  }
}

class _ItemSectionState extends State<ItemSection> {
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
            height: 50,
            width: 250,
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
                const SizedBox(width: 20),
                Icon(widget.icon, size: 20,),
                const SizedBox(width: 3),
                Expanded(
                  child: Text(
                    widget.text,
                    style: const TextStyle(
                      fontSize: 14,
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
