import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyGallery(),
    );
  }
}

class MyGallery extends StatefulWidget {
  @override
  _MyGalleryState createState() => _MyGalleryState();
}

class _MyGalleryState extends State<MyGallery> {
  List<ImageData> _imageDataList = [];
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchImages("coding");
  }

  Future<void> _fetchImages(String query) async {
    String apiKey = "43463592-4ea98384e733f897c8c32110d";
    String url = "https://pixabay.com/api/?key=$apiKey&q=$query&image_type=photo";

    try {
      final response = await http.get(Uri.parse(url));
      final data = json.decode(response.body);

      if (data['hits'] != null) {
        List<ImageData> imageDataList = [];
        for (var image in data['hits']) {
          imageDataList.add(ImageData(
            imageUrl: image['largeImageURL'],
            likes: image['likes'],
            views: image['views'],
          ));
        }
        setState(() {
          _imageDataList = imageDataList;
        });
      }
    } catch (e) {
      print("Error fetching images: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          onSubmitted: (value) {
            _fetchImages(value);
          },
          decoration: InputDecoration(
            hintText: 'Search images',
          ),
        ),
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 4.0,
          mainAxisSpacing: 4.0,
        ),
        itemCount: _imageDataList.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FullScreenImage(imageData: _imageDataList[index]),
                ),
              );
            },
            child: Image.network(
              _imageDataList[index].imageUrl,
              fit: BoxFit.cover,
            ),               
   
          );
        
        },
      ),
    );
  }
}

class FullScreenImage extends StatelessWidget {
  final ImageData imageData;

  const FullScreenImage({Key? key, required this.imageData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              imageData.imageUrl,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 16),
            Text('Likes: ${imageData.likes}'),
            Text('Views: ${imageData.views}'),
          ],
        ),
      ),
    );
  }
}

class ImageData {
  final String imageUrl;
  final int likes;
  final int views;

  ImageData({
    required this.imageUrl,
    required this.likes,
    required this.views,
  });
}
