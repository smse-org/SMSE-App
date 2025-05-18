import 'package:dartz/dartz.dart';
import 'package:smse/core/error/failuers.dart';
import 'package:smse/features/mainPage/model/content.dart';

abstract class FileUploadRep {
  Future<Either<Faliuer, ContentModel>> uploadFile(List<String> files);
}