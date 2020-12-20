library carousel_slider;

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'carousel_controller.dart';
import 'carousel_options.dart';
import 'carousel_state.dart';
import 'utils.dart';

export 'carousel_controller.dart';
export 'carousel_options.dart';

class CarouselSlider extends StatefulWidget {
  /// [CarouselOptions] to create a [CarouselState] with
  ///
  /// This property must not be null
  final CarouselOptions options;

  /// The widgets to be shown in the carousel of default constructor
  final List<Widget> items;

  /// The widget item builder that will be used to build item on demand
  final IndexedWidgetBuilder itemBuilder;

  /// A [MapController], used to control the map.
  final BasicCarouselController _carouselController;

  final int itemCount;

  CarouselSlider({
    Key key,
    @required this.items,
    @required this.options,
    CarouselController carouselController,
  })  : itemBuilder = null,
        itemCount = items != null ? items.length : 0,
        _carouselController = carouselController ?? CarouselController(),
        super(key: key);

  /// The on demand item builder constructor
  CarouselSlider.builder({
    Key key,
    @required this.itemCount,
    @required this.itemBuilder,
    @required this.options,
    CarouselController carouselController,
  })  : items = null,
        _carouselController = carouselController ?? CarouselController(),
        super(key: key);

  @override
  CarouselSliderState createState() => CarouselSliderState(_carouselController);
}

class CarouselSliderState extends State<CarouselSlider>
    with TickerProviderStateMixin {
  final BasicCarouselController carouselController;
  Timer timer;
  CarouselState carouselState;
  PageController pageController;

  /// It is related to why the page is being changed.
  CarouselPageChangedReason mode = CarouselPageChangedReason.controller;

  CarouselSliderState(this.carouselController);

  CarouselOptions get options => widget.options ?? CarouselOptions();

  void changeMode(CarouselPageChangedReason _mode) {
    mode = _mode;
  }

  @override
  void didUpdateWidget(CarouselSlider oldWidget) {
    carouselState.options = options;
    carouselState.itemCount = widget.itemCount;

    // pageController needs to be re-initialized to respond to state changes
    pageController = PageController(
      viewportFraction: options.viewportFraction,
      initialPage: carouselState.realPage,
    );
    carouselState.pageController = pageController;

    // handle autoplay when state changes
    handleAutoPlay();

    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    super.initState();
    carouselState = CarouselState(options, clearTimer, resumeTimer, changeMode);

    carouselState.itemCount = widget.itemCount;
    carouselController.state = carouselState;
    carouselState.initialPage = widget.options.initialPage;
    carouselState.realPage = options.enableInfiniteScroll
        ? carouselState.realPage + carouselState.initialPage
        : carouselState.initialPage;
    handleAutoPlay();

    pageController = PageController(
      viewportFraction: options.viewportFraction,
      initialPage: carouselState.realPage,
    );

    carouselState.pageController = pageController;
  }

  Timer getTimer() {
    if (!widget.options.autoPlay) return null;

    return Timer.periodic(
      widget.options.autoPlayInterval,
      (timer) async {
        final route = ModalRoute.of(context);

        if (route?.isCurrent == false) return;

        final previousReason = mode;
        changeMode(CarouselPageChangedReason.timed);

        var nextPage = carouselState.pageController.page.round() + 1;
        final itemCount = widget.itemCount ?? widget.items.length;

        if (nextPage >= itemCount && !widget.options.enableInfiniteScroll) {
          if (widget.options.pauseAutoPlayInFiniteScroll) {
            clearTimer();
            return;
          }

          nextPage = 0;
        }

        await carouselState.pageController.animateToPage(
          nextPage,
          duration: widget.options.autoPlayAnimationDuration,
          curve: widget.options.autoPlayCurve,
        );

        changeMode(previousReason);
      },
    );
  }

  void clearTimer() {
    if (timer != null) {
      timer.cancel();
      timer = null;
    }
  }

  void resumeTimer() {
    timer ??= getTimer();
  }

  void handleAutoPlay() {
    final autoPlayEnabled = widget.options.autoPlay;

    if (autoPlayEnabled && timer != null) return;

    clearTimer();

    if (autoPlayEnabled) resumeTimer();
  }

  Widget getGestureWrapper(Widget child) {
    return RawGestureDetector(
      gestures: {
        _MultipleGestureRecognizer:
            GestureRecognizerFactoryWithHandlers<_MultipleGestureRecognizer>(
          () => _MultipleGestureRecognizer(),
          (_MultipleGestureRecognizer instance) {
            instance.onStart = (_) {
              onStart();
            };
            instance.onDown = (_) {
              onPanDown();
            };
            instance.onEnd = (_) {
              onPanUp();
            };
            instance.onCancel = () {
              onPanUp();
            };
          },
        ),
      },
      child: NotificationListener(
        onNotification: (notification) {
          if (widget.options.onScrolled != null &&
              notification is ScrollUpdateNotification) {
            widget.options.onScrolled(carouselState.pageController.page);
          }

          return false;
        },
        child: widget.options.height != null
            ? Container(
                height: widget.options.height,
                child: child,
              )
            : AspectRatio(
                aspectRatio: widget.options.aspectRatio,
                child: child,
              ),
      ),
    );
  }

  Widget getCenterWrapper(Widget child) {
    if (widget.options.disableCenter) {
      return Container(child: child);
    }

    return Center(child: child);
  }

  Widget getEnlargeWrapper(
    Widget child, {
    double width,
    double height,
    double scale,
  }) {
    if (widget.options.enlargeStrategy == CenterPageEnlargeStrategy.height) {
      return SizedBox(
        width: width,
        height: height,
        child: child,
      );
    }

    return Transform.scale(
      scale: scale,
      child: Container(
        width: width,
        height: height,
        child: child,
      ),
    );
  }

  void onStart() {
    changeMode(CarouselPageChangedReason.manual);
  }

  void onPanDown() {
    if (widget.options.pauseAutoPlayOnTouch) clearTimer();

    changeMode(CarouselPageChangedReason.manual);
  }

  void onPanUp() {
    if (widget.options.pauseAutoPlayOnTouch) resumeTimer();
  }

  @override
  void dispose() {
    super.dispose();

    clearTimer();
  }

  @override
  Widget build(BuildContext context) {
    return getGestureWrapper(
      PageView.builder(
        physics: widget.options.scrollPhysics,
        scrollDirection: widget.options.scrollDirection,
        pageSnapping: widget.options.pageSnapping,
        controller: carouselState.pageController,
        reverse: widget.options.reverse,
        itemCount:
            widget.options.enableInfiniteScroll ? null : widget.itemCount,
        key: widget.options.pageViewKey,
        onPageChanged: (index) {
          final currentPage = getRealIndex(index + carouselState.initialPage,
              carouselState.realPage, widget.itemCount);

          if (widget.options.onPageChanged != null) {
            widget.options.onPageChanged(currentPage, mode);
          }
        },
        itemBuilder: (context, index) {
          final realIndex = getRealIndex(index + carouselState.initialPage,
              carouselState.realPage, widget.itemCount);

          return AnimatedBuilder(
            animation: carouselState.pageController,
            child: (widget.items != null)
                ? (widget.items.isNotEmpty
                    ? widget.items[realIndex]
                    : Container())
                : widget.itemBuilder(context, realIndex),
            builder: (BuildContext context, child) {
              var distortionValue = 1.0;
              // if `enlargeCenterPage` is true, we must calculate the carousel item's height
              // to display the visual effect
              if (widget.options.enlargeCenterPage != null &&
                  widget.options.enlargeCenterPage == true) {
                double itemOffset;
                // pageController.page can only be accessed after the first build,
                // so in the first build we calculate the itemoffset manually
                try {
                  itemOffset = carouselState.pageController.page - index;
                } catch (e) {
                  final storageContext = carouselState
                      .pageController.position.context.storageContext;
                  final previousSavedPosition = PageStorage.of(storageContext)
                      ?.readState(storageContext) as double;

                  itemOffset = previousSavedPosition != null
                      ? previousSavedPosition - index.toDouble()
                      : carouselState.realPage.toDouble() - index.toDouble();
                }

                final distortionRatio =
                    (1 - (itemOffset.abs() * 0.3)).clamp(0.0, 1.0);

                distortionValue = Curves.easeOut.transform(distortionRatio);
              }

              final height = widget.options.height ??
                  MediaQuery.of(context).size.width /
                      widget.options.aspectRatio;

              return getCenterWrapper(
                getEnlargeWrapper(
                  child,
                  height: distortionValue *
                      (widget.options.scrollDirection == Axis.horizontal
                          ? height
                          : MediaQuery.of(context).size.width),
                  scale: distortionValue,
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _MultipleGestureRecognizer extends PanGestureRecognizer {
  @override
  void rejectGesture(int pointer) {
    acceptGesture(pointer);
  }
}
