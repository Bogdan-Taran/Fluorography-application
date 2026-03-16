// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'request_reference_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(fetchStudentApplication)
final fetchStudentApplicationProvider = FetchStudentApplicationProvider._();

final class FetchStudentApplicationProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<GetReferenceModel>>,
          List<GetReferenceModel>,
          FutureOr<List<GetReferenceModel>>
        >
    with
        $FutureModifier<List<GetReferenceModel>>,
        $FutureProvider<List<GetReferenceModel>> {
  FetchStudentApplicationProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'fetchStudentApplicationProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$fetchStudentApplicationHash();

  @$internal
  @override
  $FutureProviderElement<List<GetReferenceModel>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<GetReferenceModel>> create(Ref ref) {
    return fetchStudentApplication(ref);
  }
}

String _$fetchStudentApplicationHash() =>
    r'aa4ab2d939bb8fb4aa206f24b69ce6c147cfc5a4';

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
