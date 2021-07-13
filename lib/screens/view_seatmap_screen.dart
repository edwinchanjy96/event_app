import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ViewSeatmapScreen extends StatelessWidget {
  final String? seatMapUrl;

  const ViewSeatmapScreen({Key? key, this.seatMapUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Hero(
              tag: 'seatmap',
              child: PhotoView(
                imageProvider: NetworkImage(seatMapUrl ?? ''),
              ),
            ),
            Positioned(
              top: 10,
              left: 25,
              child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.arrow_back_ios, color: Colors.white,),
              ),
            )
          ],
        ),
      ),
    );
  }
}
