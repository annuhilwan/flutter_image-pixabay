import 'package:flutter_image_pixabay/photo_service.dart';
import 'package:flutter/material.dart';

class PhotosPage extends StatefulWidget {
  const PhotosPage({Key? key}) : super(key: key);
  static const String pathId = 'Photos page';

  @override
  State<PhotosPage> createState() => _PhotosPageState();
}

class _PhotosPageState extends State<PhotosPage> {
  PhotosService photosService = PhotosService();
  @override
  void initState() {
    super.initState();
    photosService.getPhotos("coding");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gallery Images Pixabay'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          _getProductTypeList(),
        ]),
      ),
    );
  }

  Widget _buildListItem(
      BuildContext context, AsyncSnapshot<dynamic> snapshot, int index) {
    final photoItem = snapshot.data[index].previewURL;
    print('photoItem is $photoItem');
    return photoCard(photoItem);
  }

  Widget _buildList(BuildContext context, AsyncSnapshot<dynamic> snapshot) {
    var values = snapshot.data;
    return ListView.builder(
      itemCount: snapshot.hasData ? snapshot.data.length : 0,
      itemBuilder: (context, index) {
        return _buildListItem(context, snapshot, index);
      },
    );
  }

  Widget _getProductTypeList() {
    return Expanded(
      child: FutureBuilder(
        future: photosService.getPhotos("coding"),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: LinearProgressIndicator(),
            );
          }
          return _buildList(context, snapshot);
        },
      ),
    );
  }
}

Widget photoCard(String url) {
  
  return Card(    
    child: Row(
      children: [
        Image(
          image: NetworkImage(url),
        ),

        Image(
          image: NetworkImage(url),
        ),       
      ],
    ),
    
  //    Image(
  //     image: NetworkImage(url),
  //   ),
  // 
  );
}