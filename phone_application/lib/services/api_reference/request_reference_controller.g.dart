// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'request_reference_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(RequestReferenceController)
final requestReferenceControllerProvider =
    RequestReferenceControllerProvider._();

final class RequestReferenceControllerProvider
    extends
        $AsyncNotifierProvider<RequestReferenceController, GetReferenceModel> {
  RequestReferenceControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'requestReferenceControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$requestReferenceControllerHash();

  @$internal
  @override
  RequestReferenceController create() => RequestReferenceController();
}

String _$requestReferenceControllerHash() =>
    r'ffdb8e8de01ed1d8fff4c1d0918897f34f87865b';

abstract class _$RequestReferenceController
    extends $AsyncNotifier<GetReferenceModel> {
  FutureOr<GetReferenceModel> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<GetReferenceModel>, GetReferenceModel>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<GetReferenceModel>, GetReferenceModel>,
              AsyncValue<GetReferenceModel>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
