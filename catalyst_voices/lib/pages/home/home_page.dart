import 'package:flutter/material.dart';

final class HomePage extends StatelessWidget {
  static const homePageKey = Key('HomePage');

  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      key: homePageKey,
      body: Stack(),
    );
  }
}


// final class HomePage extends StatelessWidget {
//   static const homePageKey = Key('HomePage');

//   const HomePage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       key: homePageKey,
//       body: Stack(
//         children: [
//           Container(
//             width: double.infinity,
//             height: MediaQuery.of(context).size.height,
//             decoration: const BoxDecoration(
//               gradient: LinearGradient(
//                 begin: Alignment(0.8, 0.5),
//                 end: Alignment.center,
//                 colors: [
//                   Color(0xFF276CE7),
//                   Color(0xFF123cd3),
//                 ],
//               ),
//             ),
//           ),
//           const Padding(
//             padding: EdgeInsets.only(top: 160, left: 130),
//             child: Text(
//               'Impactful Projects',
//               style: TextStyle(
//                 color: VoicesColors.white,
//                 fontFamily: VoicesFonts.sFPro,
//                 fontSize: 72,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//           ),
//           // SizedBox(
//           //   height: 200,
//           //   width: 200,
//           //   child: CatalystImage.asset(
//           //     VoicesAssets.images.dummyCatalystVoices.path,
//           //   ),
//           // ),
//         ],
//       ),
//     );
//   }
// }
