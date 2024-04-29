import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:trendeo/core/color_app.dart';

class MessageCard extends StatefulWidget {
  const MessageCard({
    super.key,
    this.e,
    required this.isVoice,
  });
  final dynamic e;
  final bool isVoice;

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  bool isPlaying = false;

  @override
  Widget build(BuildContext context) {
    BoxDecoration messageMy() {
      return BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
        color: ColorApp.moodApp
            ? ColorApp.darkDelicateColor
            : ColorApp.lightDelicateColor,
      );
    }

    BoxDecoration messageYou() {
      return BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
          bottomLeft: Radius.circular(20),
        ),
        color: ColorApp.moodApp
            ? ColorApp.darkPrimaryColor
            : ColorApp.lightPrimaryColor,
      );
    }

    return Container(
      padding: const EdgeInsets.all(5),
      decoration:
          widget.e['senderEmail'] == FirebaseAuth.instance.currentUser!.email
              ? messageYou()
              : messageMy(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          widget.isVoice == false
              ? Text(
                  widget.e['text'],
                  style: TextStyle(
                    color: ColorApp.moodApp
                        ? ColorApp.darkBackgroundColor
                        : ColorApp.lightBackgroundColor,
                    fontSize: 20,
                  ),
                )
              : IconButton(
                  onPressed: () async {
                    final player = AudioPlayer();
                    if (isPlaying == false) {
                      setState(() {
                        isPlaying = true;
                      });
                      await player.play(
                        UrlSource(widget.e['voiceUrl']),
                      );
                      player.onPlayerComplete.listen((event) {
                        setState(() {
                          isPlaying = false;
                          player.audioCache.clearAll();
                        });
                      });
                    } else {
                      await player.pause();
                      setState(() {
                        isPlaying = false;
                      });
                    }
                  },
                  icon: Icon(
                    isPlaying == false ? Icons.play_arrow : Icons.stop,
                    color: ColorApp.darkBackgroundColor,
                  )),
          Padding(
            padding: const EdgeInsets.only(left: 5),
            child: Text(
              DateFormat('E hh:mm a')
                  .format(widget.e['timeStamp'].toDate())
                  .toString(),
              style: TextStyle(
                color: ColorApp.moodApp
                    ? ColorApp.darkBackgroundColor
                    : ColorApp.lightBackgroundColor,
                fontSize: 10,
              ),
            ),
          )
        ],
      ),
    );
  }
}
