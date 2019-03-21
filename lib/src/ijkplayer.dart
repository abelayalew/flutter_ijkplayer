import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'error.dart';
import 'logutil.dart';
import 'video_info.dart';
import 'widget/controller_widget_builder.dart';
import 'widget/ijkplayer_builder.dart';

part 'controller.dart';

part 'ijk_event_channel.dart';

part 'manager.dart';

/// Main Classes of Library
class IjkPlayer extends StatefulWidget {
  final IjkMediaController mediaController;
  final ControllerWidgetBuilder controllerWidgetBuilder;
  final PlayerBuilder playerBuilder;

  /// Main Classes of Library
  const IjkPlayer({
    Key key,
    @required this.mediaController,
    this.controllerWidgetBuilder = defaultBuildIjkControllerWidget,
    this.playerBuilder = buildDefaultIjkPlayer,
  }) : super(key: key);

  @override
  IjkPlayerState createState() => IjkPlayerState();
}

/// state of ijkplayer
class IjkPlayerState extends State<IjkPlayer> {
  /// see [IjkMediaController]
  IjkMediaController controller;

  @override
  void initState() {
    super.initState();
    controller = widget.mediaController ?? IjkMediaController();
  }

  @override
  void didUpdateWidget(IjkPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var video = StreamBuilder<int>(
      stream: controller.textureIdStream,
      initialData: controller.textureId,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container();
        }
        var id = snapshot.data;
        return StreamBuilder<VideoInfo>(
            stream: controller.videoInfoStream,
            builder: (context, videoInfoSnapShot) {
              return _buildTexture(id, videoInfoSnapShot.data);
            });
      },
    );
    var controllerWidget = widget.controllerWidgetBuilder?.call(controller);
    Widget stack = Stack(
      children: <Widget>[
        IgnorePointer(child: video),
        controllerWidget,
      ],
    );
    return stack;
  }

  Widget _buildTexture(int id, VideoInfo info) {
    if (widget?.playerBuilder != null) {
      return widget.playerBuilder.call(context, controller, info);
    }

    if (id == null) {
      return Container(
        color: Colors.black,
      );
    }

    return Container(
      color: Colors.black,
      child: Texture(
        textureId: id,
      ),
    );
  }
}
