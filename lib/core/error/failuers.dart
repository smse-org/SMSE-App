import 'package:dio/dio.dart';

abstract class Faliuer {
  final String errMessage;

  const Faliuer(this.errMessage);
}

class ServerFailuer extends Faliuer {
  ServerFailuer(super.errMessage);

  factory ServerFailuer.fromDioError(DioError dioError) {
    switch (dioError.type) {
      case DioExceptionType.connectionTimeout:
        return ServerFailuer("Connection timeout with Api Server");
      case DioExceptionType.sendTimeout:
        return ServerFailuer("Send timeout with Api Server");
      case DioExceptionType.receiveTimeout:
        return ServerFailuer("Receive timeout with Api Server");

      case DioExceptionType.badResponse:
        return ServerFailuer.fromResponse(
            dioError.response!.statusCode!, dioError.response!.data!);

      case DioExceptionType.cancel:
        return ServerFailuer("request to data was canceled");

      case DioExceptionType.unknown:
        if (dioError.message!.contains("SocketException")) {
          return ServerFailuer("No Internet Connection");
        }
        return ServerFailuer("Unexpected error , please try again later");

      case DioExceptionType.badCertificate:
        return ServerFailuer("Unexpected error , please try again later");

      case DioExceptionType.connectionError:
        return ServerFailuer("No Internet Connection");
    }

  }

  factory ServerFailuer.fromResponse(int statusCode, dynamic respnose) {
    if (statusCode == 400 || statusCode == 401 || statusCode == 403) {
      return ServerFailuer(respnose["error"]["message"]);
    } else if (statusCode == 404) {
      return ServerFailuer("Your request not found , Please try again later");
    } else if (statusCode == 500) {
      return ServerFailuer("Internal server error , Please try again later");
    } else {
      return ServerFailuer("Opps there was an error , please try again");
    }
  }
}