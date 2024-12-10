import 'dart:convert';

import 'package:flutter_mvvm/data/app_exception.dart';
import 'package:flutter_mvvm/data/network/network_api_services.dart';
import 'package:flutter_mvvm/model/costs/shipping_cost.dart';
import 'package:flutter_mvvm/model/model.dart';

class HomeRepository {
  final _apiservices = NetworkApiServices();

  Future<List<Province>> fetchProvinceList() async {
    try {
      dynamic response = await _apiservices.getApiResponse('/starter/province');
      if (response['rajaongkir']['status']['code'] == 200) {
        return (response['rajaongkir']['results'] as List)
            .map((e) => Province.fromJson(e))
            .toList();
      } else {
        throw Exception(
            'Error fetching provinces: ${response['rajaongkir']['status']['description']}');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<City>> fetchCityList(String provinceId) async {
    try {
      print('Fetching cities for province ID: $provinceId');
      final response = await _apiservices.getApiResponse(
        'starter/city',
        queryParameters: {'province': provinceId},
      );

      // Log raw API response for debugging
      print('Raw API Response: $response');

      if (response['rajaongkir']['status']['code'] == 200) {
        return (response['rajaongkir']['results'] as List)
            .map((e) => City.fromJson(e))
            .toList();
      } else {
        throw NotFoundException(
            'Error fetching cities: ${response['rajaongkir']['status']['description']}');
      }
    } catch (e) {
      print('Error in fetchCityList: $e');
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
    // Prepare the request data
    final data = {
      'origin': originCityId,
      'destination': destinationCityId,
      'weight': weight.toString(),
      'courier': courier,
    };

    print('Sending API request with data: $data');

    final response = await _apiservices.postApiResponse('/starter/cost', data);

    print('API Response received: $response');

    if (response['rajaongkir']['status']['code'] == 200) {
      // Get the courier result
      var courierResult = response['rajaongkir']['results'][0];
      
      // Extract the costs array from the courier
      var costs = courierResult['costs'] as List;
      
      // Convert each cost item to a ShippingCost object
      return costs.map((costItem) => ShippingCost(
        service: costItem['service'],
        description: costItem['description'],
        cost: (costItem['cost'] as List)
            .map((c) => CostDetail.fromJson(c))
            .toList(),
      )).toList();
    } else {
      throw FetchDataException('Something went wrong');
    }
  } catch (e) {
    print("Error calculating cost: $e");
    throw e;
  }
}
}

class NotFoundException implements Exception {
  final String message;
  NotFoundException(this.message);

  @override
  String toString() => message;
}
