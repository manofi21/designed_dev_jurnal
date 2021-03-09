import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'flutter_swiper.dart';
import 'dart:async';

import 'package:transformer_page_view/transformer_page_view.dart';

part 'custom_layout.dart';

typedef void SwiperOnTap(int index);

typedef Widget SwiperDataBuilder(BuildContext context, dynamic data, int index);

/// default auto play delay
const int kDefaultAutoplayDelayMs = 3000;

///  Default auto play transition duration (in millisecond)
const int kDefaultAutoplayTransactionDuration = 300;

const int kMaxValue = 2000000000;
const int kMiddleValue = 1000000000;

enum SwiperLayout { TINDER }

class Swiper extends StatefulWidget {
  /// If set true , the pagination will display 'outer' of the 'content' container.
  final bool outer;

  /// Inner item height, this property is valid if layout=STACK or layout=TINDER or LAYOUT=CUSTOM,
  final double itemHeight;

  /// Inner item width, this property is valid if layout=STACK or layout=TINDER or LAYOUT=CUSTOM,
  final double itemWidth;

  // height of the inside container,this property is valid when outer=true,otherwise the inside container size is controlled by parent widget
  final double containerHeight;
  // width of the inside container,this property is valid when outer=true,otherwise the inside container size is controlled by parent widget
  final double containerWidth;

  /// Build item on index
  final IndexedWidgetBuilder itemBuilder;

  /// Support transform like Android PageView did
  /// `itemBuilder` and `transformItemBuilder` must have one not null
  final PageTransformer transformer;

  /// count of the display items
  final int itemCount;

  final ValueChanged<int> onIndexChanged;

  ///auto play config
  final bool autoplay;

  ///Duration of the animation between transactions (in millisecond).
  final int autoplayDelay;

  ///disable auto play when interaction
  final bool autoplayDisableOnInteraction;

  ///auto play transition duration (in millisecond)
  final int duration;

  ///horizontal/vertical
  final Axis scrollDirection;

  ///transition curve
  final Curve curve;

  /// Set to false to disable continuous loop mode.
  final bool loop;

  ///Index number of initial slide.
  ///If not set , the `Swiper` is 'uncontrolled', which means manage index by itself
  ///If set , the `Swiper` is 'controlled', which means the index is fully managed by parent widget.
  final int index;

  ///Called when tap
  final SwiperOnTap onTap;

  ///The swiper pagination plugin
  // final SwiperPlugin pagination;

  ///the swiper control button plugin
  // final SwiperPlugin control;

  ///other plugins, you can custom your own plugin
  // final List<SwiperPlugin> plugins;

  ///
  final SwiperController controller;

  final ScrollPhysics physics;

  ///
  final double viewportFraction;

  /// Build in layouts
  final SwiperLayout layout;

  /// this value is valid when layout == SwiperLayout.CUSTOM
  // final CustomLayoutOption customLayoutOption;

  // This value is valid when viewportFraction is set and < 1.0
  final double scale;

  // This value is valid when viewportFraction is set and < 1.0
  final double fade;

  Swiper({
    this.itemBuilder,

    ///
    this.transformer,
    @required this.itemCount,
    this.autoplay: false,
    this.layout: SwiperLayout.TINDER,
    this.autoplayDelay: kDefaultAutoplayDelayMs,
    this.autoplayDisableOnInteraction: true,
    this.duration: kDefaultAutoplayTransactionDuration,
    this.onIndexChanged,
    this.index,
    this.onTap,
    // this.control,
    this.loop: true,
    this.curve: Curves.ease,
    this.scrollDirection: Axis.horizontal,
    // this.pagination,
    // this.plugins,
    this.physics,
    Key key,
    this.controller,
    // this.customLayoutOption,

    /// since v1.0.0
    this.containerHeight,
    this.containerWidth,
    this.viewportFraction: 1.0,
    this.itemHeight,
    this.itemWidth,
    this.outer: false,
    this.scale,
    this.fade,
  })  : assert(itemBuilder != null || transformer != null,
            "itemBuilder and transformItemBuilder must not be both null"),
        super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new _SwiperState();
  }
}

abstract class _SwiperTimerMixin extends State<Swiper> {
  Timer _timer;

  SwiperController _controller;

  @override
  void initState() {
    _controller = widget.controller;
    if (_controller == null) {
      _controller = new SwiperController();
    }
    _handleAutoplay();
    super.initState();
  }

  @override
  void didUpdateWidget(Swiper oldWidget) {
    if (_controller != oldWidget.controller) {
      if (oldWidget.controller != null) {
        _controller = oldWidget.controller;
      }
    }
    _handleAutoplay();
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _stopAutoplay();
    super.dispose();
  }

  bool _autoplayEnabled() {
    return _controller.autoplay ?? widget.autoplay;
  }

  void _handleAutoplay() {
    if (_autoplayEnabled() && _timer != null) return;
    _stopAutoplay();
    if (_autoplayEnabled()) {
      _startAutoplay();
    }
  }

  void _startAutoplay() {
    assert(_timer == null, "Timer must be stopped before start!");
    _timer =
        Timer.periodic(Duration(milliseconds: widget.autoplayDelay), _onTimer);
  }

  void _onTimer(Timer timer) {
    _controller.next(animation: true);
  }

  void _stopAutoplay() {
    if (_timer != null) {
      _timer.cancel();
      _timer = null;
    }
  }
}

class _SwiperState extends _SwiperTimerMixin {
  int _activeIndex;

  TransformerPageController _pageController;

  Widget _wrapTap(BuildContext context, int index) {
    return new GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        this.widget.onTap(index);
      },
      child: widget.itemBuilder(context, index),
    );
  }

  @override
  void initState() {
    _activeIndex = widget.index ?? 0;
    if (_isPageViewLayout()) {
      _pageController = new TransformerPageController(
          initialPage: widget.index,
          loop: widget.loop,
          itemCount: widget.itemCount,
          reverse:
              widget.transformer == null ? false : widget.transformer.reverse,
          viewportFraction: widget.viewportFraction);
    }
    super.initState();
  }

  bool _isPageViewLayout() {
    return widget.layout == null || widget.layout == SwiperLayout.TINDER;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  bool _getReverse(Swiper widget) =>
      widget.transformer == null ? false : widget.transformer.reverse;

  @override
  void didUpdateWidget(Swiper oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_isPageViewLayout()) {
      if (_pageController == null ||
          (widget.index != oldWidget.index ||
              widget.loop != oldWidget.loop ||
              widget.itemCount != oldWidget.itemCount ||
              widget.viewportFraction != oldWidget.viewportFraction ||
              _getReverse(widget) != _getReverse(oldWidget))) {
        _pageController = new TransformerPageController(
            initialPage: widget.index,
            loop: widget.loop,
            itemCount: widget.itemCount,
            reverse: _getReverse(widget),
            viewportFraction: widget.viewportFraction);
      }
    } else {
      scheduleMicrotask(() {
        // So that we have a chance to do `removeListener` in child widgets.
        if (_pageController != null) {
          _pageController.dispose();
          _pageController = null;
        }
      });
    }
    if (widget.index != null && widget.index != _activeIndex) {
      _activeIndex = widget.index;
    }
  }

  void _onIndexChanged(int index) {
    setState(() {
      _activeIndex = index;
    });
    if (widget.onIndexChanged != null) {
      widget.onIndexChanged(index);
    }
  }

  Widget _buildSwiper() {
    IndexedWidgetBuilder itemBuilder;
    if (widget.onTap != null) {
      itemBuilder = _wrapTap;
    } else {
      itemBuilder = widget.itemBuilder;
    }
    return new _TinderSwiper(
      loop: widget.loop,
      itemWidth: widget.itemWidth,
      itemHeight: widget.itemHeight,
      itemCount: widget.itemCount,
      itemBuilder: itemBuilder,
      index: _activeIndex,
      curve: widget.curve,
      duration: widget.duration,
      onIndexChanged: _onIndexChanged,
      controller: _controller,
      scrollDirection: widget.scrollDirection,
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget swiper = _buildSwiper();
    List<Widget> listForStack;

    if (listForStack != null) {
      return new Stack(
        children: listForStack,
      );
    }

    return swiper;
  }
}

abstract class _SubSwiper extends StatefulWidget {
  final IndexedWidgetBuilder itemBuilder;
  final int itemCount;
  final int index;
  final ValueChanged<int> onIndexChanged;
  final SwiperController controller;
  final int duration;
  final Curve curve;
  final double itemWidth;
  final double itemHeight;
  final bool loop;
  final Axis scrollDirection;

  _SubSwiper(
      {Key key,
      this.loop,
      this.itemHeight,
      this.itemWidth,
      this.duration,
      this.curve,
      this.itemBuilder,
      this.controller,
      this.index,
      this.itemCount,
      this.scrollDirection: Axis.horizontal,
      this.onIndexChanged})
      : super(key: key);

  @override
  State<StatefulWidget> createState();

  int getCorrectIndex(int indexNeedsFix) {
    if (itemCount == 0) return 0;
    int value = indexNeedsFix % itemCount;
    if (value < 0) {
      value += itemCount;
    }
    return value;
  }
}

class _TinderSwiper extends _SubSwiper {
  _TinderSwiper({
    Key key,
    Curve curve,
    int duration,
    SwiperController controller,
    ValueChanged<int> onIndexChanged,
    double itemHeight,
    double itemWidth,
    IndexedWidgetBuilder itemBuilder,
    int index,
    bool loop,
    int itemCount,
    Axis scrollDirection,
  })  : assert(itemWidth != null && itemHeight != null),
        super(
            loop: loop,
            key: key,
            itemWidth: itemWidth,
            itemHeight: itemHeight,
            itemBuilder: itemBuilder,
            curve: curve,
            duration: duration,
            controller: controller,
            index: index,
            onIndexChanged: onIndexChanged,
            itemCount: itemCount,
            scrollDirection: scrollDirection);

  @override
  State<StatefulWidget> createState() {
    return new _TinderState();
  }
}

class _TinderState extends _CustomLayoutStateBase<_TinderSwiper> {
  List<double> scales;
  List<double> offsetsX;
  List<double> offsetsY;
  List<double> opacity;
  List<double> rotates;

  List<double> red;
  List<double> green;
  List<double> blue;
  List<double> colorOpacity;

  double getOffsetY(double scale) {
    return widget.itemHeight - widget.itemHeight * scale;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(_TinderSwiper oldWidget) {
    _updateValues();
    super.didUpdateWidget(oldWidget);
  }

  @override
  void afterRender() {
    super.afterRender();

    _startIndex = -3;
    _animationCount = 5;
    opacity = [0.0, .5, 1, 1, 0.0, 0.0];
    scales = [0.80, 0.80, 0.85, 0.90, 1.0, 1.0, 1.0];
    rotates = [0.0, 0.0, 0.0, 0.0, 20.0, 25.0];

    // red = [.0, 45, 52, 52, 45, 10, .0]; //[.0, 45, 52, 40, 45 ]
    // green = [.0, 135, 121, 121, 135, 105, .0]; //[.0, 135, 121, 130, 135]
    // blue = [.0, 168, 168, 168, 168, 135, .0]; //[.0, 168, 148, 16, 168]

    red =   [ 45,  52,  52,  45,  10]; //[.0, 45, 52, 40, 45 ]
    green = [135, 121, 121, 135, 105]; //[.0, 135, 121, 130, 135]
    blue =  [168, 168, 148, 168, 135]; //[.0, 168, 148, 16, 168]

    _updateValues();
  }

  void _updateValues() {
    if (widget.scrollDirection == Axis.horizontal) {
      offsetsX = [0.0, 0.0, 0.0, 0.0, _swiperWidth, _swiperWidth];
      offsetsY = [
        0.0,
        30.0,
        15.0,
        0.0,
        0.0,
      ].reversed.toList();
    } else {
      offsetsX = [
        0.0,
        0.0,
        5.0,
        10.0,
        15.0,
        20.0,
      ];

      offsetsY = [0.0, 0.0, 0.0, 0.0, _swiperHeight, _swiperHeight];
    }
  }

  @override
  Widget _buildItem(int i, int realIndex, double animationValue) {
    double s = _getValue(scales, animationValue, i);
    double f = _getValue(offsetsX, animationValue, i);
    double fy = _getValue(offsetsY, animationValue, i);
    double o = _getValue(opacity, animationValue, i);
    double a = _getValue(rotates, animationValue, i);

    double _red = _getValue(red, animationValue, i);
    double _blue = _getValue(blue, animationValue, i);
    double _green = _getValue(green, animationValue, i);

    Alignment alignment = widget.scrollDirection == Axis.horizontal
        ? Alignment.topCenter
        : Alignment.centerLeft;

    return new Opacity(
      opacity: o,
      child: new Transform.rotate(
        angle: a / 180.0,
        child: new Transform.translate(
          key: new ValueKey<int>(_currentIndex + i),
          offset: new Offset(f, fy),
          child: new Transform.scale(
            scale: s,
            alignment: alignment,
            child: new Container(
              decoration: BoxDecoration(
                // color: colors[2],
                borderRadius: new BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20)),
                color: Color.fromRGBO(
                    _red.toInt(), _green.toInt(), _blue.toInt(), 1),
              ),

              width: widget.itemWidth ?? double.infinity,
              height: widget.itemHeight ?? double.infinity,
              // duration: Duration(milliseconds: 500),
              child: widget.itemBuilder(context, realIndex),
            ),
          ),
        ),
      ),
    );
  }
}
