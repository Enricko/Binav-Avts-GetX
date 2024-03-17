import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

class FlutterMapZoomButtons extends StatelessWidget {
  final double minZoom;
  final double maxZoom;
  final bool mini;
  final double padding;
  final Alignment alignment;
  final Color? zoomInColor;
  final Color? zoomInColorIcon;
  final Color? zoomOutColor;
  final Color? zoomOutColorIcon;
  final IconData zoomInIcon;
  final IconData zoomOutIcon;

  static const _fitBoundsPadding = EdgeInsets.all(12);

  const FlutterMapZoomButtons({
    super.key,
    this.minZoom = 1,
    this.maxZoom = 18,
    this.mini = true,
    this.padding = 2.0,
    this.alignment = Alignment.topRight,
    this.zoomInColor,
    this.zoomInColorIcon,
    this.zoomInIcon = Icons.zoom_in,
    this.zoomOutColor,
    this.zoomOutColorIcon,
    this.zoomOutIcon = Icons.zoom_out,
  });

  @override
  Widget build(BuildContext context) {
    final map = MapCamera.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        // IconButton(onPressed: (){}, icon: Icon(Icons.location_pin)),
        Tooltip(
          message: "Zoom In",
          child: Padding(
            padding: EdgeInsets.only(left: padding, top: padding,right: padding),
            child: FloatingActionButton(
              heroTag: 'zoomInButton',
              mini: mini,
              backgroundColor: zoomInColor ?? Colors.white,
              onPressed: () {
                final paddedMapCamera = CameraFit.bounds(
                  bounds: map.visibleBounds,
                  padding: _fitBoundsPadding,
                ).fit(map);
                var zoom = paddedMapCamera.zoom + 1;
                if (zoom > maxZoom) {
                  zoom = maxZoom;
                }
                MapController.of(context).move(paddedMapCamera.center, zoom);
              },
              child: Icon(zoomInIcon, color: zoomInColorIcon ?? IconTheme.of(context).color),
            ),
          ),
        ),
        Tooltip(
          message: "Zoom Out",
          child: Padding(
            padding: EdgeInsets.all(padding),
            child: FloatingActionButton(
              heroTag: 'zoomOutButton',
              mini: mini,
              backgroundColor: zoomOutColor ?? Colors.white,
              onPressed: () {
                final paddedMapCamera = CameraFit.bounds(
                  bounds: map.visibleBounds,
                  padding: _fitBoundsPadding,
                ).fit(map);
                var zoom = paddedMapCamera.zoom - 1;
                if (zoom < minZoom) {
                  zoom = minZoom;
                }
                MapController.of(context).move(paddedMapCamera.center, zoom);
              },
              child: Icon(zoomOutIcon, color: zoomOutColorIcon ?? IconTheme.of(context).color),
            ),
          ),
        ),
      ],
    );
  }
}
