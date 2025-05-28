class ListsData {
  // Danh sách đầy đủ các danh sách có trong ứng dụng
  static final List<String> listOptions = [
    'Danh sách tất cả',
    'Mặc định',
    'Cá nhân',
    'Công việc',
    'Mua sắm',
    'Quan trọng',
    'Ưa thích',
    'Kết thúc',
  ];
  
  // Phương thức lấy danh sách cho màn hình thêm task
  static List<String> getAddTaskListOptions() {
    // Loại bỏ "Danh sách tất cả" và "Kết thúc" vì không thể thêm task vào những danh sách này
    return listOptions.where((list) => 
      list != 'Danh sách tất cả' && list != 'Kết thúc').toList();
  }
}
