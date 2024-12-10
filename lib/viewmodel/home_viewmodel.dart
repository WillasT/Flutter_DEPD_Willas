import 'package:flutter/material.dart';
import 'package:flutter_mvvm/data/network/network_api_services.dart';
import 'package:flutter_mvvm/data/response/api_response.dart';
import 'package:flutter_mvvm/model/model.dart';
import 'package:flutter_mvvm/repository/home_repository.dart';
import 'package:flutter_mvvm/model/costs/shipping_cost.dart';
import 'package:flutter_mvvm/data/response/status.dart';

class HomeViewmodel with ChangeNotifier {
  final _homeRepo = HomeRepository();

  ApiResponse<List<Province>> provinceList = ApiResponse.loading();

  setProvinceList(ApiResponse<List<Province>> response) {
    provinceList = response;
    notifyListeners();
  }

  Future<void> getProvinceList() async {
    setProvinceList(ApiResponse.loading());
    try {
      final provinces = await _homeRepo.fetchProvinceList();
      setProvinceList(ApiResponse.completed(provinces));
    } catch (e) {
      setProvinceList(ApiResponse.error(e.toString()));
    }
  }

  ApiResponse<List<City>> cityList = ApiResponse.loading();

  setCityList(ApiResponse<List<City>> response) {
    cityList = response;
    notifyListeners();
  }

  Future<void> getCityList(String provinceId) async {
    try {
      print('Fetching cities for province ID: $provinceId');
      cityList = ApiResponse.loading();
      notifyListeners();

      var cities = await _homeRepo.fetchCityList(provinceId);

      print('Cities fetched: ${cities.length}');
      cityList = ApiResponse.completed(cities);
    } catch (e, stackTrace) {
      print('Detailed error fetching cities:');
      print('Error: ${e.runtimeType} - $e');
      print('Stacktrace: $stackTrace');

      cityList = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }

  ApiResponse<List<ShippingCost>> shippingCost = ApiResponse.loading();

  Future<void> calculateShippingCost({
    required String originCityId,
    required String destinationCityId,
    required int weight,
    required String courier,
  }) async {
    shippingCost = ApiResponse.loading();
    notifyListeners();

    try {
      // Add logging to debug the API call
      print('Calculating shipping cost with parameters:');
      print('Origin City ID: $originCityId');
      print('Destination City ID: $destinationCityId');
      print('Weight: $weight');
      print('Courier: $courier');

      final costs = await _homeRepo.calculateShippingCost(
        originCityId: originCityId,
        destinationCityId: destinationCityId,
        weight: weight,
        courier: courier,
      );

      if (costs.isEmpty) {
        shippingCost = ApiResponse.error(
            'No shipping costs available for the selected route');
      } else {
        shippingCost = ApiResponse.completed(costs);
      }
    } catch (e) {
      print('Error calculating shipping cost: $e');
      String errorMessage = 'Failed to calculate shipping cost';

      // if (e is NotFoundException) {
      //   errorMessage =
      //       'Route not found or service unavailable for selected cities';
      // } else if (e is Exception) {
      //   errorMessage = e.toString();
      // }

      shippingCost = ApiResponse.error(errorMessage);
    }

    notifyListeners();
  }
}
