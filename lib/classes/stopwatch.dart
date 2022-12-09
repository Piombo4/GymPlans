import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'dart:async';

import 'package:gymplans/main.dart';

class stopwatch extends StatefulWidget {
  const stopwatch({Key? key}) : super(key: key);

  @override
  State<stopwatch> createState() => _stopwatchState();
}

class _stopwatchState extends State<stopwatch> {
  late ScrollController scrollController;
  bool showStopButton = false;
  bool showLapList = false;
  late Stopwatch stopwatch;
  late Timer t;
  List<String> laps = [];

  void handleStartStop() {
    if (!showStopButton) {
      showStopButton = true;
    }
    if (stopwatch.isRunning) {
      stopwatch.stop();
    } else {
      stopwatch.start();
    }
  }

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    stopwatch = Stopwatch();
    if (mounted) {
      t = Timer.periodic(Duration(milliseconds: 30), (timer) {
        setState(() {});
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    t.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
            Visibility(
            child: Center(child: Text("TAP TO START",
                style: TextStyle(
                  fontSize: 27,
                  color: Colors.grey[400],
                )),),
            visible: !showStopButton),
                Visibility(
                    child: SizedBox(height: 20,),
                    visible: !showStopButton),
                CupertinoButton(
                    child: Container(
                      height: 250,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: myColor[600]!,
                          width: 4,
                        ),
                      ),
                      child: Text(
                        returnFormattedText(),
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 40,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                    onPressed: () {
                      handleStartStop();
                    }),
                const SizedBox(
                  height: 30,
                ),
                Visibility(
                    visible: showStopButton,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FloatingActionButton(
                          onPressed: () {
                            if (stopwatch.isRunning) {
                              stopwatch.stop();
                            }
                            reset();
                          },
                          heroTag: null,
                          backgroundColor: myColor[600],
                          elevation: 0,
                          child: const Icon(
                            size: 30,
                            Icons.stop_rounded,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(width: 30),
                        FloatingActionButton(
                          onPressed: () {
                            setState(() {
                              if (!showLapList) {
                                showLapList = true;
                              }
                              laps.add(returnFormattedText());
                              if (laps.isNotEmpty) {
                                SchedulerBinding.instance
                                    .addPostFrameCallback((_) {
                                  scrollController.animateTo(
                                      scrollController.position.maxScrollExtent,
                                      duration:
                                          const Duration(milliseconds: 200),
                                      curve: Curves.easeIn);
                                });
                              }
                            });
                          },
                          heroTag: null,
                          backgroundColor: myColor[600],
                          elevation: 0,
                          child: const Icon(
                            size: 30,
                            Icons.flag_rounded,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    )),
                Visibility(visible: showLapList, child: Divider()),
                Visibility(
                    visible: showLapList,
                    child: Flexible(
                        child: Container(
                      constraints:
                          const BoxConstraints(maxHeight: 200, maxWidth: 350),
                      child: ListView.builder(
                          reverse: true,
                          shrinkWrap: true,
                          controller: scrollController,
                          itemCount: laps.length,
                          itemBuilder: (BuildContext context, int index) {
                            return ListTile(
                                minLeadingWidth: 20,
                                leading: const Icon(Icons.flag_rounded),
                                trailing: Text(
                                  laps.elementAt(index),
                                  style: const TextStyle(
                                      color: Colors.green, fontSize: 15),
                                ),
                                title: Text(index < 10 ? "0$index" : "$index"));
                          }),
                    )))
              ],
            ),
          ),
        ));
  }

  String returnFormattedText() {
    var milli = stopwatch.elapsed.inMilliseconds;

    String milliseconds = (milli % 1000).toString().padLeft(3, "0");
    String seconds = ((milli ~/ 1000) % 60).toString().padLeft(2, "0");
    String minutes = ((milli ~/ 1000) ~/ 60).toString().padLeft(2, "0");

    return "$minutes:$seconds:$milliseconds";
  }

  void reset() {
    stopwatch.reset();
    laps = [];
    showLapList = false;
    showStopButton = false;
  }
}
