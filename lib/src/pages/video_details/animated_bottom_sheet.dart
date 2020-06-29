import 'dart:ui';
import 'dart:math';

import 'package:flutter/material.dart';

import '../../constants.dart';

const double minHeight = 160;

class AnimatedBottomSheet extends StatefulWidget {
  @override
  _AnimatedBottomSheetState createState() => _AnimatedBottomSheetState();
}

class _AnimatedBottomSheetState extends State<AnimatedBottomSheet>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  double _sliderValue = 0.0;
  double get maxHeight => MediaQuery.of(context).size.height;
  bool _ratingScaleShown = false;
  int _count = 0;
  TextEditingController _textEditingController;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 600),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _setValue(double value) => setState(() => _sliderValue = value);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      //<--add animated builder
      animation: _controller,
      builder: (context, child) {
        final _expanded = _controller.value == 1;

        return Positioned(
          height: lerpDouble(
              minHeight,
              maxHeight + 30,
              _controller
                  .value), //<-- update height value to scale with controller
          left: 0,
          right: 0,
          bottom: 0,
          child: GestureDetector(
            onTap: _toggle,
            onVerticalDragUpdate:
                _handleDragUpdate, //<-- Add verticalDragUpdate callback
            onVerticalDragEnd:
                _handleDragEnd, //<-- Add verticalDragEnd callback
            child: Container(
              // padding: const EdgeInsets.symmetric(horizontal: 32),
              decoration: const BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Stack(
                children: [
                  Positioned.fill(
                    top: 45,
                    child: Container(color: Colors.black45),
                  ),
                  Positioned(
                    left: 0,
                    top: 15,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        children: [
                          AnimatedOpacity(
                            duration: Duration(microseconds: 400),
                            curve: Curves.linear,
                            opacity: 1 - _controller.value,
                            child: _ratingScaleShown
                                ? SliderTheme(
                                    data: SliderTheme.of(context).copyWith(
                                      showValueIndicator:
                                          ShowValueIndicator.always,
                                      activeTrackColor: Colors.green,
                                      inactiveTrackColor: Colors.red,
                                      trackHeight: 3.0,
                                      thumbColor: Colors.blueAccent,
                                      thumbShape: RoundSliderThumbShape(
                                          enabledThumbRadius: 8.0),
                                      overlayShape: RoundSliderOverlayShape(
                                          overlayRadius: 14.0),
                                    ),
                                    child: Slider(
                                      min: -5,
                                      max: 5,
                                      divisions: 10,
                                      label: _sliderValue.toString(),
                                      value: _sliderValue,
                                      onChanged: (dub) => setState(() {
                                        _sliderValue = dub;
                                      }),
                                      onChangeEnd: (dub) => setState(() {
                                        //bug calls onChangeEnd when first touching slider
                                        _count += 1;
                                        if (_count > 1) {
                                          _ratingScaleShown = false;
                                          _count = 0;
                                        }
                                        _sliderValue = dub;
                                        // _ratingScaleShown = false;
                                      }),
                                    ),
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      // Spacer(),
                                      CircleAvatar(
                                        minRadius: 22,
                                        maxRadius: 30,
                                        backgroundImage: NetworkImage(
                                            "https://alchetron.com/cdn/lars-bak-computer-programmer-09ef93e7-9c03-40b1-8c5f-2528ab9a804-resize-750.gif"),
                                      ),
                                      _expanded
                                          ? Expanded(child: Container())
                                          : SizedBox(
                                              width:
                                                  19 / (1 - _controller.value),
                                            ),
                                      AnimatedOpacity(
                                        duration: Duration(microseconds: 400),
                                        curve: Curves.linear,
                                        opacity: 1 - _controller.value,
                                        child: Container(
                                          height: 40,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              Text(
                                                "Lars Bak",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white),
                                              ),
                                              Text(
                                                "500,000 Followers",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      // Spacer(),
                                    ],
                                  ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          // Wrap(
                          //   children: [
                          Container(
                            // padding: EdgeInsets.all(0),
                            height: 93,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Video Name",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                                Text(
                                  constants.scLoremIpsumMed,
                                  style: TextStyle(color: Colors.white),
                                  maxLines: 2,
                                ),
                                SizedBox(height: 10),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 35,
                                  child: TextField(
                                    controller: _textEditingController,
                                    decoration: InputDecoration(
                                      isCollapsed: true,
                                      filled: true,
                                      fillColor: Colors.black87,
                                      icon: Icon(Icons.send),
                                      border: const OutlineInputBorder(),
                                      hintText: "Comment...",
                                    ),
                                  ),
                                )
                              ],
                            ),
                            //   ),
                            // ],
                          ),
                          Container(
                            height: 900,
                            child: ListView.builder(
                              padding: EdgeInsets.all(0),
                              itemBuilder: (context, i) => ListTile(
                                leading: CircleAvatar(
                                  minRadius: 15,
                                  maxRadius: 20,
                                  backgroundImage: NetworkImage(
                                      "https://alchetron.com/cdn/lars-bak-computer-programmer-09ef93e7-9c03-40b1-8c5f-2528ab9a804-resize-750.gif"),
                                ),
                                title: Text("Name$i"),
                                subtitle: Text("This is a comment"),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 5,
                    right: 0,
                    child: AnimatedOpacity(
                        duration: Duration(microseconds: 400),
                        curve: Curves.elasticOut,
                        opacity: _ratingScaleShown ? 0 : 1 - _controller.value,
                        child: IconButton(
                          icon: Icon(Icons.star),
                          onPressed: () =>
                              setState(() => _ratingScaleShown = true),
                        )),
                  ),
                  Positioned(
                    top: 65,
                    right: 11,
                    child: AnimatedOpacity(
                        duration: Duration(microseconds: 400),
                        curve: Curves.linear,
                        opacity: _ratingScaleShown ? 0 : 1 - _controller.value,
                        child: Icon(Icons.comment)),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    _controller.value -= details.primaryDelta /
        maxHeight; //<-- Update the _controller.value by the movement done by user.
  }

  void _handleDragEnd(DragEndDetails details) {
    if (_controller.isAnimating ||
        _controller.status == AnimationStatus.completed) return;

    final double flingVelocity = details.velocity.pixelsPerSecond.dy /
        maxHeight; //<-- calculate the velocity of the gesture
    if (flingVelocity < 0.0)
      _controller.fling(
          velocity: max(2.0, -flingVelocity)); //<-- either continue it upwards
    else if (flingVelocity > 0.0)
      _controller.fling(
          velocity: min(-2.0, -flingVelocity)); //<-- or continue it downwards
    else
      _controller.fling(
          velocity: _controller.value < 0.5
              ? -2.0
              : 2.0); //<-- or just continue to whichever edge is closer
  }

  void _toggle() {
    final bool isOpen = _controller.status == AnimationStatus.completed;
    _controller.fling(
        velocity: isOpen ? -2 : 2); //<-- ...snap the sheet in proper direction
  }
}