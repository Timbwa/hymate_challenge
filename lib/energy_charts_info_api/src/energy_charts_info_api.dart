import 'package:dio/dio.dart';
import 'package:hymate_challenge/energy_charts_info_api/energy_charts_info_api.dart';
import 'package:hymate_challenge/energy_charts_info_api/src/models/models.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'energy_charts_info_api.g.dart';

@riverpod
EnergyChartsInfoApi energyChartsInfoApi(EnergyChartsInfoApiRef ref) => EnergyChartsInfoApi();

/// {@template energy_charts_info_api}
/// Wrapper for Http Client and through which all requests are made
/// {@endtemplate}
class EnergyChartsInfoApi {
  /// {@macro energy_charts_info_api}
  EnergyChartsInfoApi() {
/*
    _dio.interceptors.add(
      LogInterceptor(
        logPrint: _logger.d,
        request: false,
        requestBody: true,
        requestHeader: false,
        responseBody: true,
        responseHeader: false,
      ),
    );
*/
  }

  static const String _host = 'api.energy-charts.info';

  /// http client
  final Dio _dio = Dio();

  /// logger for pretty printing
  final Logger _logger = Logger();

  /// Returns the day-ahead spot market price for a specified bidding zone in EUR/MWh.
  ///
  /// See https://api.energy-charts.info/#/prices/day_ahead_price_price_get
  Future<PriceResponseModel> getTotalPrice({
    required PriceRequestModel priceRequestModel,
    CancelToken? cancelToken,
  }) async {
    _logger.d('Fetching total Price with: \n'
        '$priceRequestModel');
    final uri = Uri.https(_host, 'price', priceRequestModel.toMap());

    final response = await _dio.getUri<Map<String, Object?>>(uri, cancelToken: cancelToken);

    _logger.d(response);
    final priceResponse = PriceResponseModel.fromJson(response.data!);

    return priceResponse;
  }

  /// Returns the day-ahead spot market price for a specified bidding zone in EUR/MWh.
  ///
  /// See https://api.energy-charts.info/#/prices/day_ahead_price_price_get
  Future<TotalPowerResponseModel> getTotalPower({
    required TotalPowerRequestModel totalPowerRequestModel,
    CancelToken? cancelToken,
  }) async {
    _logger.d('Fetching total Power with: \n'
        '$totalPowerRequestModel');
    final uri = Uri.https(_host, 'total_power', totalPowerRequestModel.toMap());

    final response = await _dio.getUri<Map<String, Object?>>(uri, cancelToken: cancelToken);

    _logger.d(response);
    final priceResponse = TotalPowerResponseModel.fromJson(response.data!);

    return priceResponse;
  }
}
