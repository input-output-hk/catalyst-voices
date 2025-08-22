import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:flutter/material.dart';

class VoicesRadioExample extends StatefulWidget {
  static const String route = '/radio-example';

  const VoicesRadioExample({super.key});

  @override
  State<VoicesRadioExample> createState() => _VoicesRadioExampleState();
}

enum _Type {
  one,
  two,
  three,
  four,
  five;

  ({String? label, String? note}) get labelNote {
    return switch (this) {
      _Type.one => (label: name, note: 'Public'),
      _Type.two => (label: name, note: 'Private'),
      _Type.three => (label: name, note: 'Toggle'),
      _Type.four => (label: null, note: null),
      _Type.five => (label: name, note: null),
    };
  }
}

class _TypeRadio extends StatelessWidget {
  final _Type type;
  final _Type? groupValue;
  final bool toggleable;
  final ValueChanged<_Type?>? onChanged;
  final bool enabled;

  const _TypeRadio(
    this.type, {
    super.key,
    this.groupValue,
    this.toggleable = false,
    this.onChanged,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final labelNote = type.labelNote;
    final label = labelNote.label;
    final note = labelNote.note;

    return RadioGroup<_Type>(
      onChanged: _changeGroupValue,
      groupValue: groupValue,
      child: VoicesRadio<_Type>(
        value: type,
        label: label != null ? Text(label) : null,
        note: note != null ? Text(note) : null,
        toggleable: toggleable,
        enabled: enabled,
      ),
    );
  }

  void _changeGroupValue(_Type? value) {
    final onChanged = this.onChanged;
    if (groupValue != value) {
      onChanged?.call(value);
    }
  }
}

class _VoicesRadioExampleState extends State<VoicesRadioExample> {
  _Type? _current = _Type.values.last;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Voices Radio')),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemBuilder: (context, index) {
          final type = _Type.values[index];

          return _TypeRadio(
            type,
            key: ObjectKey(type),
            groupValue: _current,
            toggleable: type == _Type.three,
            onChanged: _updateGroupSelection,
            enabled: type != _Type.values.last,
          );
        },
        separatorBuilder: (context, index) => const SizedBox(height: 8),
        itemCount: _Type.values.length,
      ),
    );
  }

  void _updateGroupSelection(_Type? value) {
    setState(() {
      _current = value;
    });
  }
}
