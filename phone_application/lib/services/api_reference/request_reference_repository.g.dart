// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'request_reference_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(requestRepositoryMine)
final requestRepositoryMineProvider = RequestRepositoryMineProvider._();

final class RequestRepositoryMineProvider
    extends
        $FunctionalProvider<
          RequestRepositoryMine,
          RequestRepositoryMine,
          RequestRepositoryMine
        >
    with $Provider<RequestRepositoryMine> {
  RequestRepositoryMineProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'requestRepositoryMineProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$requestRepositoryMineHash();

  @$internal
  @override
  $ProviderElement<RequestRepositoryMine> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  RequestRepositoryMine create(Ref ref) {
    return requestRepositoryMine(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RequestRepositoryMine value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RequestRepositoryMine>(value),
    );
  }
}

String _$requestRepositoryMineHash() =>
    r'991ebe736356339f08c554c93c5396f0aea4d855';
