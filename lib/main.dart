import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
    iconTheme: IconThemeData(color: Colors.black),
    flexibleSpace: Container(
      padding: EdgeInsets.symmetric(horizontal: 22),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,        
        children:[
          Container(
            padding: EdgeInsets.symmetric(horizontal: 32, vertical: 18),
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

Widget generateYoutubeBottomBar(int index, Function(int) onTap)
{
  return Container(
    margin: EdgeInsets.only(bottom: 10.0),
    child: BottomNavigationBar(
      currentIndex: index,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      items:[
        BottomNavigationBarItem(
          icon: Icon(
            Icons.home_outlined,
            color: Colors.black,
            size: 28.0,
          ),
          title: Text('Home'),
        ),

        BottomNavigationBarItem(
          icon: Icon(
            Icons.settings_outlined,
            color: Colors.black,
            size: 28.0,
          ),
          title: Text('Settings'),
        ),

        BottomNavigationBarItem(
          icon: Icon(
            Icons.add_circle_outline,
            color: Colors.black,
            size: 40.0,
          ),
          title: Text('Create', style: TextStyle(fontSize: 0)),
        ),
        
        BottomNavigationBarItem(
          icon: Icon(
            Icons.subscriptions_outlined,
            color: Colors.black,
            size: 28.0,
          ),
          title: Text('Subscriptions'),
        ),
        
        BottomNavigationBarItem(
          icon: Icon(
            Icons.video_library,
            color: Colors.black,
            size: 28.0,
          ),
          title: Text('Library'),
        ),            
      ],
      backgroundColor: Color(0xFFFFFFFF),
      elevation: 0.0,
    ),
    decoration: BoxDecoration(
      border: Border(
        bottom: BorderSide(
          color: Color(0xFFE1E1E1),
        ),
      ),
    ),
  );
}

Widget generateVideoPreview(String title, String author)
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
                    child: Text('46:55', style: TextStyle(color: Color(0xFFD5EAEB))),
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
                  height: 6,
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
                  Text(
                    title,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: TextStyle(
                      fontSize: 17.5,
                      fontWeight: FontWeight.w400
                    ),
                  ),
                  Text(
                    author,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: 13.5,
                      color: Color(0xFF757575)
                    )
                  ),
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
  return Container(
    child: Column(
      children: [
        Row(children:[
            Container(
              padding: EdgeInsets.only(bottom: 15),
              child: Text(
                'Recent',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                )
              ),
            ),
        ]),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children:[
              generateVideoPreview("Material design. Scaffold widget. Flutter. Лекція 4",
                "Сергій Титенко | Web-development"),
              generateVideoPreview("Material design. Scaffold widget. Flutter. Лекція 4",
                "Сергій Титенко | Web-development"),
              generateVideoPreview("Material design. Scaffold widget. Flutter. Лекція 4",
                "Сергій Титенко | Web-development"),
              generateVideoPreview("Material design. Scaffold widget. Flutter. Лекція 4",
                "Сергій Титенко | Web-development"),
              generateVideoPreview("Material design. Scaffold widget. Flutter. Лекція 4",
                "Сергій Титенко | Web-development"),
              generateVideoPreview("Material design. Scaffold widget. Flutter. Лекція 4",
                "Сергій Титенко | Web-development"),
              generateVideoPreview("Material design. Scaffold widget. Flutter. Лекція 4",
                "Сергій Титенко | Web-development"),
              generateVideoPreview("Material design. Scaffold widget. Flutter. Лекція 4",
                "Сергій Титенко | Web-development"),
              generateVideoPreview("Material design. Scaffold widget. Flutter. Лекція 4",
                "Сергій Титенко | Web-development"),
              generateVideoPreview("Material design. Scaffold widget. Flutter. Лекція 4",
                "Сергій Титенко | Web-development"),
              generateVideoPreview("Material design. Scaffold widget. Flutter. Лекція 4",
                "Сергій Титенко | Web-development"),            
            ]
          ),
        ),
      ],
    ),

  );
}  

Widget generateAction(Icon icon, String title, [String? subtitle])
{
  var textChildren = [
    Text(
      title,
      style: TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.w500,
      ),
    ),
  ];

  if(subtitle != null) {
    textChildren.add(Text(
        subtitle,
        style: TextStyle(
          fontSize: 14,
          color: Color(0xFF6F6F6F),
        ),
    ));
  }
  
  return Container(
    padding: EdgeInsets.only(bottom: 35),
    child: Row(
      children: [
        icon,
        Container(
          padding: EdgeInsets.only(left: 30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: textChildren,
          )
        ),
      ]
    ),
  );
}

Widget generateActionsTab()
{
  return Column(
    children: [
      generateAction(Icon(Icons.history, size: 28.0), 'History'),
      generateAction(Icon(Icons.slideshow_sharp, size: 28.0), 'Your videos'),
      generateAction(Icon(Icons.theaters, size: 28.0), 'Your movies'),
      generateAction(Icon(Icons.watch_later_outlined, size: 28.0), 'Watch later', '286 unwatched videos'),
    ],
  );
}

Widget generatePlaylist(String title,
  [bool createNew = false, String? author, int? videoCount, double padding = 22.0])
{
  Widget previewWidget;
  if(createNew)
  {
    previewWidget = Icon(
      Icons.add,
      color: Color(0xFF3E6E98),
    );
  }
  else
  {
    previewWidget = Image(
      image: AssetImage('assets/preview.png'),
      fit: BoxFit.fill,
    );
  }

  Widget textWidget;
  if(createNew)
  {
    textWidget = Text(
      title,
      style: TextStyle(
        color: Color(0xFF3E6E98),        
        fontSize: 18
      ),
    );
  }
  else
  {
    var textChildren = [
      Row(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
            ),
          ),
        ],
      )
    ];

    if(author != null)
    {
      assert(videoCount != null);
      
      textChildren.add(
        Row(
          children: [
            Text(
              author != '' ? '$author • $videoCount videos' : '$videoCount videos',
              style: TextStyle(
                color: Color(0xFF757575),
                fontSize: 16,
              ),
            )
          ],
        )
      );
    }

    textWidget = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: textChildren,
    );
  }
  
  return Container(
    padding: EdgeInsets.only(top: createNew ? 0.0 : padding),
    child: Row(
      children: [
        Container(
          padding: EdgeInsets.only(right: 22.0),
          child: SizedBox(
            width: 55,
            height: 55,
            child: previewWidget,
          ),
        ),
        textWidget,
      ],
    ),
  );
}

Widget generatePlaylistsTab()
{
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,          
        children: [
          Text(
            'Playlists',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w400
            ),
          ),
          Spacer(),
          Text(
            'A-Z',
            style: TextStyle(fontSize: 16),            
          ),
          Icon(
            Icons.expand_more,
          )
        ],
      ),

      Expanded(
        child: ListView(
          shrinkWrap: true,
          children: [
            generatePlaylist('New playlist', true),
            generatePlaylist('3D Game Engine Development Tutorial', false, 'thebennybox', 61, 10.0),
            generatePlaylist('ACM/ICPC Training: For Beginner', false, 'Amy Knuth', 23),
            generatePlaylist('AngularJS tutorial for beginners', false, 'kudvenkat', 53),            
            generatePlaylist('Beatles', false, '', 23),                        
          ]
        ),
      ),
    ],
  );
}

Widget generateDivider([EdgeInsets padding = EdgeInsets.zero])
{
  return Container(
    padding: padding,
    decoration: BoxDecoration(
      border: Border(
        bottom: BorderSide(
          color: Color(0xFFE1E1E1),
        ),
      ),
    ),    
  );
}

Widget generateYoutubeBody()
{
  const leftPadding = 22.0;
  
  return Expanded(
    child: Column(
      children: [
        Container(
          padding: EdgeInsets.only(left: leftPadding, top: 24.0),
          child: generateHistoryTab(),
        ),
        
        generateDivider(EdgeInsets.only(top: 22.0)),

        Container(
          padding: EdgeInsets.only(left: leftPadding, top: 20.0),
          child: generateActionsTab(),
        ),

        generateDivider(),

        Expanded(
          child: Padding(
            padding: EdgeInsets.only(left: leftPadding, top: 15.0, right: leftPadding),
            child: generatePlaylistsTab(),
          )
        ),
      ],
    )
  );
}

Drawer generateYoutubeDrawer(Function() closeCallback)
{
  return Drawer(
    child: ListView(
      children: [
        ListTile(
          title: Text(
            'Drawer',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500
            ),
          ),
          trailing: IconButton(
            icon : Icon(Icons.close),
            onPressed: closeCallback,
          ),
        ),
        
        Card(
          child: ListTile(
            leading: Icon(Icons.home_outlined),
            title: Text('Home'),
          ),
        ),

        Card(
          child: ListTile(
            leading: Icon(Icons.settings_outlined),
            title: Text('Settings'),
          ),
        ),

        Card(
          child: ListTile(
            leading: Icon(Icons.subscriptions_outlined),
            title: Text('Subscriptions'),
          ),
        ),

        Card(
          child: ListTile(
            leading: Icon(Icons.video_library),
            title: Text('Library'),
          ),
        ),

      ],
    ),
  );
}

class _GeneralStatefulWidgetState extends State<GeneralStatefulWidget>
{

  int _pageIdx = 0;
  PageController? _pageController;

  @override
  void initState()
  {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose()
  {
    _pageController?.dispose();
    super.dispose();
  }

  @override
  void onPageTap(int index)
  {
    setState((){
        _pageIdx = index;
        _pageController?.animateToPage(
          index,
          duration: Duration(milliseconds: 2500),
          curve: Curves.linear,
        );
    });
  }
  
  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: generateYoutubeAppBar(),
      drawer: generateYoutubeDrawer((){Navigator.pop(context);}),
      body: Center(
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() => _pageIdx = index);
          },
          children: [
            ColoredBox(
              color: Colors.white,
              child: generateYoutubeBody(),
            ),
            ColoredBox(
              color: Colors.white,
              child: generateYoutubeBody(),
            ),
            ColoredBox(
              color: Colors.black,
              child: generateYoutubeBody(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: generateYoutubeBottomBar(_pageIdx, onPageTap),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed:(){onPageTap(2);},
        child: Text('+', style: TextStyle(color: Colors.white, fontSize: 36)),
        backgroundColor: Colors.red,
      ),      
    );
  }
  
}

class VideoPage extends StatelessWidget
{
  @override
  Widget build(BuildContext context)
  {
    return Container(
      child: Hero(
        tag: 'video',
        child: Text("Text"),
      )
    );
  }
}
