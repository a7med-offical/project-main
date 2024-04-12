// import 'package:awesome_dialog/awesome_dialog.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';

// class InfoView extends StatefulWidget {
//   const InfoView({super.key});
//   @override
//   State<InfoView> createState() => _InfoViewState();
// }
// class _InfoViewState extends State<InfoView> {
 
//   // getRequest() async {
//   //   FirebaseMessaging messaging = FirebaseMessaging.instance;

//   //   NotificationSettings settings = await messaging.requestPermission(
//   //     alert: true,
//   //     announcement: false,
//   //     badge: true,
//   //     carPlay: false,
//   //     criticalAlert: false,
//   //     provisional: false,
//   //     sound: true,
//   //   );

//   //   if (settings.authorizationStatus == AuthorizationStatus.authorized) {
//   //     print('User granted permission');
//   //   } else if (settings.authorizationStatus ==
//   //       AuthorizationStatus.provisional) {
//   //     print('User granted provisional permission');
//   //   } else {
//   //     print('User declined or has not accepted permission');
//   //   }
//   // }

//   void initState() {
   
//     getMyToken();
//     getRequest();
    
//     super.initState();
//   }

//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: [
//           Center(child: Text('Info Screen')),
//           MaterialButton(
//             onPressed: () async {
//               await sendNotification(title: 'Ahmeh', bode: 'tanea');
//             },
//             child: Text('Send'),
//           )
//         ],
//       ),
//     );
//   }
// }