// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'curator_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(CuratorController)
final curatorControllerProvider = CuratorControllerProvider._();

final class CuratorControllerProvider
    extends
        $AsyncNotifierProvider<
          CuratorController,
          List<SingleGroupWithStudentsModel>
        > {
  CuratorControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'curatorControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$curatorControllerHash();

  @$internal
  @override
  CuratorController create() => CuratorController();
}

String _$curatorControllerHash() => r'f89789e8ae592b6481160ad770888eeee3335c4e';

abstract class _$CuratorController
    extends $AsyncNotifier<List<SingleGroupWithStudentsModel>> {
  FutureOr<List<SingleGroupWithStudentsModel>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<List<SingleGroupWithStudentsModel>>,
              List<SingleGroupWithStudentsModel>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<SingleGroupWithStudentsModel>>,
                List<SingleGroupWithStudentsModel>
              >,
              AsyncValue<List<SingleGroupWithStudentsModel>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(filteredCuratorGroups)
final filteredCuratorGroupsProvider = FilteredCuratorGroupsProvider._();

final class FilteredCuratorGroupsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<SingleGroupWithStudentsModel>>,
          AsyncValue<List<SingleGroupWithStudentsModel>>,
          AsyncValue<List<SingleGroupWithStudentsModel>>
        >
    with $Provider<AsyncValue<List<SingleGroupWithStudentsModel>>> {
  FilteredCuratorGroupsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'filteredCuratorGroupsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$filteredCuratorGroupsHash();

  @$internal
  @override
  $ProviderElement<AsyncValue<List<SingleGroupWithStudentsModel>>>
  $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  AsyncValue<List<SingleGroupWithStudentsModel>> create(Ref ref) {
    return filteredCuratorGroups(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(
    AsyncValue<List<SingleGroupWithStudentsModel>> value,
  ) {
    return $ProviderOverride(
      origin: this,
      providerOverride:
          $SyncValueProvider<AsyncValue<List<SingleGroupWithStudentsModel>>>(
            value,
          ),
    );
  }
}

String _$filteredCuratorGroupsHash() =>
    r'0160c054cfd584617201f59390387533ca7c02b0';
