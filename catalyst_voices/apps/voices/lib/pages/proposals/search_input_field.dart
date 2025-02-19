import 'dart:async';

import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchInputField extends StatefulWidget {
  const SearchInputField({
    super.key,
  });

  @override
  State<SearchInputField> createState() => _SearchInputFieldState();
}

class _SearchInputFieldState extends State<SearchInputField> {
  late final ProposalsCubit _proposalsCubit;
  late final TextEditingController _controller;
  Timer? _debounce;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250,
      child: VoicesTextField(
        controller: _controller,
        onFieldSubmitted: (_) {},
        decoration: VoicesTextFieldDecoration(
          prefixIcon: VoicesAssets.icons.search.buildIcon(),
          hintText: context.l10n.searchProposals,
          filled: true,
          fillColor: context.colors.elevationsOnSurfaceNeutralLv1White,
          borderRadius: BorderRadius.circular(8),
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: context.colors.outlineBorderVariant,
            ),
          ),
          suffixIcon: ValueListenableBuilder<TextEditingValue>(
            valueListenable: _controller,
            builder: (context, value, child) {
              return Offstage(
                offstage: value.text.isEmpty,
                child: VoicesTextButton(
                  onTap: _clearTextFiled,
                  style: TextButton.styleFrom(
                    foregroundColor: context.colors.textOnPrimaryLevel0,
                  ),
                  child: Text(context.l10n.reset),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _debounce?.cancel();
    _debounce = null;
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _proposalsCubit = context.read<ProposalsCubit>();
    _controller = TextEditingController();
    _controller.addListener(_onSearchChanged);
  }

  void _clearTextFiled() {
    _controller.clear();
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) {
      _debounce?.cancel();
    }
    _debounce = Timer(const Duration(milliseconds: 300), () {
      _proposalsCubit.changeSearchValue(_controller.text);
    });
  }
}
