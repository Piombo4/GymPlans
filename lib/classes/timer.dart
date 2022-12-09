import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:numberpicker/numberpicker.dart';
import 'dart:async';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import '../main.dart';
import 'package:duration_picker_dialog_box/duration_picker_dialog_box.dart';

class timer extends StatefulWidget {
  const timer({Key? key}) : super(key: key);

  @override
  State<timer> createState() => _timerState();
}

class _timerState extends State<timer> {
  int m = 0, s = 1, h = 0;
  bool isRunning = false;
  bool isPaused = false;
  bool timerSet = false;
  CountDownController controller = CountDownController();

  void init() {
    super.initState();
}

  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Visibility(
        child: FloatingActionButton(
          onPressed: () {
            setState(() {
              start();
            });
          },
          child: Icon(
            Icons.play_arrow_rounded,
            size: 30,
          ),
          elevation: 0,
        ),
        visible: !isRunning,
        replacement: pauseAndStop(),
      ),
      body: SafeArea(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Visibility(
              child: Fading(), visible: !timerSet, replacement: timerDisplay()),
          SizedBox(
            height: 100,
          )
        ],
      )),
    );
  }

  void start() {
    if (!isRunning) {
      isRunning = true;
      timerSet = true;
    }
  }

  void stop() {
    if (isRunning) {
      isRunning = false;
      isPaused = false;
      timerSet = false;
    }
  }

  void pauseAndResume() {
    if (isRunning) {
      if (!isPaused) {
        isPaused = true;
        controller.pause();
      } else {
        isPaused = false;
        controller.resume();
      }
    }
  }

  Widget timerDisplay() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularCountDownTimer(
            controller: controller,
            onComplete: () {},
            ringGradient: LinearGradient(
                colors: [myColor, Colors.amberAccent],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft),
            width: 248,
            height: 248,
            duration: h * 3600 + m * 60 + s,
            fillColor: Colors.white,
            ringColor: Colors.amber,
            isReverse: true,
            textFormat: CountdownTextFormat.HH_MM_SS,
            textStyle: TextStyle(
                color: Colors.black, fontSize: 35, fontWeight: FontWeight.w100),
            strokeWidth: 5.0,
          ),

        ],
      ),
    );
  }

  Widget pauseAndStop() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FloatingActionButton(
          elevation: 0,
          onPressed: () {
            setState(() {
              stop();
            });
          },
          child: Icon(Icons.stop_rounded),
        ),
        const SizedBox(width: 30),
        Visibility(
            child: FloatingActionButton(
              elevation: 0,
              onPressed: () {
                setState(() {
                  pauseAndResume();
                });
              },
              child: Icon(Icons.pause_rounded),
            ),
            visible: !isPaused,
            replacement: FloatingActionButton(
                elevation: 0,
                onPressed: () {
                  setState(() {
                    pauseAndResume();
                  });
                },
                child: Icon(
                  Icons.play_arrow_rounded,
                  size: 30,
                )))
      ],
    );
  }

  /*Column(mainAxisAlignment: MainAxisAlignment.center,
  children: [

  Text("Add a timer",style: TextStyle(fontSize: 20,color: Colors.grey[700])),
  SizedBox(height: 25,),
  FloatingActionButton(
  onPressed: _showTimePicker,
  child:  Icon(Icons.add),
  elevation: 0,
  )
  ],
  ),*/
  Widget Fading() {
    return ShaderMask(
        shaderCallback: (Rect rect) {
          return LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.purple,
              Colors.transparent,
              Colors.transparent,
              Colors.purple
            ],
            stops: [
              0,
              0.3,
              0.7,
              1.0
            ], // 10% purple, 80% transparent, 10% purple
          ).createShader(rect);
        },
        child: Picker(),
        blendMode: BlendMode.dstOut);

  }

  Widget Picker() {
    return Row(children: [
      Flexible(
        child: NumberPicker(zeroPad: true,
            infiniteLoop: true,
            decoration: BoxDecoration(
                border: Border(
              top: BorderSide(width: 1.0, color: Colors.amber),
              bottom: BorderSide(width: 1.0, color: Colors.amber),
            )),
            itemHeight: 60,
            itemWidth: 160,
            textStyle: TextStyle(fontSize: 30),
            selectedTextStyle: TextStyle(fontSize: 30, color: Colors.amber),
            itemCount: 5,
            minValue: 0,
            maxValue: 23,
            value: h,
            onChanged: (value) => setState(() => h = value)),
      ),
      Flexible(
        child: NumberPicker(zeroPad: true,
            infiniteLoop: true,
            decoration: BoxDecoration(
                border: Border(
              top: BorderSide(width: 1.0, color: Colors.amber),
              bottom: BorderSide(width: 1.0, color: Colors.amber),
            )),
            itemHeight: 60,
            itemWidth: 160,
            textStyle: TextStyle(fontSize: 30),
            selectedTextStyle: TextStyle(fontSize: 30, color: Colors.amber),
            itemCount: 5,
            minValue: 0,
            maxValue: 59,
            value: m,
            onChanged: (value) => setState(() => m = value)),
      ),
      Flexible(
          child: NumberPicker(zeroPad: true,
              infiniteLoop: true,
              decoration: BoxDecoration(
                  border: Border(
                top: BorderSide(width: 1.0, color: Colors.amber),
                bottom: BorderSide(width: 1.0, color: Colors.amber),
              )),
              itemHeight: 60,
              itemWidth: 160,
              textStyle: TextStyle(fontSize: 30),
              selectedTextStyle: TextStyle(fontSize: 30, color: Colors.amber),
              itemCount: 5,
              minValue: 1,
              maxValue: 59,
              value: s,
              onChanged: (value) => setState(() => s = value))),
    ]);
  }
}
