import 'package:bloc_tutorial/features/game/model/game_response.dart';
import 'package:http/http.dart' as http;

class APIService {
  final String _baseUrl = "https://api.rawg.io/api/";
  final String _apiKey = 'ac911495e1944667a61bd51d9d1b7e3a';

  Future<List<Result>> fetchData(String _search, int _page, int _pageSize) async {
    String fullURL = "${_baseUrl}games?key=${_apiKey}&page_size=${_pageSize}&page=${_page}&search=${_search}";
    print("URL : "+fullURL);
    http.Response response =
        await http.get(Uri.parse(fullURL));
    print("response code: "+response.statusCode.toString());
    if (response.statusCode == 200) {
        print("response dari API : "+response.body);
        final gameResponse = gameResponseFromJson(response.body);
        return gameResponse.results;
    } else {
      throw Exception('Failed to load todos');
    }
  }


}
