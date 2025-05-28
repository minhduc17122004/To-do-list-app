import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'providers/task_provider.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      // quản lý trạng thái cho ứng dụng
      create: (context) => TaskProvider(), // tạo một đối tượng TaskProvider
      // TaskProvider là một lớp kế thừa từ ChangeNotifier, nó sẽ thông báo cho các widget con khi có sự thay đổi về trạng thái của nó
      child: const MyApp(), // MyApp là widget chính của ứng dụng
      // nó sẽ được xây dựng lại khi có sự thay đổi về trạng thái của TaskProvider
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo Clone',
      debugShowCheckedModeBanner: false, // ẩn banner debug
      localizationsDelegates: const [
        // cấu hình ngôn ngữ
        GlobalMaterialLocalizations
            .delegate, // cấu hình ngôn ngữ cho MaterialApp
        GlobalWidgetsLocalizations.delegate, // cấu hình ngôn ngữ cho WidgetsApp
      ],
      supportedLocales: const [
        Locale('vi', ''), // cấu hình ngôn ngữ cho hệ thống
      ],
      home: const HomeScreen(),
    );
  }
}
