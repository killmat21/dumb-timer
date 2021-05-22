import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:math' as math;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dumb Timer',
      home: TimerPage()
    );
  }
}

class TimerPage extends StatefulWidget {
  TimerPage({Key key}) : super(key: key);

  @override
  _TimerPageState createState() => _TimerPageState();
}


class _TimerPageState extends State<TimerPage> {
  var sets = [];
  var exerciseTime = "0:00:00.000000";
  var restTime = "0:00:00.000000";

  void _addSet() {
    setState(() {
      int place = sets.length;
      var extimeList = exerciseTime.split(":");
      var extime = extimeList[1] + ":" + extimeList[2].split(".")[0];
      var rtimeList = restTime.split(":");
      var rtime = rtimeList[1] + ":" + rtimeList[2].split(".")[0];
      sets.add({'place': place, 'exercise': extime, 'rest': rtime});
    });
  }

  void _removeSet(index) {
    setState(() {
      sets.removeAt(index);
      sets = List.from(sets);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            centerTitle: true,
            backgroundColor: Colors.white,
            title: Text(
              "Dumb Timer",
              style: TextStyle(color: Colors.black, fontFamily: 'IndieFlower', fontSize: 24),
            )
        ),
        body: Center(
            child: Column(
                children: <Widget> [
                  Padding(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                            'EXERCISE: ',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontFamily: 'Montserrat')
                        ),
                        Container(
                          height: 150,
                          width: 300,
                          child: CupertinoTimerPicker(
                            mode: CupertinoTimerPickerMode.ms,
                            onTimerDurationChanged: (value) {
                              exerciseTime = value.toString();
                            },
                          ),
                        ),
                      ],
                    ),
                    padding: EdgeInsets.only(top: 25),
                  ),
                  Padding(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                            'REST: ',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontFamily: 'Montserrat')
                        ),
                        Container(
                          height: 150,
                          width: 300,
                          child:CupertinoTimerPicker(
                            mode: CupertinoTimerPickerMode.ms,
                            onTimerDurationChanged: (value) {
                              restTime = value.toString();
                            },
                          ),
                        )
                      ],
                    ),
                    padding: EdgeInsets.only(top: 25),
                  ),
                  Padding(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: FloatingActionButton(
                              onPressed: () {
                                print(exerciseTime);
                                if (exerciseTime != "0:00:00.000000")
                                  _addSet();
                              },
                              child: Text("ADD"),
                              backgroundColor: Colors.black,
                            ),
                          ),
                          Expanded(
                            child: FloatingActionButton(
                              onPressed: () {
                                if (sets.length > 0) {
                                  Navigator.push(
                                    context,
                                      MaterialPageRoute(builder: (context) =>
                                          CountdownTimer(sets: sets))
                                  );
                                }
                              },
                              child: const Icon(Icons.play_arrow),
                              backgroundColor: Colors.black,
                            ),
                          )
                        ],
                    ),
                    padding: EdgeInsets.only(top: 15, bottom: 25),
                  ),
                  Column(
                    children: <Widget> [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                                'YOUR TIMINGS:',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontFamily: 'Montserrat')
                            ),
                          ]
                      ),
                      Container(
                        height: 230,
                        child: ListView.separated(
                          padding: const EdgeInsets.all(8),
                          itemCount: sets.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              child: Center(
                                  child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget> [
                                        Text('Round ${index + 1} / ', style: TextStyle(fontFamily: 'Montserrat')),
                                        Text('Exercise: ${sets[index]["exercise"]} / ', style: TextStyle(fontFamily: 'Montserrat')),
                                        Text('Rest: ${sets[index]["rest"]}', style: TextStyle(fontFamily: 'Montserrat')),
                                        IconButton(
                                          icon: const Icon(Icons.cancel),
                                          color: Colors.black,
                                          hoverColor: Colors.transparent,
                                          padding: EdgeInsets.symmetric(horizontal: 25),
                                          onPressed: () {
                                            _removeSet(index);
                                          },
                                        ),
                                      ]
                                  )
                              ),
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) => const Divider(),
                        )
                      )
                    ],
                  )
                ]
            )
        )
    );
  }
}


class CountdownTimer extends StatefulWidget {
  CountdownTimer({Key key, @required this.sets}) : super(key: key);
  final List sets;

  @override
  _CountdownTimerState createState() => _CountdownTimerState();
}


class _CountdownTimerState extends State<CountdownTimer> with TickerProviderStateMixin {
  AnimationController controller;

  bool isPlaying = true;

  String get timerString {
    Duration duration = controller.duration * controller.value;
    return '${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  @override
  void initState() {
    super.initState();
    List time = widget.sets[0]["exercise"].split(":");
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: int.parse(time[0]) * 60 + int.parse(time[1])),
    );
    controller.reverse(from: 1.0);
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = ThemeData(
      canvasColor: Colors.white,
      iconTheme: IconThemeData(
        color: Colors.black,
      ),
      accentColor: Colors.black,
      brightness: Brightness.dark,
      indicatorColor: Colors.black
    );
    return Scaffold(
      appBar: AppBar(
          iconTheme: IconThemeData(
              color: Colors.black
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          title: Text(
            "Dumb Timer",
            style: TextStyle(color: Colors.black, fontFamily: 'IndieFlower', fontSize: 24),
          )
      ),
      body: Padding(
        padding: EdgeInsets.all(25.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Align(
                alignment: FractionalOffset.center,
                child: AspectRatio(
                  aspectRatio: 1.0,
                  child: Stack(
                    children: <Widget>[
                      Positioned.fill(
                        child: AnimatedBuilder(
                          animation: controller,
                          builder: (BuildContext context, Widget child) {
                            return CustomPaint(
                                painter: TimerPainter(
                                  animation: controller,
                                  backgroundColor: Colors.white,
                                  color: themeData.indicatorColor,
                                ));
                          },
                        ),
                      ),
                      Align(
                        alignment: FractionalOffset.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            AnimatedBuilder(
                                animation: controller,
                                builder: (BuildContext context, Widget child) {
                                  return Text(
                                    timerString,
                                    style: TextStyle(fontSize: 100),
                                  );
                                }),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  FloatingActionButton(
                    child: AnimatedBuilder(
                      animation: controller,
                      builder: (BuildContext context, Widget child) {
                        return Icon(isPlaying
                        ? Icons.pause
                        : Icons.play_arrow);
                      },
                    ),
                    backgroundColor: Colors.black,
                    onPressed: () {
                      setState(() => isPlaying = !isPlaying);
                      if (controller.isAnimating) {
                        controller.stop(canceled: true);
                      } else {
                        controller.reverse(
                            from: controller.value == 0.0
                                ? 1.0
                                : controller.value);
                      }
                    },
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class TimerPainter extends CustomPainter {
  TimerPainter({
    this.animation,
    this.backgroundColor,
    this.color,
  }) : super(repaint: animation);

  final Animation<double> animation;
  final Color backgroundColor, color;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = backgroundColor
      ..strokeWidth = 5.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(size.center(Offset.zero), size.width / 2.0, paint);
    paint.color = color;
    double progress = (1.0 - animation.value) * 2 * math.pi;
    canvas.drawArc(Offset.zero & size, math.pi * 1.5, -progress, false, paint);
  }

  @override
  bool shouldRepaint(TimerPainter old) {
    return animation.value != old.animation.value ||
        color != old.color ||
        backgroundColor != old.backgroundColor;
  }
}