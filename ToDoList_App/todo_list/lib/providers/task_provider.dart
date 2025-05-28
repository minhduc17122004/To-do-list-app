import 'package:flutter/material.dart';
import '../models/task.dart';

class TaskProvider extends ChangeNotifier {
  List<Task> _tasks = [];
  List<Task> _completedTasks = []; // Danh sách các task đã hoàn thành

  List<Task> get tasks => _tasks;
  List<Task> get completedTasks => _completedTasks;

  // Add a new task
  void addTask(Task task) {
    _tasks.add(task);
    notifyListeners();
  }

  // cập nhật task
  void toggleTask(Task task) {
    if (task.isCompleted) {
      // Nếu task đã được đánh dấu hoàn thành, đặt lại trạng thái và di chuyển về danh sách gốc
      task.isCompleted = false;

      // Di chuyển task từ danh sách hoàn thành về danh sách chưa hoàn thành
      _completedTasks.remove(task);
      _tasks.add(task);

      // Khôi phục danh sách gốc
      task.list = task.originalList;
    } else {
      // Nếu task chưa hoàn thành, đánh dấu là hoàn thành và di chuyển vào danh sách "Kết thúc"
      task.isCompleted = true;

      // Lưu danh sách gốc trước khi di chuyển (mặc dù đã được lưu khi khởi tạo)
      task.originalList = task.list;

      // Di chuyển task từ danh sách chưa hoàn thành sang danh sách hoàn thành
      _tasks.remove(task);
      _completedTasks.add(task);

      // Đặt danh sách hiện tại là "Kết thúc"
      task.list = 'Kết thúc';
    }
    notifyListeners(); // Cập nhật UI
  }

  // Dựa vào tên danh sách để lấy danh sách task
  List<Task> getTasksByList(String listName) {
    if (listName == 'Danh sách tất cả') {
      return _tasks;
    } else if (listName == 'Kết thúc') {
      return _completedTasks;
    } else {
      return _tasks.where((task) => task.list == listName).toList();
    }
  }

  // Lấy danh sách task theo danh mục
  Map<String, List<Task>> getTasksByCategoryForList(String listName) {
    // Sử dụng lại getTasksByList
    final filteredTasks = getTasksByList(listName);

    // Tạo Map để phân loại task theo danh mục
    final Map<String, List<Task>> categorized = {};

    // Tạo các danh mục trước để đảm bảo thứ tự
    final categories = [
      'Không có ngày',
      'Quá hạn',
      'Hôm nay',
      'Ngày mai',
      'Tuần này',
      'Sắp tới',
    ];
    for (var category in categories) {
      categorized[category] = [];
    }

    // Phân loại các task vào danh mục tương ứng
    for (var task in filteredTasks) {
      final category = task.category;
      if (!categorized.containsKey(category)) {
        categorized[category] = [];
      }
      categorized[category]!.add(task);
    }

    // Loại bỏ các danh mục trống
    categorized.removeWhere((key, value) => value.isEmpty);

    return categorized;
  }

  // Xoá task
  void removeTask(String taskId) {
    _tasks.removeWhere((task) => task.id == taskId);
    _completedTasks.removeWhere((task) => task.id == taskId);
    notifyListeners();
  }

  // Đếm số lượng task trong một danh sách cụ thể
  int countTasksInList(String listName) {
    // Hàm này sẽ đếm số lượng task trong danh sách cụ thể
    if (listName == 'Danh sách tất cả') {
      // Danh sách tất cả = tổng số task chưa hoàn thành (không tính danh sách Kết thúc)
      return _tasks.length;
    } else if (listName == 'Kết thúc') {
      // Danh sách Kết thúc = số task đã hoàn thành
      return _completedTasks.length;
    } else {
      // Các danh sách khác = số task thuộc danh sách đó và chưa hoàn thành
      return _tasks.where((task) => task.list == listName).length;
    }
  }
}
