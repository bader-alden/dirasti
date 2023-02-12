import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:dirasti/Bloc/bottom_nav/bottom_nav_bloc.dart';
import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MultiBlocProvider(
        providers: [ BlocProvider(
          create: (BuildContext context) => BottomNavBloc(),
        ),
        ],
        child: BlocBuilder<BottomNavBloc, BottomNavState>(
          builder: (context, state) {
            return Scaffold(
              bottomNavigationBar: CurvedNavigationBar(
                backgroundColor: Colors.transparent,
                index: context.select((BottomNavBloc bloc) => bloc.state.index),
                buttonBackgroundColor: Colors.orange,
                items: [
                  Icon(Icons.notifications_rounded, size: 30, color: context.select((BottomNavBloc bloc) => bloc.state.index) == 0 ? Colors.white : Colors.grey),
                  Icon(Icons.person, size: 30, color: context.select((BottomNavBloc bloc) => bloc.state.index) == 1 ? Colors.white : Colors.grey),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(Icons.home, size: 30, color: context.select((BottomNavBloc bloc) => bloc.state.index) == 2 ? Colors.white : Colors.grey),
                  ),
                  Icon(Icons.calendar_month_rounded, size: 30, color: context.select((BottomNavBloc bloc) => bloc.state.index) == 3 ? Colors.white : Colors.grey),
                  Icon(Icons.settings, size: 30, color: context.select((BottomNavBloc bloc) => bloc.state.index) == 4 ? Colors.white : Colors.grey),
                ],
                onTap: (index) => context.read<BottomNavBloc>().change_index(index),
              ),

            );
          },
        ),
      ),
    );
  }
}
