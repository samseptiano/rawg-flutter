import 'package:bloc_tutorial/assets/app_color.dart';
import 'package:bloc_tutorial/assets/app_string.dart';
import 'package:bloc_tutorial/features/game/model/game_response.dart';
import 'package:flutter/material.dart';

class GameDetailView extends StatefulWidget {
  late Result resultDetail;

  GameDetailView({required this.resultDetail});

  @override
  State<GameDetailView> createState() => _GameDetailViewState();
}

class _GameDetailViewState extends State<GameDetailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppString().AppName),
        actions: <Widget>[
          SizedBox(
              height: 38.0,
              width: 38.0,
              child: new IconButton(
                icon: new Image.asset('images/icon_image.png'),
                onPressed: () {
                  // do something
                },
              ))
        ],
      ),
      body: Container(
        child: Stack(
          children: [
            Container(
              child: Image.network(
                widget.resultDetail.backgroundImage.toString(),
                fit: BoxFit.fill,
                height: double.infinity,
                width: double.infinity,
                alignment: Alignment.center,
                loadingBuilder: (BuildContext context, Widget child,
                    ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  );
                },
                color: Colors.black45,
                colorBlendMode: BlendMode.darken,
              ),
            ),
            Container(
              padding: EdgeInsets.all(16),
              child: Container(
                  child: Text(
                widget.resultDetail.name.toString(),
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 40,
                    color: AppColors.black,
                    shadows: [
                      Shadow(
                          // bottomLeft
                          offset: Offset(-1.5, -1.5),
                          color: AppColors.primaryTheme),
                      Shadow(
                          // bottomRight
                          offset: Offset(1.5, -1.5),
                          color: AppColors.primaryTheme),
                      Shadow(
                          // topRight
                          offset: Offset(1.5, 1.5),
                          color: AppColors.black),
                      Shadow(
                          // topLeft
                          offset: Offset(-1.5, 1.5),
                          color: AppColors.primaryTheme),
                    ]),
              )),
            ),
          ],
        ),
      ),
    );
  }
}
