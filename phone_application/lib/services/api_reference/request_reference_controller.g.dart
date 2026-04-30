// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'request_reference_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(fetchEntireListApplications)
final fetchEntireListApplicationsProvider =
    FetchEntireListApplicationsFamily._();

final class FetchEntireListApplicationsProvider
    extends
        $FunctionalProvider<
          AsyncValue<({List<GetReferenceModel> applications, String? message})>,
          ({List<GetReferenceModel> applications, String? message}),
          FutureOr<({List<GetReferenceModel> applications, String? message})>
        >
    with
        $FutureModifier<
          ({List<GetReferenceModel> applications, String? message})
        >,
        $FutureProvider<
          ({List<GetReferenceModel> applications, String? message})
        > {
  FetchEntireListApplicationsProvider._({
    required FetchEntireListApplicationsFamily super.from,
    required ({String? name, String? group, bool? onlyUnfinished})
    super.argument,
  }) : super(
         retry: null,
         name: r'fetchEntireListApplicationsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$fetchEntireListApplicationsHash();

  @override
  String toString() {
    return r'fetchEntireListApplicationsProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<
    ({List<GetReferenceModel> applications, String? message})
  >
  $createElement($ProviderPointer pointer) => $FutureProviderElement(pointer);

  @override
  FutureOr<({List<GetReferenceModel> applications, String? message})> create(
    Ref ref,
  ) {
    final argument =
        this.argument as ({String? name, String? group, bool? onlyUnfinished});
    return fetchEntireListApplications(
      ref,
      name: argument.name,
      group: argument.group,
      onlyUnfinished: argument.onlyUnfinished,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is FetchEntireListApplicationsProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$fetchEntireListApplicationsHash() =>
    r'3566c79dbf98f05e5f6b35da721e2751344dd3f2';

final class FetchEntireListApplicationsFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<({List<GetReferenceModel> applications, String? message})>,
          ({String? name, String? group, bool? onlyUnfinished})
        > {
  FetchEntireListApplicationsFamily._()
    : super(
        retry: null,
        name: r'fetchEntireListApplicationsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  FetchEntireListApplicationsProvider call({
    String? name,
    String? group,
    bool? onlyUnfinished,
  }) => FetchEntireListApplicationsProvider._(
    argument: (name: name, group: group, onlyUnfinished: onlyUnfinished),
    from: this,
  );

  @override
  String toString() => r'fetchEntireListApplicationsProvider';
}

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
    r'6e66724bf621c0de190fb5d4c76298a61c9e04f8';

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
