import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geminiclone/main.dart';
import 'package:geminiclone/presentation/bloc/starter/starter_event.dart';
import 'package:geminiclone/presentation/bloc/starter/starter_state.dart';
import 'package:video_player/video_player.dart';

import '../bloc/starter/starter_bloc.dart';
import 'home_page.dart';

class StarterPage extends StatefulWidget {
  static const String id = 'starter_page';
  const StarterPage({super.key});

  @override
  State<StarterPage> createState() => _StarterPageState();
}

class _StarterPageState extends State<StarterPage> {
  late StarterBloc bloc;


  @override
  void initState() {
    super.initState();
    bloc = context.read<StarterBloc>();
    bloc.initVideoController();
    bloc.add(StarterVideoEvent());
  }

  @override
  void dispose() {
    bloc.exitVideoController();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: BlocBuilder<StarterBloc, StarterState>(
        builder: (context, state){
          return Container(
            padding: EdgeInsets.symmetric(vertical: 40),
            child: Column(
              children: [
                Container(
                  child: const Image(
                    width: 150,
                    image: AssetImage('assets/images/gemini_logo.png'),
                    fit: BoxFit.cover,
                  ),
                ),

                Expanded(
                  child: bloc.controller.value.isInitialized
                      ? VideoPlayer(bloc.controller)
                      : Container(),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: (){
                        Navigator.pushReplacementNamed(context, HomePage.id);
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey, width: 2),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Row(
                          children: [
                            Text(
                              'Chat with Gemini ',
                              style: TextStyle(color: Colors.grey[400], fontSize: 18),
                            ),
                            const Icon(
                              Icons.arrow_forward,
                              color: Colors.grey,
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
