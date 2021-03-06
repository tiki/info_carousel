/*
 * Copyright (c) TIKI Inc.
 * MIT license. See LICENSE file in root directory.
 */

import 'package:flutter/material.dart';

import 'cover/layout_cover.dart';
import 'scroll/layout_scroll.dart';

class CardViewLayoutSwipe extends AnimatedWidget {
  final AnimationController _animationController;

  const CardViewLayoutSwipe(this._animationController, {Key? key})
      : super(key: key, listenable: _animationController);

  Animation<double> get _animationValue => listenable as Animation<double>;

  @override
  Widget build(BuildContext context) {
    return _animationValue.value < 1.0
        ? InfoCarouselCardLayoutCover(_animationValue, _animationController)
        : CardViewLayoutScroll(_animationValue, _animationController);
  }
}
