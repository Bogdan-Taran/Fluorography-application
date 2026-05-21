import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

final secretaryReferenceSearchQueryProvider = StateProvider<String>((ref) => '');
final secretaryReferenceShowOnlyActiveProvider = StateProvider<bool>((ref) => false);
