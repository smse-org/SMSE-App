import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smse/features/uploded_content/data/repositories/display_content_repo.dart';
import 'package:smse/features/uploded_content/presentation/controller/cubit/content_state.dart';

class ContentCubit extends Cubit<ContentState> {
  final DisplayContentRepo repository;

  ContentCubit(this.repository) : super(const ContentInitial());

  void fetchContents() async {
    emit(const ContentLoading());
    final result = await repository.getContent();
    result.fold(
          (failure) => emit(ContentError(failure.errMessage)),
          (contents) => emit(ContentLoaded(contents)),
    );
  }

  void deleteContent(int id) async {
    emit(const ContentDeleting());
    final result = await repository.deleteContent(id: id);
    result.fold(
          (failure) => emit(ContentError(failure.errMessage)),
          (_) => emit(const ContentDeleted()),
    );
    fetchContents(); // Refresh contents after deletion
  }

  void downloadFile(int id, String fileName) async {
    emit(const FileDownloading(0)); // Emit initial download state (0%)

    final result = await repository.downloadContent(id: id, fileName: fileName);

    result.fold(
          (failure) => emit(ContentError(failure.errMessage)), // Emit error if download fails
          (filePath) => emit(FileDownloaded(filePath)), // Emit success state with file path
    );
  }

  void toggleContentTag(int id, bool isTagged) async {
    emit(const ContentTagging());
    final result = await repository.toggleContentTag(id: id, isTagged: isTagged);
    result.fold(
          (failure) => emit(ContentError(failure.errMessage)),
          (_) => emit(const ContentTagged()),
    );
    fetchContents(); // Refresh contents after tagging
  }

  Future<void> uploadFiles(List<String> files) async {
    emit(const ContentUploading());
    final result = await repository.uploadFiles(files);
    result.fold(
      (failure) => emit(ContentError(failure.errMessage)),
      (_) => emit(const ContentUploaded()),
    );
  }

  Future<String> getThumbnail(int id) async {
    final result = await repository.getThumbnail(id);
    return result.fold(
      (failure) => throw Exception(failure.errMessage),
      (thumbnail) => thumbnail,
    );
  }
}

