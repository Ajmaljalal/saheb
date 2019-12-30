import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../widgets/imageRenderer.dart';

class GridViewImageRenderer extends StatelessWidget {
  final List images;
  GridViewImageRenderer({this.images});
  @override
  Widget build(BuildContext context) {
    return StaggeredGridView.count(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      crossAxisCount: 4,
      children: images.map<Widget>((image) {
        return singleImageRenderer(image, context, 250.0, BoxFit.fill);
      }).toList(),
      staggeredTiles: [...buildTiles(images.length)],
      mainAxisSpacing: 2.0,
      crossAxisSpacing: 2.0, // add some space
    );
  }

  List<dynamic> buildTiles(count) {
    List tiles;
    if (count == 1) {
      tiles = [StaggeredTile.count(4, 4)];
    }
    if (count == 2) {
      tiles = [
        StaggeredTile.count(2, 2),
        StaggeredTile.count(2, 2),
      ];
    }

    if (count == 3) {
      tiles = [
        StaggeredTile.count(4, 2),
        StaggeredTile.count(2, 2),
        StaggeredTile.count(2, 2),
      ];
    }

    if (count == 4) {
      tiles = [
        StaggeredTile.count(2, 2),
        StaggeredTile.count(2, 2),
        StaggeredTile.count(2, 2),
        StaggeredTile.count(2, 2),
      ];
    }

    if (count == 5) {
      tiles = [
        StaggeredTile.count(2, 2),
        StaggeredTile.count(1, 1),
        StaggeredTile.count(1, 1),
        StaggeredTile.count(1, 1),
        StaggeredTile.count(1, 1),
      ];
    }

    if (count == 6) {
      tiles = [
        StaggeredTile.count(2, 2),
        StaggeredTile.count(2, 2),
        StaggeredTile.count(1, 1),
        StaggeredTile.count(1, 1),
        StaggeredTile.count(1, 1),
        StaggeredTile.count(1, 1),
      ];
    }
    return tiles;
  }
}
