// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AdminController)
final adminControllerProvider = AdminControllerProvider._();

final class AdminControllerProvider
    extends
        $AsyncNotifierProvider<
          AdminController,
          List<SingleGroupWithStudentsModel>
        > {
  AdminControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'adminControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$adminControllerHash();

  @$internal
  @override
  AdminController create() => AdminController();
}

String _$adminControllerHash() => r'b3b87bbe29d2dfad8d842c0e8c84b01221482a9a';

abstract class _$AdminController
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

@ProviderFor(filteredAdminGroups)
final filteredAdminGroupsProvider = FilteredAdminGroupsProvider._();

final class FilteredAdminGroupsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<SingleGroupWithStudentsModel>>,
          AsyncValue<List<SingleGroupWithStudentsModel>>,
          AsyncValue<List<SingleGroupWithStudentsModel>>
        >
    with $Provider<AsyncValue<List<SingleGroupWithStudentsModel>>> {
  FilteredAdminGroupsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'filteredAdminGroupsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$filteredAdminGroupsHash();

  @$internal
  @override
  $ProviderElement<AsyncValue<List<SingleGroupWithStudentsModel>>>
  $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  AsyncValue<List<SingleGroupWithStudentsModel>> create(Ref ref) {
    return filteredAdminGroups(ref);
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

String _$filteredAdminGroupsHash() =>
    r'1e70256a8539834540b547b5ac14bf703262cad0';
