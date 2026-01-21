// import 'package:flutter/material.dart';
// import 'camera.dart';
// import 'contactList.dart';
// import 'maps.dart';
// import 'phoneNotes.dart';
//
// Navigation(context){
//   return Drawer(
//     child: ListView(
//       padding: EdgeInsets.zero,
//       children: <Widget>[
//         const DrawerHeader(
//           decoration: BoxDecoration(
//             color: Colors.deepPurple,
//           ),
//           child: Text('Navigation'),
//         ),
//         ListTile(
//           title: RichText(text:const TextSpan(children: [WidgetSpan(child: Icon(Icons.home)),WidgetSpan(child: Text("Home"))])),
//           onTap: () {
//             Navigator.pop(context);
//             Navigator.pop(context);
//           },
//         ),
//         ListTile(
//           title: RichText(text:const TextSpan(children: [WidgetSpan(child: Icon(Icons.contact_mail_outlined)),WidgetSpan(child: Text("Contact List"))])),
//           onTap: () {
//             Navigator.pop(context);
//             Navigator.pop(context);
//             Navigator.push(context, MaterialPageRoute(builder: (context) => const ContactListApp(title: 'Contact List Application')));
//           },
//         ),
//         ListTile(
//           title: RichText(text:const TextSpan(children: [WidgetSpan(child: Icon(Icons.camera_alt)),WidgetSpan(child: Text("Camera"))])),
//           onTap: () {
//             Navigator.pop(context);
//             Navigator.pop(context);
//             Navigator.push(context, MaterialPageRoute(builder: (context) => const CameraApp(title: "Camera Application")));
//           },
//         ),
//         ListTile(
//           title: RichText(text:const TextSpan(children: [WidgetSpan(child: Icon(Icons.phone)),WidgetSpan(child: Text("Phone Notes"))])),
//           onTap: () {
//             Navigator.pop(context);
//             Navigator.pop(context);
//             Navigator.push(context, MaterialPageRoute(builder: (context) => const PhoneNotes(title: "Phone Notes")));
//           },
//         ),
//         ListTile(
//           title: RichText(text:const TextSpan(children: [WidgetSpan(child: Icon(Icons.map_sharp)),WidgetSpan(child: Text("Technical Magic Locations"))])),
//           onTap: () {
//             Navigator.pop(context);
//             Navigator.pop(context);
//             Navigator.push(context, MaterialPageRoute(builder: (context) => const Maps(title: 'Technical Magic Locations')));
//           },
//         ),
//       ],
//     ),
//   );
// }