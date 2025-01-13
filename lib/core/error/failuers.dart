import 'package:dio/dio.dart';

abstract class Faliuer {
  final String errMessage;

  const Faliuer(this.errMessage);
}

class ServerFailuer extends Faliuer {
  ServerFailuer(super.errMessage);

  factory ServerFailuer.fromDioError(DioException dioError) {
    switch (dioError.type) {
      case DioExceptionType.connectionTimeout:
        return ServerFailuer("Connection timeout with API Server");
      case DioExceptionType.sendTimeout:
        return ServerFailuer("Send timeout with API Server");
      case DioExceptionType.receiveTimeout:
        return ServerFailuer("Receive timeout with API Server");
      case DioExceptionType.badResponse:
        if (dioError.response != null) {
          return ServerFailuer.fromResponse(
              dioError.response!.statusCode, dioError.response!.data);
        }
        return ServerFailuer("Received an invalid response from the server.");
      case DioExceptionType.cancel:
        return ServerFailuer("Request was canceled.");
      case DioExceptionType.unknown:
        if (dioError.message?.contains("SocketException") ?? false) {
          return ServerFailuer("No Internet Connection");
        }
        return ServerFailuer("Unexpected error, please try again later.");
      case DioExceptionType.badCertificate:
        return ServerFailuer("Unexpected certificate error.");
      case DioExceptionType.connectionError:
        return ServerFailuer("No Internet Connection.");
      default:
        return ServerFailuer("Unexpected error occurred.");
    }
  }

  factory ServerFailuer.fromResponse(int? statusCode, dynamic response) {
    if (response == null) {
      return ServerFailuer("Unexpected error occurred, please try again later.");
    }

    String errorMessage = "Invalid credentials";
    if (response is Map<String, dynamic>) {
      // Handle different error response structures
      errorMessage = response["error"]?["message"] ??
          response["msg"] ??
          response["message"] ??
          errorMessage;
    }

    if (statusCode != null) {
      if (statusCode == 400 || statusCode == 401 || statusCode == 403) {
        return ServerFailuer(errorMessage);
      } else if (statusCode == 404) {
        return ServerFailuer("Your request was not found. Please try again later.");
      } else if (statusCode == 500) {
        return ServerFailuer("Internal server error. Please try again later.");
      }
    }

    return ServerFailuer(errorMessage);
  }
}
