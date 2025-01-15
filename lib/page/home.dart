import 'package:fluent_ui/fluent_ui.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';

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
    // Play a [Media] or [Playlist].
    // Replace the URL with your RTSP stream URL.
    player.open(Media(
        'rtsp://192.168.1.149:8554/stream')); // Replace with your RTSP stream URL
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
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
                  widthFactor: 0.7, // Chiếm 70% chiều rộng màn hình
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Video(controller: controller),
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
