import 'package:flutter/material.dart';

class Task {
  final String id;
  final String title;
  final DateTime date;
  final TimeOfDay time;
  final String repeat;
  String list;
  String originalList;
  bool isCompleted;

  Task({
    required this.id,
    required this.title,
    required this.date,
    required this.time,
    required this.repeat,
    required this.list,
    this.isCompleted = false,
  }) : originalList = list;

  // Tạo task từ dữ liệu nhận được từ màn hình thêm task
  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: map['title'],
      date: map['date'],
      time: map['time'],
      repeat: map['repeat'],
      list: map['list'],
    );
  }

  // Lấy danh mục của task dựa vào ngày (quá hạn, hôm nay, ngày mai, tuần này)
  String get category {
    // Nếu task thuộc danh sách Mặc định, gán danh mục là "Không có ngày"
    if (list == 'Mặc định') {
      return 'Không có ngày';
    }

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final taskDay = DateTime(date.year, date.month, date.day);

    // Nếu ngày của task trước ngày hiện tại, task đã quá hạn
    if (taskDay.isBefore(today)) {
      return 'Quá hạn';
    }
    // Nếu ngày của task là ngày hiện tại
    else if (taskDay.isAtSameMomentAs(today)) {
      // Kiểm tra thêm thời gian
      // Lấy thời gian hiện tại
      final currentHour = now.hour;
      final currentMinute = now.minute;

      // Nếu thời gian của task đã qua so với thời gian hiện tại
      if (time.hour < currentHour ||
          (time.hour == currentHour && time.minute < currentMinute)) {
        return 'Quá hạn';
      } else {
        return 'Hôm nay';
      }
    } else if (taskDay.difference(today).inDays == 1) {
      return 'Ngày mai';
    } else if (taskDay.difference(today).inDays < 7) {
      return 'Tuần này';
    } else {
      return 'Sắp tới';
    }
  }

  // Format thời gian để hiển thị (VD: 12:00)
  String getFormattedTime(BuildContext context) {
    return time.format(context);
  }

  // Format ngày để hiển thị (VD: Hôm nay, 12:00)
  String getFormattedDate() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final taskDay = DateTime(date.year, date.month, date.day);

    if (taskDay.isAtSameMomentAs(today)) {
      // nếu taskDay là hôm nay
      return 'Hôm nay';
    } else if (taskDay.isAtSameMomentAs(tomorrow)) {
      // nếu taskDay là ngày mai
      return 'Ngày mai';
    } else {
      // Lấy tên thứ trong tuần
      final weekdays = [
        'Thứ 2',
        'Thứ 3',
        'Thứ 4',
        'Thứ 5',
        'Thứ 6',
        'Thứ 7',
        'CN',
      ];
      return weekdays[date.weekday - 1]; // Thứ 2 là 1, CN là 7
    }
  }
}
