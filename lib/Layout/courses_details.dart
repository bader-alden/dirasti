import 'package:container_tab_indicator/container_tab_indicator.dart';
import 'package:dirasti/module/part_module.dart';
import 'package:dirasti/utils/const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:uuid/uuid.dart';
import '../Bloc/bottom_nav/bottom_nav_bloc.dart';
import '../Bloc/main/main_bloc.dart';
import '../main.dart';
import '../module/course_module.dart';
import '../module/subject_module.dart';
import '../module/teacher_module.dart';

TabController? tab_con;
TabController? video_tab_con;
PageController? page_con;
bool not_buy = true;
bool is_video_play =false;
int part = 0;

final GlobalKey<BetterPlayerPlaylistState> _betterPlayerPlaylistStateKey =
GlobalKey();
List<BetterPlayerDataSource> _dataSourceList = [];
late BetterPlayerConfiguration _betterPlayerConfiguration;
bool isVideoInit = false  ;
late BetterPlayerPlaylistConfiguration _betterPlayerPlaylistConfiguration;
// List test_list_video = ["الاولى", "الثاتية", "الثالثة", "الرابعة", "الاولaى", "الثaاتية", "الثالaثة", "الaرابعة"];

class CoursesDetails extends StatefulWidget {
  const CoursesDetails({Key? key, required this.course}) : super(key: key);
  final course_module course;
  @override
  State<CoursesDetails> createState() => _CoursesDetailsState( course);
}

class _CoursesDetailsState extends State<CoursesDetails> with TickerProviderStateMixin {
  final course_module course;


  _CoursesDetailsState( this.course) {
    _betterPlayerConfiguration = BetterPlayerConfiguration(
      autoPlay: true,
      looping: false,
      aspectRatio:16/9 ,
      fit: BoxFit.fitHeight,
      showPlaceholderUntilPlay: true,
      deviceOrientationsAfterFullScreen: [
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ],
    );
    _betterPlayerPlaylistConfiguration = BetterPlayerPlaylistConfiguration(
    //  loopVideos: true,
      nextVideoDelay: Duration(seconds: 3),
    );

  }
  // _CoursesDetailsState(this.subject, this.teacher, this.course);
  @override
  void initState() {
    super.initState();
    not_buy = true;
    isVideoInit = true;
    tab_con = TabController(length: 2, vsync: this, initialIndex: 1);
    //video_tab_con = TabController(length: test_list_video.length, vsync: this, initialIndex: test_list_video.length - 1);
    page_con = PageController(initialPage: 1);
  }
@override
  void dispose() {
    super.dispose();
    is_video_play=false;
    isVideoInit=false;
    _betterPlayerPlaylistController?.betterPlayerController?.videoPlayerController?.dispose();
    _betterPlayerPlaylistController?.dispose();
    _betterPlayerPlaylistController?.betterPlayerController?.dispose(forceDispose: true);
    _betterPlayerPlaylistController?.betterPlayerController?.clearCache();
  }
  @override
  Widget build(BuildContext context) {
    // FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
    return WillPopScope(
      onWillPop: () async {
        is_video_play=false;
        _betterPlayerPlaylistController?.betterPlayerController?.videoPlayerController?.dispose();
        _betterPlayerPlaylistController?.dispose();
        _betterPlayerPlaylistController?.betterPlayerController?.dispose(forceDispose: true);
        _betterPlayerPlaylistController?.betterPlayerController?.clearCache();
        return await true;
      },
      child: BlocProvider(
        create: (context) => MainBloc()..add(get_course_details_event(course.grade, course.subject, course.teacher_name, course.id)),
        child: BlocConsumer<MainBloc, MainState>(
          listener: (context, state) {
            if(state is watch_state){
              setState(() {
                is_video_play=true;
                part = state.part;
              });
            }
            if (state is not_sub_state) {
              setState(() {
                not_buy = true;
              });
            }
            if (state is sub_state) {
              video_tab_con = TabController(length: context.read<MainBloc>().part_list.length, vsync: this, initialIndex: 0);
              setState(() {
                not_buy = false;
              });
            }
          },
          builder: (context, state) {
            return Scaffold(
              appBar: appbar_back(course.name ?? "اسم الكورس"),
              body: Column(
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  if(is_video_play)
            FutureBuilder<List<BetterPlayerDataSource>>(
              future: setupData(context),
              builder: (context,snapshot) {
                if(snapshot.connectionState == ConnectionState.waiting ||snapshot.data==null){
                  return  Center(child: Image.asset("assets/loading.gif",width: 75,));
                }else {
                  isVideoInit = true;
                  return BetterPlayerPlaylist(
                  key: _betterPlayerPlaylistStateKey,
                  betterPlayerConfiguration: _betterPlayerConfiguration,
                  betterPlayerPlaylistConfiguration: _betterPlayerPlaylistConfiguration,
                  betterPlayerDataSourceList: snapshot.data!,
                );
                }
              }
            )
                    else
                  banner_widget(course.banner!),
                  SizedBox(
                    height: 30,
                  ),
                  Expanded(
                    child: StatefulBuilder(
                      builder: (contexta,sets) {
                        return Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Container(
                                height: 50,
                                width: double.infinity,
                                decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(10)),
                                child: IgnorePointer(
                                  ignoring: not_buy,
                                  child: TabBar(
                                    controller: tab_con,
                                    tabs: [
                                      Text('الدروس', style: TextStyle(color: tab_con?.index == 0 ? Colors.white : Colors.black, fontSize: 22)),
                                      Text('التفاصيل', style: TextStyle(color: tab_con?.index == 1 ? Colors.white : Colors.black, fontSize: 22)),
                                    ],
                                    indicator: ContainerTabIndicator(
                                      color: blue,
                                      radius: BorderRadius.circular(10.0),
                                      //  padding: const EdgeInsets.symmetric(horizontal: 20),
                                    ),
                                    onTap: (index) {
                                      //  setState(() {});
                                      sets((){});
                                      if(!is_video_play){
                                        context.read<MainBloc>().add(watch_event(0));
                                      }
                                      page_con?.animateToPage(index, duration: Duration(milliseconds: 300), curve: Curves.linear);
                                    },
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Expanded(
                                child: PageView(
                                  physics: not_buy ? NeverScrollableScrollPhysics() : BouncingScrollPhysics(),
                                  controller: page_con,
                                  onPageChanged: (index) {
                                    // setState(() {});
                                    sets((){});
                                    if(!is_video_play){
                                      context.read<MainBloc>().add(watch_event(0));
                                    }
                                    tab_con?.animateTo(index);
                                  },
                                  children: [
                                    course_details_page_2(context, sets,_betterPlayerPlaylistController,course),
                                    course_details_page_1(context, course, state),
                                  ],
                                ))
                          ],
                        );
                      }
                    ),
                  ),

                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Future<List<BetterPlayerDataSource>> setupData(BuildContext context) async {
    for(int i =0; i<context.read<MainBloc>().part_list.length;i++){
      context.read<MainBloc>().part_list[i].part?.forEach((element) {
        // print(element.res!.values.first);
        // print(element.res );
        _dataSourceList.add(
          BetterPlayerDataSource(
              BetterPlayerDataSourceType.network,
              // element.res!.values.first,
              element.res!.values.toList()[1],
               resolutions: element.res?.map((key, value) => MapEntry(key, value.toString()))
          ),
        );
      });
    }


    // _dataSourceList.add(
    //   BetterPlayerDataSource(
    //     BetterPlayerDataSourceType.network, Constants.forBiggerBlazesUrl,
    //   ),
    // );
    //
    // _dataSourceList.add(
    //   BetterPlayerDataSource(
    //     BetterPlayerDataSourceType.network,
    //     Constants.bugBuckBunnyVideoUrl,
    //   ),
    // );
    // _dataSourceList.add(
    //   BetterPlayerDataSource(
    //     BetterPlayerDataSourceType.network,
    //     Constants.forBiggerJoyridesVideoUrl,
    //   ),
    // );

    return _dataSourceList;
  }

}
BetterPlayerPlaylistController? get _betterPlayerPlaylistController =>
    _betterPlayerPlaylistStateKey
        .currentState?.betterPlayerPlaylistController;

Widget course_details_page_1(context, course_module course, state) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
    child: Column(
      children: [
        Expanded(
          child: ListView(
            physics: BouncingScrollPhysics(),
            children: [
              Row(
                children: [
                  if( course.price=="0")
                  Text(
                   "كورس مجاني",
                    style: TextStyle(fontSize: 22, color: orange, fontWeight: FontWeight.bold),
                  )
                  else
                  Text(
                    "السعر " + course.price!,
                    style: TextStyle(fontSize: 22, color: orange, fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  Text(
                    "اسم الكورس",
                    style: TextStyle(fontSize: 22, color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Spacer(),
                  Text(
                    ": التفاصيل",
                    style: TextStyle(fontSize: 20, color: blue, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Text(course.des??"", textDirection: TextDirection.rtl),
            ],
          ),
        ),
        //Spacer(),
        if (state is not_sub_state)
          InkWell(
              onTap: () {
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.pop(context);
                // context.read<BottomNavBloc>().change_index(0);
                home_page_con.jumpToPage(1);
              },
              child: Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(color: blue, borderRadius: BorderRadius.circular(10)),
                  child: Center(
                      child: Text(
                    "شراء الكورس",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ))))
        else if (state is sub_state||is_video_play)
          Builder(
            builder: (context) {
              return BlocProvider(
                  create: (context) => MainBloc(),
                  child: InkWell(
                  onTap: () {
                    page_con?.animateTo(0, duration: Duration(milliseconds: 300), curve: Curves.linear);
                    tab_con?.animateTo(0);
                    if(!is_video_play){
                      context.read<MainBloc>().add(watch_event(0));
                    }

                   // MainBloc().add(watch_event(0));
                  },
                  child: Container(
                      width: double.infinity,
                      height: 50,
                      decoration: BoxDecoration(color: blue, borderRadius: BorderRadius.circular(10)),
                      child: Center(
                          child: Text(
                        "بدء المشاهدة",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      )))),
);
            }
          )
        else
          Container(
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(color: blue, borderRadius: BorderRadius.circular(10)),
              child: Center(
                  child: CircularProgressIndicator(
                color: Colors.white,
              )))
      ],
    ),
  );
}

Widget course_details_page_2(BuildContext context, setstate,_betterPlayerPlaylistController ,course) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          ": الوحدات",
          style: TextStyle(color: orange, fontSize: 22, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 10,
        ),
        Directionality(
          textDirection: TextDirection.rtl,
          child: TabBar(
            isScrollable: true,
            padding: EdgeInsets.zero,
            indicatorPadding: const EdgeInsets.symmetric(horizontal: 4),
            labelPadding: EdgeInsets.zero,
            controller: video_tab_con,
            tabs: context.read<MainBloc>().part_tab_list
                .map(
                  (e) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Container(
                       // width: 80,
                        decoration: BoxDecoration(border: Border.all(), borderRadius: BorderRadius.circular(10)),
                        padding: EdgeInsets.all(4),
                        child: Center(
                            child: Text(e,
                                style: TextStyle(
                                    color: video_tab_con?.index == context.read<MainBloc>().part_tab_list.toList().indexOf(e) ? Colors.white : Colors.black,
                                    fontSize: 15)))),
                  ),
                )
                .toList(),
            indicator: ContainerTabIndicator(
              color: blue,
              padding: EdgeInsets.zero,
              radius: BorderRadius.circular(12.0),
              //  padding: const EdgeInsets.symmetric(horizontal: 20),
            ),
            onTap: (index) {

              setstate(() {});
            },
          ),
        ),
        SizedBox(
          height: 20,
        ),
        if(video_tab_con!=null)
        Expanded(
            child: StatefulBuilder(
              builder: (context,setstat) {
                return ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: context.read<MainBloc>().part_list[video_tab_con!.index].part?.length,
                    itemBuilder: (context, index) {
                      return tab_part_item(context ,index,context.read<MainBloc>().part_list[video_tab_con!.index].part![index],setstat,course);
                    });
              }
            ))
      ],
    ),
  );
}

Widget tab_part_item(BuildContext context, int index,part_detail_module model,setstate , course_module course) {
 var nameModel = context.read<MainBloc>().part_list[video_tab_con!.index];

  var logsName = "1|${course.id}|${nameModel.id}|${model.name}";
//  var logsName =Uuid().v4();
  // 1|3|10|14|16
  _betterPlayerPlaylistController?.betterPlayerController?.addEventsListener((p0) {
    Duration? currentPosition = _betterPlayerPlaylistController?.betterPlayerController?.videoPlayerController!.value.position;
    Duration? currentDuration = _betterPlayerPlaylistController?.betterPlayerController?.videoPlayerController!.value.duration;
    int? currentPositionInSeconds = currentPosition?.inSeconds;
    if(currentDuration?.inSeconds == currentPositionInSeconds){
      if(context.read<MainBloc>().video_index_map[video_tab_con?.index]!.indexOf(_betterPlayerPlaylistController?.currentDataSourceIndex??0) == index &&
                context.read<MainBloc>().video_index_map[video_tab_con?.index]!.contains(_betterPlayerPlaylistController?.currentDataSourceIndex)){
                  print("end the video");
      context.read<MainBloc>().add(logs_event(logsName));
      setstate((){});
                }else{
                  print("=-----=");
                  print(context.read<MainBloc>().video_index_map[video_tab_con?.index]!.indexOf(_betterPlayerPlaylistController?.currentDataSourceIndex??0));
                  print(index);
                  print(context.read<MainBloc>().video_index_map[video_tab_con?.index]!);
                  print(_betterPlayerPlaylistController?.currentDataSourceIndex);
                  print("=-----=");
                }
      
    }
    if(_betterPlayerPlaylistController?.betterPlayerController?.isBuffering()??false){

      _betterPlayerPlaylistController?.betterPlayerController?.videoPlayerController?.position.then((value) {

        if(value!.inSeconds == 0){

          setstate((){});

        }else{
         // print(value.inSecond );
        }
      });
    }else{

    }
  });


  return InkWell(
    borderRadius: BorderRadius.circular(10),
    onTap: () {
      // print("=======");
      //     print(_betterPlayerPlaylistController?.currentDataSourceIndex);
      //     print(index);
      //     print(video_tab_con?.index);
      //     print(part);
      //     context.read<MainBloc>().logs_list.forEach((element) {print(element);});
      //     print(context.read<MainBloc>().video_index_map[video_tab_con?.index]!.indexOf(_betterPlayerPlaylistController?.currentDataSourceIndex??0) == index &&
      //           context.read<MainBloc>().video_index_map[video_tab_con?.index]!.contains(_betterPlayerPlaylistController?.currentDataSourceIndex));
      if(is_video_play && _betterPlayerPlaylistController?.currentDataSourceIndex ==index&&video_tab_con?.index==part){
        if( _betterPlayerPlaylistController!.betterPlayerController!.isPlaying()!){
          _betterPlayerPlaylistController?.betterPlayerController?.pause();
        }else {
          _betterPlayerPlaylistController?.betterPlayerController?.play();
        }
        setstate((){});
      }
      else if(video_tab_con?.index!=part&& is_video_play){
       // Tost("change tab", Colors.red);

        _betterPlayerPlaylistController?.setupDataSource(context.read<MainBloc>().video_index_map[video_tab_con?.index]![index]);
        setstate((){});
      }
      else if(is_video_play){
        // print("Currently playing video: " +
        //     _betterPlayerPlaylistController?.currentDataSourceIndex
        //         .toString());
        _betterPlayerPlaylistController?.setupDataSource(index);
        setstate((){});
      }else{

        // setstate((){});
        //     context.read<MainBloc>().add(watch_event(video_tab_con?.index));
      }
    },
    child: Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Icon( context.read<MainBloc>().video_index_map[video_tab_con?.index]!.indexOf(_betterPlayerPlaylistController?.currentDataSourceIndex??0) == index &&
                context.read<MainBloc>().video_index_map[video_tab_con?.index]!.contains(_betterPlayerPlaylistController?.currentDataSourceIndex) &&
                (_betterPlayerPlaylistController!.betterPlayerController!.isPlaying()!||_betterPlayerPlaylistController!.betterPlayerController!.isBuffering()!)
                ?Icons.pause :Icons.play_arrow_rounded, size: 50),
            Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(model.name!, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                Text(
                    model.time!,
                  style: TextStyle(color: Colors.grey),
                  textDirection: TextDirection.ltr,
                )
              ],
            ),
            SizedBox(
              width: 15,
            ),
            // SizedBox(height: 75,width: 75,child: Placeholder(),)
            //  SizedBox(height: 75,width: 75,child: Center(child: Text((index+1).toString(),style: TextStyle(fontSize: 30),)),)
            Container(
              decoration: BoxDecoration(color:
              context.read<MainBloc>().video_index_map[video_tab_con?.index]!.indexOf(_betterPlayerPlaylistController?.currentDataSourceIndex??0) == index
                  &&
                  context.read<MainBloc>().video_index_map[video_tab_con?.index]!.contains(_betterPlayerPlaylistController?.currentDataSourceIndex)
                  ? orange :
              context.read<MainBloc>().logs_list.contains(logsName)
                  ?Colors.green
                  :blue
                  , borderRadius: BorderRadius.circular(15)),
              height: 75,
              width: 75,
              child: Center(
                  child: Text(
                    (index + 1).toString(),
                    style: TextStyle(fontSize: 30, color: Colors.white),
                  )),
            )
          ],
        ),
      ),
    ),
  );
}











// class PlaylistPage extends StatefulWidget {
//   @override
//   _PlaylistPageState createState() => _PlaylistPageState();
// }
//
// class _PlaylistPageState extends State<PlaylistPage> {
//
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Playlist"),
//       ),
//       body: FutureBuilder<List<BetterPlayerDataSource>>(
//         future: setupData(),
//         builder: (context, snapshot) {
//           if (!snapshot.hasData) {
//             return Text("Building!");
//           } else {
//             return ListView(children: [
//               AspectRatio(
//                 aspectRatio: 1,
//                 child:
//               ),
//               // ElevatedButton(
//               //   onPressed: () {
//               //     var list = [
//               //       BetterPlayerDataSource(
//               //         BetterPlayerDataSourceType.network,
//               //         Constants.bugBuckBunnyVideoUrl,
//               //       )
//               //     ];
//               //     _betterPlayerPlaylistController?.setupDataSourceList(list);
//               //   },
//               //   child: Text("Setup new data source list"),
//               // ),
//             ]);
//           }
//         },
//       ),
//     );
//   }
//
//   BetterPlayerPlaylistController? get _betterPlayerPlaylistController =>
//       _betterPlayerPlaylistStateKey
//           .currentState!.betterPlayerPlaylistController;
// }

