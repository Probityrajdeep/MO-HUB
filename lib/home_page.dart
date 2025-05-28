import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'video_player_item.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final Box _videoBox;

  @override
  void initState() {
    super.initState();
    _videoBox = Hive.box('videos');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: RichText(
          text: TextSpan(
            style: TextStyle(fontSize: 24),
            children: [
              TextSpan(
                text: 'Mo ',
                style: TextStyle(color: Colors.white),
              ),
              WidgetSpan(
                alignment: PlaceholderAlignment.middle,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.deepPurpleAccent,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'Hub',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.upload, color: Colors.white),
            onPressed: () => Navigator.pushNamed(context, '/upload'),
          ),
        ],
      ),
      backgroundColor: Colors.black,
      body: ValueListenableBuilder(
        valueListenable: _videoBox.listenable(),
        builder: (_, Box box, __) {
          if (box.isEmpty) {
            return Center(
              child: Text(
                'No videos yet. Tap upload to add one!',
                style: TextStyle(color: Colors.grey),
              ),
            );
          }
          return PageView.builder(
            scrollDirection: Axis.vertical,
            itemCount: box.length,
            itemBuilder: (_, index) {
              final key = box.keyAt(index);
              final data = Map<String, dynamic>.from(box.get(key));
              return VideoPlayerItem(video: data, videoKey: key);
            },
          );
        },
      ),
    );
  }
}
