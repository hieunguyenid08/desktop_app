import 'package:desktop_app/page/home.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:window_manager/window_manager.dart';
import 'package:flutter/services.dart';

import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  windowManager.ensureInitialized();
  windowManager.waitUntilReadyToShow().then((_) async {
    await windowManager.setTitle('ParknGo');
    await windowManager.setTitleBarStyle(TitleBarStyle.normal);
    await windowManager.setBackgroundColor(Colors.transparent);
    await windowManager.setPreventClose(true);
    //await windowManager.setSize(const Size(755, 545));
    await windowManager.setMinimumSize(const Size(600, 720));
    await windowManager.center();
    await windowManager.show();
    await windowManager.setSkipTaskbar(false);
  });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FluentApp(
      title: 'Fluent App Demo',
      themeMode: ThemeMode.system,
      theme: FluentThemeData(
        brightness: Brightness.light,
        accentColor: Colors.orange,
        
        navigationPaneTheme: NavigationPaneThemeData(
             tileColor: Color(0xFF027A48), // 
            //  Color(0xFF027A48), // Background color for NavigationPane

            ),
      ),
      darkTheme: FluentThemeData(
          brightness: Brightness.dark, accentColor: Colors.orange),
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int PaneIndex = 0;

  @override
  Widget build(BuildContext context) {
    return NavigationView(
      appBar: NavigationAppBar(
        height: 50,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            'assets/images/logo.png', // Make sure to add your logo file to assets
            fit: BoxFit.contain,
          ),
        ),
        actions: WindownsButton(),
      ),
      pane: NavigationPane(
        decoration: BoxDecoration(
          color: Color(0xFF027A48),
          // Change from BorderRadius.zero to specify which corners should be rounded
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(8),
            bottomRight: Radius.circular(8),
          ),
        ),
        size: NavigationPaneSize(
          openWidth: 250.0, // Width when the pane is open
          compactWidth: 70.0, // Width in compact mode
          openMinWidth: 250.0, // Minimum width when the pane is open
          openMaxWidth: 320.0, // Maximum width when the pane is open
        ),
        displayMode: PaneDisplayMode.compact,
        selected: PaneIndex,
        onItemPressed: (value) {
          setState(() {
            PaneIndex = value;
          });
        },
        items: [
          PaneItem(
            icon: Center(
              child: Icon(FluentIcons.t_v_monitor, size: 24),
            ),
            title: Text('Màn hình giám sát'),
            body: HomePage(),
          ),
          PaneItem(
            icon: Center(
              child: Icon(FluentIcons.favorite_star, size: 24),
            ),
            title: Text('Favorite'),
            body: Container(),
          ),
        ],
        footerItems: [
          PaneItem(
            icon: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(FluentIcons.contact, size: 24),
                  SizedBox(height: 2),
                  Icon(FluentIcons.sign_out, size: 24),
                ],
              ),
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Profile'),
                SizedBox(height: 4),
                Text('Đăng xuất'),
              ],
            ),
            body: Container(),
          ),
        ],
      ),
    );
  }
}

class WindownsButton extends StatelessWidget {
  const WindownsButton({super.key});

  @override
  Widget build(BuildContext context) {
    final FluentThemeData theme = FluentTheme.of(context);
    return SizedBox(
      width: 138,
      height: 40,
      child: WindowCaption(
        brightness: theme.brightness,
        backgroundColor: Colors.transparent,
      ),
    );
  }
}
