import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:hive_flutter/hive_flutter.dart';

class VideoPlayerItem extends StatefulWidget {
  final Map<String, dynamic> video;
  final dynamic videoKey;
  VideoPlayerItem({required this.video, required this.videoKey});

  @override
  _VideoPlayerItemState createState() => _VideoPlayerItemState();
}

class _VideoPlayerItemState extends State<VideoPlayerItem> {
  late final VideoPlayerController _controller;
  bool _isLiked = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(File(widget.video['path']))
      ..initialize().then((_) {
        setState(() {});
        _controller
          ..setLooping(true)
          ..play();
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleLike() {
    final box = Hive.box('videos');
    final likes = (widget.video['likes'] as int) + 1;
    box.put(widget.videoKey, {
      'path': widget.video['path'],
      'likes': likes,
      'comments': widget.video['comments'],
    });
    setState(() => _isLiked = true);
  }

  void _addComment() {
    final comments = List<String>.from(widget.video['comments']);
    final ctrl = TextEditingController();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black87,
      builder: (_) => Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ...comments.map((c) => ListTile(
              title: Text(c, style: TextStyle(color: Colors.white)),
            )),
            TextField(
              controller: ctrl,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Comment',
                labelStyle: TextStyle(color: Colors.deepPurpleAccent),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (ctrl.text.isNotEmpty) {
                  comments.add(ctrl.text);
                  Hive.box('videos').put(widget.videoKey, {
                    'path': widget.video['path'],
                    'likes': widget.video['likes'],
                    'comments': comments,
                  });
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurpleAccent,
              ),
              child: Text('Post'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: _controller.value.isInitialized
              ? AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: VideoPlayer(_controller),
          )
              : CircularProgressIndicator(),
        ),
        Positioned(
          right: 16,
          bottom: 80,
          child: Column(
            children: [
              IconButton(
                icon: Icon(
                  _isLiked ? Icons.favorite : Icons.favorite_border,
                  color: _isLiked ? Colors.red : Colors.white,
                  size: 32,
                ),
                onPressed: _toggleLike,
              ),
              Text(
                '${widget.video['likes']}',
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 24),
              IconButton(
                icon: Icon(Icons.comment, color: Colors.white, size: 32),
                onPressed: _addComment,
              ),
              Text(
                '${(widget.video['comments'] as List).length}',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
