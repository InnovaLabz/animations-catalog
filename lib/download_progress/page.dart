import 'dart:async';

import 'package:flutter/material.dart';

class DownloadProgressPage extends StatelessWidget {
  const DownloadProgressPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFF9A2BED),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            DownloadProgress(
              width: size.width * 0.7,
              height: 60,
            ),
          ],
        ),
      ),
    );
  }
}

final increments = [5, 10, 8, 12];

class DownloadProgress extends StatefulWidget {
  const DownloadProgress({
    Key? key,
    required this.width,
    required this.height,
  }) : super(key: key);

  final double width;
  final double height;

  @override
  _DownloadProgressState createState() => _DownloadProgressState();
}

class _DownloadProgressState extends State<DownloadProgress>
    with SingleTickerProviderStateMixin {
  double overlayWidthFactor = 0;
  double _widthFactor = 0;
  double _progress = 0;
  Timer? _timer;
  late AnimationController _controller;
  late Animation<Offset> _downloadTextSlideIn;
  late Animation<RelativeRect> _expandRightAnimation;
  late Animation<RelativeRect> _downloadTextSlideIn2;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _timer = _startTimer();
        }
      });

    _downloadTextSlideIn =
        Tween<Offset>(begin: const Offset(0, 1), end: const Offset(0, 0))
            .animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(
          0.000,
          0.400,
          curve: Curves.easeOut,
        ),
      ),
    );

    // _downloadTextSlideIn2 = RelativeRectTween(
    //   begin: RelativeRect.fromSize(Rect.fromLTWH(left, top, width, height), container),
    //   end: const RelativeRect.fromLTRB(100.0, 0, 0, 0),
    // ).animate(
    //   CurvedAnimation(
    //     parent: _controller,
    //     curve: const Interval(0.000, 0.400, curve: Curves.easeOut),
    //   ),
    // );

    _expandRightAnimation = RelativeRectTween(
      begin: RelativeRect.fromLTRB(widget.width, 0, 0, 0.0),
      end: RelativeRect.fill,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.500, 1.000, curve: Curves.easeOut),
      ),
    );

    Future.delayed(const Duration(seconds: 1), () {
      _controller.forward();
    });
  }

  Timer _startTimer() {
    return Timer.periodic(const Duration(milliseconds: 500), (timer) {
      setState(() {
        final index = _progress % increments.length;
        _progress += increments[index.toInt()];
        _widthFactor = _progress / 100.0;
        if (_progress >= 100) {
          _progress = 100;
          _widthFactor = 1.0;
          _timer?.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: widget.width,
          height: widget.height,
          color: const Color(0xFF9A2BED),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Align(
              //   alignment: Alignment.centerRight,
              //   child: SlideTransition(
              //     position: _downloadTextSlideIn,
              //     child: const Text(
              //       'DOWNLOAD',
              //       style: TextStyle(color: Colors.white),
              //     ),
              //   ),
              // ),
              PositionedTransition(
                rect: _downloadTextSlideIn2,
                child: const Text(
                  'DOWNLOAD',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  height: widget.height * 0.3,
                  color: const Color(0xFF9A2BED),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                top: 0,
                child: Container(
                  height: widget.height * 0.3,
                  color: const Color(0xFF9A2BED),
                ),
              ),
            ],
          ),
        ),
        PositionedTransition(
          rect: _expandRightAnimation,
          child: Container(
            color: const Color(0xFF6922BB),
          ),
        ),
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          width: _widthFactor * widget.width,
          height: widget.height,
          color: Colors.white,
        ),
      ],
    );
  }
}
