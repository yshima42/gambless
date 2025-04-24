// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tracker_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$trackerRepositoryHash() => r'dfaa40f89869b682b18185e96b117f28cdd28154';

/// See also [trackerRepository].
@ProviderFor(trackerRepository)
final trackerRepositoryProvider =
    AutoDisposeProvider<TrackerRepository>.internal(
  trackerRepository,
  name: r'trackerRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$trackerRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TrackerRepositoryRef = AutoDisposeProviderRef<TrackerRepository>;
String _$daysCleanHash() => r'dffe8a551c90cbe79e4703b1179446d6f5e9cf7c';

/// See also [daysClean].
@ProviderFor(daysClean)
final daysCleanProvider = AutoDisposeProvider<int>.internal(
  daysClean,
  name: r'daysCleanProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$daysCleanHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DaysCleanRef = AutoDisposeProviderRef<int>;
String _$milestonesHash() => r'0f85acd0b838c9a6daab163444d1757464e7ea23';

/// See also [milestones].
@ProviderFor(milestones)
final milestonesProvider = AutoDisposeProvider<List<int>>.internal(
  milestones,
  name: r'milestonesProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$milestonesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef MilestonesRef = AutoDisposeProviderRef<List<int>>;
String _$weeklyDataHash() => r'0fd0b5a27464a7762d8bdd611ae7924b0ad4beb5';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [weeklyData].
@ProviderFor(weeklyData)
const weeklyDataProvider = WeeklyDataFamily();

/// See also [weeklyData].
class WeeklyDataFamily extends Family<List<DayData>> {
  /// See also [weeklyData].
  const WeeklyDataFamily();

  /// See also [weeklyData].
  WeeklyDataProvider call(
    int weeksBack,
  ) {
    return WeeklyDataProvider(
      weeksBack,
    );
  }

  @override
  WeeklyDataProvider getProviderOverride(
    covariant WeeklyDataProvider provider,
  ) {
    return call(
      provider.weeksBack,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'weeklyDataProvider';
}

/// See also [weeklyData].
class WeeklyDataProvider extends AutoDisposeProvider<List<DayData>> {
  /// See also [weeklyData].
  WeeklyDataProvider(
    int weeksBack,
  ) : this._internal(
          (ref) => weeklyData(
            ref as WeeklyDataRef,
            weeksBack,
          ),
          from: weeklyDataProvider,
          name: r'weeklyDataProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$weeklyDataHash,
          dependencies: WeeklyDataFamily._dependencies,
          allTransitiveDependencies:
              WeeklyDataFamily._allTransitiveDependencies,
          weeksBack: weeksBack,
        );

  WeeklyDataProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.weeksBack,
  }) : super.internal();

  final int weeksBack;

  @override
  Override overrideWith(
    List<DayData> Function(WeeklyDataRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: WeeklyDataProvider._internal(
        (ref) => create(ref as WeeklyDataRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        weeksBack: weeksBack,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<List<DayData>> createElement() {
    return _WeeklyDataProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is WeeklyDataProvider && other.weeksBack == weeksBack;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, weeksBack.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin WeeklyDataRef on AutoDisposeProviderRef<List<DayData>> {
  /// The parameter `weeksBack` of this provider.
  int get weeksBack;
}

class _WeeklyDataProviderElement
    extends AutoDisposeProviderElement<List<DayData>> with WeeklyDataRef {
  _WeeklyDataProviderElement(super.provider);

  @override
  int get weeksBack => (origin as WeeklyDataProvider).weeksBack;
}

String _$trackerHash() => r'be107ccd22522d9e53b1ec0e255349dc6831531e';

/// See also [Tracker].
@ProviderFor(Tracker)
final trackerProvider =
    AutoDisposeNotifierProvider<Tracker, AsyncValue<TrackerData?>>.internal(
  Tracker.new,
  name: r'trackerProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$trackerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$Tracker = AutoDisposeNotifier<AsyncValue<TrackerData?>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
