import 'package:dartz/dartz.dart';
import 'package:smse/core/error/failuers.dart';
import 'package:smse/core/network/api/api_service.dart';
import 'package:smse/features/mainPage/model/content.dart';
import 'package:smse/features/uploded_content/data/repositories/display_content_repo.dart';

class DisplayContentRepoImp extends DisplayContentRepo{
  ApiService apiService;

  DisplayContentRepoImp(this.apiService);

  @override
  Future<Either<Faliuer, void>> deleteContent({required int id})async {
    try {
      await apiService.delete(endpoint: 'contents/$id');
      return const Right(null);
    } catch (e) {
      return Left(ServerFailuer( e.toString()));
    }
  }

  @override
  Future<Either<Faliuer, void>> downloadContent({required int id}) {
    // TODO: implement downloadContent
    throw UnimplementedError();
  }

  @override
  Future<Either<Faliuer, List<ContentModel>>> getContent() async{
    try {
      final response = await apiService.get(endpoint: 'contents');
      final List<dynamic> contentData = response['contents'];
      final contents = contentData.map((data) => ContentModel.fromJson(data)).toList();
      return Right(contents);
    } catch (e) {
      return Left(ServerFailuer( e.toString()));
    }
  }

}