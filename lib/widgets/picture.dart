import 'package:flutter/material.dart';

class Picture extends StatefulWidget {
  final String? imgUrl;
  final double width;
  final double height;

  const Picture(
      {Key? key,
      required this.imgUrl,
      required this.width,
      required this.height})
      : super(key: key);

  @override
  State<Picture> createState() => _PictureState();
}

class _PictureState extends State<Picture> {
  @override
  Widget build(BuildContext context) {
    return widget.imgUrl == null
        ? Container(
            height: widget.height,
            width: widget.width,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/profile_picture.png"),
                    fit: BoxFit.cover)),
          )
        : Image.network(
            widget.imgUrl!,
            width: widget.width,
            height: widget.height,
            fit: BoxFit.cover,
            loadingBuilder: imageLoadingBuilder,
          );
  }

  Widget imageLoadingBuilder(BuildContext context, Widget child,
          ImageChunkEvent? loadingProgress) =>
      loadingProgress == null
          ? child
          : CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                  : null,
            );
}
