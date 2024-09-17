import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:flutter/material.dart';

class NoInternetConnectionBanner extends StatelessWidget {
  final VoidCallback onRefresh;

  const NoInternetConnectionBanner({
    Key? key,
    this.onRefresh = _noop,
  }) : super(key: key);

  static void _noop() {}

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: LayoutBuilder(
        builder: (context, constraints) {
          bool isButtonDisplay = constraints.maxWidth > 744;

          return Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            margin: EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: const Color(0xEEAD0000),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CatalystSvgIcon.asset(
                          VoicesAssets.icons.wifi.path,
                          color: Colors.white,
                        ),
                        SizedBox(width: 8),
                        Text(
                          constraints.maxWidth.toString(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'Your internet is playing hide and seek. Check your internet connection, or try again in a moment.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                isButtonDisplay ? SizedBox(height: 16) : Container(),
                isButtonDisplay
                    ? Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          VoicesTextButton(
                              onTap: this.onRefresh,
                              child: Text(
                                'Refresh',
                                style: TextStyle(color: Colors.white),
                              ))
                        ],
                      )
                    : Container()
              ],
            ),
          );
        },
      ),
    );
  }
}
