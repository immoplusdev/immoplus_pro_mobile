import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus_pro/utils/utils.dart';
import 'package:photo_view/photo_view_gallery.dart';

class ViewerImageLogment extends StatelessWidget {
  ViewerImageLogment(
      {Key? key,
      required this.tag,
      required this.imageUrls,
      this.initialPage = 0})
      : super(key: key);

  final String tag;
  final int initialPage;
  final List<String>? imageUrls;
  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: tag,
      child: Scaffold(
        appBar: AppBar(
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundColor: CupertinoColors.systemFill,
              child: IconButton(
                icon: Icon(
                  CupertinoIcons.chevron_left,
                  color: Colors.white,
                ),
                onPressed: () {
                  context.pop();
                },
              ),
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        extendBodyBehindAppBar: true,
        body: PhotoViewGallery(
          loadingBuilder: (context, event) => Container(
            color: Colors.black,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
          pageController: PageController(
            initialPage: initialPage,
          ),
          pageOptions: imageUrls!
              .map((image) => PhotoViewGalleryPageOptions(
                    imageProvider: CachedNetworkImageProvider(
                        Utils.getImagePath(id: image)),
                  ))
              .toList(),
        ),
      ),
    );
  }
}
