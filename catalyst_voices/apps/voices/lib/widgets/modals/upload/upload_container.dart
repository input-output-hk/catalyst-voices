import 'package:catalyst_voices/dependency/dependencies.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:cross_file/cross_file.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';

class UploadContainer extends StatefulWidget {
  final String itemNameToUpload;
  final String? info;
  final List<String>? allowedExtensions;
  final ValueChanged<XFile>? onFileSelected;

  const UploadContainer({
    super.key,
    required this.itemNameToUpload,
    this.info,
    this.allowedExtensions,
    this.onFileSelected,
  });

  @override
  State<UploadContainer> createState() => _UploadContainerState();
}

class _UploadContainerState extends State<UploadContainer> {
  DropzoneViewController? _dropzoneController;

  @override
  Widget build(BuildContext context) {
    return DottedBorder(
      options: RoundedRectDottedBorderOptions(
        radius: const Radius.circular(12),
        dashPattern: const [8, 6],
        color: Theme.of(context).colors.iconsPrimary,
      ),
      child: Stack(
        fit: StackFit.expand,
        alignment: Alignment.center,
        children: [
          // We allow drag&drop only on web
          if (CatalystPlatform.isWeb)
            DropzoneView(
              operation: DragOperation.copy,
              cursor: CursorType.grab,
              onCreated: (ctrl) {
                _dropzoneController = ctrl;
              },
              onDropFile: widget.onFileSelected != null ? _pickDroppedFile : null,
            ),
          InkWell(
            onTap: _pickFileUpload,
            child: Wrap(
              direction: Axis.vertical,
              alignment: WrapAlignment.center,
              runAlignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 12,
              children: [
                const _UploadIcon(),
                _UploadText(nameToUpload: widget.itemNameToUpload),
                if (widget.info case final value?) _UploadInfoText(value),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickDroppedFile(DropzoneFileInterface file) async {
    final controller = _dropzoneController;
    final onFileSelected = widget.onFileSelected;
    if (controller == null || onFileSelected == null) {
      return;
    }

    final bytes = await controller.getFileData(file);
    final name = await controller.getFilename(file);
    final xFile = XFile.fromData(bytes, name: name);

    onFileSelected(xFile);
  }

  Future<void> _pickFileUpload() async {
    final service = Dependencies.instance.get<UploaderService>();
    final pickedFile = await service.uploadFile(allowedExtensions: widget.allowedExtensions);
    if (pickedFile == null || !mounted) {
      return;
    }

    widget.onFileSelected?.call(pickedFile);
  }
}

class _UploadIcon extends StatelessWidget {
  const _UploadIcon();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colors;

    return Container(
      width: 80,
      height: 80,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: colors.iconsPrimary, width: 3),
      ),
      child: VoicesAssets.icons.upload.buildIcon(color: colors.iconsPrimary),
    );
  }
}

class _UploadInfoText extends StatelessWidget {
  final String data;

  const _UploadInfoText(this.data);

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      style: Theme.of(context).textTheme.bodyMedium,
    );
  }
}

class _UploadText extends StatelessWidget {
  final String nameToUpload;

  const _UploadText({
    required this.nameToUpload,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: context.l10n.uploadDropInfo(nameToUpload),
        style: Theme.of(context).textTheme.titleSmall,
        children: <TextSpan>[
          TextSpan(
            text: context.l10n.browse,
            style: TextStyle(
              color: Theme.of(context).colors.iconsPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
