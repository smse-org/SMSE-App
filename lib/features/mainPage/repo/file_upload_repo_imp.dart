import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:smse/core/error/failuers.dart';
import 'package:smse/core/network/api/api_service.dart';
import 'package:smse/features/mainPage/model/content.dart';
import 'package:smse/features/mainPage/repo/file_uploadrepo.dart';

class FileUploadRepoImp extends FileUploadRep {
  final ApiService apiService;

  FileUploadRepoImp(this.apiService);

  @override
  Future<Either<Faliuer, ContentModel>> uploadFile(List<String> files) async {
    final formatData = FormData();
    for (var filepath in files) {
      final fileName = filepath.split('/').last; // Extract the file name
      formatData.files.add(
        MapEntry(
          'file', // Field name expected by the API
          await MultipartFile.fromFile(
            filepath,
            filename: fileName, // Use the actual file name
          ),
        ),
      );
    }

    try {
      final response = await apiService.post(
        endpoint: "contents",
        data: formatData,
        token: true,
      );

      if (response['message'] == "Content created successfully") {
        return Right(ContentModel.fromJson(response));
      } else {
        return Left(ServerFailuer("Unexpected response format"));
      }
    } on DioException catch (e) {
      if (e.response != null) {
        print("Error Data: ${e.response?.data}");
        print("Error Status Code: ${e.response?.statusCode}");
      }
      return Left(ServerFailuer.fromDioError(e));
    } catch (e) {
      return Left(ServerFailuer(e.toString()));
    }
  }
}
