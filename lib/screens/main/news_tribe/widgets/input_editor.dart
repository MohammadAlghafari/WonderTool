import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:wonder_tool/themes/colors.dart';

class InputEditorWidget extends StatelessWidget {
  final String data;
  final Function(String) onDone;

  const InputEditorWidget({
    Key? key,
    required this.data,
    required this.onDone,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _controller = HtmlEditorController();

    return Builder(builder: (context) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
        SystemChannels.textInput.invokeMethod('TextInput.show');
      
      });
      return Container(
        color: const Color.fromARGB(255, 18, 18, 18),
        child: SafeArea(
          top: false,
          child: Wrap(
            children: [
              Container(
                color: primaryColor,
                height: 300,
                child: HtmlEditor(
                  controller: _controller,
                  htmlToolbarOptions: const HtmlToolbarOptions(
                    defaultToolbarButtons: [
                      FontButtons(),
                      ListButtons(listStyles: false),
                    ],
                    buttonSelectedColor: blueColor,
                  ),
                  htmlEditorOptions: HtmlEditorOptions(
                    hint: "What's Happening...",
                    initialText: data,
                    darkMode: true,
                  ),
                  otherOptions: const OtherOptions(
                    height: 300,
                    decoration: BoxDecoration(
                      border: Border.fromBorderSide(
                        BorderSide(
                          color: secondColor,
                          width: 0,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Container(
                padding: const EdgeInsets.only(bottom: 10),
                alignment: Alignment.center,
                child: ElevatedButton(
                  onPressed: () async {
                    String text = await _controller.getText();
                    onDone(text);
                    Get.back();
                  },
                  child: const AutoSizeText(
                    "Done",
                    maxLines: 1,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
