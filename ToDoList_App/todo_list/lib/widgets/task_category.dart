import 'package:flutter/material.dart';
import '../models/task.dart';
import 'task_item.dart';

class TaskCategory extends StatelessWidget {
  final String title; // Tiêu đề danh mục
  final List<Task> tasks; // Danh sách công việc thuộc danh mục
  final Function(bool?, Task) onTaskToggle; // Hàm xử lý khi trạng thái công việc thay đổi
  final Color titleColor; // Màu sắc cho tiêu đề danh mục
  final bool showListName; // Cờ xác định có hiển thị tên danh sách hay không

  const TaskCategory({
    Key? key,
    required this.title,
    required this.tasks,
    required this.onTaskToggle,
    this.titleColor = Colors.white, // Màu mặc định cho tiêu đề là trắng
    this.showListName = false, // Mặc định không hiển thị tên danh sách
  }) : super(key: key);

  // Thêm phương thức static để có thể sử dụng mà không cần tạo instance
  static Color getCategoryColor(String category) {
    switch (category) {
      case 'Quá hạn':
        return Colors.red;
      case 'Hôm nay':
        return const Color.fromARGB(255, 1, 115, 182);
      case 'Không có ngày':
        return Colors.white60;
      default:
        return Colors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Không hiển thị nếu không có công việc nào trong danh mục này
    if (tasks.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Tiêu đề danh mục
        Padding(
          padding: const EdgeInsets.only(left: 16, top: 24, bottom: 8),
          child: Text(
            title,
            style: TextStyle(
              color: titleColor,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        // Danh sách các công việc trong danh mục này
        ...tasks.map((task) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: TaskItem(
            task: task,
            onCheckboxChanged: (value) => onTaskToggle(value, task),
            showListName: showListName, // Truyền thông tin hiển thị tên danh sách xuống TaskItem
          ),
        )).toList(),
      ],
    );
  }
}