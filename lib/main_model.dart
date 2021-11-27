import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserData
{
  String userName = "Unknown";
  int notificationsCount = 0;
  int unwatchedVideosCount = 0;
  Color color = Colors.white;

  UserData() { }

  factory UserData.parseJson(Map<String, dynamic> json)
  {
    UserData user = UserData();
    user.userName = json["name"];
    user.notificationsCount = json["notifications"];
    user.unwatchedVideosCount = json["unwatched"];
    user.color = Color(int.parse(json["color"], radix: 16));

    return user;
  }
}

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
  bool _classicTheme = true;

  bool get isClassicTheme => _classicTheme;

  void _updateThemePreferences() async
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('THEME', _classicTheme);
  }

  void _extractThemePreferences() async
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _classicTheme = prefs.getBool('THEME') ?? true;
    notifyListeners();    
  }

  MainModel()
  {
    _extractThemePreferences();
  }

  void forceRedraw()
  {
    notifyListeners();
  }
  
  void switchTheme()
  {
    _classicTheme = !_classicTheme;
    _updateThemePreferences();
    notifyListeners();
  }
  
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

  void removeAllVideos()
  {
    selectedVideos.clear();
    notifyListeners();
  }
}
