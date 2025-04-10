import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:smse/core/error/failuers.dart';
import 'package:smse/core/network/api/api_service.dart';
import 'package:smse/features/mainPage/model/content.dart';
import 'package:smse/features/uploded_content/data/repositories/display_content_repo.dart';
import 'package:smse/features/uploded_content/presentation/controller/cubit/content_state.dart';

class DisplayContentRepoImp extends DisplayContentRepo {
  final ApiService apiService;

  DisplayContentRepoImp(this.apiService);

  @override
  Future<Either<Faliuer, void>> deleteContent({required int id}) async {
    try {
      await apiService.delete(endpoint: 'contents/$id');
      return const Right(null);
    } on ServerFailuer catch (failure) {
      return Left(failure);
    } on DioException catch (dioError) {
      return Left(ServerFailuer.fromDioError(dioError));
    } catch (e) {
      return Left(ServerFailuer("Unexpected error: \${e.toString()}"));
    }
  }

  @override
  Future<Either<Faliuer, String>> downloadContent({
    required int id,
    required String fileName,
  }) async {
    try {
      String endpoint = "contents/download?content_id=$id"; // Correct query parameter format
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String savePath = "${appDocDir.path}/$fileName";

      await apiService.downloadFile(
        endpoint: endpoint,
        savePath: savePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            print("Download Progress: ${(received / total * 100).toStringAsFixed(0)}%");
          }
        },
      );

      OpenFilex.open(savePath); // Open file after successful download
      return Right(savePath); // Return file path
    } on DioException catch (dioError) {
      return Left(ServerFailuer.fromDioError(dioError));
    } catch (e) {
      return Left(ServerFailuer("Unexpected error: ${e.toString()}"));
    }
  }


  @override
  Future<Either<Faliuer, List<ContentModel>>> getContent() async {
    try {
      final response = await apiService.get(endpoint: 'contents');
      final List<dynamic> contentData = response['contents'];
      final contents = contentData.map((data) => ContentModel.fromJson(data)).toList();
      return Right(contents);
    } on ServerFailuer catch (failure) {
      return Left(failure);
    } on DioException catch (dioError) {
      return Left(ServerFailuer.fromDioError(dioError));
    } catch (e) {
      return Left(ServerFailuer("Unexpected error: \${e.toString()}"));
    }
  }
}
