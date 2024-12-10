import 'package:flutter/material.dart';
import 'package:flutter_mvvm/data/response/api_response.dart';
import 'package:flutter_mvvm/model/model.dart';
import 'package:flutter_mvvm/repository/home_repository.dart';
import 'package:flutter_mvvm/model/costs/shipping_cost.dart';

class HomeViewmodel with ChangeNotifier {
  final _homeRepo = HomeRepository();

  ApiResponse<List<Province>> provinceList = ApiResponse.loading();

  setProvinceList(ApiResponse<List<Province>> response) {
    provinceList = response;
    notifyListeners();
  }

  Future<void> getProvinceList() async {
    setProvinceList(ApiResponse.loading());
    _homeRepo.fetchProvinceList().then((value) {
      setProvinceList(ApiResponse.completed(value));
    }).onError((error, stackTrace) {
      setProvinceList(ApiResponse.error(error.toString()));
    });
  }

  ApiResponse<List<City>> cityList = ApiResponse.loading();

  setCityList(ApiResponse<List<City>> response) {
    cityList = response;
    notifyListeners();
  }

  Future<void> getCityList(var provId) async {
    setCityList(ApiResponse.loading());
    _homeRepo.fetchCityList(provId).then((value) {
      setCityList(ApiResponse.completed(value));
    }).onError((error, stackTrace) {
      setCityList(ApiResponse.error(error.toString()));
    });
  }

  ApiResponse<List<ShippingCost>> shippingCost = ApiResponse.loading();

  Future<void> calculateShippingCost({
    required String originCityId,
    required String destinationCityId,
    required int weight,
    required String courier,
  }) async {
    // Set the state to loading before making the API call
    shippingCost = ApiResponse.loading();
    notifyListeners();

    try {
      // Call the API service to calculate shipping costs
      final costs = await _homeRepo.calculateShippingCost(
        originCityId: originCityId,
        destinationCityId: destinationCityId,
        weight: weight,
        courier: courier,
      );

      // Update the shipping cost with the received data
      shippingCost = ApiResponse.completed(costs);
    } catch (e) {
      // Handle any errors that occur during the API call
      shippingCost = ApiResponse.error(e.toString());
    }

    // Notify listeners of the state change
    notifyListeners();
  }

  // Optional: Method to reset shipping cost
  void resetShippingCost() {
    shippingCost = ApiResponse.loading();
    notifyListeners();
  }
}
