// // lib/services/model_service.dart
//
//
// import 'package:flutter/services.dart';
// import 'package:tflite_flutter/tflite_flutter.dart';
// import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';
// import 'dart:io';
// import 'package:flutter/foundation.dart'; // for debugPrint
//
// import 'package:image/image.dart' as img;
//
// class ModelService {
//   late Interpreter _interpreter;
//   late List<String> _labels;
//
//   static const int inputSize = 384;
//   static const String modelPath = 'models/POC3_EfficientNetV2S.tflite';
//
//   Future<void> loadModel() async {
//     // Load model
//     _interpreter = await Interpreter.fromAsset(modelPath);
//
//     // Load labels
//     await loadLabels();
//
//     debugPrint('Model loaded successfully.');
//   }
//
//   Future<void> loadLabels() async {
//     final raw = await rootBundle.loadString('assets/models/labels.txt');
//     _labels = raw.split('\n');
//   }
//
//   final Map<String, Map<String, String>> diseaseInfo = {
//     'Tomato_Early_Blight': {
//       'arabic': 'اللفحة المبكرة في الطماطم',
//       'cause': 'تسببها فطريات في الجو الرطب.',
//       'treatment': 'إزالة الأوراق المصابة واستخدام مبيدات فطرية نحاسية.'
//     },
//     'Tomato_Healthy': {
//       'arabic': 'نبات سليم',
//       'cause': 'لا توجد أعراض مرضية.',
//       'treatment': 'استمر في الري والتسميد المنتظم.'
//     },
//     'Tomato_Leaf_Miner': {
//       'arabic': 'حفار أوراق الطماطم',
//       'cause': 'يرقات الحشرة داخل أنسجة الورقة.',
//       'treatment': 'قصّ الأوراق المصابة واستخدام مصائد فرمونية.'
//     }
//   };
//
//   Future<Map<String, dynamic>> analyzeImage(String path) async {
//     final bytes = File(path).readAsBytesSync();
//     img.Image? image = img.decodeImage(bytes);
//     if (image == null) throw Exception('Image decode failed');
//
//     // Preprocess
//     TensorImage input = TensorImage.fromImage(image);
//     final processor = ImageProcessorBuilder()
//         .add(ResizeOp(inputSize, inputSize, ResizeMethod.BILINEAR))
//         .add(NormalizeOp(0.0, 255.0))
//         .build();
//     input = processor.process(input);
//
//     // Output shape = number of labels
//     final output = TensorBufferFloat([1, _labels.length]);
//
//     _interpreter.run(input.buffer, output.buffer);
//
//     final scores = output.getDoubleList();
//     final maxScore = scores.reduce((a, b) => a > b ? a : b);
//     final index = scores.indexOf(maxScore);
//     final label = _labels[index];
//
//     return {
//       'disease': label,
//       'confidence': maxScore,
//       'arabic': diseaseInfo[label]?['arabic'] ?? '',
//       'cause': diseaseInfo[label]?['cause'] ?? '',
//       'treatment': diseaseInfo[label]?['treatment'] ?? '',
//     };
//   }
// }
// lib/services/model_service.dart

// lib/services/model_service.dart

// lib/services/model_service.dart

import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;
import 'package:flutter/foundation.dart';

class ModelService {
  late Interpreter _interpreter;
  late List<String> _labels;

  static const int inputSize = 384;
  static const String modelPath = 'assets/models/POC3_EfficientNetV2S.tflite';

  /// Load TFLite model and labels
  Future<void> loadModel() async {
    _interpreter = await Interpreter.fromAsset(modelPath);
    await loadLabels();
    debugPrint('Model loaded successfully.');
  }

  Future<void> loadLabels() async {
    final raw = await rootBundle.loadString('assets/models/labels.txt');
    _labels = raw
        .split('\n')
        .map((l) => l.trim()) // remove extra spaces/newlines
        .where((l) => l.isNotEmpty) // skip empty lines
        .toList();
  }


  /// Disease info in Arabic and treatment
  final Map<String, Map<String, String>> diseaseInfo = {
    'Tomato_Early_Blight': {
      'arabic': 'اللفحة المبكرة في الطماطم',
      'cause': 'تسببها فطريات في الجو الرطب.',
      'treatment': 'إزالة الأوراق المصابة واستخدام مبيدات فطرية نحاسية.'
    },
    'Tomato_Healthy': {
      'arabic': 'نبات سليم',
      'cause': 'لا توجد أعراض مرضية.',
      'treatment': 'استمر في الري والتسميد المنتظم.'
    },
    'Tomato_Leaf_Miner': {
      'arabic': 'حفار أوراق الطماطم',
      'cause': 'يرقات الحشرة داخل أنسجة الورقة.',
      'treatment': 'قصّ الأوراق المصابة واستخدام مصائد فرمونية.'
    }
  };

  /// Analyze an image from path
  Future<Map<String, dynamic>> analyzeImage(String path) async {
    // Load and decode image
    final bytes = File(path).readAsBytesSync();
    img.Image? image = img.decodeImage(bytes);
    if (image == null) throw Exception('Image decode failed');

    // Resize to model input
    final resized = img.copyResize(image, width: inputSize, height: inputSize);

    // Prepare 4D input: [1, height, width, 3]
    var input = Float32List(1 * inputSize * inputSize * 3);
    int pixelIndex = 0;
    for (int y = 0; y < inputSize; y++) {
      for (int x = 0; x < inputSize; x++) {
        final pixel = resized.getPixel(x, y);
        input[pixelIndex++] = img.getRed(pixel) / 255.0;
        input[pixelIndex++] = img.getGreen(pixel) / 255.0;
        input[pixelIndex++] = img.getBlue(pixel) / 255.0;
      }
    }

    // Wrap as 4D: [1, 384, 384, 3]
    var inputBuffer = input.reshape4D([1, inputSize, inputSize, 3]);

    // Prepare output buffer
    var outputBuffer = List.filled(_labels.length, 0.0).reshape2D([1, _labels.length]);

    // Run model
    _interpreter.run(inputBuffer, outputBuffer);

    // Extract prediction
    List<double> scores = List<double>.from(outputBuffer[0]);
    double maxScore = scores.reduce((a, b) => a > b ? a : b);
    int maxIndex = scores.indexOf(maxScore);
    String label = _labels[maxIndex].trim();


    return {
      'disease': label,
      'confidence': maxScore,
      'arabic': diseaseInfo[label]?['arabic'] ?? '',
      'cause': diseaseInfo[label]?['cause'] ?? '',
      'treatment': diseaseInfo[label]?['treatment'] ?? '',
    };
  }
}

/// Reshape 1D list into 2D
extension ListReshape2D on List<double> {
  List<List<double>> reshape2D(List<int> dims) {
    if (dims.length != 2) throw Exception('Only 2D reshape supported');
    int rows = dims[0], cols = dims[1];
    if (length != rows * cols) throw Exception('Invalid reshape dimensions');
    List<List<double>> result = [];
    for (int i = 0; i < rows; i++) {
      result.add(sublist(i * cols, (i + 1) * cols));
    }
    return result;
  }
}

/// Reshape 1D list into 4D
extension ListReshape4D on Float32List {
  List<List<List<List<double>>>> reshape4D(List<int> dims) {
    if (dims.length != 4) throw Exception('Only 4D reshape supported');
    int n = dims[0], h = dims[1], w = dims[2], c = dims[3];
    if (length != n * h * w * c) throw Exception('Invalid reshape dimensions');
    List<List<List<List<double>>>> result = [];
    int index = 0;
    for (int i = 0; i < n; i++) {
      List<List<List<double>>> batch = [];
      for (int y = 0; y < h; y++) {
        List<List<double>> row = [];
        for (int x = 0; x < w; x++) {
          List<double> channel = [];
          for (int ch = 0; ch < c; ch++) {
            channel.add(this[index++].toDouble());
          }
          row.add(channel);
        }
        batch.add(row);
      }
      result.add(batch);
    }
    return result;
  }
}
