import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/pages/account/widgets/account_status_title_text.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AccountActionTile extends StatelessWidget {
  const AccountActionTile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocSelector<AccountCubit, AccountState,
        MyAccountStatusNotification>(
      selector: (state) => state.status,
      builder: (context, state) {
        return Offstage(
          offstage: state.type == MyAccountStatusNotificationType.offstage,
          child: _AccountActionTile(status: state),
        );
      },
    );
  }
}

class _AccountActionTile extends StatelessWidget {
  final MyAccountStatusNotification status;

  const _AccountActionTile({
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: status.type.backgroundColor(context),
      borderRadius: BorderRadius.circular(8),
      textStyle: context.textTheme.labelLarge?.copyWith(
        color: status.type.foregroundColor(context),
      ),
      child: IconTheme(
        data: IconThemeData(
          size: 18,
          color: status.type.foregroundColor(context),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  status.icon.buildIcon(),
                  const SizedBox(width: 8),
                  Expanded(child: AccountStatusTitleText(data: status)),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                child: Text(status.message(context)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
