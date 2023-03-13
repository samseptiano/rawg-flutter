import 'package:bloc_tutorial/features/game/domain/api_service.dart';
import 'package:bloc_tutorial/features/game/model/game_response.dart';

class GameRepositoryImpl implements GameRepository {
  APIService service = APIService();

  @override
  Future<List<Result>> fetchDataImpl(String _search, int _page, int _pageSize) {
    return service.fetchData(_search, _page, _pageSize);
  }
}

abstract class GameRepository {
  Future<List<Result>> fetchDataImpl(String _search, int _page, int _pageSize);
}
