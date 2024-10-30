import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geminiclone/presentation/bloc/home/home_bloc.dart';
import 'package:geminiclone/presentation/bloc/starter/starter_event.dart';
import 'package:geminiclone/presentation/bloc/starter/starter_state.dart';
import 'package:geminiclone/presentation/pages/home_page.dart';
import 'package:video_player/video_player.dart';

import '../home/picker_bloc.dart';

class StarterBloc extends Bloc<StarterEvent, StarterState> {
  late VideoPlayerController controller;

  StarterBloc() : super(StarterInitial()) {
    on<StarterVideoEvent>(_playVideoPlayer);
  }

  Future<void> _playVideoPlayer(
      StarterVideoEvent event, Emitter<StarterState> emit) async {
    controller.play();
    controller.setLooping(true);
    emit(StarterVideoState());
  }

  initVideoController() async {
    controller = VideoPlayerController.asset("assets/videos/gemini_video.mp4")
      ..initialize();
  }

  exitVideoController() async {
    controller.dispose();
  }

  callHomePage(BuildContext context) {
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) {
      return MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => HomeBloc()),
            BlocProvider(create: (context) => PickerBloc()),
          ],
          child: HomePage());
    }));
  }
}
