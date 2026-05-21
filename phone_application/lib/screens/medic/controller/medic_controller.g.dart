// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medic_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(MedicController)
final medicControllerProvider = MedicControllerProvider._();

final class MedicControllerProvider
    extends
        $AsyncNotifierProvider<MedicController, List<StaffAndStudentsModel>> {
  MedicControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'medicControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$medicControllerHash();

  @$internal
  @override
  MedicController create() => MedicController();
}

String _$medicControllerHash() => r'd9da17334dbb3529b90b864cf052bc9366fcfd3f';

abstract class _$MedicController
    extends $AsyncNotifier<List<StaffAndStudentsModel>> {
  FutureOr<List<StaffAndStudentsModel>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<List<StaffAndStudentsModel>>,
              List<StaffAndStudentsModel>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<StaffAndStudentsModel>>,
                List<StaffAndStudentsModel>
              >,
              AsyncValue<List<StaffAndStudentsModel>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(filteredMedicCommunity)
final filteredMedicCommunityProvider = FilteredMedicCommunityProvider._();

final class FilteredMedicCommunityProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<StaffAndStudentsModel>>,
          AsyncValue<List<StaffAndStudentsModel>>,
          AsyncValue<List<StaffAndStudentsModel>>
        >
    with $Provider<AsyncValue<List<StaffAndStudentsModel>>> {
  FilteredMedicCommunityProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'filteredMedicCommunityProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$filteredMedicCommunityHash();

  @$internal
  @override
  $ProviderElement<AsyncValue<List<StaffAndStudentsModel>>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AsyncValue<List<StaffAndStudentsModel>> create(Ref ref) {
    return filteredMedicCommunity(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<List<StaffAndStudentsModel>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride:
          $SyncValueProvider<AsyncValue<List<StaffAndStudentsModel>>>(value),
    );
  }
}

String _$filteredMedicCommunityHash() =>
    r'e4116158a7d926bb6f3879eb4aed83a7a0c73726';
