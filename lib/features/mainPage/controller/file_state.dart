



import 'package:equatable/equatable.dart';
import 'package:smse/features/mainPage/model/content.dart';

abstract class FileUploadState extends Equatable {
  const FileUploadState();

  @override
  List<Object> get props => [];
}

class FileUploadInitial extends FileUploadState {}

class FileUploadInProgress extends FileUploadState {

}

class FileUploadSuccess extends FileUploadState {
  final ContentModel response;

  const FileUploadSuccess(this.response);

  @override
  List<Object> get props => [response];
}

class FileUploadFailure extends FileUploadState {
  final String error;

  const FileUploadFailure(this.error);

  @override
  List<Object> get props => [error];
}
