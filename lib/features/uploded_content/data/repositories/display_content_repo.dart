import 'package:dartz/dartz.dart';
import 'package:smse/core/error/failuers.dart';
import 'package:smse/features/mainPage/model/content.dart';

abstract class DisplayContentRepo{
  Future<Either<Faliuer,List<ContentModel>>>getContent();
  Future<Either<Faliuer,void>>deleteContent({required int id});
  Future<Either<Faliuer, String>> downloadContent({required int id , required String fileName});
  Future<Either<Faliuer, void>> toggleContentTag({required int id, required bool isTagged});
  Future<Either<Faliuer, void>> uploadFiles(List<String> files);
}