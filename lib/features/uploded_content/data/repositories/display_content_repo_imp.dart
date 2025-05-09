import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:smse/core/error/failuers.dart';
import 'package:smse/core/network/api/api_service.dart';
import 'package:smse/core/services/notification_service.dart';
import 'package:smse/features/mainPage/model/content.dart';
import 'package:smse/features/uploded_content/data/repositories/display_content_repo.dart';
import 'package:smse/features/uploded_content/presentation/controller/cubit/content_state.dart';

class DisplayContentRepoImp extends DisplayContentRepo {
  final ApiService apiService;
  final NotificationService _notificationService = NotificationService();
  static int _notificationId = 0;

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
      // Get the file path from the content model
      String filePath = fileName; // This should be the full path from the content model
      
      // Construct the endpoint with both required query parameters
      String endpoint = "contents/download?content_id=$id&file_path=$filePath";
      
      // Get the application documents directory for saving the file
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String savePath = "${appDocDir.path}/${fileName.split('/').last}"; // Use just the filename for saving

      // Generate a unique notification ID for this download
      final notificationId = _notificationId++;

      await apiService.downloadFile(
        endpoint: endpoint,
        savePath: savePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            int progress = (received / total * 100).round();
            // Show download progress notification
            _notificationService.showDownloadProgress(
              fileName: fileName.split('/').last,
              progress: progress,
              notificationId: notificationId,
            );
          }
        },
      );

      // Show download complete notification
      await _notificationService.showDownloadComplete(
        fileName: fileName.split('/').last,
        notificationId: notificationId,
      );

      OpenFilex.open(savePath); // Open file after successful download
      return Right(savePath); // Return file path
    } on ServerFailuer catch (failure) {
      // Show error notification
      await _notificationService.showError(
        title: 'Download Failed',
        message: failure.errMessage,
        notificationId: _notificationId++,
      );
      return Left(failure);
    } on DioException catch (dioError) {
      // Show error notification
      await _notificationService.showError(
        title: 'Download Failed',
        message: dioError.message ?? 'Network error occurred',
        notificationId: _notificationId++,
      );
      return Left(ServerFailuer.fromDioError(dioError));
    } catch (e) {
      // Show error notification
      await _notificationService.showError(
        title: 'Download Failed',
        message: e.toString(),
        notificationId: _notificationId++,
      );
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

  @override
  Future<Either<Faliuer, void>> toggleContentTag({required int id, required bool isTagged}) async {
    try {
      await apiService.put(
        token: true,
        endpoint: 'contents/$id',
        data: {'content_tag': isTagged},
      );
      return const Right(null);
    } on ServerFailuer catch (failure) {
      return Left(failure);
    } on DioException catch (dioError) {
      return Left(ServerFailuer.fromDioError(dioError));
    } catch (e) {
      return Left(ServerFailuer("Unexpected error: ${e.toString()}"));
    }
  }
}
