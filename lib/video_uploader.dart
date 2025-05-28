import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:hive_flutter/hive_flutter.dart';

class VideoUploader extends StatefulWidget {
  @override
  _VideoUploaderState createState() => _VideoUploaderState();
}

class _VideoUploaderState extends State<VideoUploader> {
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickAndSaveVideo() async {
    // Request the user to pick a video from their gallery
    final XFile? videoFile = await _picker.pickVideo(
      source: ImageSource.gallery,
    );

    if (videoFile != null) {
      // Open the Hive box for videos
      final box = Hive.box('videos');

      // Save the new video entry (path, zero likes, empty comments)
      await box.add({
        'path': videoFile.path,
        'likes': 0,
        'comments': <String>[],
      });

      // Notify the user and navigate back
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Video uploaded successfully!')),
      );
      Navigator.pop(context);
    } else {
      // If the user cancelled picking a video
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No video selected.')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    // Automatically launch picker when this screen appears
    WidgetsBinding.instance.addPostFrameCallback((_) => _pickAndSaveVideo());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Video'),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: Text(
          'Select a video from your gallery to upload.',
          style: TextStyle(color: Colors.white, fontSize: 16),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
