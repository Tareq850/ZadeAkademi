/*import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zego_uikit/zego_uikit.dart';
import 'package:zego_uikit_prebuilt_video_conference/zego_uikit_prebuilt_video_conference.dart';
import 'abacus.dart';
import 'draw.dart';
import 'package:file_picker/file_picker.dart';
import 'package:open_app_file/open_app_file.dart';
import 'package:ed_screen_recorder/ed_screen_recorder.dart';
import 'package:easy_pdf_viewer/easy_pdf_viewer.dart';
class VideoConferencePage extends StatefulWidget {
  final conferenceID;
  final user;
  final id;
  final course_id;
  const VideoConferencePage(this.conferenceID, this.user, this.id, this.course_id, {Key? key})
      : super(key: key);
  @override
  State<VideoConferencePage> createState() => VideoConferencePageState();
}
class VideoConferencePageState extends State<VideoConferencePage> {
  List<IconData> customIcons = [
    Icons.phone,
    Icons.draw_outlined,
    Icons.videogame_asset_sharp,
    Icons.emergency_recording,
    Icons.file_open,
  ];
  late PDFDocument document;
  String filePath = '';
  Future Files() async{
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      PlatformFile file = result.files.first;
      setState(() async {
        String? filePath = file.path;
        document = await PDFDocument.fromAsset(filePath!);
        await OpenAppFile.open(filePath);
      });
      print(file.path);
    } else {
      // User canceled the picker
    }
  }
  bool isFullscreen = true;
  var _response;
  // use this to control whether to call the method to enable full-screen mode.
  ZegoUIKitPrebuiltVideoConferenceController controller =
  ZegoUIKitPrebuiltVideoConferenceController();


  @override
  void initState() {
    super.initState();
  }
  Future<void> startRecord({required String fileName}) async {
     Directory? tempDir = await getApplicationSupportDirectory();
     String tempPath = tempDir.path;
     try{
       print(tempPath);
       print(".....................................................00000626.............");
       var startrecord = await EdScreenRecorder().startRecordScreen(fileExtension: "mp4",
           fileName: fileName, audioEnable: true,dirPathToSave: tempPath,  videoBitrate: 10, addTimeCode: true);
       setState(() {
         _response = startrecord;
       });
     }on PlatformException {
       print("......................................................525626.............");
     }

  }
  Future<void> stopRecord() async {
    try{
      print(".......0000000000000.................................525626.............");
      print(_response);
      var stopResponse = await EdScreenRecorder().stopRecord();

      setState(() {
        _response = stopResponse;
      });
    }on PlatformException {
      print("Error: An error occurred while stopping recording.......................");
    }
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ZegoUIKitPrebuiltVideoConference(
        appID: 454540219, // Fill in the appID that you get from ZEGOCLOUD Admin Console.
        appSign: "c329bbbcd8db9dd6d6e3a48584eb344ee4f9cc04dc67c139369251f5ad0be412", // Fill in the appSign that you get from ZEGOCLOUD Admin Console.
        userID: widget.id.toString(),
        userName: widget.user['name'].toString(),
        conferenceID: widget.course_id.toString(),
        config: (
            ZegoUIKitPrebuiltVideoConferenceConfig()
          ..onLeaveConfirmation = (BuildContext context) async {
            return await showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return Directionality(
                    textDirection: TextDirection.rtl,
                    child: AlertDialog(
                      backgroundColor: Colors.green[900]!.withOpacity(0.9),
                      title: const Text("مغادرة الجلسة",
                          style: TextStyle(color: Colors.white70)),
                      content: const Text(
                          "أنت على وشك مغادرة الجلسة!",
                          style: TextStyle(color: Colors.white70)),
                      actions: [
                        ElevatedButton(
                          child: const Text("تراجع",
                              style: TextStyle(color: Colors.red)),
                          onPressed: () => Navigator.of(context).pop(false),
                        ),
                        ElevatedButton(
                          child: const Text("تأكيد"),
                          onPressed: () => Navigator.of(context).pop(true),
                        ),
                      ],
                    ),
                  );
                });}
          ..audioVideoViewConfig.foregroundBuilder =
              (context, size, user, extraInfo) {
            // Here is the full-screen mode button.
            return Container(
              child: OutlinedButton(
                  onPressed: () {
                    isFullscreen = !isFullscreen;
                    controller.showScreenSharingViewInFullscreenMode(
                        user?.id ?? '',
                        isFullscreen); // Call this to decide whether to show the shared screen in full-screen mode.
                  },
                  child: const Text("")),
            );
          }

          ..layout = (ZegoLayout.gallery(
              addBorderRadiusAndSpacingBetweenView: true,
              showScreenSharingFullscreenModeToggleButtonRules:
              ZegoShowFullscreenModeToggleButtonRules.alwaysShow,
              showNewScreenSharingViewInFullscreenMode: false,
          ))// Set the layout to gallery mode. and configure the [showNewScreenSharingViewInFullscreenMode] and [showScreenSharingFullscreenModeToggleButtonRules].
          ..bottomMenuBarConfig = (ZegoBottomMenuBarConfig(
              extendButtons: [
               /* ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(40, 40), backgroundColor: const Color(0xffffffff).withOpacity(0.6),
                    shape: const CircleBorder(),
                  ),
                  onPressed: () {
                      startRecord(fileName: "eren");
                  },
                  child: Icon(customIcons[0]),
                ),*/
                /*ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(40, 40), backgroundColor: const Color(0xffffffff).withOpacity(0.6),
                    shape: const CircleBorder(),
                  ),
                  onPressed: () {
                    stopRecord();
                  },
                  child: Icon(customIcons[6]),
                ),*/
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(40, 40), backgroundColor: const Color(0xffffffff).withOpacity(0.6),
                    shape: const CircleBorder(),
                  ),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context){
                      return DrawingPage();
                    }));
                  },
                  child: Icon(customIcons[1]),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(40, 40), backgroundColor: const Color(0xffffffff).withOpacity(0.6),
                    shape: const CircleBorder(),
                  ),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context){
                      return Abacus();
                    }));
                  },
                  child: Icon(customIcons[2]),
                ),

                ElevatedButton(
                  onPressed: () {
                    Files();
                  },
                  child: Icon(customIcons[4]),
                ),
              ],
              buttons: [
                ZegoMenuBarButtonName.leaveButton,
                ZegoMenuBarButtonName.toggleCameraButton,
                ZegoMenuBarButtonName.toggleMicrophoneButton,
                ZegoMenuBarButtonName.chatButton,
                ZegoMenuBarButtonName.switchCameraButton,
                ZegoMenuBarButtonName.switchAudioOutputButton,

              ])..backgroundColor = Color(0xff00521e)
          )
                ..topMenuBarConfig = (
                    ZegoTopMenuBarConfig()
                      ..backgroundColor = Color(0xff00521e)
            )
            ..memberListConfig = ZegoMemberListConfig(
              showMicrophoneState: true,
              showCameraState: true,)

            // Add a screen sharing toggle button.
            ..notificationViewConfig = ZegoInRoomNotificationViewConfig(notifyUserLeave: true, userJoinItemBuilder: (context, user, extraInfo) => Container(color: Colors.green,child: Text('${widget.user['name']} انضم للجلسة ', style: TextStyle(color: Colors.white),)), userLeaveItemBuilder: (context, user, extraInfo) => Container(color: Colors.red,child: Text('${widget.user['name']} غادر الجلسة ', style: TextStyle(color: Colors.white),)),itemBuilder: (context, message, extraInfo) => Container(color: Colors.green,child: Text('${widget.user['status']}', style: TextStyle(color: Colors.white),)),)
            ..rootNavigator = false
            ..useSpeakerWhenJoining = true
            ..turnOnMicrophoneWhenJoining = false
            ..turnOnCameraWhenJoining = false
        ),
      ),

    );
  }
}*/
/*AlertDialog(
backgroundColor: Color(0xff01953D),
title: const Text("مغادرة الجلسة",
style: TextStyle(color: Colors.white)),
content: const Text(
"هل أنت متأكد من رغبتك في مغادرة الجلسة؟",
style: TextStyle(color: Colors.white)),
actions: [
ElevatedButton(
child: const Text("تراجع",),
onPressed: () => Navigator.of(context).pop(false),
),
ElevatedButton(
child: const Text("تأكيد"),
onPressed: () => Navigator.of(context).pop(true),
),
],
),*/
/*turnOnCameraWhenJoining: false,
turnOnMicrophoneWhenJoining: false,
useSpeakerWhenJoining: true,*/
/*bottomMenuBarConfig: ZegoBottomMenuBarConfig(

maxCount: 5,
extendButtons: [
ElevatedButton(
style: ElevatedButton.styleFrom(
fixedSize: const Size(60, 60), backgroundColor: const Color(0xffffffff).withOpacity(0.6),
shape: const CircleBorder(),
),
onPressed: () {
Navigator.of(context).push(MaterialPageRoute(builder: (context){
return DrawingPage();
}));
},
child: Icon(customIcons[1]),
),
ElevatedButton(
style: ElevatedButton.styleFrom(
fixedSize: const Size(60, 60), backgroundColor: const Color(0xffffffff).withOpacity(0.6),
shape: const CircleBorder(),
),
onPressed: () {
Navigator.of(context).push(MaterialPageRoute(builder: (context){
return Abacus();
}));
},
child: Icon(customIcons[2]),
),

ElevatedButton(
onPressed: () {
zego.ZegoMediaPlayer(size: Size.square(20),canControl: true,isMovable: true,playIcon: Icon(customIcons[4]),filePathOrURL: "www.google.com",);
},
child: Icon(customIcons[4]),
),
],
buttons: [
ZegoMenuBarButtonName.toggleCameraButton,
ZegoMenuBarButtonName.toggleMicrophoneButton,
ZegoMenuBarButtonName.switchAudioOutputButton,
ZegoMenuBarButtonName.leaveButton,
ZegoMenuBarButtonName.switchCameraButton,
ZegoMenuBarButtonName.chatButton,
ZegoMenuBarButtonName.toggleScreenSharingButton,
],

),*/
/*class VideoConferencePageState extends State<VideoConferencePage> {
  /*final serverText = TextEditingController();
  final roomText = TextEditingController(text: "omni_room_sample_1234");
  final subjectText = TextEditingController(text: "Subject1");
  final nameText = TextEditingController(text: "User1");
  final emailText = TextEditingController(text: "fake1@email.com");
  final iosAppBarRGBAColor =
  TextEditingController(text: "#0080FF80"); //transparent blue
  bool? isAudioOnly = false;
  bool? isAudioMuted = false;
  bool? isVideoMuted = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _openDrawingPage() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return DrawingPage();
    }));
  }*/

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text('${widget.conferenceID['course_name']}'),
          backgroundColor: Theme.of(context).primaryColor,
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0, vertical: 20
          ),
          child: meetConfig(),
        ),
      ),
    );
  }

  Widget meetConfig() {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Row(
            children: [
              Expanded(
                flex: 2,
                child: SizedBox(
                  height: 64.0,
                  width: double.maxFinite,
                  child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateColor.resolveWith(
                                (states) => Theme.of(context).colorScheme.secondary)),
                    onPressed: _openDrawingPage,
                    child: Text(
                      'فتح لوحة الرسم',
                      style: TextStyle(color: Colors.white, fontSize: 17),
                    ),
                  ),
                ),
              ),
              const Expanded(flex: 1, child: SizedBox()),
              Expanded(
                flex: 2,
                child: SizedBox(
                  height: 64.0,
                  width: double.maxFinite,
                  child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateColor.resolveWith(
                                (states) => Theme.of(context).colorScheme.secondary)),
                    onPressed: (){Navigator.of(context).push(MaterialPageRoute(builder: (context){return Abacus();}));},
                    child: Text(
                      'فتح اباكوس',
                      style: TextStyle(color: Colors.white, fontSize: 17),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 50),
          SizedBox(
            height: 64.0,
            width: double.maxFinite,
            child: widget.user['type'] == 'طالب'
                ? ElevatedButton(
              onPressed: () {
                _startJitsiMeeting();
              },
              style: ButtonStyle(
                  backgroundColor: MaterialStateColor.resolveWith(
                          (states) => Theme.of(context).primaryColor)),
                  child: const Text(
                    "انضم الى الجلسة",
                    style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            )
                : ElevatedButton(
                    onPressed: () {
                     _joinMeeting();
                  },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateColor.resolveWith(
                          (states) => Theme.of(context).primaryColor)),
                    child: const Text(
                      "ابدأ الجلسة",
                      style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ),
          const SizedBox(
            height: 48.0,
          ),
        ],
      ),
    );
  }

  _joinMeeting() async {
    final String? serverUrl =
    serverText.text.trim().isEmpty ? null : serverText.text;
    Map<String, Object> featureFlags = {
      'add-people.enabled': true,
      'audio-focus.disabled': false,
      'calendar.enabled': true,
      'pip-while-screen-sharing.enabled': true,
      'pip.enabled': true,
      'recording.enabled': true,
      'start page.enabled' : true
    };

    Map<String, Object?> configOverrides = {
      // الأمور المتعلقة بواجهة المستخدم والأدوات
      'toolbarButtons': ['microphone', 'camera', 'tileview', 'fullscreen'],
      'overflowMenuButtons': ['chat', 'raisehand', 'participants', 'invite', 'settings', 'tileview', 'filmstrip'],
      'filmStripOnly': true,
      'disableInviteFunctions': true,
      'disableDeepLinking': true,

      // الأمور المتعلقة بالصوت والفيديو
      'startAudioMuted': 2, // 0: غير مكتوم, 1: مكتوم, 2: مكتوم افتراضيا
      'startVideoMuted': 2, // 0: غير مكتوم, 1: مكتوم, 2: مكتوم افتراضيا
      'startWithAudioMuted': true,
      'startWithVideoMuted': true,
      //'preferredVideoQuality': FeatureFlagVideoQuality.LOW,

      // الأمور المتعلقة بالشاشة المشتركة
      'desktopSharingFrameRate': 30,
      'desktopSharingScreen': 'screen',
      'desktopSharingSourceDevice': 'screen',

      // الأمور المتعلقة بالتسجيل والبث المباشر
      'liveStreamingEnabled': true,
      'fileRecordingsEnabled': true,
      'fileRecordingsServiceEnabled': true,
      'fileRecordingsServiceSharingEnabled': true,

      // الأمور المتعلقة بالترجمة واللغة
      'transcribingEnabled': true,
      'transcribingInterimResults': true,
      'transcribingLanguage': 'ar',
      'closeCaptionEnabled': true,
      'channelLastN': 4,

      // أمور متنوعة
      'disableJoinLeaveNotifications': false,
      'disableRemoteMute': false,
      'enableCalendarIntegration': true,
      'enableClosePage': false,
      'disableAutoFocus': false,
      'disableAudioLevels': false,
    };

    var options = JitsiMeetingOptions(
      roomNameOrUrl: widget.course_id,
      serverUrl: serverUrl,
      subject: widget.conferenceID['course_name'],
      //token: widget.user['token'],
      isAudioMuted: isAudioMuted,
      isAudioOnly: isAudioOnly,
      isVideoMuted: isVideoMuted,
      userDisplayName: widget.user['name'],
      userEmail: widget.user['email'],
      featureFlags: featureFlags,
      configOverrides: configOverrides,
    );

    await JitsiMeetWrapper.joinMeeting(
      options: options,
      listener: JitsiMeetingListener(
        onOpened: () => debugPrint("onOpened"),
        onConferenceWillJoin: (url) {
          debugPrint("onConferenceWillJoin: url: $url");
        },
        onConferenceJoined: (url) {
          debugPrint("onConferenceJoined: url: $url");
        },
        onConferenceTerminated: (url, error) {
          debugPrint("onConferenceTerminated: url: $url, error: $error");
        },
        onAudioMutedChanged: (isMuted) {
          debugPrint("onAudioMutedChanged: isMuted: $isMuted");
        },
        onVideoMutedChanged: (isMuted) {
          debugPrint("onVideoMutedChanged: isMuted: $isMuted");
        },
        onScreenShareToggled: (participantId, isSharing) {
          debugPrint(
            "onScreenShareToggled: participantId: $participantId, "
                "isSharing: $isSharing",
          );
        },
        onParticipantJoined: (email, name, role, participantId) {
          debugPrint(
            "onParticipantJoined: email: $email, name: $name, role: $role, "
                "participantId: $participantId",
          );
        },
        onParticipantLeft: (participantId) {
          debugPrint("onParticipantLeft: participantId: $participantId");
        },
        onParticipantsInfoRetrieved: (participantsInfo, requestId) {
          debugPrint(
            "onParticipantsInfoRetrieved: participantsInfo: $participantsInfo, "
                "requestId: $requestId",
          );
        },
        onChatMessageReceived: (senderId, message, isPrivate) {
          debugPrint(
            "onChatMessageReceived: senderId: $senderId, message: $message, "
                "isPrivate: $isPrivate",
          );
        },
        onChatToggled: (isOpen) => debugPrint("onChatToggled: isOpen: $isOpen"),
        onClosed: () => debugPrint("onClosed"),
      ),);
  }

  void _startJitsiMeeting() async {
    final String? serverUrl =
    serverText.text.trim().isEmpty ? null : serverText.text;
    Map<String, Object> featureFlags = {
      'add-people.enabled': false,
      'calendar.enabled': false,
      'filmstrip.enabled': false,
      'invite.enabled': false,
      'kick-out.enabled': false,
      'pip.enabled': true,
      'pip-while-screen-sharing.enabled': true,
    };
    Map<String, Object?> configOverrides = {
      // الأمور المتعلقة بواجهة المستخدم والأدوات
      'toolbarButtons': ['microphone', 'camera', 'tileview', 'fullscreen'],
      'overflowMenuButtons': ['chat', 'raisehand', 'participants', 'filmstrip'],
      'filmStripOnly': true,
      'disableInviteFunctions': true,
      'disableDeepLinking': true,

      // الأمور المتعلقة بالصوت والفيديو
      'startAudioMuted': 2, // 0: غير مكتوم, 1: مكتوم, 2: مكتوم افتراضيا
      'startVideoMuted': 2, // 0: غير مكتوم, 1: مكتوم, 2: مكتوم افتراضيا
      'startWithAudioMuted': true,
      'startWithVideoMuted': true,
      //'preferredVideoQuality': FeatureFlagVideoQuality.LOW,

      // الأمور المتعلقة بالشاشة المشتركة
      'desktopSharingFrameRate': 30,
      'desktopSharingScreen': 'screen',
      'desktopSharingSourceDevice': 'screen',

      // الأمور المتعلقة بالتسجيل والبث المباشر
      'liveStreamingEnabled': false,
      'fileRecordingsEnabled': false,
      'fileRecordingsServiceEnabled': false,
      'fileRecordingsServiceSharingEnabled': false,

      // الأمور المتعلقة بالترجمة واللغة
      'transcribingEnabled': true,
      'transcribingInterimResults': true,
      'transcribingLanguage': 'ar',
      'closeCaptionEnabled': true,
      'channelLastN': 4,

      // أمور متنوعة
      'disableJoinLeaveNotifications': false,
      'disableRemoteMute': false,
      'enableCalendarIntegration': false,
      'enableClosePage': false,
      'disableAutoFocus': false,
      'disableAudioLevels': false,
    };

    var options = JitsiMeetingOptions(
      roomNameOrUrl: widget.course_id,
      serverUrl: serverUrl,
      subject: widget.conferenceID['course_name'],
      //token: tokenText.text,
      isAudioMuted: isAudioMuted,
      isAudioOnly: isAudioOnly,
      isVideoMuted: isVideoMuted,
      userDisplayName: widget.user['name'],
      userEmail: widget.user['email'],
      featureFlags: featureFlags,
      configOverrides : configOverrides,
    );
    await JitsiMeetWrapper.joinMeeting(
      options: options,
      listener: JitsiMeetingListener(
        onOpened: () => debugPrint("onOpened"),
        onConferenceWillJoin: (url) {
          debugPrint("onConferenceWillJoin: url: $url");
        },
        onConferenceJoined: (url) {
          debugPrint("onConferenceJoined: url: $url");
        },
        onConferenceTerminated: (url, error) {
          debugPrint("onConferenceTerminated: url: $url, error: $error");
        },
        onAudioMutedChanged: (isMuted) {
          debugPrint("onAudioMutedChanged: isMuted: $isMuted");
        },
        onVideoMutedChanged: (isMuted) {
          debugPrint("onVideoMutedChanged: isMuted: $isMuted");
        },
        onScreenShareToggled: (participantId, isSharing) {
          debugPrint(
            "onScreenShareToggled: participantId: $participantId, "
                "isSharing: $isSharing",
          );
        },
        onParticipantJoined: (email, name, role, participantId) {
          debugPrint(
            "onParticipantJoined: email: $email, name: $name, role: طالب, "
                "participantId: $participantId",
          );
        },
        onParticipantLeft: (participantId) {
          debugPrint("onParticipantLeft: participantId: $participantId");
        },
        onParticipantsInfoRetrieved: (participantsInfo, requestId) {
          debugPrint(
            "onParticipantsInfoRetrieved: participantsInfo: $participantsInfo, "
                "requestId: $requestId",
          );
        },
        onChatMessageReceived: (senderId, message, isPrivate) {
          debugPrint(
            "onChatMessageReceived: senderId: $senderId, message: $message, "
                "isPrivate: $isPrivate",
          );
        },
        onChatToggled: (isOpen) => debugPrint("onChatToggled: isOpen: $isOpen"),
        onClosed: () => debugPrint("onClosed"),
      ),);
  }
}*/






