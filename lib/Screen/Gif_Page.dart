import 'package:flutter/material.dart';
import '../Providers/Gif_Provider.dart';
import '../Models/ModeloGif.dart';

class GifPage extends StatefulWidget {
  const GifPage({Key? key}) : super(key: key);

  @override
  State<GifPage> createState() => _GifPageState();
}

class _GifPageState extends State<GifPage> {
  final gifsprovider = GifProvider();
  late ScrollController _scrollController;
  List<ModeloGif> _loadedGifs = [];
  int _perPage = 20;
  int _startIndex = 0;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_loadMoreGifs);
    _loadGifs();
  }

  void _loadGifs() async {
    if (!_isLoading) {
      setState(() {
        _isLoading = true;
      });

      final newGifs = await gifsprovider.getMoreGifs(_perPage, _startIndex);
      setState(() {
        _loadedGifs.addAll(newGifs);
        _startIndex += newGifs.length;
        _isLoading = false;
      });
    }
  }

  void _loadMoreGifs() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadGifs();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Container(
        child: GridView.builder(
          controller: _scrollController,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
          ),
          itemCount: _loadedGifs.length,
          itemBuilder: (context, index) {
            final gif = _loadedGifs[index];
            final url = gif.images?.downsized?.url;
            return Card(
              child: Image.network(
                url ?? '',
                fit: BoxFit.fill,
              ),
            );
          },
        ),
      ),
    ));
  }
}

List<Widget> ListGifs(List<ModeloGif> data) {
  List<Widget> gifs = [];
  for (var gif in data) {
    final String url = gif.images?.downsized?.url as String;
    gifs.add(
      Card(
        child: Column(
          children: <Widget>[
            Expanded(
                child: Image.network(
              url,
              fit: BoxFit.fill,
            ))
          ],
        ),
      ),
    );
  }

  return gifs;
}
