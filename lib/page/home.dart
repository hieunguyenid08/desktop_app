import 'package:fluent_ui/fluent_ui.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:opencv_dart/opencv_dart.dart' as cv;
import 'package:image/image.dart' show decodeImage, copyResize, encodeJpg;
import 'package:onnxruntime/onnxruntime.dart';
import 'package:logging/logging.dart';
import 'dart:math' show min;
import 'package:flutter/services.dart' show rootBundle;
import 'dart:math' show max;
import 'dart:typed_data';
import 'dart:math' show exp;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Tạo thêm player và controller cho video thứ 2
  late final player = Player();
  late final player2 = Player();
  late final controller = VideoController(player);
  late final controller2 = VideoController(player2);

  @override
  void initState() {
    super.initState();

    player.open(
      Media(
          'assets/video/Traffic Control CCTV.mp4'), // Thay đổi tên file theo video của bạn
      play: true,
    );

    // Khởi tạo video 2
    player2.open(
      Media(
          'assets/video/pexels-taryn-elliott-5309381 (1080p).mp4'), // Thay đổi tên file theo video của bạn
      play: true,
    );
  }

  @override
  void dispose() {
    player.dispose();
    player2.dispose();
    super.dispose();
  }

  String? latestScreenshot1;
  String? latestScreenshot2;
  final List<String> names = [
    'bicycle',
    'car',
    'motorcycle',
    'airplane',
    'bus',
    'train',
    'truck',
    'boat',
    'traffic light',
    'fire hydrant',
    'stop sign',
    'parking meter',
    'bench',
    'bird',
    'cat',
    'dog',
    'horse',
    'sheep',
    'cow',
    'elephant',
    'bear',
    'zebra',
    'giraffe',
    'backpack',
    'umbrella',
    'handbag',
    'tie',
    'suitcase',
    'frisbee',
    'skis',
    'snowboard',
    'sports ball',
    'kite',
    'baseball bat',
    'baseball glove',
    'skateboard',
    'surfboard',
    'tennis racket',
    'bottle',
    'wine glass',
    'cup',
    'fork',
    'knife',
    'spoon',
    'bowl',
    'banana',
    'apple',
    'sandwich',
    'orange',
    'broccoli',
    'carrot',
    'hot dog',
    'pizza',
    'donut',
    'cake',
    'chair',
    'couch',
    'potted plant',
    'bed',
    'dining table',
    'toilet',
    'tv',
    'laptop',
    'mouse',
    'remote',
    'keyboard',
    'cell phone',
    'microwave',
    'oven',
    'toaster',
    'sink',
    'refrigerator',
    'book',
    'clock',
    'vase',
    'scissors',
    'teddy bear',
    'hair drier',
    'toothbrush'
  ];
  final List<List<double>> _COLORS = [
    [0.000, 0.447, 0.741],
    [0.850, 0.325, 0.098],
    [0.929, 0.694, 0.125],
    [0.494, 0.184, 0.556],
    [0.466, 0.674, 0.188],
    [0.301, 0.745, 0.933],
    [0.635, 0.078, 0.184],
    [0.300, 0.300, 0.300],
    [0.600, 0.600, 0.600],
    [1.000, 0.000, 0.000],
    [1.000, 0.500, 0.000],
    [0.749, 0.749, 0.000],
    [0.000, 1.000, 0.000],
    [0.000, 0.000, 1.000],
    [0.667, 0.000, 1.000],
    [0.333, 0.333, 0.000],
    [0.333, 0.667, 0.000],
    [0.333, 1.000, 0.000],
    [0.667, 0.333, 0.000],
    [0.667, 0.667, 0.000],
    [0.667, 1.000, 0.000],
    [1.000, 0.333, 0.000],
    [1.000, 0.667, 0.000],
    [1.000, 1.000, 0.000],
    [0.000, 0.333, 0.500],
    [0.000, 0.667, 0.500],
    [0.000, 1.000, 0.500],
    [0.333, 0.000, 0.500],
    [0.333, 0.333, 0.500],
    [0.333, 0.667, 0.500],
    [0.333, 1.000, 0.500],
    [0.667, 0.000, 0.500],
    [0.667, 0.333, 0.500],
    [0.667, 0.667, 0.500],
    [0.667, 1.000, 0.500],
    [1.000, 0.000, 0.500],
    [1.000, 0.333, 0.500],
    [1.000, 0.667, 0.500],
    [1.000, 1.000, 0.500],
    [0.000, 0.333, 1.000],
    [0.000, 0.667, 1.000],
    [0.000, 1.000, 1.000],
    [0.333, 0.000, 1.000],
    [0.333, 0.333, 1.000],
    [0.333, 0.667, 1.000],
    [0.333, 1.000, 1.000],
    [0.667, 0.000, 1.000],
    [0.667, 0.333, 1.000],
    [0.667, 0.667, 1.000],
    [0.667, 1.000, 1.000],
    [1.000, 0.000, 1.000],
    [1.000, 0.333, 1.000],
    [1.000, 0.667, 1.000],
    [0.333, 0.000, 0.000],
    [0.500, 0.000, 0.000],
    [0.667, 0.000, 0.000],
    [0.833, 0.000, 0.000],
    [1.000, 0.000, 0.000],
    [0.000, 0.167, 0.000],
    [0.000, 0.333, 0.000],
    [0.000, 0.500, 0.000],
    [0.000, 0.667, 0.000],
    [0.000, 0.833, 0.000],
    [0.000, 1.000, 0.000],
    [0.000, 0.000, 0.167],
    [0.000, 0.000, 0.333],
    [0.000, 0.000, 0.500],
    [0.000, 0.000, 0.667],
    [0.000, 0.000, 0.833],
    [0.000, 0.000, 1.000],
    [0.000, 0.000, 0.000],
    [0.143, 0.143, 0.143],
    [0.286, 0.286, 0.286],
    [0.429, 0.429, 0.429],
    [0.571, 0.571, 0.571],
    [0.714, 0.714, 0.714],
    [0.857, 0.857, 0.857],
    [0.000, 0.447, 0.741],
    [0.314, 0.717, 0.741],
    [0.500, 0.500, 0.000]
  ];
  // Assuming input is a List<List<List<int>>> with shape (640, 640, 3)
  List<List<List<double>>> transposeMatrix(List<List<List<int>>> input) {
    int height = input.length;
    int width = input[0].length;
    int channels = input[0][0].length;

    // Initialize output matrix with shape (3, 640, 640)
    List<List<List<double>>> output = List.generate(
      channels,
      (_) => List.generate(
        height,
        (_) => List.generate(width, (_) => 0.0),
      ),
    );

    // Perform the transpose
    for (int c = 0; c < channels; c++) {
      for (int h = 0; h < height; h++) {
        for (int w = 0; w < width; w++) {
          output[c][h][w] = input[h][w][c].toDouble();
        }
      }
    }

    return output;
  }

  (List<List<List<double>>>, double) preprocess(cv.Mat img, List<int> inputSize,
      {List<int> swap = const [2, 0, 1]}) {
    cv.Mat paddedImg;

    // Kiểm tra số kênh màu của ảnh
    if (img.channels == 3) {
      // Tạo ảnh padding với giá trị 114
      paddedImg = cv.Mat.zeros(inputSize[0], inputSize[1], cv.MatType.CV_8UC3);
      paddedImg.setTo(cv.Scalar(114, 114, 114));
    } else {
      paddedImg = cv.Mat.ones(inputSize[0], inputSize[1], cv.MatType.CV_8UC1)
          .multiply(114);
    }

    // Tính tỷ lệ resize
    double r = min(
        inputSize[0] / img.rows.toDouble(), inputSize[1] / img.cols.toDouble());

    // Resize ảnh
    int newWidth = (img.cols * r).toInt();
    int newHeight = (img.rows * r).toInt();

    cv.Mat resizedImg = cv.resize(
      img,
      (newWidth, newHeight),
      interpolation: cv.INTER_LINEAR,
    );
    resizedImg.copyTo(paddedImg.region(cv.Rect(0, 0, newWidth, newHeight)));

    // Transpose the resized image to swap rows and columns
    List<List<List<int>>> matToList = List.generate(
      paddedImg.rows,
      (i) => List.generate(
        paddedImg.cols,
        (j) => List.generate(3, (k) => paddedImg.at<cv.Vec3b>(i, j).val[k]),
      ),
    );

    List<List<List<double>>> output = transposeMatrix(matToList);

    return (output, r);
  }
//   List<List<List<double>>> demoPostprocess(List<List<List<double>>> tensorData, List<int> imgSize, {bool p6 = false}) {
//   final List<int> strides = p6 ? [8, 16, 32, 64] : [8, 16, 32];
//   final hsizes = strides.map((stride) => imgSize[0] ~/ stride).toList();
//   final wsizes = strides.map((stride) => imgSize[1] ~/ stride).toList();

//   List<List<double>> grids = [];
//   List<List<double>> expandedStrides = [];

//   for (int i = 0; i < strides.length; i++) {
//     final hsize = hsizes[i];
//     final wsize = wsizes[i];
//     final stride = strides[i];

//     // Create grid coordinates
//     final xv = List<double>.generate(wsize, (i) => i.toDouble());
//     final yv = List<double>.generate(hsize, (i) => i.toDouble());
    
//     // Create meshgrid
//     final grid = List<List<double>>.generate(
//       hsize * wsize,
//       (index) => [
//         xv[index % wsize],
//         yv[index ~/ wsize]
//       ],
//     );
    
//     // Reshape and add to grids
//         grids.addAll(grid);

    
//     // Create expanded strides
//     final strideGrid = List<List<double>>.generate(
//       hsize * wsize,
//       (_) => [stride.toDouble()],
//     );
//     expandedStrides.addAll(strideGrid);
//   }

//   // Concatenate grids and expanded strides
//   final concatenatedGrids = grids.expand((x) => x).toList();
//   final concatenatedStrides = expandedStrides.expand((x) => x).toList();

//   // Apply transformations to outputs
//   for (int i = 0; i < tensorData.length; i++) {
//     for (int j = 0; j < tensorData[i].length; j++) {
//       // Update first two dimensions
//       tensorData[i][j][0] = (tensorData[i][j][0] + concatenatedGrids[j][0]) * concatenatedStrides[j][0];
//       tensorData[i][j][1] = (tensorData[i][j][1] + concatenatedGrids[j][1]) * concatenatedStrides[j][0];
      
//       // Update next two dimensions
//       tensorData[i][j][2] = exp(tensorData[i][j][2]) * concatenatedStrides[j][0];
//       tensorData[i][j][3] = exp(tensorData[i][j][3]) * concatenatedStrides[j][0];
//     }
//   }

//   return tensorData;
// }
  Future<void> runInference(cv.Mat paddedImg) async {
    // Load model
    final sessionOptions = OrtSessionOptions();
    const assetFileName = 'assets/model/yolox_nano_640x640.onnx';
    final rawAssetFile = await rootBundle.load(assetFileName);
    final bytes = rawAssetFile.buffer.asUint8List();
    final session = OrtSession.fromBuffer(bytes, sessionOptions);
    final (processedImg, ratio) = preprocess(paddedImg, [640, 640]);
    final shape = [
      1,
      3,
      640,
      640
    ]; // Batch size = 1, Channels = 3, Height = 640, Width = 640
    final flatList = processedImg.expand((c) => c.expand((h) => h)).toList();
    final inputOrt = OrtValueTensor.createTensorWithDataList(
        Float32List.fromList(flatList), shape);
    final inputs = {'images': inputOrt};
    final runOptions = OrtRunOptions();

    final outputs = await session.runAsync(runOptions, inputs);
    if (outputs != null) {
      final tensorData = outputs[0]?.value as List<List<List<double>>>;
      



      //final processedOutputs = demoPostprocess(tensorData, [640, 640]);
      print("First 10 elements of processed output: ${tensorData}");
   }
    inputOrt.release();
    runOptions.release();
    outputs?.forEach((element) {
      element?.release();
    });
  }

  //capture picture from video 1
  Future<void> captureScreenshot1() async {
    try {
      final screenshot = await player.screenshot();
      if (screenshot == null) throw 'Không thể chụp ảnh';

      // Resize ảnh về 640x640 sử dụng package image
      final originalImage = decodeImage(screenshot);
      final resizedImage = copyResize(originalImage!, width: 640, height: 640);
      final resizedBytes = encodeJpg(resizedImage);

      final directory = Directory('assets/image/screen1');
      if (!directory.existsSync()) {
        directory.createSync(recursive: true);
      }

      final fileName =
          'screenshot2_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final file = File('${directory.path}/$fileName');
      await file.writeAsBytes(resizedBytes);

      //xử lý model tại đây
      setState(() {
        final file = File('assets/image/screen1/anh3.jpg');
        latestScreenshot1 = file.path;
        print("latestScreenshot1: ${latestScreenshot1}");
        if (File(file.path).existsSync()) {
          final mat = cv.imread(file.path);
          print("Image loaded successfully");
          //final (processedImg, ratio) = preprocess(mat, [640, 640]);
          runInference(mat);
        } else {
          print("Error: Image file does not exist at path: ${file.path}");
        }
      });
      // Cập nhật state với đường dẫn ảnh mới
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
      // ... existing InfoBar code ...
    } catch (e) {
      // ... existing error handling ...
    }
  }

  Future<void> captureScreenshot2() async {
    try {
      final screenshot = await player2.screenshot();
      if (screenshot == null) throw 'Không thể chụp ảnh';
      // Resize ảnh về 640x640 sử dụng package image
      final originalImage = decodeImage(screenshot);
      final resizedImage = copyResize(originalImage!, width: 640, height: 640);
      final resizedBytes = encodeJpg(resizedImage);
      final directory = Directory('assets/image/screen2');
      if (!directory.existsSync()) {
        directory.createSync(recursive: true);
      }

      final fileName =
          'screenshot2_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final file = File('${directory.path}/$fileName');
      await file.writeAsBytes(resizedBytes);

      setState(() {
        latestScreenshot2 = file.path;
      });
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
      // ... existing InfoBar code ...
    } catch (e) {
      // ... existing error handling ...
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      content: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            // Màn hình bên trái
            Expanded(
              child: Center(
                child: FractionallySizedBox(
                  widthFactor: 0.6,
                  heightFactor: 0.8, // Tăng heightFactor để có chỗ cho ảnh
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 3, // Điều chỉnh tỷ lệ video
                        child: AspectRatio(
                          aspectRatio: 16 / 9,
                          child: Video(controller: controller),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Button(
                        child: const Text('Chụp ảnh Video 1'),
                        onPressed: captureScreenshot1,
                      ),
                      const SizedBox(height: 10),
                      // Hiển thị ảnh screenshot
                      // if (latestScreenshot1 != null)
                      //   Expanded(
                      //     flex: 2, // Điều chỉnh tỷ lệ ảnh
                      //     child: Image.file(
                      //       File(latestScreenshot1!),
                      //       fit: BoxFit.contain,
                      //     ),
                      //   ),
                    ],
                  ),
                ),
              ),
            ),
            // Màn hình bên phải
            Expanded(
              child: Center(
                child: FractionallySizedBox(
                  widthFactor: 0.6,
                  heightFactor: 0.8, // Tăng heightFactor để có chỗ cho ảnh
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 3, // Điều chỉnh tỷ lệ video
                        child: AspectRatio(
                          aspectRatio: 16 / 9,
                          child: Video(controller: controller2),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Button(
                        child: const Text('Chụp ảnh Video 2'),
                        onPressed: captureScreenshot2,
                      ),
                      const SizedBox(height: 10),
                      // Hiển thị ảnh screenshot
                      if (latestScreenshot2 != null)
                        Expanded(
                          flex: 2, // Điều chỉnh tỷ lệ ảnh
                          child: Image.file(
                            File(latestScreenshot2!),
                            fit: BoxFit.contain,
                          ),
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
