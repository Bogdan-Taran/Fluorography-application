// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reference_screen.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(example)
final exampleProvider = ExampleProvider._();

final class ExampleProvider extends $FunctionalProvider<String, String, String>
    with $Provider<String> {
  ExampleProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'exampleProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$exampleHash();

  @$internal
  @override
  $ProviderElement<String> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String create(Ref ref) {
    return example(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$exampleHash() => r'f8b1fd4c529aa4a35750bfc7e7df96e9db18c1a5';

@ProviderFor(ExampleClassRiv)
final exampleClassRivProvider = ExampleClassRivProvider._();

final class ExampleClassRivProvider
    extends $NotifierProvider<ExampleClassRiv, String> {
  ExampleClassRivProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'exampleClassRivProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$exampleClassRivHash();

  @$internal
  @override
  ExampleClassRiv create() => ExampleClassRiv();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$exampleClassRivHash() => r'cf55f137cf844a92aa41e5be05437ee23a15f359';

abstract class _$ExampleClassRiv extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<String, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String, String>,
              String,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
