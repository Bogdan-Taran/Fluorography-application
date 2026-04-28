// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'request_reference_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(fetchEntireListApplications)
final fetchEntireListApplicationsProvider =
    FetchEntireListApplicationsProvider._();

final class FetchEntireListApplicationsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<GetReferenceModel>>,
          List<GetReferenceModel>,
          FutureOr<List<GetReferenceModel>>
        >
    with
        $FutureModifier<List<GetReferenceModel>>,
        $FutureProvider<List<GetReferenceModel>> {
  FetchEntireListApplicationsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'fetchEntireListApplicationsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$fetchEntireListApplicationsHash();

  @$internal
  @override
  $FutureProviderElement<List<GetReferenceModel>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<GetReferenceModel>> create(Ref ref) {
    return fetchEntireListApplications(ref);
  }
}

String _$fetchEntireListApplicationsHash() =>
    r'3d5325f7b3dcd5df19e204e5e77fef7836e6271f';

@ProviderFor(UpdateReferenceStatusController)
final updateReferenceStatusControllerProvider =
    UpdateReferenceStatusControllerProvider._();

final class UpdateReferenceStatusControllerProvider
    extends $AsyncNotifierProvider<UpdateReferenceStatusController, void> {
  UpdateReferenceStatusControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'updateReferenceStatusControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$updateReferenceStatusControllerHash();

  @$internal
  @override
  UpdateReferenceStatusController create() => UpdateReferenceStatusController();
}

String _$updateReferenceStatusControllerHash() =>
    r'483c6a75f47db7be4952c1fef69eaeb47e7672f4';

abstract class _$UpdateReferenceStatusController extends $AsyncNotifier<void> {
  FutureOr<void> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<void>, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, void>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(PostApplicationController)
final postApplicationControllerProvider = PostApplicationControllerProvider._();

final class PostApplicationControllerProvider
    extends $AsyncNotifierProvider<PostApplicationController, String?> {
  PostApplicationControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'postApplicationControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$postApplicationControllerHash();

  @$internal
  @override
  PostApplicationController create() => PostApplicationController();
}

String _$postApplicationControllerHash() =>
    r'e77ee0f3f1c5d351857acb52a21ec85c342dae06';

abstract class _$PostApplicationController extends $AsyncNotifier<String?> {
  FutureOr<String?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<String?>, String?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<String?>, String?>,
              AsyncValue<String?>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
