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
    r'bdca3f33c70f368aa8658aaeb2f6733448344236';

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
    r'729f7233bc334f2433a8ab8f6ce6f994ee2deabd';

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
    extends $AsyncNotifierProvider<PostApplicationController, void> {
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
    r'a5a836405deecdf3a59e41a15662794c72ad74a0';

abstract class _$PostApplicationController extends $AsyncNotifier<void> {
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
