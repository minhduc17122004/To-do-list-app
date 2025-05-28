import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/lists_data.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';
import '../widgets/add_list_dialog.dart';
import '../widgets/back_confirmation_dialog.dart';
import '../widgets/custom_repeat_dialog.dart';
import '../widgets/delete_confirmation_dialog.dart';
import '../utils/date_format_utils.dart';

class AddTaskScreen extends StatefulWidget {
  final Task?
  existingTask; // Task hiện có để chỉnh sửa, có thể là null nếu tạo mới
  // hàm khởi tạo
  // Nếu có task hiện có, truyền vào để chỉnh sửa
  // Nếu không có task hiện có, truyền vào null để tạo mới
  const AddTaskScreen({
    super.key,
    this.existingTask, // Có thể là null khi tạo mới task
  });

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState(); //  khởi tạo đối tượng
  // trả về một đối tượng của lớp _AddTaskScreenState
  // lớp này sẽ quản lý trạng thái của widget AddTaskScreen
  // và sẽ được gọi khi widget này được tạo ra
  // lớp này sẽ kế thừa từ State<AddTaskScreen>
  // và sẽ có các phương thức để quản lý trạng thái của widget này
  // và sẽ có các thuộc tính để lưu trữ trạng thái của widget này
  // và sẽ có các phương thức để xây dựng giao diện của widget này
  // và sẽ có các phương thức để xử lý các sự kiện của widget này
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  // kế thừa từ State<AddTaskScreen>
  final TextEditingController _taskController =
      TextEditingController(); // Controller để quản lý nội dung của TextField
  DateTime? _selectedDate; // Biến để lưu ngày đã chọn
  TimeOfDay? _selectedTime; // Biến để lưu giờ đã chọn
  String _selectedRepeat = 'Không lặp lại'; // Biến để lưu kiểu lặp lại đã chọn
  // Danh sách các tùy chọn lặp lại
  final List<String> _repeatOptions = [
    'Không lặp lại',
    'Hàng ngày',
    'Hàng tuần (Thứ 2-Thứ 6)',
    'Hàng tuần',
    'Hàng tháng',
    'Hàng năm',
    'Khác...',
  ];
  String? _selectedList; // Biến để lưu danh sách đã chọn
  String? _taskId; // Thêm biến để lưu ID của task đang chỉnh sửa

  @override
  void initState() {
    super.initState();

    // Kiểm tra xem có phải là chỉnh sửa task hay không
    if (widget.existingTask != null) {
      // Gán dữ liệu từ task hiện có vào các trường
      _taskController.text = widget.existingTask!.title; // Gán tiêu đề task
      _selectedDate = widget.existingTask!.date; // Gán ngày task
      _selectedTime = widget.existingTask!.time; // Gán giờ task
      _selectedRepeat = widget.existingTask!.repeat; // Gán kiểu lặp lại task
      _selectedList =
          widget.existingTask!.list ==
                  'Kết thúc' // Nếu task nằm trong danh sách "Kết thúc"
              ? widget
                  .existingTask!
                  .originalList // đúng thì gán danh sách gốc
              : widget.existingTask!.list; // sai thì gán danh sách hiện tại
      _taskId = widget.existingTask!.id; // Lưu ID của task hiện có
    } else {
      // Nếu là tạo mới, khởi tạo giá trị mặc định
      _selectedList =
          ListsData.getAddTaskListOptions()[0]; // Lấy item đầu tiên của danh sách dành cho màn hình thêm task
    }
  }

  // Hiển thị dialog thêm danh sách
  void _showAddListDialog() {
    final controller =
        TextEditingController(); // tạo một textediting controller mới dùng để điều khiển và lấy dl từ textfield
    showDialog(
      context: context, // tham số ngữ cảnh widget hiện tại
      builder: (BuildContext context) {
        // hàm trả về giao diện của dialog có tên là AddListDialog
        return AddListDialog(
          controller:
              controller, // Truyền TextEditingController vào cho TextField
          onListAdded: (String newList) {
            // Truyền một callback để xử lý khi người dùng nhấn nút "Thêm danh sách".
            setState(() {
              _selectedList = newList;
            });
          },
        );
      },
    );
  }

  // Hiển thị dialog lặp lại
  void _showCustomRepeatDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomRepeatDialog(
          onRepeatSet: (number, unit) {
            // Truyền một callback để xử lý khi người dùng nhấn nút "Lặp lại".
            // number là số lần lặp lại
            // unit là đơn vị lặp lại (ngày, tuần, tháng, năm)
            final customValue = 'Khác ($number $unit)'; // Tạo giá trị tùy chỉnh
            setState(() {
              _repeatOptions.removeWhere(
                (item) => item.startsWith('Khác ('),
              ); // Xóa các tùy chọn khác
              _repeatOptions.insert(0, customValue); // Thêm tùy chọn mới
              _selectedRepeat = customValue; // Cập nhật giá trị đã chọn
            });
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isEditing =
        widget.existingTask !=
        null; // Kiểm tra xem có phải là chỉnh sửa task hay không

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 1, 115, 182),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            // Kiểm tra xem có thay đổi nào không
            bool hasChanges = false;

            if (widget.existingTask != null) {
              // Trường hợp chỉnh sửa - so sánh với task gốc
              hasChanges =
                  _taskController.text !=
                      widget.existingTask!.title || // so sánh tiêu đề
                  _selectedDate?.day != widget.existingTask!.date.day ||
                  _selectedDate?.month != widget.existingTask!.date.month ||
                  _selectedDate?.year != widget.existingTask!.date.year ||
                  _selectedTime?.format(context) !=
                      widget.existingTask!.time.format(context) ||
                  _selectedRepeat != widget.existingTask!.repeat ||
                  _selectedList !=
                      (widget.existingTask!.list == 'Kết thúc'
                          ? widget.existingTask!.originalList
                          : widget.existingTask!.list);
            } else {
              // Trường hợp thêm mới - kiểm tra xem có nhập dữ liệu gì chưa
              hasChanges =
                  _taskController.text.isNotEmpty ||
                  _selectedDate != null ||
                  _selectedTime != null ||
                  _selectedRepeat != 'Không lặp lại' ||
                  _selectedList != ListsData.getAddTaskListOptions()[0];
            }

            if (hasChanges) {
              // Sử dụng widget BackConfirmationDialog
              final actionType =
                  widget.existingTask != null ? "chỉnh sửa" : "thêm mới";
              BackConfirmationDialog.show(
                context: context,
                actionType: actionType, // Xác nhận hành động
                onConfirm: () {
                  Navigator.of(context).pop(); // Quay lại màn hình trước
                },
              );
            } else {
              Navigator.pop(context);
              print(
                'Người dùng đã quay lại mà không có thay đổi',
              ); // Log xác nhận khi không có thay đổi
            }
          },
        ),
        title: Text(
          isEditing ? 'Chỉnh sửa nhiệm vụ' : 'Nhiệm vụ mới',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          // Chỉ hiển thị nút xóa khi đang chỉnh sửa task
          if (isEditing)
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.white),
              onPressed: () {
                // Sử dụng phương thức tĩnh để hiển thị dialog xác nhận xóa
                DeleteConfirmationDialog.show(
                  context: context,
                  content: 'Bạn có chắc chắn muốn xóa nhiệm vụ này?',
                  onConfirm: () {
                    // Xóa task và quay về màn hình chính
                    if (_taskId != null) {
                      Provider.of<TaskProvider>(
                        context,
                        listen: false,
                      ).removeTask(_taskId!);
                    }
                    Navigator.pop(context); // Quay về màn hình chính
                  },
                );
              },
            ),
        ],
      ),
      backgroundColor: const Color.fromARGB(255, 1, 45, 81),
      body: SingleChildScrollView(
        // Cuộn nội dung
        child: Padding(
          padding: const EdgeInsets.all(16.0), // căn lề 16px
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Là những gì được thực hiện?', // Tiêu đề
                style: TextStyle(
                  fontWeight: FontWeight.bold, // Chữ đậm
                  color: Color(0xFF80CFFF), // Màu xanh
                  fontSize: 16, // Kích thước 16px
                ),
              ),
              Row(
                children: [
                  Expanded(
                    // Chiếm hết chiều rộng còn lại
                    child: TextField(
                      controller: _taskController,
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                      decoration: const InputDecoration(
                        hintText: 'Nhiệm vụ nhập đây',
                        hintStyle: TextStyle(color: Colors.white60),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white60,
                          ), // đường gạch dưới khi chưa chọn
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            // đường gạch dưới khi đã chọn
                            color: Color(0xFF80CFFF),
                            width: 2,
                          ),
                        ),
                      ),
                      cursorColor: Color(0xFF80CFFF), // con trỏ cũng màu xanh
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 40),
              const Text(
                'Ngày đáo hạn',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF80CFFF),
                  fontSize: 16,
                ),
              ),

              GestureDetector(
                // chạm vào để chọn ngày
                // GestureDetector là widget cho phép nhận diện các cử chỉ chạm
                onTap: _selectDate, // chọn ngày
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.only(
                          bottom: 2,
                        ), // chỉnh khoảng cách dưới dòng
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: Colors.white60),
                          ),
                        ),
                        child: Text(
                          _selectedDate == null
                              ? 'Không có ngày'
                              : DateFormatUtils.formatDate(_selectedDate!),
                          style: TextStyle(
                            color:
                                _selectedDate == null
                                    ? Colors.white60
                                    : Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.calendar_today,
                        color: Colors.white,
                      ),
                      onPressed: _selectDate,
                    ),
                    if (_selectedDate != null)
                      IconButton(
                        icon: const Icon(Icons.clear, color: Colors.white),
                        onPressed: () {
                          setState(() {
                            _selectedDate = null;
                          });
                        },
                      ),
                  ],
                ),
              ),

              // Only show time picker if date is selected
              if (_selectedDate != null) ...[
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: _selectTime,
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.only(
                            bottom: 2,
                          ), // chỉnh khoảng cách dưới dòng
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: Colors.white60),
                            ),
                          ),
                          child: Text(
                            _selectedTime != null
                                ? _selectedTime!.format(context)
                                : 'Chọn giờ',
                            style: TextStyle(
                              color:
                                  _selectedTime == null
                                      ? Colors.white60
                                      : Colors.white,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.access_time,
                          color: Colors.white,
                        ),
                        onPressed: _selectTime, // mở lịch chọn giờ
                      ),
                      if (_selectedTime != null)
                        IconButton(
                          icon: const Icon(Icons.clear, color: Colors.white),
                          onPressed: () {
                            setState(() {
                              _selectedTime = null; // xóa giờ đã chọn
                            });
                          },
                        ),
                    ],
                  ),
                ),
              ],
              SizedBox(height: 10),
              const Text(
                'Thông báo',
                style: TextStyle(color: Color(0xFF80CFFF), fontSize: 15),
              ),
              Text(
                _selectedDate == null
                    ? 'Không có ngày - không có thông báo.'
                    : 'Thông báo vào ngày và giờ đã chọn.',
                style: const TextStyle(color: Colors.white60, fontSize: 13),
              ),
              const SizedBox(height: 40),
              if (_selectedDate != null) ...[
                const Text(
                  'Lặp lại',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF80CFFF),
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                  ), // cách 2 bên trái phải 10px
                  child: Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween, // căn đều 2 bên
                    children: [
                      Expanded(
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            isDense: true, // làm dẹt dropdown
                            value: _selectedRepeat,
                            icon: const Icon(
                              Icons.arrow_drop_down,
                              color: Colors.white60,
                              size: 25,
                            ),
                            // 1) Style cho các item trong menu xổ xuống:
                            //    (màu xanh đen cho items)
                            items:
                                _repeatOptions.map<DropdownMenuItem<String>>((
                                  String
                                  value, // lấy từng giá trị trong danh sách
                                ) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(
                                      value,
                                      style: const TextStyle(
                                        color: Color.fromARGB(
                                          210,
                                          50,
                                          49,
                                          49,
                                        ), // màu items
                                        fontSize: 18,
                                      ),
                                    ),
                                  );
                                }).toList(), // chuyển đổi thành danh sách
                            // 2) Builder cho phần hiển thị giá trị đang chọn:
                            //    (màu trắng cho selected value)
                            selectedItemBuilder: (BuildContext context) {
                              return _repeatOptions.map<Widget>((String value) {
                                return Text(
                                  value,
                                  style: const TextStyle(
                                    color: Color.fromARGB(
                                      255,
                                      225,
                                      223,
                                      223,
                                    ), // màu riêng cho selected
                                    fontSize: 18,
                                  ),
                                );
                              }).toList();
                            },

                            // Không dùng style chung nữa, vì đã custom qua selectedItemBuilder & items
                            onChanged: (String? newValue) {
                              if (newValue == 'Khác...') {
                                _showCustomRepeatDialog();
                              } else {
                                setState(() {
                                  _selectedRepeat = newValue!;
                                });
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 45),
              const Text(
                'Thêm vào danh sách',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF80CFFF),
                  fontSize: 16,
                ),
              ),
              Container(
                padding: const EdgeInsets.only(left: 10), // cách trái 10px
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center, // căn giữa
                  children: [
                    Expanded(
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value:
                              _selectedList, // giá trị bắt đầu là danh sách hiện tại
                          icon: const Icon(
                            Icons.arrow_drop_down,
                            color: Colors.white60,
                          ),
                          dropdownColor: const Color.fromARGB(
                            255,
                            255,
                            254,
                            254,
                          ),
                          isDense: true, // làm dẹt dropdown`
                          // 1) Style cho các item trong menu xổ xuống:
                          //    (màu xanh đen cho items)
                          items:
                              ListsData.getAddTaskListOptions()
                                  .map<DropdownMenuItem<String>>((
                                    String value,
                                  ) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(
                                        value,
                                        style: const TextStyle(
                                          color: Color.fromARGB(
                                            210,
                                            44,
                                            44,
                                            43,
                                          ), // màu items
                                          fontSize: 18,
                                        ),
                                      ),
                                    );
                                  })
                                  .toList(),
                          // 2) Builder cho phần hiển thị giá trị đang chọn:
                          //    (màu trắng cho selected value)
                          selectedItemBuilder: (BuildContext context) {
                            return ListsData.getAddTaskListOptions()
                                .map<Widget>((String value) {
                                  return Text(
                                    value,
                                    style: const TextStyle(
                                      color: Color.fromARGB(
                                        255,
                                        225,
                                        223,
                                        223,
                                      ), // màu riêng cho selected
                                      fontSize: 18,
                                    ),
                                  );
                                })
                                .toList();
                          },

                          // Không dùng style chung nữa, vì đã custom qua selectedItemBuilder & items
                          onChanged: (String? newValue) {
                            // chọn danh sách
                            setState(() {
                              _selectedList =
                                  newValue!; // cập nhật danh sách đã chọn
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Align(
                      alignment: Alignment.center, // căn giữa
                      child: IconButton(
                        icon: const Icon(
                          Icons.playlist_add,
                          color: Colors.white,
                          size: 30,
                        ),
                        onPressed: _showAddListDialog,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        // nút nổi góc dưới bên phải màn hình
        onPressed: () {
          if (_taskController.text.isEmpty) {
            // kiểm tra xem có nhập tên nhiệm vụ không
            ScaffoldMessenger.of(context).showSnackBar(
              // hiển thị thông báo
              const SnackBar(content: Text('Vui lòng nhập tên nhiệm vụ')),
            );
            return;
          }

          // Lấy provider để thêm/ sửa task
          final taskProvider = Provider.of<TaskProvider>(
            context,
            listen: false,
          );
          // Xử lý thêm hoặc sửa task
          if (isEditing && _taskId != null) {
            // Đây là trường hợp chỉnh sửa, xóa task cũ và thêm task mới với cùng ID
            taskProvider.removeTask(_taskId!);

            // Tạo task mới với ID cũ
            final updatedTask = Task(
              id: _taskId!,
              title: _taskController.text,
              date: _selectedDate ?? DateTime.now(),
              time: _selectedTime ?? TimeOfDay.now(),
              repeat: _selectedRepeat,
              list: _selectedList ?? 'Mặc định',
              isCompleted: widget.existingTask!.isCompleted,
            );

            // Thêm task đã cập nhật vào provider
            taskProvider.addTask(updatedTask);
          } else {
            // Tạo task mới
            final task = Task(
              id: DateTime.now().millisecondsSinceEpoch.toString(),
              title: _taskController.text,
              date: _selectedDate ?? DateTime.now(),
              time: _selectedTime ?? TimeOfDay.now(),
              repeat: _selectedRepeat,
              list: _selectedList ?? 'Mặc định',
            );

            // Thêm task vào provider
            taskProvider.addTask(task);
          }

          // Quay trở lại màn hình chính
          Navigator.pop(context);
        },
        backgroundColor: Colors.white,
        elevation: 5, // độ nổi của nút
        shape: const CircleBorder(), // hình dạng nút tròn
        child: const Icon(Icons.check, color: Colors.blue),
      ),
    );
  }

  void _selectDate() async {
    // chọn ngày
    final DateTime? picked = await DateFormatUtils.selectDate(
      context: context,
      initialDate: _selectedDate,
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _selectTime() async {
    // chọn giờ
    final TimeOfDay? picked = await DateFormatUtils.selectTime(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }
}
