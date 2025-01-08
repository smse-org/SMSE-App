import 'package:dio/dio.dart';
import 'package:smse/constants.dart';
import 'package:smse/core/utililes/cachedSP.dart';

class ApiService {
  final String _baseUrl = "https://smseai.me/api/v1/";
  final Dio _dio;

  ApiService(this._dio);

  // GET request
  Future<Map<String, dynamic>> get({required String endpoint}) async {
    try {
      final response = await _dio.get("$_baseUrl$endpoint",
      options: Options(
        headers: {
         'Authorization': 'Bearer ${await CachedData.getData(Constant.accessToekn)}',
        },)

      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Error during GET request: $e');
    }
  }

  // POST request
  Future<Map<String, dynamic>> post({
    required String endpoint,
    required dynamic data,
    bool? token=false,
    Function(int sent, int total)? onSendProgress,

  }) async {
    if (token == true) {
      try {
        final response = await _dio.post("$_baseUrl$endpoint",
            data: data,
            options: Options(
                headers: {
            'Content-Type': 'multipart/form-data',
                  'Authorization': 'Bearer ${await CachedData.getData(
                      Constant.accessToekn)}',
                },
            ),
          onSendProgress: onSendProgress
        );
        return response.data;
      } catch (e) {
        throw Exception('Error during POST request: $e');
      }
    } else {
      try {
        final response = await _dio.post("$_baseUrl$endpoint", data: data);

        if (response.statusCode == 200) {
          return response.data;
        } else if (response.statusCode == 400) {
          // Handle 400 error more gracefully
          throw DioException(
            requestOptions: response.requestOptions,
            error: response.data['msg'], // Extract message from response
          );
        } else {
          throw Exception('Failed to post data');
        }
      } catch (e) {
        throw Exception('Error during POST request: $e');
      }
    }
  }
}
