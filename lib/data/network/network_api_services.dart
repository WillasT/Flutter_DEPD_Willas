import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_mvvm/data/app_exception.dart';
import 'package:flutter_mvvm/shared/shared.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_mvvm/data/network/base_api_services.dart';

class NetworkApiServices implements BaseApiServices {
  @override
  Future getApiResponse(String endpoint) async {
    dynamic responseJson;
    try {
      final response = await http.get(
        Uri.https(Const.baseUrl, endpoint),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'key': Const.apiKey
        }
      );
      responseJson = returnResponse(response);
    } on SocketException {
      throw NoInternetException('No internet connection');
    } on TimeoutException {
      throw FetchDataException('Network request timeout!');
    }

    return responseJson;
  }

  @override
  Future postApiResponse(String endpoint, dynamic data) async {
    dynamic responseJson;
    try {
      final response = await http.post(
        Uri.https(Const.baseUrl, endpoint),
        headers: <String, String>{
          'Content-Type': 'application/x-www-form-urlencoded',
          'key': Const.apiKey
        },
        body: data
      );
      responseJson = returnResponse(response);
    } on SocketException {
      throw NoInternetException('No internet connection');
    } on TimeoutException {
      throw FetchDataException('Network request timeout!');
    }

    return responseJson;
  }

  dynamic returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        dynamic responseJson = jsonDecode(response.body);
        return responseJson;
      case 400:
        throw BadRequestException(response.body.toString());
      case 401:
        throw UnauthorisedException('Unauthorized access');
      case 403:
        throw ForbiddenException('Forbidden access');
      case 404:
        throw NotFoundException('Endpoint not found');
      case 500:
        throw InternalServerException('Internal server error');
      default:
        throw FetchDataException(
          'Error occurred while communicating with server with status code: ${response.statusCode}'
        );
    }
  }
}

// Additional custom exceptions for more specific error handling
class BadRequestException implements Exception {
  final String message;
  BadRequestException(this.message);
}

class UnauthorisedException implements Exception {
  final String message;
  UnauthorisedException(this.message);
}

class ForbiddenException implements Exception {
  final String message;
  ForbiddenException(this.message);
}

class NotFoundException implements Exception {
  final String message;
  NotFoundException(this.message);
}

class InternalServerException implements Exception {
  final String message;
  InternalServerException(this.message);
}