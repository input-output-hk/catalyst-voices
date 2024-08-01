import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:flutter/widgets.dart';

/// A function that resolves a [Color] based on a given
/// [VoicesColorScheme].
///
/// This function takes a [VoicesColorScheme] as input and returns an optional
/// [Color].
typedef ColorResolver = Color? Function(VoicesColorScheme);
