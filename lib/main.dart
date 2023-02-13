import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:dirasti/Bloc/bottom_nav/bottom_nav_bloc.dart';
import 'package:dirasti/utills/const.dart';
import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'Layout/home_page.dart';

main() {
  runApp(const App());
}
var _home_page_con=PageController(initialPage: 2);
class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MultiBlocProvider(
        providers: [ 
          BlocProvider(
          create: (BuildContext context) => BottomNavBloc(),
        ),
        ],
        child: BlocBuilder<BottomNavBloc, BottomNavState>(
          builder: (context, state) {
            return Scaffold(
              backgroundColor: white,
              bottomNavigationBar: CurvedNavigationBar(
                backgroundColor: Colors.transparent,
                color: Colors.transparent,
                index: context.select((BottomNavBloc bloc) => bloc.state.index),
                buttonBackgroundColor: orange,
                height: 65,
                items: [
                  Icon(Icons.notifications_rounded, size: 30, color: context.select((BottomNavBloc bloc) => bloc.state.index) == 0 ? Colors.white : blue),
                  Icon(Icons.person, size: 30, color: context.select((BottomNavBloc bloc) => bloc.state.index) == 1 ? Colors.white : blue),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(Icons.home, size: 30, color: context.select((BottomNavBloc bloc) => bloc.state.index) == 2 ? Colors.white : blue),
                  ),
                  Icon(Icons.calendar_month_rounded, size: 30, color: context.select((BottomNavBloc bloc) => bloc.state.index) == 3 ? Colors.white : blue),
                  Icon(Icons.settings, size: 30, color: context.select((BottomNavBloc bloc) => bloc.state.index) == 4 ? Colors.white : blue),
                ],
                onTap: (index)  {
                  context.read<BottomNavBloc>().change_index(index);
                  _home_page_con.jumpToPage(index);
                  },
              ),
             body: PageView(
               onPageChanged: (index){
                 context.read<BottomNavBloc>().change_index(index);
               },
               controller: _home_page_con,
               children: [
                 Container(),
                 Container(),
                 HomePage(),
                 Container(),
                 Container(),
               ],
             ),
            );
          },
        ),
      ),
    );
  }
}
