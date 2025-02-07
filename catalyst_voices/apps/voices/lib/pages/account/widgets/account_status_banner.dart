import 'package:catalyst_voices/pages/account/widgets/account_status_title_text.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AccountStatusBanner extends StatelessWidget {
  const AccountStatusBanner({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocSelector<AccountCubit, AccountState,
        MyAccountStatusNotification>(
      selector: (state) => state.status,
      builder: (context, state) => _AccountStatusBanner(status: state),
    );
  }
}

class _AccountStatusBanner extends StatefulWidget {
  final MyAccountStatusNotification status;

  const _AccountStatusBanner({
    required this.status,
  });

  @override
  State<_AccountStatusBanner> createState() => _AccountStatusBannerState();
}

class _AccountStatusBannerState extends State<_AccountStatusBanner> {
  late bool _offstage;

  @override
  void initState() {
    super.initState();
    _offstage = _isStatusTypeOffstage();
  }

  @override
  void didUpdateWidget(_AccountStatusBanner oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.status != oldWidget.status) {
      _offstage = _isStatusTypeOffstage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Offstage(
      offstage: _offstage,
      child: Material(
        color: widget.status.type.backgroundColor(context),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
          child: IconTheme(
            data: IconThemeData(
              size: 18,
              color: widget.status.type.foregroundColor(context),
            ),
            child: Row(
              children: [
                widget.status.icon.buildIcon(),
                Expanded(child: AccountStatusTitleText(data: widget.status)),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: _onDismissTap,
                  child: VoicesAssets.icons.x.buildIcon(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onDismissTap() {
    setState(() {
      _offstage = true;
    });
  }

  bool _isStatusTypeOffstage() {
    return widget.status.type == MyAccountStatusNotificationType.offstage;
  }
}
