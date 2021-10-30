import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'main_model.dart';

void main() => runApp(
  ChangeNotifierProvider(
    create: (context) => MainModel(),
    child: MyApp()
  ),
);

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
            //padding: EdgeInsets.only(left: 32, top: 48, bottom: 18),            
            child: Image(
              image: AssetImage(
                'assets/youtube_logo.png',
              ),
              fit: BoxFit.contain,              
              filterQuality: FilterQuality.medium,
              isAntiAlias: true,
            ),
          ),
          Spacer(),
          Container(
            // padding: EdgeInsets.only(top: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,            
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
            ),
          ),
        ],
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

Widget generatePlaylist(String title,
  [bool createNew = false, String? author, int? videoCount, double padding = 22.0])
{
  return PlaylistWidget(title, createNew, author, videoCount);
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

Widget generateYoutubeBody(BuildContext context, Function(VideoWidget) onVideoDTap)
{
  const leftPadding = 22.0;
  
  return Expanded(
    child: Column(
      children: [
        Container(
          padding: EdgeInsets.only(left: leftPadding, top: 24.0),
          child: RecentTab(onVideoDTap),
        ),
        
        generateDivider(EdgeInsets.only(top: 22.0)),

        Container(
          padding: EdgeInsets.only(left: leftPadding, top: 20.0),
          child: ActionsTab(),
        ),

        generateDivider(),

        Expanded(
          child: Padding(
            padding: EdgeInsets.only(left: leftPadding, top: 15.0, right: leftPadding),
            child: PlaylistsTab(),
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
  bool onVideoDTap(VideoWidget video)
  {
    if(video.selected)
    {
      Provider.of<MainModel>(context, listen: false).removeVideo(video.data);
    }
    else
    {
      Provider.of<MainModel>(context, listen: false).addVideo(video.data);
    }
    
    return true;
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
              child: generateYoutubeBody(context, onVideoDTap),
            ),
            ColoredBox(
              color: Colors.white,
              child: generateYoutubeBody(context, onVideoDTap),
            ),
            ColoredBox(
              color: Colors.black,
              child: generateYoutubeBody(context, onVideoDTap),
            ),
            ColoredBox(
              color: Colors.white,
              child: generateYoutubeBody(context, onVideoDTap),
            ),
            ColoredBox(
              color: Colors.white,
              child: generateYoutubeBody(context, onVideoDTap),
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

Widget generateVideoWidget(String title, String author, int index)
{
  return Container(
    width: double.infinity,
    padding: EdgeInsets.only(top: 22.0),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 360,
              child: Hero(
                tag: 'video$index',
                child: Image(
                  image: AssetImage('assets/preview.png'),
                  fit: BoxFit.fitHeight,
                ),
              ),

              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    blurRadius: 20.0,
                  ),
                ],
              ),              
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,          
          children: [
            Text('$title'),
          ],
        )
      ]
    )
  );
}

class VideoPage extends StatelessWidget
{
  String _title;
  String _author;
  int _index;
  
  VideoPage(
    String title,
    String author,
    int index
  ): _title=title, _author=author, _index=index {}
  
  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: generateYoutubeAppBar(),
      body: Center(
        child: Expanded(
          child: Column (
            children: [
              Container(
                padding: EdgeInsets.only(left: 22.0, top: 24.0),
                child: RecentTab((VideoWidget) {}),
              ),

              generateVideoWidget(_title, _author, _index),
            ]
          ),
        ),
      ),
    );
  }
}

// ----------------------------------------------------------------------------

abstract class Tab extends StatelessWidget
{
  @override
  Widget build(BuildContext context)
  {
    String? title = getTitle();

    List<Widget> titleContainer = title != null ? [
      Container(
        padding: EdgeInsets.only(bottom: 15),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w400,
          )
        ),
      ),      
    ] : [];
    
    return Expanded(
      child: Column(
        children: [
          Row(children: titleContainer),
          generateContent(context),
        ],
      ),
    );    
  }

  String? getTitle();  
  Widget generateContent(BuildContext context);
}

class RecentTab extends Tab
{
  final Function(VideoWidget) onVideoSelectedCallback;

  RecentTab(this.onVideoSelectedCallback);
  
  @override
  String? getTitle()
  {
    return "Recent";
  }

  @override
  Widget generateContent(BuildContext context)
  {
    int omitVideoIdx = 0; // TODO:
    
    List<Widget> previews = [];
    for(var i = 0; i < 10; i++)
    {
      if(omitVideoIdx > 0 && i == omitVideoIdx)
      {
        continue;
      }

      
      previews.add(VideoWidget(
          VideoData(
            'Material design. Scaffold widget. Flutter. Лекція 4',
            'Сергій Титенко | Web-development',
            46, 55, i,
          ),
          onVideoSelectedCallback,
        ),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: previews,
      ),
    );
  }
}

class ActionsTab extends Tab
{
  @override
  String? getTitle()
  {
    return "Actions";
  }

  @override
  Widget generateContent(BuildContext context)
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
}

class PlaylistsTab extends Tab
{
  @override
  String? getTitle()
  {
    return "Playlists";
  }

  @override
  Widget generateContent(BuildContext context)
  {
    String newPlaylistTitle = 'New playlist';
    List<VideoData> selectedVideos = Provider.of<MainModel>(context, listen: true).selectedVideos;
    if(selectedVideos.length > 0)
    {
      newPlaylistTitle = newPlaylistTitle + ' with videos: ';
      for(VideoData video in selectedVideos)
      {
        newPlaylistTitle += video.title + '; ';
      }

      if(newPlaylistTitle.length > 75)
      {
        newPlaylistTitle = newPlaylistTitle.replaceRange(74, null, '...');
      }
    }
    
    return Expanded(
      child: ListView(
        shrinkWrap: true,
        children: [
          PlaylistWidget(newPlaylistTitle, true),
          PlaylistWidget('3D Game Engine Development Tutorial', false, 'thebennybox', 61),
          PlaylistWidget('ACM/ICPC Training: For Beginner', false, 'Amy Knuth', 23),
          PlaylistWidget('AngularJS tutorial for beginners', false, 'kudvenkat', 53),            
          PlaylistWidget('Beatles', false, '', 23),                        
        ]
      ),
    );   
  }
}

class VideoWidget extends StatefulWidget
{
  final VideoData data;
  final Function(VideoWidget) _onSelectedCallback;
  
  bool selected = false;
  
  VideoWidget(this.data, this._onSelectedCallback);
  
  @override
  State<VideoWidget> createState() => VideoWidgetState();
}

class VideoWidgetState extends State<VideoWidget>
{
  @override
  Widget build(BuildContext context)
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
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        transitionDuration: Duration(milliseconds: 2500),
                        pageBuilder: (A, B, C) => VideoPage(widget.data.title, widget.data.author, widget.data.id),
                      ),
                    );
                  },

                  onDoubleTap: () {
                    // NOTE: If callback has been processed - redraw
                    if(widget._onSelectedCallback(widget))
                    {
                      setState(() {
                          widget.selected = !widget.selected;
                      });
                    }
                  },
                  
                  child: Hero(
                    child: Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue,
                            spreadRadius: widget.selected ? 2.0 : 0.0,
                            blurRadius: widget.selected ? 8.0 : 0.0,
                          ),
                        ],
                      ),
                      child: Image(
                        image: AssetImage('assets/preview.png'),
                        fit: BoxFit.contain,
                      ),
                    ),
                    tag: 'video${widget.data.id}',
                  ),
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
                      child: Text('${widget.data.minutes}:${widget.data.seconds}', style: TextStyle(color: Color(0xFFD5EAEB))),
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
                    width: double.infinity,
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
                      widget.data.title,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: TextStyle(
                        fontSize: 17.5,
                        fontWeight: FontWeight.w400
                      ),
                    ),
                    Text(
                      widget.data.author,
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
}

class PlaylistWidget extends StatelessWidget
{

  final bool createNew;
  final String title;
  final String? author;
  final int? videoCount;

  PlaylistWidget(this.title, [bool createNew = false, String? author, int? videoCount]):
    createNew = createNew,
    author = author,
    videoCount = videoCount { }
  
  @override
  Widget build(BuildContext context)
  {
    const double padding = 22.0;
    
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
          fontSize: 16
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
                fontSize: 16,
                fontWeight: FontWeight.w500,              
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
                  fontSize: 14,
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
        crossAxisAlignment: createNew? CrossAxisAlignment.center : CrossAxisAlignment.start,
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
  
}
