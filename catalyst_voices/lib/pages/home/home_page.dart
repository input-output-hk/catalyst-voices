import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SizedBox(
        height: 460,
        width: 480,
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: TextField(
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    onChanged: print,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

final class HomePage extends StatelessWidget {
  static const homePageKey = Key('HomePage');

  static const loginFormKey = Key('LoginForm');
  static const loginErrorSnackbarKey = Key('LoginErrorSnackbar');

  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Home(),
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
