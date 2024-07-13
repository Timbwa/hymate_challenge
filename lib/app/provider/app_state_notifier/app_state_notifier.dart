import 'package:hymate_challenge/app/provider/provider.dart';
import 'package:hymate_challenge/energy_charts_info_api/energy_charts_info_api.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_state_notifier.g.dart';

/// Maintains the [AppState] and provides methods to the UI for modifying the state
@riverpod
class AppStateNotifier extends _$AppStateNotifier {
  static const defaultBiddingZone = BiddingZone.germanyLuxembourg;
  static const totalPowerRequestModel = TotalPowerRequestModel();
  static const _defaultProductionTypeIndex = 18;
  final priceRequestModel = PriceRequestModel(bzn: defaultBiddingZone.abbreviation);

  @override
  FutureOr<AppState> build() async {
    print('======================= BUILDING APP STATENOTIFIER ==================');

    return await _fetchPowerAndPrices(totalPowerRequestModel, priceRequestModel);
  }

  void updateDataPoints({required String key, required LineData dataPoints}) {
    final currentAppStateLines = state.value!.lines..addAll({key: dataPoints});
    state = AsyncData(state.value!.copyWith(lines: currentAppStateLines));
    print('==================================');
    print(state);
  }

  Future<PriceResponseModel> fetchTotalPrice(PriceRequestModel requestModel) async {
    final cancelToken = ref.cancelToken();

    final response = await ref
        .watch(energyChartsInfoApiProvider)
        .getTotalPrice(priceRequestModel: requestModel, cancelToken: cancelToken);

    return response;
  }

  Future<TotalPowerResponseModel> fetchTotalPower(TotalPowerRequestModel requestModel) async {
    final cancelToken = ref.cancelToken();

    final response = await ref
        .watch(energyChartsInfoApiProvider)
        .getTotalPower(totalPowerRequestModel: requestModel, cancelToken: cancelToken);

    return response;
  }

  Future<void> fetchTotalPriceAndUpdateState(PriceRequestModel priceRequestModel) async {
    print('Before');
    print(state.valueOrNull?.lines);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final priceResponse = await fetchTotalPrice(priceRequestModel);
      final currentLines = state.value!.lines;

      final lines = {
        'price': LineData(
          name: 'price',
          unixTimestamps: priceResponse.unixSeconds,
          yDataPoints: priceResponse.price,
        ),
      };
      currentLines.addAll(lines);

      return state.value!.copyWith(lines: currentLines);
    });
    print('After');
    print(state.valueOrNull?.lines);
  }

  Future<void> fetchTotalPowerAndUpdateState(TotalPowerRequestModel totalPowerRequestModel) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final totalPowerResponse = await fetchTotalPower(totalPowerRequestModel);
      final currentLines = state.value!.lines;

      final lines = {
        // TODO ammend to allow multilpe production types
        'power': LineData(
          unixTimestamps: totalPowerResponse.unixSeconds,
          name: totalPowerResponse.productionTypes[_defaultProductionTypeIndex].name,
          yDataPoints: totalPowerResponse.productionTypes[_defaultProductionTypeIndex].data,
        ),
      };
      currentLines.addAll(lines);

      return state.value!.copyWith(lines: currentLines);
    });
  }

  Future<AppState> _fetchPowerAndPrices(
    TotalPowerRequestModel totalPowerRequestModel,
    PriceRequestModel priceRequestModel,
  ) async {
    final totalPowerResponse = await fetchTotalPower(totalPowerRequestModel);
    final priceResponse = await fetchTotalPrice(priceRequestModel);
    final lines = {
      'price': LineData(
        name: 'price',
        unixTimestamps: priceResponse.unixSeconds,
        yDataPoints: priceResponse.price,
      ),
      // TODO ammend to allow multilpe production types
      'power': LineData(
        unixTimestamps: totalPowerResponse.unixSeconds,
        name: totalPowerResponse.productionTypes[_defaultProductionTypeIndex].name,
        yDataPoints: totalPowerResponse.productionTypes[_defaultProductionTypeIndex].data,
      ),
    };

    return AppState(lines: lines);
  }

  /// reset the state to default values
  void reset() {
    state = AsyncData(state.value!.copyWith(lines: {}));
  }
}
