import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import '../../../data/models/message_model.dart';
import '../../../data/respositories/gemini_talk_respository_impl.dart';
import '../../../domain/usecases/gemini_text_and_image_usecase.dart';
import '../../../domain/usecases/gemini_text_only_usecase.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  GeminiTextOnlyUseCase textOnlyUseCase = GeminiTextOnlyUseCase(GeminiTalkRepositoryImpl());
  GeminiTextAndImageUseCase textAndImageUseCase = GeminiTextAndImageUseCase(GeminiTalkRepositoryImpl());

  TextEditingController textController = TextEditingController();
  String pickedImage64 = '';
  List<MessageModel> messages = [];

  HomeBloc() : super(HomeInitialState()) {
    on<HomeSendEvent>(_onAskToGemini);
  }

  Future<void> _onAskToGemini(HomeSendEvent event, Emitter<HomeState> emit) async {

  }
}
