import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import '../../../core/services/log_service.dart';
import '../../../core/services/utils_service.dart';
import '../../../data/models/message_model.dart';
import '../../../data/respositories/gemini_talk_respository_impl.dart';
import '../../../domain/usecases/gemini_text_and_image_usecase.dart';
import '../../../domain/usecases/gemini_text_only_usecase.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  GeminiTextOnlyUseCase textOnlyUseCase =
      GeminiTextOnlyUseCase(GeminiTalkRepositoryImpl());
  GeminiTextAndImageUseCase textAndImageUseCase =
      GeminiTextAndImageUseCase(GeminiTalkRepositoryImpl());

  TextEditingController textController = TextEditingController();
  List<MessageModel> messages = [];

  HomeBloc() : super(HomeInitialState()) {
    on<HomeTextOnlyEvent>(_onHomeTextOnlyEvent);
    on<HomeTextAndImageEvent>(_onHomeTextAndImageEvent);
  }

  Future<void> _onHomeTextOnlyEvent(HomeTextOnlyEvent event, Emitter<HomeState> emit) async {
    emit(HomeLoadingState());
    var either = await textOnlyUseCase.call(event.message);
    either.fold((l) {
      LogService.e(l);
      MessageModel gemini = MessageModel(isMine: false, message: l);
      updateMessages(gemini);
      emit(HomeFailureState());
    }, (r) async {
      LogService.i(r);
      MessageModel gemini = MessageModel(isMine: false, message: r);
      updateMessages(gemini);
      emit(HomeSuccessState());
    });
  }

  Future<void> _onHomeTextAndImageEvent(HomeTextAndImageEvent event, Emitter<HomeState> emit) async {
    emit(HomeLoadingState());
    var either = await textAndImageUseCase.call(event.message, event.base64Image!);
    either.fold((l) {
      LogService.e(l);
      MessageModel gemini = MessageModel(isMine: false, message: l);
      updateMessages(gemini);
      emit(HomeFailureState());
    }, (r) async {
      LogService.i(r);
      MessageModel gemini = MessageModel(isMine: false, message: r);
      updateMessages(gemini);
      emit(HomeSuccessState());
    });
  }

  updateMessages(MessageModel messageModel) {
    messages.add(messageModel);
  }

  askToGemini(String? pickedImage64) {
    String message = textController.text.toString().trim();

    if (pickedImage64 == null) {
      MessageModel mine = MessageModel(isMine: true, message: message);
      updateMessages(mine);
      add(HomeTextOnlyEvent(message: message));
    } else {
      MessageModel mine = MessageModel(isMine: true, message: message, base64: pickedImage64);
      updateMessages(mine);
      add(HomeTextAndImageEvent(message: message, base64Image: pickedImage64));
    }
    textController.clear();
  }
}
