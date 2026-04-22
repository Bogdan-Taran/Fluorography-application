// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'request_reference_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(requestRepository)
final requestRepositoryProvider = RequestRepositoryProvider._();

final class RequestRepositoryProvider
    extends
        $FunctionalProvider<
          RequestRepository,
          RequestRepository,
          RequestRepository
        >
    with $Provider<RequestRepository> {
  RequestRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'requestRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$requestRepositoryHash();

  @$internal
  @override
  $ProviderElement<RequestRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  RequestRepository create(Ref ref) {
    return requestRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RequestRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RequestRepository>(value),
    );
  }
}

String _$requestRepositoryHash() => r'2b4227f2e6e44bde6423f16efb9412599cf62b97';
