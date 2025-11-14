// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import '../services/model_service.dart';
// import 'result_screen.dart';
//
// class CaptureScreen extends StatefulWidget {
//   const CaptureScreen({super.key});
//
//   @override
//   State<CaptureScreen> createState() => _CaptureScreenState();
// }
//
// class _CaptureScreenState extends State<CaptureScreen> {
//   final modelService = ModelService();
//   File? _imageFile;
//   bool _loading = false;
//
//   final picker = ImagePicker();
//
//   @override
//   void initState() {
//     super.initState();
//     modelService.loadModel(); // load model once
//     modelService.loadLabels();
//   }
//
//   Future<void> pickImage(ImageSource source) async {
//     final pickedFile = await picker.pickImage(source: source);
//     if (pickedFile != null) {
//       setState(() {
//         _imageFile = File(pickedFile.path);
//       });
//     }
//   }
//
//   Future<void> analyzeImage() async {
//     if (_imageFile == null) return;
//
//     setState(() => _loading = true);
//
//     final result = await modelService.analyzeImage(_imageFile!.path);
//
//     if (!mounted) return; // <-- ensures widget still exists
//
//     setState(() => _loading = false);
//
//     // Navigate to ResultScreen
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => ResultScreen(result: result, imageFile: _imageFile!),
//       ),
//     );
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('AgriVision')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             if (_imageFile != null)
//               Image.file(_imageFile!, height: 300),
//             if (_imageFile == null)
//               Container(
//                 height: 300,
//                 color: Colors.grey[200],
//                 child: const Center(child: Text('No image selected')),
//               ),
//             const SizedBox(height: 20),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 ElevatedButton.icon(
//                   icon: const Icon(Icons.camera),
//                   label: const Text('Camera'),
//                   onPressed: () => pickImage(ImageSource.camera),
//                 ),
//                 const SizedBox(width: 20),
//                 ElevatedButton.icon(
//                   icon: const Icon(Icons.photo_library),
//                   label: const Text('Gallery'),
//                   onPressed: () => pickImage(ImageSource.gallery),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _imageFile != null && !_loading ? analyzeImage : null,
//               child: _loading
//                   ? const CircularProgressIndicator(color: Colors.white)
//                   : const Text('Analyze'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/model_service.dart';
import 'result_screen.dart';

class CaptureScreen extends StatefulWidget {
  const CaptureScreen({super.key});

  @override
  State<CaptureScreen> createState() => _CaptureScreenState();
}

class _CaptureScreenState extends State<CaptureScreen> {
  final modelService = ModelService();
  File? _imageFile;
  bool _loading = false;
  bool _modelLoaded = false; // ✅ track if model is loaded

  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadModel();
  }

  Future<void> _loadModel() async {
    try {
      await modelService.loadModel();
      await modelService.loadLabels();
      if (!mounted) return;
      setState(() {
        _modelLoaded = true;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _modelLoaded = false;
      });
      debugPrint('Error loading model: $e');
    }
  }

  Future<void> pickImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> analyzeImage() async {
    if (_imageFile == null) return;

    setState(() => _loading = true);

    try {
      final result = await modelService.analyzeImage(_imageFile!.path);
      if (!mounted) return;
      setState(() => _loading = false);

      // Navigate to ResultScreen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              ResultScreen(result: result, imageFile: _imageFile!),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error analyzing image: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AgriVision')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: !_modelLoaded
            ? const Center(
          child: CircularProgressIndicator(),
        )
            : Column(
          children: [
            if (_imageFile != null)
              Image.file(_imageFile!, height: 300),
            if (_imageFile == null)
              Container(
                height: 300,
                color: Colors.grey[200],
                child:
                const Center(child: Text('No image selected')),
              ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.camera),
                  label: const Text('Camera'),
                  onPressed: () => pickImage(ImageSource.camera),
                ),
                const SizedBox(width: 20),
                ElevatedButton.icon(
                  icon: const Icon(Icons.photo_library),
                  label: const Text('Gallery'),
                  onPressed: () => pickImage(ImageSource.gallery),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _imageFile != null && !_loading && _modelLoaded
                  ? analyzeImage
                  : null,
              child: _loading
                  ? const CircularProgressIndicator(
                  color: Colors.white)
                  : const Text('Analyze'),
            ),
          ],
        ),
      ),
    );
  }
}
