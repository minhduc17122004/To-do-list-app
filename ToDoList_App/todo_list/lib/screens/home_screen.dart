import 'package:flutter/material.dart'; // Thư viện Flutter
// Package provider cung cấp framework để quản lý state
import 'package:provider/provider.dart'; // Thư viện Provider để quản lý trạng thái

import 'add_task_screen.dart'; // Thư viện AddTaskScreen để thêm task
import '../data/lists_data.dart'; // Thư viện ListsData chứa danh sách các danh sách công việc
import '../widgets/add_list_dialog.dart'; // Thư viện AddListDialog để thêm danh sách mới
import '../widgets/task_category.dart'; // Thư viện TaskCategory để hiển thị danh sách công việc theo danh mục
import '../widgets/task_item.dart'; // Thư viện TaskItem để hiển thị từng công việc

import '../providers/task_provider.dart'; // Thư viện TaskProvider để quản lý trạng thái công việc. Tạo các provider classes riêng để implement logic cụ thể cho ứng dụng
import '../models/task.dart'; // Thư viện Task chứa mô hình công việc

class HomeScreen extends StatefulWidget {
  // khai báo HomeScreen là một StatefulWidget
  const HomeScreen({super.key}); // Khai báo constructor cho HomeScreen

  @override
  State<HomeScreen> createState() => _HomeScreenState(); // Tạo một đối tượng trạng thái cho HomeScreen có tên là _HomeScreenState để xử lý logic và trạng thái của widget
}

class _HomeScreenState extends State<HomeScreen> {
  // Tạo một lớp chứa trạng thái riêng cho HomeScreen, mọi thay đổi trạng thái sẽ được quản lý trong lớp này
  String _selectedList =
      'Danh sách tất cả'; // Danh sách được chọn khi vào màn hình

  // Controller cho dialog thêm list mới
  final TextEditingController _newListController = TextEditingController();

  // Controller cho TextField trong bottomNavigationBar
  final TextEditingController _quickTaskController = TextEditingController();

  // Hàm show dialog thêm danh sách mới
  void _showAddListDialog() {
    // Hàm này sẽ hiển thị một dialog để thêm danh sách mới
    showDialog(
      // Hàm showDialog sẽ hiển thị một dialog
      context:
          context, // context là một đối tượng BuildContext, nó chứa thông tin về vị trí của widget trong cây widget
      builder: (BuildContext context) {
        // Hàm builder sẽ tạo một widget để hiển thị dialog
        return AddListDialog(
          // Tạo một đối tượng AddListDialog
          controller:
              _newListController, // Truyền vào controller để lấy giá trị từ TextField
          onListAdded: (String newList) {
            // Hàm này sẽ được gọi khi người dùng thêm danh sách mới
            setState(() {
              // setState sẽ thông báo cho Flutter rằng trạng thái của widget đã thay đổi và cần được xây dựng lại
              _selectedList = newList; // cập nhật danh sách được chọn
            });
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Hàm build sẽ tạo ra một widget để hiển thị HomeScreen
    // Lấy danh sách công việc từ provider
    final taskProvider = Provider.of<TaskProvider>(
      context,
    ); // Lấy đối tượng TaskProvider từ context
    final List<Task> displayedTasks = taskProvider.getTasksByList(
      _selectedList,
    ); // Lấy danh sách công việc theo danh sách được chọn
    final hasTasks =
        displayedTasks
            .isNotEmpty; // Kiểm tra xem có công việc nào trong danh sách không

    // Lấy tasks phân loại theo danh mục cho danh sách đã chọn
    final Map<String, List<Task>> tasksByCategory = taskProvider
        .getTasksByCategoryForList(_selectedList);

    return Scaffold(
      // Scaffold là một widget cung cấp cấu trúc cơ bản cho ứng dụn
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 1, 115, 182),
        leading: const Padding(
          // Leading widget là widget nằm bên trái AppBar
          // Icon nằm bên trái AppBar
          padding: EdgeInsets.all(12), // khoảng cách giữa icon và viền
          child: Icon(Icons.check_circle, color: Colors.white, size: 30),
        ),
        title: PopupMenuButton<String>(
          onSelected: (value) {
            // Hàm này sẽ được gọi khi người dùng chọn một mục trong PopupMenu
            if (value == 'Danh sách mới') {
              _showAddListDialog();
              return;
            }
            setState(() {
              _selectedList = value; // Cập nhật danh sách được chọn
            });
          },
          color: const Color.fromARGB(255, 1, 63, 113), // Màu nền của PopupMenu
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ), // Bo tròn các góc của PopupMenu
          itemBuilder: // Hàm này sẽ tạo ra danh sách các mục trong PopupMenu
              (context) => [
                // Danh sách các mục
                ...ListsData.listOptions.map((option) {
                  // Xác định icon và kiểu padding dựa vào loại item
                  IconData icon;
                  EdgeInsetsGeometry itemPadding;

                  if (option == 'Danh sách tất cả') {
                    icon = Icons.home;
                    itemPadding = const EdgeInsets.symmetric(
                      horizontal: 16, // khoảng cách bên trái và phải là 16
                      vertical: 8, // khoảng cách bên trên và dưới là 8
                    );
                  } else if (option == 'Kết thúc') {
                    icon = Icons.check_box;
                    itemPadding = const EdgeInsets.symmetric(
                      horizontal: 16, // khoảng cách bên trái và phải là 16
                      vertical: 8, // khoảng cách bên trên và dưới là 8
                    );
                  } else {
                    icon = Icons.list;
                    itemPadding = const EdgeInsets.only(
                      left: 32,
                      right: 16,
                      top: 8,
                      bottom: 8,
                    ); // Thụt lề trái vào 32
                  }

                  // Lấy số lượng task trong danh sách này
                  final taskCount = Provider.of<TaskProvider>(
                    context, // Lấy đối tượng TaskProvider từ context
                    listen:
                        false, // Không cần lắng nghe sự thay đổi của TaskProvider
                  ).countTasksInList(option);

                  return PopupMenuItem<String>(
                    value: option,
                    padding: EdgeInsets.zero, // Bỏ padding mặc định
                    child: Container(
                      padding: itemPadding, // Sử dụng padding tùy chỉnh
                      child: Row(
                        children: [
                          Icon(icon, color: Colors.white, size: 22),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              option,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight:
                                    _selectedList ==
                                            option // Kiểm tra xem danh sách hiện tại có phải là danh sách được chọn không
                                        ? FontWeight
                                            .bold // Nếu đúng, in đậm
                                        : FontWeight
                                            .normal, // Nếu sai, in thường
                                fontSize: 20,
                              ),
                            ),
                          ),
                          // Hiển thị số lượng task
                          if (taskCount > 0) // Chỉ hiển thị khi có task
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                // Thêm hiệu ứng bo tròn
                                color:
                                    option == 'Kết thúc'
                                        ? Colors.green.withOpacity(
                                          0.3,
                                        ) // Màu xanh nhạt cho danh sách "Kết thúc"
                                        : Colors.white.withOpacity(
                                          0.2,
                                        ), // Màu trắng nhạt cho các danh sách khác
                                borderRadius: BorderRadius.circular(
                                  12,
                                ), // Bo tròn các góc
                              ),
                              child: Text(
                                taskCount.toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                }),
                // Mục "Danh sách mới" ở cuối, bị mờ và không chọn được
                PopupMenuItem<String>(
                  value: 'Danh sách mới', // Thêm value
                  padding: EdgeInsets.zero, // Bỏ padding mặc định
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ), // Thêm padding cho Container
                    child: Row(
                      children: const [
                        Icon(
                          Icons.playlist_add,
                          color: Colors.white60,
                          size: 22,
                        ),
                        SizedBox(width: 12),
                        Text(
                          'Danh sách mới',
                          style: TextStyle(color: Colors.white60, fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
          child: Row(
            // Tạo một hàng để hiển thị tên danh sách hiện tại
            mainAxisSize: MainAxisSize.min, // Chiều rộng tối thiểu của hàng
            children: [
              const SizedBox(width: 8),
              Text(
                _selectedList,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 10),
              const Icon(Icons.arrow_drop_down, color: Colors.white),
            ],
          ),
        ),
        actions: const [
          // DS widget nằm bên phải AppBar
          Icon(Icons.search, color: Colors.white),
          SizedBox(width: 16), // Khoảng cách giữa các icon
          Icon(Icons.more_vert, color: Colors.white),
          SizedBox(width: 8), // Khoảng cách giữa các icon
        ],
      ),
      body:
          hasTasks
              ? (_selectedList == 'Kết thúc')
                  // Nếu đang ở danh sách "Kết thúc", hiển thị danh sách task không phân theo danh mục
                  ? ListView.builder(
                    // Sử dụng ListView.builder để tạo danh sách công việc
                    itemCount:
                        displayedTasks
                            .length, // Số lượng công việc trong danh sách
                    itemBuilder: (context, index) {
                      // Hàm này sẽ tạo ra từng item trong danh sách
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                        ), // Thêm khoảng cách bên trái và phải
                        child: TaskItem(
                          // Tạo một item công việc
                          task: displayedTasks[index], // Công việc hiện tại
                          onCheckboxChanged: // Hàm này sẽ được gọi khi người dùng đánh dấu công việc
                              (checked) => taskProvider.toggleTask(
                                displayedTasks[index],
                              ),
                          showListName:
                              true, // Không hiển thị tên danh sách hiện tại trong danh sách "Kết thúc"
                          showOriginalListInCompletedTasks:
                              true, // Hiển thị danh sách gốc trong danh sách "Kết thúc"
                        ),
                      );
                    },
                  )
                  // Nếu không phải danh sách "Kết thúc", hiển thị theo danh mục như cũ
                  : ListView(
                    children: [
                      // Danh sách các danh mục công việc theo thứ tự ưu tiên
                      for (var category in [
                        'Quá hạn',
                        'Hôm nay',
                        'Ngày mai',
                        'Tuần này',
                        'Sắp tới',
                        'Không có ngày',
                      ])
                        if (tasksByCategory.containsKey(
                              category,
                            ) && // kiểm tra xem danh mục có tồn tại trong tasksByCategory
                            tasksByCategory[category]!
                                .isNotEmpty) // nếu danh mục có công việc
                          TaskCategory(
                            title:
                                category, // Tiêu đề danh mục (Quá hạn, Hôm nay, v.v.)
                            tasks:
                                tasksByCategory[category]!, // Danh sách công việc thuộc danh mục này
                            titleColor: TaskCategory.getCategoryColor(
                              category,
                            ), // Thay đổi cách gọi
                            showListName:
                                _selectedList ==
                                'Danh sách tất cả', // Chỉ hiển thị tên danh sách khi đang ở chế độ xem tất cả
                            onTaskToggle: (checked, task) {
                              // Hàm này sẽ được gọi khi người dùng đánh dấu công việc
                              taskProvider.toggleTask(
                                // Thay đổi trạng thái công việc
                                task,
                              ); // Xử lý khi người dùng đánh dấu hoàn thành công việc
                            },
                          ),
                    ],
                  )
              : Stack(
                children: [
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/holding_phone.png',
                          height: 180,
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 40,
                    right: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Thêm công việc đầu tiên',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic,
                            color: Colors.white,
                          ),
                        ),
                        Image.asset(
                          'assets/images/arrow.png',
                          height: 100,
                          width: 100,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Hàm này sẽ được gọi khi người dùng nhấn nút thêm công việc
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddTaskScreen()),
          ); // Chuyển đến màn hình AddTaskScreen
        },
        backgroundColor: Colors.white,
        elevation: 4, // Đổ bóng cho nút
        shape: const CircleBorder(), // Hình dạng của nút là hình tròn
        child: const Icon(Icons.add, color: Colors.blue),
      ),
      bottomNavigationBar: Container(
        color: const Color.fromARGB(255, 1, 115, 182),
        padding: const EdgeInsets.symmetric(
          vertical: 16,
        ), // Thêm khoảng cách dọc 16px phía trên và dưới bên trong Container
        height: 60, // Chiều cao của thanh điều hướng
        child: Row(
          children: [
            const SizedBox(width: 10), // Khoảng cách bên trái
            const Icon(Icons.mic, color: Colors.white),
            const SizedBox(width: 10),
            Expanded(
              // Mở rộng cho phép textfield để chiếm không gian còn lại
              child: TextField(
                controller: _quickTaskController,
                decoration: const InputDecoration(
                  hintText: 'Nhập nhiệm vụ tại đây...',
                  hintStyle: TextStyle(color: Colors.white60),
                  enabledBorder: UnderlineInputBorder(
                    // Đường viền khi không có focus
                    borderSide: BorderSide(color: Colors.white60),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xFF80CFFF),
                      width: 1.5,
                    ),
                  ),
                ),
                cursorColor: Color(0xFF80CFFF), // Màu con trỏ
                style: const TextStyle(color: Colors.white),
                onSubmitted: (value) {
                  // Hàm này sẽ được gọi khi người dùng nhấn Enter
                  if (value.isNotEmpty) {
                    // Tạo task mới, sử dụng DateTime.now() chỉ như một giá trị mặc định
                    // nhưng không dùng để hiển thị hoặc tính toán
                    final task = Task(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      title: value,
                      date:
                          DateTime.now(), // Vẫn cần cung cấp giá trị nhưng sẽ bị bỏ qua
                      time: const TimeOfDay(
                        hour: 0,
                        minute: 0,
                      ), // Thời gian không xác định
                      repeat: 'Không lặp lại',
                      list: 'Mặc định', // Luôn thêm vào danh sách Mặc định
                    );

                    // Thêm task vào provider
                    taskProvider.addTask(task);

                    // Xóa text sau khi thêm
                    _quickTaskController.clear();
                  }
                },
              ),
            ),
          ],
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 1, 45, 81),
    );
  }
}
