import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class PhotoViewerScreen extends StatefulWidget {
  PageController pageController;
  int initialIndex;
  List<dynamic> images;

  PhotoViewerScreen(this.initialIndex, this.images)
      : pageController = PageController(initialPage: initialIndex);

  @override
  _PhotoViewerScreenState createState() => _PhotoViewerScreenState();
}

class _PhotoViewerScreenState extends State<PhotoViewerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffF9C303),
        title: Text("Image View"),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: PhotoViewGallery.builder(
          scrollPhysics: const BouncingScrollPhysics(),
          builder: (BuildContext context, int index) {
            return PhotoViewGalleryPageOptions(
              imageProvider: NetworkImage(widget.images[index]),
              initialScale: PhotoViewComputedScale.contained * 0.8,
              heroAttributes:
                  PhotoViewHeroAttributes(tag: widget.images[index]),
            );
          },
          itemCount: widget.images.length,
          loadingBuilder: (context, event) => Center(
            child: CircularProgressIndicator(
              color: Color(0xffF9C303),
            ),
          ),
          backgroundDecoration: BoxDecoration(color: Colors.white),
          scrollDirection: Axis.horizontal,
          pageController: widget.pageController,
        ),
      ),
    );
  }
}
