import 'package:equatable/equatable.dart';
import 'package:smse/features/mainPage/model/content.dart';

abstract class ContentState extends Equatable {
  const ContentState();

  @override
  List<Object?> get props => [];
}

// Initial State
class ContentInitial extends ContentState {
  const ContentInitial();
}

// Loading Contents
class ContentLoading extends ContentState {
  const ContentLoading();
}

// Successfully Loaded Contents
class ContentLoaded extends ContentState {
  final List<ContentModel> contents;

  const ContentLoaded(this.contents);

  @override
  List<Object?> get props => [contents];
}

// Error Handling
class ContentError extends ContentState {
  final String message;

  const ContentError(this.message);

  @override
  List<Object?> get props => [message];
}

// Content Deletion States
class ContentDeleting extends ContentState {
  const ContentDeleting();
}

class ContentDeleted extends ContentState {
  const ContentDeleted();
}

// File Download States
class FileDownloading extends ContentState {
  final double progress; // Added progress tracking

  const FileDownloading(this.progress);

  @override
  List<Object?> get props => [progress];
}

class FileDownloaded extends ContentState {
  final String filePath; // Added file path to open the file

  const FileDownloaded(this.filePath);

  @override
  List<Object?> get props => [filePath];
}
