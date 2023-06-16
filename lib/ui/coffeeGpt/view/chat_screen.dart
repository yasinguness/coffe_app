import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:coffe_app/common/constants/coffee_colors.dart';
import 'package:coffe_app/common/widgets/app_bar_widget.dart';
import 'package:coffe_app/common/widgets/chat_bubble_widget/message_bubble.dart';
import 'package:coffe_app/locator.dart';
import 'package:coffe_app/main.dart';
import 'package:coffe_app/network/services/chat_gpt/chat_gpt_service.dart';
import 'package:coffe_app/ui/base/base_view.dart';
import 'package:coffe_app/common/widgets/text_widget.dart';
import 'package:coffe_app/ui/coffeeGpt/view_model/coffee_gpt_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

@RoutePage()
class ChatScreenView extends StatefulWidget {
  const ChatScreenView({super.key});

  @override
  State<ChatScreenView> createState() => _ChatScreenViewState();
}

class _ChatScreenViewState extends State<ChatScreenView> with SingleTickerProviderStateMixin, RouteAware {
  bool _isTyping = false;
  late TextEditingController textEditingController;
  late ScrollController scrollController;
  late FocusNode node;
  late AnimationController controller;
  late Animation<double> scaleAnimation;
  @override
  @override
  void initState() {
    // TODO: implement initState
    textEditingController = TextEditingController();
    scrollController = ScrollController();
    node = FocusNode();
    controller = AnimationController(vsync: this, duration: const Duration(seconds: 1));
    scaleAnimation = CurvedAnimation(parent: controller, curve: Curves.elasticInOut);

    controller.addListener(() {
      setState(() {});
    });

    controller.forward();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    textEditingController.dispose();
    scrollController.dispose();
    node.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<CoffeGptViewModel>(
      routeObserver: routeObserver,
      onDispose: () => routeObserver.unsubscribe(this),
      builder: (context, value, widget) => ScaleTransition(
        scale: scaleAnimation,
        child: Scaffold(
          backgroundColor: const Color.fromARGB(255, 55, 52, 53),
          appBar: const CustomAppBar(backgroundColor: CoffeeColors.kBrownColor),
          body: SafeArea(
              child: Column(
            children: [
              const SizedBox(
                height: 8,
              ),
              const OutBubble(
                  message: "Merhaba, Ben Cofi. Ne çeşit bir kahve içmek istediğini biraz açıklayabilir misin ?",
                  chatIndex: 1),
              _messageList(value),
              if (_isTyping) ...[
                const SpinKitThreeBounce(
                  color: Colors.black,
                  size: 18,
                ),
              ],
              const SizedBox(
                height: 16,
              ),
              Container(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                          child: TextField(
                        focusNode: node,
                        style: Theme.of(context).textTheme.bodyLarge,
                        controller: textEditingController,
                        onSubmitted: (value2) async {
                          await sendMessageFCT(value);
                        },
                        decoration: _textFieldDecoration(context),
                      )),
                      IconButton(
                        onPressed: () async {
                          await sendMessageFCT(value);
                        },
                        icon: const Icon(Icons.send),
                        color: Colors.black,
                      )
                    ],
                  ),
                ),
              )
            ],
          )),
        ),
      ),
      model: CoffeGptViewModel(chatGptServices: locator<ChatGptServices>()),
    );
  }

  Flexible _messageList(CoffeGptViewModel value) {
    return Flexible(
        child: ListView.builder(
      controller: scrollController,
      itemCount: value.list.length,
      itemBuilder: (context, index) {
        return OutBubble(message: value.list[index].msg, chatIndex: value.list[index].chatIndex);
      },
    ));
  }

  InputDecoration _textFieldDecoration(BuildContext context) {
    return InputDecoration(
        /* focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(width: 2, color: Colors.black)) */
        /*  enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(width: 2, color: Colors.black)) */
        hintText: "Bana soru sor",
        hintStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 16));
  }

  Future<void> sendMessageFCT(CoffeGptViewModel value) async {
    if (_isTyping) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: TextWidget(
            label: "You cant send multiple messages at a time",
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    if (textEditingController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: TextWidget(
            label: "Please type a message",
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    try {
      String msg = textEditingController.text;
      setState(() {
        _isTyping = true;
        value.addUserMessage(message: msg);
        textEditingController.clear();
        node.unfocus();
      });
      await value.sendMessage(msg);

      setState(() {});
    } catch (error) {
      log("error $error");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: TextWidget(
          label: error.toString(),
        ),
        backgroundColor: Colors.red,
      ));
    } finally {
      setState(() {
        scrollListToEnd();
        _isTyping = false;
      });
    }
  }

  void scrollListToEnd() {
    scrollController.animateTo(scrollController.position.maxScrollExtent,
        duration: const Duration(seconds: 2), curve: Curves.easeOut);
  }
}
