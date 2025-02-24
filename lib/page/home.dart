import 'package:fluent_ui/fluent_ui.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
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
import 'dart:math' as math;
import 'package:image/image.dart' as img;
import 'package:flutter_tesseract_ocr/flutter_tesseract_ocr.dart';
import 'dart:convert';
import 'package:http_parser/http_parser.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Tạo thêm player và controller cho video thứ 2
  late TextEditingController textController;

  late final player = Player();
  late final player2 = Player();
  late final controller = VideoController(player);
  late final controller2 = VideoController(player2);

  @override
  void initState() {
    super.initState();
    textController = TextEditingController();

    player.open(
      Media(
          'assets/video/pexels-taryn-elliott-5309381 (1080p).mp4'), // Thay đổi tên file theo video của bạn
      play: true,
    );

    // Khởi tạo video 2
    player2.open(
      Media(
          'assets/video/assets/video/Traffic Control CCTV.mp4'), // Thay đổi tên file theo video của bạn
      play: true,
    );
  }

  @override
  void dispose() {
    textController.dispose();
    player.dispose();
    player2.dispose();
    super.dispose();
  }

  String? ocrText;
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

  List<List<List<double>>> demoPostprocess(
      List<List<List<double>>> tensorData, List<int> imgSize,
      {bool p6 = false}) {
    final List<int> strides = p6 ? [8, 16, 32, 64] : [8, 16, 32];
    final hsizes = strides.map((stride) => imgSize[0] ~/ stride).toList();
    final wsizes = strides.map((stride) => imgSize[1] ~/ stride).toList();

    List<List<double>> grids = [];
    List<List<double>> expandedStrides = [];

    for (int i = 0; i < strides.length; i++) {
      final hsize = hsizes[i];
      final wsize = wsizes[i];
      final stride = strides[i];

      // Create grid coordinates
      final xv = List<double>.generate(wsize, (i) => i.toDouble());
      final yv = List<double>.generate(hsize, (i) => i.toDouble());

      // Create meshgrid
      final grid = List<List<double>>.generate(
        hsize * wsize,
        (index) => [xv[index % wsize], yv[index ~/ wsize]],
      );

      // Reshape and add to grids
      grids.addAll(grid);

      // Create expanded strides
      final strideGrid = List<List<double>>.generate(
        hsize * wsize,
        (_) => [stride.toDouble()],
      );
      expandedStrides.addAll(strideGrid);
    }

    // Concatenate grids and expanded strides
    //final concatenatedGrids = grids.expand((x) => x).toList();
    //final concatenatedStrides = expandedStrides.expand((x) => x).toList();

    // Apply transformations to outputs
    for (int i = 0; i < tensorData.length; i++) {
      for (int j = 0; j < tensorData[i].length; j++) {
        // Update first two dimensions
        tensorData[i][j][0] =
            (tensorData[i][j][0] + grids[j][0]) * expandedStrides[j][0];
        tensorData[i][j][1] =
            (tensorData[i][j][1] + grids[j][1]) * expandedStrides[j][0];

        // Update next two dimensions
        tensorData[i][j][2] = exp(tensorData[i][j][2]) * expandedStrides[j][0];
        tensorData[i][j][3] = exp(tensorData[i][j][3]) * expandedStrides[j][0];
      }
    }

    return tensorData;
  }

  List<List<double>>? multiclassNmsClassAgnostic(
      List<List<double>> boxes, List<List<double>> scores) {
    const double nmsThr = 0.45;
    const double scoreThr = 0.1;

    // Tìm chỉ số class có điểm cao nhất cho mỗi box (tương đương scores.argmax(1))
    final List<int> clsInds = List.generate(scores.length, (i) {
      int maxIdx = 0;
      double maxScore = scores[i][0];
      for (int j = 1; j < scores[i].length; j++) {
        if (scores[i][j] > maxScore) {
          maxScore = scores[i][j];
          maxIdx = j;
        }
      }
      return maxIdx;
    });

    // Lấy điểm số cao nhất cho mỗi box
    final List<double> clsScores =
        List.generate(clsInds.length, (i) => scores[i][clsInds[i]]);

    // Lọc các box có điểm số > score_thr
    final List<int> validIndices = [];
    for (int i = 0; i < clsScores.length; i++) {
      if (clsScores[i] > scoreThr) {
        validIndices.add(i);
      }
    }

    if (validIndices.isEmpty) {
      return null;
    }

    // Lấy các giá trị hợp lệ
    final List<List<double>> validBoxes =
        validIndices.map((i) => boxes[i]).toList();
    final List<double> validScores =
        validIndices.map((i) => clsScores[i]).toList();
    final List<int> validClsInds = validIndices.map((i) => clsInds[i]).toList();

    // Áp dụng NMS
    final List<int> keep = nms(validBoxes, validScores);

    if (keep.isNotEmpty) {
      // Tạo kết quả cuối cùng
      return keep
          .map((i) => [
                ...validBoxes[i], // box coordinates [x1, y1, x2, y2]
                validScores[i], // score
                validClsInds[i].toDouble(), // class index
              ])
          .toList();
    }

    return null;
  }

  List<int> nms(List<List<double>> boxes, List<double> scores) {
    const double nmsThr = 0.45;
    final List<int> keep = [];

    // Tạo danh sách indices được sắp xếp theo điểm số giảm dần
    final List<int> order = List.generate(scores.length, (i) => i)
      ..sort((a, b) => scores[b].compareTo(scores[a]));

    final List<double> areas = boxes.map((box) {
      return (box[2] - box[0] + 1) * (box[3] - box[1] + 1);
    }).toList();

    while (order.isNotEmpty) {
      final int i = order[0];
      keep.add(i);

      if (order.length == 1) break;

      final List<int> remainingIndices = [];

      for (int j = 1; j < order.length; j++) {
        final int idx = order[j];

        // Tính toán intersection
        final double xx1 = math.max(boxes[i][0], boxes[idx][0]);
        final double yy1 = math.max(boxes[i][1], boxes[idx][1]);
        final double xx2 = math.min(boxes[i][2], boxes[idx][2]);
        final double yy2 = math.min(boxes[i][3], boxes[idx][3]);

        final double w = math.max(0.0, xx2 - xx1 + 1);
        final double h = math.max(0.0, yy2 - yy1 + 1);
        final double inter = w * h;

        // Tính IoU
        final double ovr = inter / (areas[i] + areas[idx] - inter);

        if (ovr <= nmsThr) {
          remainingIndices.add(idx);
        }
      }

      order.clear();
      order.addAll(remainingIndices);
    }

    return keep;
  }

  Future<String?> callOCRAPI(String imagePath) async {
    try {
      
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://0.0.0.0:7860/ocr'),
      );

     
      request.headers.addAll({
        'accept': 'application/json',
      });

      // Thêm file vào request
      final file = File(imagePath);
      final stream = http.ByteStream(file.openRead());
      final length = await file.length();

      final multipartFile = http.MultipartFile(
        'file',
        stream,
        length,
        filename: file.path.split('/').last,
        contentType: MediaType('image', 'jpeg'),
      );

      request.files.add(multipartFile);

      
      final response = await request.send();
     

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        final List<dynamic> result = jsonDecode(responseBody);
        if (result.isNotEmpty) {
          final text = result[0]['txt'] as String;
        
          // Combine text and text2, keeping only numbers and uppercase letters
          if (result.length > 1 && result[1]['txt'].isNotEmpty) {
            final text2 = result[1]['txt'] as String;
            final combinedText = text + text2;
            // Use regular expression to keep only numbers and uppercase letters
            final filteredText = combinedText.replaceAll(RegExp(r'[^A-Z0-9]'), '');
            return filteredText;
          }
          
          
          // If text2 is empty, return text after filtering
          return text.replaceAll(RegExp(r'[^A-Z0-9]'), '');
        }
        return null;
      }
    } catch (e) {
      print('OCR API Error: $e');
      return null;
    }
  }

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

      final processedOutputs = demoPostprocess(tensorData, [640, 640]);
      // Assuming processedOutputs is List<List<List<double>>>
      final predictions = processedOutputs[0];

      // Extract boxes and scores
      final boxes = predictions.map((pred) => pred.sublist(0, 4)).toList();

      final scores = predictions.map((pred) {
        return pred.sublist(5).map((value) => pred[4] * value).toList();
      }).toList();

      // Convert boxes to xyxy format
      final boxesXyxy = List.generate(boxes.length, (_) => List.filled(4, 0.0));
      for (int i = 0; i < boxes.length; i++) {
        boxesXyxy[i][0] = boxes[i][0] - boxes[i][2] / 2.0;
        boxesXyxy[i][1] = boxes[i][1] - boxes[i][3] / 2.0;
        boxesXyxy[i][2] = boxes[i][0] + boxes[i][2] / 2.0;
        boxesXyxy[i][3] = boxes[i][1] + boxes[i][3] / 2.0;
      }

      // Scale boxes by ratio
      for (int i = 0; i < boxesXyxy.length; i++) {
        for (int j = 0; j < 4; j++) {
          boxesXyxy[i][j] /= ratio;
        }
      }

      final dets = multiclassNmsClassAgnostic(boxesXyxy, scores);

      // Thêm phần visualization
      if (dets != null) {
        // Tách boxes, scores và class indices từ dets
        final finalBoxes = dets.map((det) => det.sublist(0, 4)).toList();
        final finalScores = dets.map((det) => det[4]).toList();
        final finalClsInds = dets.map((det) => det[5].toInt()).toList();

        // Vẽ các detection lên ảnh
        for (int i = 0; i < finalBoxes.length; i++) {
          final box = finalBoxes[i];
          final clsId = finalClsInds[i];
          final score = finalScores[i];

          if (score < 0.3) continue; // confidence threshold

          // Convert coordinates to int
          final x0 = box[0].toInt();
          final y0 = box[1].toInt();
          final x1 = box[2].toInt();
          final y1 = box[3].toInt();

          // Get color for current class
          final color = _COLORS[clsId % _COLORS.length];
          final colorScaled = [
            (color[0] * 255).toInt(),
            (color[1] * 255).toInt(),
            (color[2] * 255).toInt()
          ];

          final text = '${names[clsId]}:${(score * 100).toStringAsFixed(1)}%';

// Calculate text color based on mean color value
          final txtColor = _COLORS[clsId].reduce((a, b) => a + b) / 3 > 0.5
              ? cv.Scalar(0, 0, 0)
              : cv.Scalar(255, 255, 255);

// Get text size
          final txtSize = cv.getTextSize(text, cv.FONT_HERSHEY_SIMPLEX, 0.4, 1);

// Draw bounding box
          // cv.rectangle(
          //     paddedImg,
          //     cv.Rect(x0, y0, x1 - x0, y1 - y0),
          //     cv.Scalar(colorScaled[0].toDouble(), colorScaled[1].toDouble(),
          //         colorScaled[2].toDouble()),
          //     thickness: 2);
          final directory = Directory('assets/output');
          if (!directory.existsSync()) {
            directory.createSync(recursive: true);
          }
          //cv.imwrite('${directory.path}/imagedetected.jpg', paddedImg);
          final safeX0 = math.max(0, x0);
          final safeY0 = math.max(0, y0);
          final safeX1 = math.min(paddedImg.cols, x1);
          final safeY1 = math.min(paddedImg.rows, y1);

          // Kiểm tra kích thước vùng cắt hợp lệ
          if (safeX1 > safeX0 && safeY1 > safeY0 && i == 0) {
            // Cắt đối tượng từ ảnh gốc
            final objectROI = paddedImg.region(
                cv.Rect(safeX0, safeY0, safeX1 - safeX0, safeY1 - safeY0));

            // Tạo tên file duy nhất cho đối tượng
            final objectFileName =
                '${names[clsId]}_${DateTime.now().millisecondsSinceEpoch}_$i.jpg';

            // Lưu ảnh đối tượng
            cv.imwrite('${directory.path}/$objectFileName', objectROI);

            // Ghi thông tin đối tượng vào file log
            final logFile = File('${directory.path}/detection_log.txt');
            final logEntry =
                'Object: ${names[clsId]}, Confidence: ${(score * 100).toStringAsFixed(1)}%, '
                'File: $objectFileName, Time: ${DateTime.now()}\n';

            await logFile.writeAsString(
              logEntry,
              mode: FileMode.append,
            );
            // Tính toán màu nền của text
            final txtBkColor = [
              (color[0] * 255 * 0.7).toInt(),
              (color[1] * 255 * 0.7).toInt(),
              (color[2] * 255 * 0.7).toInt()
            ];

//Draw text background
            cv.rectangle(
                paddedImg,
                cv.Rect(x0, y0 + 1, txtSize.$1.width + 1,
                    (txtSize.$1.height * 1.5).toInt()),
                cv.Scalar(txtBkColor[0].toDouble(), txtBkColor[1].toDouble(),
                    txtBkColor[2].toDouble()),
                thickness: -1);

// Draw text
            cv.putText(paddedImg, text, cv.Point(x0, y0 + txtSize.$1.height),
                cv.FONT_HERSHEY_SIMPLEX, 0.4, txtColor,
                thickness: 1);

            //Gọi API OCR với đường dẫn ảnh
            final ocrResult =
                await callOCRAPI('${directory.path}/$objectFileName');
            if (ocrResult != null) {
              ocrText = ocrResult;
           
            }
          }
        }
      }
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
        latestScreenshot1 = file.path;
        ocrText = null; // Reset text cũ
        textController.text = ''; // Reset controller
      });

      if (File(file.path).existsSync()) {
        var mat = cv.imread(latestScreenshot1!);
        //var mat = cv.imread('assets/image/screen1/xemay.jpg');
        print("Image loaded successfully");
        mat = cv.cvtColor(mat, cv.COLOR_BGR2RGB);
        await runInference(mat);

        // Cập nhật text mới
        if (ocrText != null) {
          setState(() {
            textController.text = ocrText ?? '';
            print("New OCR Text: $ocrText");
          });
        }
      }

      // Hiển thị thông báo
      if (mounted) {
        displayInfoBar(
          context,
          builder: (context, close) {
            return InfoBar(
              title: const Text('Thành công'),
              content: Text('Biển số xe: ${ocrText ?? "Không tìm thấy"}'),
              severity: InfoBarSeverity.success,
            );
          },
        );
      }
    } catch (e) {
      print("Error in captureScreenshot1: $e");
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
            Expanded(
              child: Center(
                child: FractionallySizedBox(
                  widthFactor: 0.6,
                  heightFactor: 0.8,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 3,
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
                      // InfoLabel với TextBox
                      InfoLabel(
                        label: 'Biển số xe:',
                        child: TextBox(
                          readOnly: true,
                          placeholder: 'Chưa có kết quả',
                          controller:
                              TextEditingController(text: ocrText ?? ''),
                          expands: false,
                        ),
                      ),
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
                  heightFactor: 0.8,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 3,
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
                      // InfoLabel với TextBox
                      InfoLabel(
                        label: 'Biển số xe:',
                        child: TextBox(
                          readOnly: true,
                          placeholder: 'Chưa có kết quả',
                          controller:
                              TextEditingController(text: ocrText ?? ''),
                          expands: false,
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
