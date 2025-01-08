import 'package:bloc/bloc.dart';
import 'package:smse/features/mainPage/controller/file_state.dart';
import 'package:smse/features/mainPage/repo/file_uploadrepo.dart';

class FileUploadCubit extends Cubit<FileUploadState> {
  final FileUploadRep fileUploadRepository;

  FileUploadCubit(this.fileUploadRepository) : super(FileUploadInitial());

  Future<void> uploadFiles(List<String> files) async {
    try {
      emit(FileUploadInProgress());

      final response = await fileUploadRepository.uploadFile(
        files,
      );

      response.fold(
            (failure) {
          emit(FileUploadFailure(failure.errMessage));
        },
            (success) {
          emit(FileUploadSuccess(success));
        },
      );
    } catch (e) {
      emit(FileUploadFailure(e.toString()));
    }
  }
}
