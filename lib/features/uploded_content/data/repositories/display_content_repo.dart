import 'package:dartz/dartz.dart';
import 'package:smse/core/error/failuers.dart';
import 'package:smse/features/mainPage/model/content.dart';

abstract class DisplayContentRepo{
  Future<Either<Faliuer,List<ContentModel>>>getContent();
  Future<Either<Faliuer,void>>deleteContent({required int id});
  Future<Either<Faliuer,void>>downloadContent({required int id});

}