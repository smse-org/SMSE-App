import 'package:equatable/equatable.dart';
import 'package:smse/features/mainPage/model/content.dart';

abstract class ContentState extends Equatable {
  const ContentState();

  @override
  List<Object?> get props => [];
}

class ContentInitial extends ContentState {
  const ContentInitial();
}

class ContentLoading extends ContentState {
  const ContentLoading();
}

class ContentLoaded extends ContentState {
  final List<ContentModel> contents;

  const ContentLoaded(this.contents);

  @override
  List<Object?> get props => [contents];
}

class ContentError extends ContentState {
  final String message;

  const ContentError(this.message);

  @override
  List<Object?> get props => [message];
}

class ContentDeleting extends ContentState {
  const ContentDeleting();
}

class ContentDeleted extends ContentState {
  const ContentDeleted();
}

class FileDownloading extends ContentState {
  const FileDownloading();
}

class FileDownloaded extends ContentState {
  const FileDownloaded();
}
