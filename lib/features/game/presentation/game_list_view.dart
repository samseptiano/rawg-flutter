import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:bloc_tutorial/assets/app_color.dart';
import 'package:bloc_tutorial/assets/app_string.dart';
import 'package:bloc_tutorial/features/game/bloc/list_api_bloc/list_api_bloc.dart';
import 'package:bloc_tutorial/features/game/bloc/user_click_bloc/user_click_bloc.dart';
import 'package:bloc_tutorial/features/game/model/game_response.dart';
import 'package:bloc_tutorial/features/game/presentation/my_animated_widget.dart';
import 'package:bloc_tutorial/features/game/presentation/game_detail_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GameListView extends StatefulWidget {
  const GameListView({Key? key}) : super(key: key);
  @override
  State<GameListView> createState() => _GameListViewState();
}

class _GameListViewState extends State<GameListView>
    with SingleTickerProviderStateMixin {
  late ListAPIBloc _listAPIBloc;
  late UserClickBloc _userClickBloc;

  late Animation<double> animation;
  late AnimationController animationController;
  late Animation colorAnimation;

  ScrollController _scrollController = new ScrollController();
  final _searchController = TextEditingController();

  File? _image;

  // This is the image picker
  final _picker = ImagePicker();

  // Implementing the image picker
  Future<void> _openImagePicker() async {
    final XFile? pickedImage =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
    }
  }

  //============================================================ file picker web ====================================

  // Variable to hold the selected image file
  PlatformFile? _imageFile;

  // Method to pick and display an image file
  Future<void> _pickImage() async {
    try {
      // Pick an image file using file_picker package
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
      );

      // If user cancels the picker, do nothing
      if (result == null) return;

      // If user picks an image, update the state with the new image file
      setState(() {
        _imageFile = result.files.first;
      });
    } catch (e) {
      // If there is an error, show a snackbar with the error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
  }
  //=================================================================================================================

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    animationController =
        AnimationController(duration: const Duration(seconds: 10), vsync: this);
    colorAnimation = ColorTween(begin: Colors.blue, end: Colors.yellow)
        .animate(animationController);
    animation =
        Tween<double>(begin: 100.0, end: 200.0).animate(animationController);

    animationController.forward();

    animationController.addListener(() {
      setState(() {});
    });

    _listAPIBloc = BlocProvider.of<ListAPIBloc>(context);
    _userClickBloc = BlocProvider.of<UserClickBloc>(context);

    _searchController.addListener(_printSearchQuery);

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _getMoreData();
      }
      // print("scrolling: ${_scrollController.position.pixels} ${ _scrollController.position.maxScrollExtent}");
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
            FadeTransition(
              child: SizedBox(
                  height: 38.0,
                  width: 38.0,
                  child: new IconButton(
                    icon: new Image.asset('images/icon_image.png'),
                    onPressed: () {
                      // do something
                    },
                    color: colorAnimation.value,
                  )),
              opacity: animation,
            )
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
                child: 
                SingleChildScrollView(
                controller: _scrollController,
                child: Expanded(child: Column(
                  children: <Widget>[buttonImagePicker(), showMovieList()],
                )),
              )
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
          shrinkWrap: true,
          physics: const AlwaysScrollableScrollPhysics(), // new
          // controller: _scrollController,
          itemExtent: 80,
          itemCount: state.results.length + 1,
          itemBuilder: (BuildContext context, int index) {
            print("loading showed with index ${index}");
             if (index == state.results.length) {
              //showing loader at the bottom of list
              print("loading showed here");
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
            animationController.reset();
            animationController.forward();
            navigateToOtherPage(result);
            // _userClickBloc.add(UserClickListEvent(result));
          },
        );
      } else if (state is UserClickActive) {
        return GestureDetector(
          child: ListTile(
            tileColor: state.result.id == result.id
                ? colorAnimation.value
                : Colors.transparent,
            leading: showImageMovie(result.backgroundImage.toString()),
            title: Text(result.name.toString()),
            subtitle: Text(result.rating.toString()),
            trailing: Text(result.released.toString().split(" ")[0]),
          ),
          onTap: () {
            animationController.reset();
            animationController.forward();
            navigateToOtherPage(result);
            // _userClickBloc.add(UserClickListEvent(result));
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
            animationController.reset();
            animationController.forward();
            navigateToOtherPage(result);
            // _userClickBloc.add(UserClickListEvent(result));
          },
        );
      }
    });
  }

  Widget buttonImagePicker() {
    return Column(children: [
      GestureDetector(
          onTap: () {
            _pickImage();
          },
          child: Container(
              alignment: Alignment.center,
              width: double.infinity,
              height: 300,
              color: Colors.grey[300],
              child: _imageFile != null
                  ? Image.memory(
                      Uint8List.fromList(_imageFile!.bytes!),
                      width: double.infinity,
                      height: 250,
                      fit: BoxFit.cover,
                    )
                  : const Text('Please select an image'))),
      const SizedBox(height: 35),
      // The picked image for mobile version will be displayed here
      // Container(
      //   alignment: Alignment.center,
      //   width: double.infinity,
      //   height: 300,
      //   color: Colors.grey[300],
      //   child: _image != null
      //       ? Image.file(_image!, fit: BoxFit.cover)
      //       : const Text('Please select an image'),
      // )
    ]);
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
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => GameDetailView(resultDetail: _resultDetail)));
  }
}
