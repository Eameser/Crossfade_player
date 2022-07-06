import 'dart:async';
//import 'dart:html';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
//import 'package:open_file/open_file.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _isPlaying = false;
  bool _isPlaying1 = false;
  bool _isPlaying2 = false;
  bool _stopped1 = false;
  bool _stopped2 = false;
  Duration duration1 = Duration.zero;
  Duration position1 = Duration.zero;
  Duration duration2 = Duration.zero;
  Duration position2 = Duration.zero;
  Duration crossfade = Duration.zero;

  var speedDialDirection = SpeedDialDirection.up;
  String? track_1_1 = "Track 1";
  String? track_1_2 = "Track 2";
  String? buffer1 = "Track ";
  String? track_2_1 = "Track 1";
  String? track_2_2 = "Track 2";
  String? buffer2 = "Track ";

  AudioPlayer audioPlayer1 = AudioPlayer();
  AudioPlayerState audioPlayer1State = AudioPlayerState.PAUSED;
  //late AudioCache audioCache;
  AudioPlayer audioPlayer2 = AudioPlayer();
  AudioPlayerState audioPlayer2State = AudioPlayerState.PAUSED;

  //String? bufferPath = '';
  String? path11 = '1.mp3';
  String? path12 = '2.mp3';
  String? path21 = '1.mp3';
  String? path22 = '2.mp3';

  double _currentValue = 0;
  int _currentDisplayValue = 0;

  void initState() {
    super.initState();
    audioPlayer1.onAudioPositionChanged.listen((newPosition) {
      setState(() {
        position1 = newPosition;
      });
    });

    audioPlayer2.onAudioPositionChanged.listen((newPosition) {
      setState(() {
        position2 = newPosition;
      });
    });

    audioPlayer1.onPlayerStateChanged.listen((event) {
      setState(() {
        _isPlaying1 = event == PlayerState.play;
      });
    });

    audioPlayer1.onPlayerCompletion.listen((event) {
      setState(() {
        position1 = duration1;
        //position2 = Duration.zero;
        position2 = Duration.zero;
      });
      resumeAudio();
    });

    audioPlayer2.onPlayerCompletion.listen((event) {
      setState(() {
        position2= duration2;
        //position1 = Duration.zero;
        position1 = Duration.zero;
      });
      resumeAudio();
    });

    audioPlayer2.onPlayerStateChanged.listen((event) {
      setState(() {
        _isPlaying2 = event == PlayerState.play;
      });
    });

    audioPlayer1.onDurationChanged.listen((newDuration) {
      setState(() {
        duration1 = newDuration;
      });
    });

    audioPlayer2.onDurationChanged.listen((newDuration) {
      setState(() {
        duration2 = newDuration;
      });
    });

    audioPlayer1.onAudioPositionChanged.listen((newPosition) {
      setState(() {
        position1 = newPosition;
      });
    });

    audioPlayer2.onAudioPositionChanged.listen((newPosition) {
      setState(() {
        position2 = newPosition;
      });
    });
  }
  @override
  void dispose() {
    super.dispose();
    audioPlayer1.release();
    audioPlayer1.dispose();
    //audioCache.clearCache();
  }
  /*playLocal(path) async {
    await audioPlayer.play(path, isLocal: true);
    //audioPlayer.setUrl(path, isLocal: true);
  }*/

  pauseAudio() async {
    await audioPlayer1.pause();
    await audioPlayer2.pause();
  }

  resumeAudio() async {
    final split1 = duration1 - crossfade;
    final split2 = duration2 - crossfade;

    for (; ;) {
      if (position2 > split2 || position1 < split1) {
        await audioPlayer1.resume();
        //audioPlayer2.setVolume(1.0 - 0.0);
      }
      if (position1 > split1) {
        await audioPlayer2.resume();
        //audioPlayer1.setVolume(1.0 - 0.0);
      }
    }

    /*if (position1 >= split1) {
      await audioPlayer2.resume();
      //await audioPlayer2.seek(position2);
      print(position1);
      print(position2);
    }
    if (position1 != duration1 || position2 >= split1){
      //await audioPlayer1.seek(position1);
      await audioPlayer1.resume();
      print(position1);
      print(position2);
      print(crossfade);
    }*/
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      /*appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text('Crossfade player'),
        backgroundColor: Colors.lightGreen,
      ),*/
      body: Column(
        //mainAxisAlignment: MainAxisAlignment.center,
        //mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            height: 650,
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(20),
                bottomLeft: Radius.circular(20),
              ),
            ),
          ),
          Row(
            children: [
              Container(
                  padding: EdgeInsets.fromLTRB(0, 20, 0, 10),
                  height: 150,
                  width: 150,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      //fixedSize: Size(45,50),
                      primary: Colors.transparent,
                      shadowColor: Colors.transparent,
                      //onPrimary: Colors.indigo.shade100,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    child: SpeedDial(
                      //buttonSize: Size(40, 40),
                      label: Text(buffer1!,
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          )),
                      backgroundColor: Colors.lightGreen,
                      direction: speedDialDirection,
                      switchLabelPosition: true,
                      children: [
                        SpeedDialChild(
                          child: Text('1'),
                          onTap: changeTo11,
                        ),
                        SpeedDialChild(
                          child: Text('2'),
                          onTap: changeTo12,
                        ),
                        /*SpeedDialChild(
                          child: Text('3'),
                          onTap: () {},
                        ),*/
                      ],
                    ),
                  )
              ),
              Spacer(),
              Container(
                padding: EdgeInsets.fromLTRB(0, 20, 0, 10),
                height: 100,
                width: 75,
                child: ElevatedButton(
                  onPressed: () async {
                    if (_isPlaying == true) {
                      pauseAudio();
                      audioPlayer1State = AudioPlayerState.PAUSED;
                      setState(() {
                        _isPlaying = false;
                      });
                    } else {
                      resumeAudio();
                      audioPlayer1State = AudioPlayerState.PLAYING;
                      setState(() {
                        _isPlaying = true;
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      primary: Colors.lightGreen,
                      //onPrimary: Colors.indigo.shade100,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      )),
                  //child: Text('PLAY'),
                  child: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
                ),
              ),
              Spacer(),
              Container(
                  padding: EdgeInsets.fromLTRB(0, 20, 0, 10),
                  height: 150,
                  width: 150,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      //fixedSize: Size(45,50),
                      primary: Colors.transparent,
                      shadowColor: Colors.transparent,
                      //onPrimary: Colors.indigo.shade100,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    child: SpeedDial(
                      //buttonSize: Size(40, 40),
                      label: Text(buffer2!,
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          )),
                      backgroundColor: Colors.lightGreen,
                      direction: speedDialDirection,
                      switchLabelPosition: true,
                      children: [
                        SpeedDialChild(
                          child: Text('1'),
                          onTap: changeTo21,
                        ),
                        SpeedDialChild(
                          child: Text('2'),
                          onTap: changeTo22,
                        ),
                        /*SpeedDialChild(
                          child: Text('3'),
                          onTap: () {},
                        ),*/
                      ],
                    ),
                  )
              ),
            ],
          ),
          Slider(
              value: _currentValue,
              min: 0,
              max: 10,
              divisions: 8, //yes
              label: _currentDisplayValue.toString(),
              activeColor: Colors.lightGreen,
              inactiveColor: Colors.black26,
              onChanged: (value) {
                setState(() => _currentValue = value);
                _currentDisplayValue = (_currentValue/1.25 + 2).toInt();
                crossfade = Duration(seconds: _currentDisplayValue);
                //print(crossfade);
              }
          )
        ],
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void changeAudio1() {
    for (Duration i = crossfade; i < duration1;) {
      audioPlayer1.setVolume(1.0 - 0.0);
    }
  }

  Future setAudio1(path) async {
    //audioPlayer1.setReleaseMode(ReleaseMode.LOOP);
      final player = AudioCache(prefix: 'assets/');
      final url = await player.load(path);
      audioPlayer1.setUrl(url.path, isLocal: true);
      //position1 = crossfade + position1;
      /*final result = await FilePicker.platform.pickFiles();
    if (result != null){
      final file = File(result.files.single.path);
      audioPlayer.setUrl(file.path, isLocal: true);
  }*/

  }

  Future setAudio2(path) async {
    //audioPlayer2.setReleaseMode(ReleaseMode.LOOP);
    final player = AudioCache(prefix: 'assets/');
    final url = await player.load(path);
    audioPlayer2.setUrl(url.path, isLocal: true);
  }

  void changeTo11() async {
    buffer1 = track_1_1;
    setAudio1(path11);
  }

  void changeTo12() {
    buffer1 = track_1_2;
    setAudio1(path12);
  }

  void changeTo21() {
    buffer2 = track_2_1;
    setAudio2(path21);
  }

  void changeTo22() {
    buffer2 = track_2_2;
    setAudio2(path22);
  }
}
