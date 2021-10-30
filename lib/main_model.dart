import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VideoData
{
  String title;
  String author;
  int minutes;
  int seconds;
  final int id;

  VideoData(this.title, this.author, this.minutes, this.seconds, this.id);
}

class MainModel extends ChangeNotifier
{
  final List<VideoData> _selectedVideos = [];

  List<VideoData> get selectedVideos => _selectedVideos;

  void addVideo(VideoData video)
  {
    selectedVideos.add(video);
    notifyListeners();
  }

  void removeVideo(VideoData video)
  {
    selectedVideos.removeWhere((VideoData givenVideo) { return givenVideo.id == video.id; });
    notifyListeners();
  }
}
