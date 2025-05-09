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
          'file',
          await MultipartFile.fromFile(
            filepath,
            filename: fileName,
          ),
        ),
      );
    }

    try {
      final response = await apiService.postContent(
        endpoint: "contents",
        data: formatData,
        token: true,
      );


      if (response['message'] == "Content created successfully" && response['content'] != null) {
        return Right(ContentModel.fromJson(response['content']));
      } else {
        return Left(ServerFailuer("Unexpected response format"));
      }
    } on ServerFailuer catch (failure) {
      return Left(failure);
    } on DioException catch (dioError) {
      return Left(ServerFailuer.fromDioError(dioError));
    } catch (e) {
      return Left(ServerFailuer("Unexpected error: ${e.toString()}"));
    }
  }
}
