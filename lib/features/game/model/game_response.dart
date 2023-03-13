// To parse this JSON data, do
//
//     final gameResponse = gameResponseFromJson(jsonString);

import 'dart:convert';

GameResponse gameResponseFromJson(String str) => GameResponse.fromJson(json.decode(str));

String gameResponseToJson(GameResponse data) => json.encode(data.toJson());

class GameResponse {
    GameResponse({
        required this.count,
        required this.next,
        this.previous,
        required this.results,
        required this.seoTitle,
        required this.seoDescription,
        required this.seoKeywords,
        required this.seoH1,
        required this.noindex,
        required this.nofollow,
        required this.description,
    });

    int? count;
    String? next;
    String? previous;
    List<Result> results;
    String? seoTitle;
    String? seoDescription;
    String? seoKeywords;
    String? seoH1;
    bool? noindex;
    bool? nofollow;
    String? description;

    factory GameResponse.fromJson(Map<String, dynamic> json) => GameResponse(
        count: json["count"],
        next: json["next"],
        previous: json["previous"],
        results: List<Result>.from(json["results"].map((x) => Result.fromJson(x))),
        seoTitle: json["seo_title"],
        seoDescription: json["seo_description"],
        seoKeywords: json["seo_keywords"],
        seoH1: json["seo_h1"],
        noindex: json["noindex"],
        nofollow: json["nofollow"],
        description: json["description"],
    );

    Map<String, dynamic> toJson() => {
        "count": count,
        "next": next,
        "previous": previous,
        "results": List<dynamic>.from(results.map((x) => x.toJson())),
        "seo_title": seoTitle,
        "seo_description": seoDescription,
        "seo_keywords": seoKeywords,
        "seo_h1": seoH1,
        "noindex": noindex,
        "nofollow": nofollow,
        "description": description,
    };
}

class Result {
    Result({
        required this.id,
        required this.slug,
        required this.name,
        required this.released,
        required this.tba,
        required this.backgroundImage,
        required this.rating,
        required this.ratingTop,
        required this.ratings,
        required this.ratingsCount,
        required this.reviewsTextCount,
        required this.added,
        required this.metacritic,
        required this.playtime,
        required this.suggestionsCount,
        required this.updated,
        this.userGame,
        required this.reviewsCount,
        required this.saturatedColor,
        required this.dominantColor,
        required this.genres,
    });

    int? id;
    String? slug;
    String? name;
    DateTime? released;
    bool? tba;
    String? backgroundImage;
    double? rating;
    int? ratingTop;
    List<Rating> ratings;
    int? ratingsCount;
    int? reviewsTextCount;
    int? added;
    int? metacritic;
    int? playtime;
    int? suggestionsCount;
    DateTime? updated;
    String? userGame;
    int? reviewsCount;
    String? saturatedColor;
    String? dominantColor;
    List<Genre> genres;

    factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json["id"],
        slug: json["slug"],
        name: json["name"],
        released: DateTime.parse(json["released"]),
        tba: json["tba"],
        backgroundImage: json["background_image"],
        rating: json["rating"]?.toDouble(),
        ratingTop: json["rating_top"],
        ratings: List<Rating>.from(json["ratings"].map((x) => Rating.fromJson(x))),
        ratingsCount: json["ratings_count"],
        reviewsTextCount: json["reviews_text_count"],
        added: json["added"],
        metacritic: json["metacritic"],
        playtime: json["playtime"],
        suggestionsCount: json["suggestions_count"],
        updated: DateTime.parse(json["updated"]),
        userGame: json["user_game"],
        reviewsCount: json["reviews_count"],
        saturatedColor: json["saturated_color"],
        dominantColor: json["dominant_color"],
        genres: List<Genre>.from(json["genres"].map((x) => Genre.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "slug": slug,
        "name": name,
        "released": "${released?.year.toString().padLeft(4, '0')}-${released?.month.toString().padLeft(2, '0')}-${released?.day.toString().padLeft(2, '0')}",
        "tba": tba,
        "background_image": backgroundImage,
        "rating": rating,
        "rating_top": ratingTop,
        "ratings": List<dynamic>.from(ratings.map((x) => x.toJson())),
        "ratings_count": ratingsCount,
        "reviews_text_count": reviewsTextCount,
        "added": added,
        "metacritic": metacritic,
        "playtime": playtime,
        "suggestions_count": suggestionsCount,
        "updated": updated?.toIso8601String(),
        "user_game": userGame,
        "reviews_count": reviewsCount,
        "saturated_color": saturatedColor,
        "dominant_color": dominantColor,
        "genres": List<dynamic>.from(genres.map((x) => x.toJson())),
    };
}

class Genre {
    Genre({
        required this.id,
        required this.name,
        required this.slug,
        required this.gamesCount,
        required this.imageBackground,
    });

    int? id;
    String? name;
    String? slug;
    int? gamesCount;
    String? imageBackground;

    factory Genre.fromJson(Map<String, dynamic> json) => Genre(
        id: json["id"],
        name: json["name"],
        slug: json["slug"],
        gamesCount: json["games_count"],
        imageBackground: json["image_background"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "slug": slug,
        "games_count": gamesCount,
        "image_background": imageBackground,
    };
}

class Rating {
    Rating({
        required this.id,
        required this.title,
        required this.count,
        required this.percent,
    });

    int? id;
    String? title;
    int? count;
    double? percent;

    factory Rating.fromJson(Map<String, dynamic> json) => Rating(
        id: json["id"],
        title: json["title"],
        count: json["count"],
        percent: json["percent"]?.toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "count": count,
        "percent": percent,
    };
}
