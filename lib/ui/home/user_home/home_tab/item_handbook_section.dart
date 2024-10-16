import 'package:flutter/material.dart';

class ItemHandbookSection extends StatefulWidget {
  final Function? function;
  final String image;
  final String text;

  const ItemHandbookSection(
      {super.key,
        required this.function,
        required this.image,
        required this.text});

  @override
  State<StatefulWidget> createState() {
    return _ItemHandbookSectionState();
  }
}

class _ItemHandbookSectionState extends State<ItemHandbookSection> {
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
            height: 200,
            width: 250,
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Column(
                children: [
                  const SizedBox(height: 5),
                  Image.asset(
                    '${widget.image}',
                    height: 120,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 3),
                  Expanded(
                    child: Text(
                      widget.text,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                      maxLines: 2, // Giới hạn số dòng chữ
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,//khi quá dài thêm ...
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
