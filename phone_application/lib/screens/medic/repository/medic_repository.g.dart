// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medic_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(medicRepository)
final medicRepositoryProvider = MedicRepositoryProvider._();

final class MedicRepositoryProvider
    extends
        $FunctionalProvider<MedicRepository, MedicRepository, MedicRepository>
    with $Provider<MedicRepository> {
  MedicRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'medicRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$medicRepositoryHash();

  @$internal
  @override
  $ProviderElement<MedicRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  MedicRepository create(Ref ref) {
    return medicRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MedicRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MedicRepository>(value),
    );
  }
}

String _$medicRepositoryHash() => r'869fb2146a03593f6a9396ce11ff217cb07700da';
