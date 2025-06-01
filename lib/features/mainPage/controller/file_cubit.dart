import 'package:bloc/bloc.dart';
import 'package:smse/features/mainPage/controller/file_state.dart';
import 'package:smse/features/mainPage/repo/file_uploadrepo.dart';

class FileUploadCubit extends Cubit<FileUploadState> {
  final FileUploadRep fileUploadRepository;

  FileUploadCubit(this.fileUploadRepository) : super(FileUploadInitial());

  Future<void> uploadFiles(List<String> files) async {
    try {
      print('Starting file upload process with ${files.length} files');
      emit(const FileUploadInProgress(progress: 0.0));

      for (int i = 0; i < files.length; i++) {
        print('Uploading file ${i + 1}/${files.length}: ${files[i]}');
        final response = await fileUploadRepository.uploadFile([files[i]]);
        
        // Calculate progress
        final progress = (i + 1) / files.length;
        print('Upload progress: ${(progress * 100).toStringAsFixed(1)}%');
        emit(FileUploadInProgress(progress: progress));

        response.fold(
          (failure) {
            print('Upload failed: ${failure.errMessage}');
            emit(FileUploadFailure(failure.errMessage));
            return;
          },
          (success) {
            print('File ${i + 1} uploaded successfully');
            if (i == files.length - 1) {
              print('All files uploaded successfully');
              emit(FileUploadSuccess(success));
            }
          },
        );
      }
    } catch (e) {
      print('Error during upload: $e');
      emit(FileUploadFailure(e.toString()));
    }
  }
}
