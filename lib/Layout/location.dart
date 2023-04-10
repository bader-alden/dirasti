import 'package:dirasti/utils/const.dart';
import 'package:dirasti/utils/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:map_launcher/map_launcher.dart';
List list_location = [] ;
class Location extends StatefulWidget {
  const Location({Key? key}) : super(key: key);

  @override
  State<Location> createState() => _LocationState();
}

class _LocationState extends State<Location> {

  @override
  void initState() {
dio.get_data(url: "/data/Coupon_points_of_sale",).then((value) {
  list_location.clear();
  value?.data.forEach((e){
    list_location.add(e);
    if(list_location.length -1 == value?.data.indexOf(e)){
      setState(() {});
    }
  });
});
  }
  @override
  Widget build(BuildContext context) {
    FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
    return Scaffold(
      appBar: appbar_back("أماكن بيع أكواد التفعيل"),
      body: list_location.isEmpty
            ?Center(child: CircularProgressIndicator())
            :ListView.builder(
        itemCount: list_location.length,
          physics: BouncingScrollPhysics(),itemBuilder: (context,index){
        return Card(child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                SizedBox(width: 20,),
                InkWell(
                  onTap: () async {
                    final availableMaps = await MapLauncher.installedMaps;
                    await availableMaps.first.showMarker(
                      coords: Coords(double.parse(list_location[index]["lat"]), double.parse(list_location[index]["lang"])),
                      title: list_location[index]["name"],
                    );
                  },
                  child: Card(elevation: 2,child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(Icons.location_on_outlined,color: blue,size: 30),
                  )),
                ),
                Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(list_location[index]["name"],style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold)),
                    Text(list_location[index]["address"],style: TextStyle(fontSize: 14)),
                  ],
                ),
                SizedBox(width: 10,),
                Icon(Icons.circle,size: 5),

              ],
            ),
          ),
        ),);
      }),
    );
  }


}
