import 'package:flutter/material.dart';
import '../data/lists_data.dart';

class AddListDialog extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onListAdded;

  const AddListDialog({
    Key? key,
    required this.controller,
    required this.onListAdded,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      title: const Text(
        'Danh sách mới',
        style: TextStyle(
          color: Color.fromARGB(255, 24, 146, 222),
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      content: TextField(
        controller: controller,
        style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
        decoration: const InputDecoration(
          hintText: 'Nhập tên danh sách',
          hintStyle: TextStyle(color: Color.fromARGB(104, 0, 0, 0)),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Color.fromARGB(104, 0, 0, 0)),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF80CFFF), width: 2),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('HUỶ BỎ', style: TextStyle(color: Colors.blue)),
        ),
        TextButton(
          onPressed: () {
            if (controller.text.isNotEmpty) {
              final endIndex = ListsData.listOptions.indexOf('Kết thúc');
              if (endIndex != -1) {
                ListsData.listOptions.insert(endIndex, controller.text);
              } else {
                ListsData.listOptions.add(controller.text);
              }
              
              onListAdded(controller.text);
              controller.clear();
              Navigator.pop(context);
            }
          },
          child: const Text('THÊM', style: TextStyle(color: Colors.blue)),
        ),
      ],
    );
  }
}