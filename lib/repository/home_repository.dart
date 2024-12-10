import 'package:flutter_mvvm/data/network/network_api_services.dart';
import 'package:flutter_mvvm/model/costs/shipping_cost.dart';
import 'package:flutter_mvvm/model/model.dart';

class HomeRepository {
  final _apiservices = NetworkApiServices();

  Future<List<Province>> fetchProvinceList() async {
    try {
      dynamic response = await _apiservices.getApiResponse('/starter/province');
      List<Province> result = [];

      if (response['rajaongkir']['status']['code'] == 200) {
        result = (response['rajaongkir']['results'] as List)
            .map((e) => Province.fromJson(e))
            .toList();
      }
      return result;
    } catch (e) {
      throw e;
    }
  }

  Future<List<City>> fetchCityList(String provinceId) async {
    try {
      final response =
          await _apiservices.getApiResponse('city?province=$provinceId');
      final results = response['rajaongkir']['results'] as List;
      return results.map((city) => City.fromJson(city)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<ShippingCost>> calculateShippingCost({
    required String originCityId,
    required String destinationCityId,
    required int weight,
    required String courier,
  }) async {
    try {
      final postData = {
        'origin': originCityId,
        'destination': destinationCityId,
        'weight': weight.toString(),
        'courier': courier,
      };

      final response = await _apiservices.postApiResponse('cost', postData);
      final results = response['rajaongkir']['results'] as List;

      return results.map((result) => ShippingCost.fromJson(result)).toList();
    } catch (e) {
      rethrow;
    }
  }
}
