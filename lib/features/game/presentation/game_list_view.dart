import 'package:bloc_tutorial/assets/app_color.dart';
import 'package:bloc_tutorial/assets/app_string.dart';
import 'package:bloc_tutorial/features/game/bloc/list_api_bloc/list_api_bloc.dart';
import 'package:bloc_tutorial/features/game/bloc/user_click_bloc/user_click_bloc.dart';
import 'package:bloc_tutorial/features/game/model/game_response.dart';
import 'package:bloc_tutorial/features/game/presentation/game_detail_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GameListView extends StatefulWidget {
  const GameListView({Key? key}) : super(key: key);
  @override
  State<GameListView> createState() => _GameListViewState();
}

class _GameListViewState extends State<GameListView> {
  late ListAPIBloc _listAPIBloc;
  late UserClickBloc _userClickBloc;

  ScrollController _scrollController = new ScrollController();
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _listAPIBloc = BlocProvider.of<ListAPIBloc>(context);
    _userClickBloc = BlocProvider.of<UserClickBloc>(context);

    _searchController.addListener(_printSearchQuery);

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _getMoreData();
      }
    });
  }

  void _printSearchQuery() {
    print('Search Query : ${_searchController.text}');
    _listAPIBloc.add(FetchedListAPISearchLoadMore(_searchController.text));
  }

  void _getMoreData() {
    print("load more date...");
    _listAPIBloc.add(FetchedListAPISearchLoadMore(_searchController.text));
  }

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
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                child: showSearchBar(),
              ),
              Expanded(
                child: showMovieList(),
              )
            ],
          ),
        ));
  }

  Widget showMovieList() {
    return BlocBuilder<ListAPIBloc, ListAPIState>(builder: (context, state) {
      print("state now: " + state.toString());
      if (state is ListAPIInitial) {
        _listAPIBloc.add(FetchedListAPISearch(_searchController.text));
        return showLoader();
      } else if (state is ListAPILoaded) {
        return ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(), // new
          controller: _scrollController,
          itemExtent: 80,
          itemCount: state.results.length + 1,
          itemBuilder: (BuildContext context, int index) {
            if (index == state.results.length) {
              //showing loader at the bottom of list
              return showLoader();
            }
            return showListItemSelected(state.results[index]);
          },
        );
        return Container();
      } else {
        return const CircularProgressIndicator();
      }
    });
  }

  Widget showListItemSelected(Result result) {
    return BlocBuilder<UserClickBloc, UserClickState>(
        builder: (context, state) {
      if (state is UserClickNotActive) {
        return GestureDetector(
          child: ListTile(
            leading: showImageMovie(result.backgroundImage.toString()),
            title: Text(result.name.toString()),
            subtitle: Text(result.rating.toString()),
            trailing: Text(result.released.toString().split(" ")[0]),
          ),
          onTap: () {
            navigateToOtherPage(result);
            _userClickBloc.add(UserClickListEvent(result));
          },
        );
      } else if (state is UserClickActive) {
        return GestureDetector(
          child: ListTile(
            tileColor: state.result.id == result.id
                ? AppColors.itemSelected
                : Colors.transparent,
            leading: showImageMovie(result.backgroundImage.toString()),
            title: Text(result.name.toString()),
            subtitle: Text(result.rating.toString()),
            trailing: Text(result.released.toString().split(" ")[0]),
          ),
          onTap: () {
            navigateToOtherPage(result);
            _userClickBloc.add(UserClickListEvent(result));
          },
        );
      } else {
        return GestureDetector(
          child: ListTile(
            leading: showImageMovie(result.backgroundImage.toString()),
            title: Text(result.name.toString()),
            subtitle: Text(result.rating.toString()),
            trailing: Text(result.released.toString().split(" ")[0]),
          ),
          onTap: () {
            navigateToOtherPage(result);
            _userClickBloc.add(UserClickListEvent(result));
          },
        );
      }
    });
  }

  Widget showImageMovie(String imgUrl) {
    return CircleAvatar(
        radius: 52.0,
        child: ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: Image.network(
              imgUrl,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
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
            )));
  }

  Widget showSearchBar() {
    return Center(
      child: Container(
        margin: EdgeInsets.all(16),
        child: TextField(
          autofocus: false,
          style: TextStyle(fontSize: 15.0, color: AppColors.black),
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: 'search..',
            filled: true,
            fillColor: AppColors.primaryThemeLight,
            contentPadding:
                const EdgeInsets.only(left: 14.0, bottom: 6.0, top: 8.0),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.primaryTheme),
              borderRadius: BorderRadius.circular(10.0),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          controller: _searchController,
        ),
      ),
    );
  }

  Widget showLoader() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  void navigateToOtherPage(Result _resultDetail) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => GameDetailView(resultDetail: _resultDetail)));
  }
}
