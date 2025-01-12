import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smse/features/uploded_content/data/repositories/display_content_repo.dart';
import 'content_state.dart';

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

  void downloadFile(int id) async {
    emit(const FileDownloading());
    final result = await repository.downloadContent(id: id);
    result.fold(
          (failure) => emit(ContentError(failure.errMessage)),
          (_) => emit(const FileDownloaded()),
    );
  }
}
