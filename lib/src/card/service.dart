/*
 * Copyright (c) TIKI Inc.
 * MIT license. See LICENSE file in root directory.
 */

import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import '../../info_carousel.dart';
import '../container/service.dart';
import 'controller.dart';
import 'presenter.dart';

class InfoCarouselCardService extends ChangeNotifier {
  late final InfoCarouselCardPresenter presenter;
  late final InfoCarouselCardModel model;
  late final InfoCarouselCardController controller;
  late final InfoCarouselService infoCarouselService;

  InfoCarouselCardService(
      {required dynamic card, required this.infoCarouselService}) {
    presenter = InfoCarouselCardPresenter(this);
    controller = InfoCarouselCardController(this);
    if (card != null) {
      model = InfoCarouselCardModel.fromDynamic(card);
    }
  }

  shareCard(String message, ui.Image image) async {
    bool permission = await requestPermission(Permission.storage);
    if (permission) {
      ByteData bytes = (await image.toByteData())!;
      var buffer = bytes.buffer;
      Uint8List pngBytes = buffer.asUint8List();
      Directory directory;
      if (Platform.isIOS) {
        directory = await getApplicationDocumentsDirectory();
      } else {
        directory = (await getExternalStorageDirectory())!;
      }
      String path = directory.path + '/tikishare.png';
      File imgFile = File(path);
      imgFile.writeAsBytesSync(pngBytes, flush: true);
      Share.shareFiles(
        [path],
        text: message,
      );
    }
  }

  static Future<bool> requestPermission(Permission permission) async {
      if (await permission.isGranted) {
        return true;
      } else {
        PermissionStatus result = await permission.request();
        if (result.isGranted) return true;
      }
      return false;
    }
}
