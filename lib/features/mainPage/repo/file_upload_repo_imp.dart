import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:smse/core/error/failuers.dart';
import 'package:smse/core/network/api/api_service.dart';
import 'package:smse/features/mainPage/model/content.dart';
import 'package:smse/features/mainPage/repo/file_uploadrepo.dart';

class FileUploadRepoImp extends FileUploadRep {
  final ApiService apiService;

  FileUploadRepoImp(this.apiService);

  @override
  Future<Either<Faliuer, ContentModel>> uploadFile(List<String> files) async {
    try {
      print('Repository: Starting file upload');
      for (var filepath in files) {
        print('Repository: Processing file: $filepath');
        final fileName = filepath.split('/').last;
        final fileType = fileName.toLowerCase().endsWith('.jpg') || fileName.toLowerCase().endsWith('.jpeg')
            ? 'image/jpeg'
            : fileName.toLowerCase().endsWith('.txt')
                ? 'text/plain'
                : fileName.toLowerCase().endsWith('.wav')
                    ? 'audio/wav'
                    : 'application/octet-stream';

        print('Repository: File type detected as: $fileType');

        final formatData = FormData.fromMap({
          'file': await MultipartFile.fromFile(
            filepath,
            filename: fileName,
            contentType: MediaType.parse(fileType),
          ),
        });

        print('Repository: Sending request to API');
        final response = await apiService.postContent(
          endpoint: "contents",
          data: formatData,
          token: true,
        );
        print('Repository: API Response: $response');

        if (response['message'] == "Content created successfully" && response['content'] != null) {
          print('Repository: Upload successful');
          return Right(ContentModel.fromJson(response['content']));
        } else {
          print('Repository: Unexpected response format: $response');
          return Left(ServerFailuer(response['message'] ?? "Unexpected response format"));
        }
      }
      print('Repository: No files were uploaded');
      return Left(ServerFailuer("No files were uploaded"));
    } on ServerFailuer catch (failure) {
      print('Repository: Server failure: ${failure.errMessage}');
      return Left(failure);
    } on DioException catch (dioError) {
      print('Repository: Dio error: ${dioError.message}');
      return Left(ServerFailuer.fromDioError(dioError));
    } catch (e) {
      print('Repository: Unexpected error: $e');
      return Left(ServerFailuer("Unexpected error: ${e.toString()}"));
    }
  }
}
