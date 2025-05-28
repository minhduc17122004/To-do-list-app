import 'package:flutter/material.dart';

class BackConfirmationDialog {
  /// Hiển thị dialog xác nhận khi người dùng muốn quay lại
  /// 
  /// [context]: BuildContext hiện tại
  /// [onConfirm]: Hàm callback khi người dùng xác nhận quay lại
  /// [actionType]: Loại hành động (thêm mới/chỉnh sửa) để hiển thị trong log
  static void show({
    required BuildContext context,
    required VoidCallback onConfirm,
    required String actionType,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('BẠN CÓ CHẮN CHẮN', style: TextStyle(color: Color.fromARGB(255, 24, 146, 222), fontSize: 20, fontWeight: FontWeight.bold)),
          content: const Text('Thoát mà không lưu?', style: TextStyle(fontSize: 16)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Đóng dialog
              },
              child: const Text('HUỶ BỎ', style: TextStyle(fontSize: 16, color: Color.fromARGB(255, 80, 78, 78))),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Đóng dialog
                onConfirm(); // Gọi callback
                print('Người dùng đã hủy thao tác $actionType task'); // Log xác nhận
              },
              child: const Text('VÂNG', style: TextStyle(fontSize: 16, color: Color.fromARGB(255, 24, 146, 222))),
            ),
          ],
        );
      },
    );
  }
} 