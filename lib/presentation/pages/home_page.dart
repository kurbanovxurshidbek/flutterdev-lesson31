import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/constants/constants.dart';
import '../../core/services/log_service.dart';
import '../../core/services/utils_service.dart';
import '../../data/models/message_model.dart';
import '../../data/respositories/gemini_talk_respository_impl.dart';
import '../../domain/usecases/gemini_text_and_image_usecase.dart';
import '../../domain/usecases/gemini_text_only_usecase.dart';
import '../widgets/item_gemini_message.dart';
import '../widgets/item_user_message.dart';

class HomePage extends StatefulWidget {
  static const String id = 'home_page';

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GeminiTextOnlyUseCase textOnlyUseCase =
      GeminiTextOnlyUseCase(GeminiTalkRepositoryImpl());
  GeminiTextAndImageUseCase textAndImageUseCase =
      GeminiTextAndImageUseCase(GeminiTalkRepositoryImpl());

  TextEditingController textController = TextEditingController();
  String pickedImage64 = '';

  List<MessageModel> messages = [];

  _pickImageFromGallery() async {
    var result = await Utils.pickAndConvertImage();
    LogService.i('Image selected !!!');
    setState(() {
      pickedImage64 = result;
    });
  }

  _removePickedImage(){
    setState(() {
      pickedImage64 = '';
    });
  }

  askToGemini() {
    String message = textController.text.toString().trim();

    if (pickedImage64.isNotEmpty) {
      MessageModel mine =
          MessageModel(isMine: true, message: message, base64: pickedImage64);
      updateMessages(mine);
      apiTextAndImage(message);
    } else {
      MessageModel mine = MessageModel(isMine: true, message: message);
      updateMessages(mine);

      apiTextOnly(message);
    }
    textController.clear();

    _removePickedImage();
  }

  apiTextOnly(String text) async {
    var either = await textOnlyUseCase.call(text);
    either.fold((l) {
      LogService.d(l);
      MessageModel gemini = MessageModel(isMine: false, message: l);
      updateMessages(gemini);
    }, (r) async {
      LogService.d(r);
      MessageModel gemini = MessageModel(isMine: false, message: r);
      updateMessages(gemini);
    });
  }

  apiTextAndImage(String text) async {
    var base64 = await Utils.pickAndConvertImage();

    var either = await textAndImageUseCase.call(text, base64);
    either.fold((l) {
      LogService.d(l);
      MessageModel gemini = MessageModel(isMine: false, message: l);
      updateMessages(gemini);
    }, (r) async {
      LogService.d(r);
      MessageModel gemini = MessageModel(isMine: false, message: r);
      updateMessages(gemini);
    });
  }

  updateMessages(MessageModel messageModel) {
    setState(() {
      messages.add(messageModel);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: () {
        },
        child: Container(
          padding: EdgeInsets.only(bottom: 20, top: 20),
          child: Column(
            children: [
              const SizedBox(
                height: 45,
                child: Image(
                  image: AssetImage('assets/images/gemini_logo.png'),
                  fit: BoxFit.cover,
                ),
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(15),
                  child: messages.isEmpty
                      ? Center(
                          child: SizedBox(
                            height: 100,
                            width: 100,
                            child: Image.asset('assets/images/gemini_icon.png'),
                          ),
                        )
                      : ListView.builder(
                          itemCount: messages.length,
                          itemBuilder: (context, index) {
                            var message = messages[index];
                            if (message.isMine!) {
                              return itemOfUserMessage(message);
                            } else {
                              return itemOfGeminiMessage(message);
                            }
                          },
                        ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(right: 20, left: 20),
                padding: const EdgeInsets.only(left: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(color: Colors.grey, width: 1.5),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    pickedImage64.isEmpty
                        ? SizedBox.shrink()
                        : Stack(
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          height: 70,
                          width: 70,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.white)),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.memory(
                              base64Decode(pickedImage64),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),

                        Container(
                          margin: EdgeInsets.only(top: 10),
                          height: 70,
                          width: 70,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.white)),
                          child: Center(
                            child: IconButton(
                              onPressed: (){
                                  _removePickedImage();
                              },
                              icon: Icon(Icons.clear, color: Colors.black,),
                            ),
                          ),
                        ),


                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: textController,
                            maxLines: null,
                            style: TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Message',
                              hintStyle: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        IconButton(
                          onPressed: () async {
                            _pickImageFromGallery();
                          },
                          icon: const Icon(
                            Icons.attach_file,
                            color: Colors.grey,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            askToGemini();
                          },
                          icon: const Icon(
                            Icons.send,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
