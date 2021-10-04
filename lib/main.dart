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

Widget generateVideoPreview()
{
  return Container(
    padding: EdgeInsets.only(right: 22),
    width: 202,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          alignment: Alignment.center,
          height: 113,
          child: Stack(
            children: [
              Image(
                image: AssetImage('assets/preview.png'),
                fit: BoxFit.contain,
              ),

              // Video length box
              Align(
                alignment: Alignment(0.85, 0.5),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(1),
                    color: Colors.black.withOpacity(0.8),
                  ),
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 5.5, vertical: 1.0),
                    child: Text('46:55', style: TextStyle(color: Color(0xFFF8F3F0))),
                  ),
                ),
              ),

              // Bottom red line
              Align(
                alignment: Alignment(-1.0, 0.78),
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xFFF80302),
                  ),
                  height: 5,
                  width: double.infinity, // @point
                ),
              ),

            ]
          ),
          
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,                            
                children:[
                  Text("Long long long long long long long long long", overflow: TextOverflow.ellipsis, maxLines: 2),
                  Text("Author author author author auhtor", overflow: TextOverflow.ellipsis, maxLines: 1),
                ]
              ),
            ),
            IconButton(
              iconSize: 10.0,
              padding: EdgeInsets.all(0.0),
              constraints: BoxConstraints(),
              color: Colors.black,
              icon: Icon(Icons.more_vert, size: 20.0),
              onPressed: (){}
            ),
          ],
        ),
      ],
    )
  );
}

Widget generateHistoryTab()
{
  return Column(
    children: [
      Row(children:[
          Text("Останні"),
      ]),
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children:[
            generateVideoPreview(),
            generateVideoPreview(),
            generateVideoPreview(),
            generateVideoPreview(),
            generateVideoPreview(),
            generateVideoPreview(),
            generateVideoPreview(),
            generateVideoPreview(),
            generateVideoPreview(),
            generateVideoPreview(),
            generateVideoPreview(),
            generateVideoPreview(),                        
          ]
        ),
      ),
    ]
  );
}  

Widget generateYoutubeBody()
{
  return Container(
    padding: EdgeInsets.only(left: 22.0, top: 24.0),
    color: Colors.white,
    child: Column(
      children: [
        generateHistoryTab()
      ],
    )
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
        child: generateYoutubeBody(),
      ),
      bottomNavigationBar: BottomAppBar(
        child: generateYoutubeBottomBar(),
      ),
    );
  }
  
}
