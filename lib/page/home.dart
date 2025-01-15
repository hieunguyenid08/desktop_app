import 'package:fluent_ui/fluent_ui.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Create a [Player] to control playback.
  late final player = Player();
  // Create a [VideoController] to handle video output from [Player].
  late final controller = VideoController(player);

  @override
  void initState() {
    super.initState();
    // Mở stream với các tùy chọn cho livestream
    player.open(
      Media(
        'rtsp://192.168.1.18:554/live',
        // Thêm các tùy chọn để tối ưu cho streaming
        httpHeaders: const {
          'User-Agent': 'Mozilla/5.0',
        },
        extras: {
          'low-latency': '1',
          'rtsp-tcp': '1',
          'network-timeout': '3000',
          'buffer-duration': '0',
        },
      ),
      play: true,
    );
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  Future<void> captureScreenshot() async {
    try {
      final screenshot = await player.screenshot();
      if (screenshot == null) throw 'Không thể chụp ảnh';
       final directory = Directory('assets/image');
      // Tạo thư mục nếu chưa tồn tại
      if (!directory.existsSync()) {
        directory.createSync(recursive: true);
      }
      // final appDir = await getApplicationDocumentsDirectory();
      // final fileName = 'screenshot_${DateTime.now().millisecondsSinceEpoch}.jpg';
      // final file = File('${appDir.path}/$fileName');
      // await file.writeAsBytes(screenshot);
      
      final fileName = 'screenshot_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final file = File('${directory.path}/$fileName');
      await file.writeAsBytes(screenshot);
      if (mounted) {
        displayInfoBar(
          context,
          builder: (context, close) {
            return InfoBar(
              title: const Text('Thành công'),
              content: Text('Đã lưu ảnh: ${file.path}'),
              severity: InfoBarSeverity.success,
            );
          },
        );
      }
    } catch (e) {
      if (mounted) {
        displayInfoBar(
          context,
          builder: (context, close) {
            return InfoBar(
              title: const Text('Lỗi'),
              content: Text('Không thể chụp ảnh: $e'),
              severity: InfoBarSeverity.error,
            );
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      content: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Center(
                child: FractionallySizedBox(
                  widthFactor: 0.7,
                  child: Column(
                    children: [
                      Expanded(
                        child: AspectRatio(
                          aspectRatio: 16 / 9,
                          child: Video(controller: controller),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Button(
                        child: const Text('Chụp ảnh'),
                        onPressed: captureScreenshot,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
