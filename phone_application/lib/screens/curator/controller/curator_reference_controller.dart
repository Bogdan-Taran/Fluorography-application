import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

final curatorReferenceSearchQueryProvider = StateProvider<String>((ref) => '');
final curatorReferenceShowOnlyActiveProvider = StateProvider<bool>((ref) => false);
