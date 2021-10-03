import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Youtube design',
      home: GeneralStatefulWidget()
    );
  }
}

class GeneralStatefulWidget extends StatefulWidget
{
  @override
  State<GeneralStatefulWidget> createState() => _GeneralStatefulWidgetState();
}

Container generateUserLogo(String userName, Color backgroundColor, [double size = 30.0])
{
  return Container(
    width: size,
    height: size,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,            
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          userName[0],
          style: TextStyle(color: Colors.white),
        ),
      ],
    ),

    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      color: backgroundColor, 
    ),
  );
}

AppBar generateYoutubeAppBar([double spaceBetweenIcons = 30.0])
{
  return AppBar(
    flexibleSpace: Container(
      padding: EdgeInsets.symmetric(horizontal: 22),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,        
        children:[
          Container(
            padding: EdgeInsets.symmetric(vertical: 18),
            child: Image(
              image: AssetImage('assets/youtube_logo.png'),
              filterQuality: FilterQuality.medium,
              isAntiAlias: true,
            ),
          ),
          Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,            
            // crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Icon(
                Icons.notifications_none,
                color: Colors.black,
                size: 30.0,
              ),
              SizedBox(width: spaceBetweenIcons),
              Icon(
                Icons.search,
                color: Colors.black,
                size: 30.0,
              ),
              SizedBox(width: spaceBetweenIcons),
              generateUserLogo('T', Color(0xFFF36F0B)),
            ],
          )
        ]
      ),
    ),
    
    backgroundColor: const Color(0xFFFFFFFF),
  );
}

Widget generateYoutubeBottomBar()
{
  return Container(
    margin: EdgeInsets.only(bottom: 10.0),
    child: BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items:[
        BottomNavigationBarItem(
          icon: Icon(
            Icons.home_outlined,
            color: Colors.black,
            size: 28.0,
          ),
          title: Text('Головна'),
        ),

        BottomNavigationBarItem(
          icon: Icon(
            Icons.settings_outlined,
            color: Colors.black,
            size: 28.0,
          ),
          title: Text('Налаштування'),
        ),

        BottomNavigationBarItem(
          icon: Icon(
            Icons.add_circle_outline,
            color: Colors.black,
            size: 40.0,
          ),
          title: Text('Створити', style: TextStyle(fontSize: 0)),
        ),
        
        BottomNavigationBarItem(
          icon: Icon(
            Icons.subscriptions_outlined,
            color: Colors.black,
            size: 28.0,
          ),
          title: Text('Підписки'),
        ),
        
        BottomNavigationBarItem(
          icon: Icon(
            Icons.video_library,
            color: Colors.black,
            size: 28.0,
          ),
          title: Text('Бібліотека'),
        ),            
      ],
      backgroundColor: Color(0xFFFFFFFF),
      elevation: 0.0,
    ),
    decoration: BoxDecoration(
      border: Border(
        bottom: BorderSide(
          color: Color(0xFFE8E8E8),
        ),
      ),
    ),
  );
}

class _GeneralStatefulWidgetState extends State<GeneralStatefulWidget>
{

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: generateYoutubeAppBar(),
      body: Center(
        child: Text('Body'),
      ),
      bottomNavigationBar: BottomAppBar(
        child: generateYoutubeBottomBar(),
      ),
    );
  }
  
}
