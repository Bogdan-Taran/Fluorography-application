// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fluorography_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(FluorographyController)
final fluorographyControllerProvider = FluorographyControllerProvider._();

final class FluorographyControllerProvider
    extends $NotifierProvider<FluorographyController, FluorographyState> {
  FluorographyControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'fluorographyControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$fluorographyControllerHash();

  @$internal
  @override
  FluorographyController create() => FluorographyController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FluorographyState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FluorographyState>(value),
    );
  }
}

String _$fluorographyControllerHash() =>
    r'18d53999c51f4f0b2e7ac11027b04e65d66d7001';

abstract class _$FluorographyController extends $Notifier<FluorographyState> {
  FluorographyState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<FluorographyState, FluorographyState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<FluorographyState, FluorographyState>,
              FluorographyState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
