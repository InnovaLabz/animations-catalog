import 'dart:async';

import 'package:flutter/material.dart';

final increments = [5, 10, 8, 12];

class DownloadProgressPage extends StatefulWidget {
  const DownloadProgressPage({Key? key}) : super(key: key);

  @override
  _DownloadProgressPageState createState() => _DownloadProgressPageState();
}

class _DownloadProgressPageState extends State<DownloadProgressPage> {
  double _progress = 0;
  Timer? _timer;
  bool _startDownload = false;

  void _startTimer() {
    _timer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      setState(() {
        final index = _progress % increments.length;
        _progress += increments[index.toInt()];
        if (_progress >= 100) {
          _progress = 100;
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
              progress: _progress,
              start: _startDownload,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      if (!_startDownload) {
                        _startDownload = true;
                        _startTimer();
                      }
                    });
                  },
                  child: const Text(
                    'Animate',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _startDownload = false;
                      _progress = 0;
                    });
                  },
                  child: const Text(
                    'Reset',
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

class DownloadProgress extends StatefulWidget {
  const DownloadProgress({
    Key? key,
    required this.width,
    required this.height,
    required this.start,
    this.progress = 0,
  }) : super(key: key);

  final double width;
  final double height;
  final bool start;
  final double progress;

  @override
  _DownloadProgressState createState() => _DownloadProgressState();
}

class _DownloadProgressState extends State<DownloadProgress>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _downloadTextSlideIn;
  late Animation<RelativeRect> _expandRightAnimation;

  bool _showProgressIndicator = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          setState(() {
            _showProgressIndicator = true;
          });
        } else {
          setState(() {
            _showProgressIndicator = false;
          });
        }
      });

    _downloadTextSlideIn =
        Tween<Offset>(begin: const Offset(0, 1.2), end: const Offset(0, 0))
            .animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(
          0.000,
          0.300,
          curve: Curves.ease,
        ),
      ),
    );

    _expandRightAnimation = RelativeRectTween(
      begin: RelativeRect.fromLTRB(widget.width, 0, 0, 0.0),
      end: RelativeRect.fill,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.500, 1.000, curve: Curves.easeOut),
      ),
    );

    Future.delayed(Duration.zero, () {
      if (widget.start) {
        _controller.forward();
      }
    });
  }

  @override
  void didUpdateWidget(DownloadProgress oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.start != widget.start) {
      if (widget.start == true) {
        if (_controller.isAnimating) {
          _controller.reset();
          _controller.forward();
        } else {
          _controller.forward();
        }
      } else {
        _showProgressIndicator = false;
        _controller.reset();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Stack(
        children: [
          Container(
            width: widget.width,
            height: widget.height,
            color: const Color(0xFF9A2BED),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Positioned(
                  right: 20,
                  bottom: widget.height * 0.3,
                  child: SlideInText(
                    animation: _downloadTextSlideIn,
                    text: 'DOWNLOAD',
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
              ],
            ),
          ),
          PositionedTransition(
            rect: _expandRightAnimation,
            child: Container(
              color: const Color(0xFF6922BB),
            ),
          ),
          if (_showProgressIndicator) ...[
            Positioned(
              top: 0,
              left: 0,
              child: ProgressIndicator(
                progress: widget.progress,
                width: widget.width,
                height: widget.height,
              ),
            ),
          ]
        ],
      ),
    );
  }
}

// class ProgressIndicator extends StatelessWidget {
//   const ProgressIndicator({
//     Key? key,
//     required this.width,
//     required this.height,
//   }) : super(key: key);

//   final double width;
//   final double height;

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedContainer(
//       duration: const Duration(milliseconds: 200),
//       curve: Curves.easeOut,
//       width: width,
//       height: height,
//       color: Colors.white,
//     );
//   }
// }

class SlideInText extends AnimatedWidget {
  const SlideInText({
    Key? key,
    required this.animation,
    required this.text,
  }) : super(key: key, listenable: animation);

  final Animation<Offset> animation;
  final String text;

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: animation,
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class ProgressIndicator extends StatefulWidget {
  const ProgressIndicator({
    Key? key,
    required this.width,
    required this.height,
    required this.progress,
  }) : super(key: key);

  final double width;
  final double height;
  final double progress;

  @override
  _ProgressIndicatorState createState() => _ProgressIndicatorState();
}

class _ProgressIndicatorState extends State<ProgressIndicator> {
  List<Widget> _buildProgressDigits() {
    final widgetList = <Widget>[];
    final progressValueDigits = widget.progress.toInt().toString().split('');
    for (int i = 0; i < progressValueDigits.length; i++) {
      final digit = progressValueDigits[i];
      widgetList.add(
        ProgressValueDigit(
          width: widget.width,
          height: widget.height,
          progressDigit: int.parse(digit),
        ),
      );
    }
    return widgetList;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
          width: (widget.progress / 100) * widget.width,
          height: widget.height,
          color: Colors.white,
        ),
        Positioned(
          left: 12,
          top: widget.height * 0.3,
          bottom: widget.height * 0.3,
          child: SizedBox(
            width: widget.width,
            height: widget.height,
            child: Row(
              children: [
                ..._buildProgressDigits(),
              ],
            ),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          top: 0,
          child: Container(
            height: widget.height * 0.2,
            color: Colors.white,
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(
            height: widget.height * 0.2,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

class ProgressValueDigit extends StatefulWidget {
  const ProgressValueDigit({
    Key? key,
    required this.width,
    required this.height,
    required this.progressDigit,
  }) : super(key: key);

  final double width;
  final double height;
  final int progressDigit;

  @override
  _ProgressValueDigitState createState() => _ProgressValueDigitState();
}

class _ProgressValueDigitState extends State<ProgressValueDigit>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideOutPrevProgressDigit;
  late Animation<Offset> _slideInPrevProgressDigit;
  late Animation<double> _progressDigitOpacity;
  late Animation<double> _prevProgressDigitOpacity;
  late int _progressDigit;
  int _prevProgressDigit = 0;

  @override
  void initState() {
    super.initState();

    _progressDigit = widget.progressDigit;

    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));

    _slideOutPrevProgressDigit = _controller
        .drive(
          CurveTween(curve: Curves.ease),
        )
        .drive(
          Tween<Offset>(
            begin: Offset.zero,
            end: const Offset(0, -1),
          ),
        );

    _prevProgressDigitOpacity = _controller
        .drive(
          CurveTween(curve: const Interval(0.300, 0.500, curve: Curves.ease)),
        )
        .drive(Tween<double>(begin: 1, end: 0));

    _progressDigitOpacity = _controller
        .drive(
          CurveTween(curve: const Interval(0.500, 1.000, curve: Curves.ease)),
        )
        .drive(Tween<double>(begin: 0, end: 1.0));

    _slideInPrevProgressDigit = _controller
        .drive(
          CurveTween(curve: Curves.ease),
        )
        .drive(
          Tween<Offset>(
            begin: const Offset(0, 2),
            end: Offset.zero,
          ),
        );
  }

  @override
  void didUpdateWidget(ProgressValueDigit oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.progressDigit != widget.progressDigit) {
      _prevProgressDigit = oldWidget.progressDigit;
      _progressDigit = widget.progressDigit;
      _controller.reset();
      _controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SlideTransition(
          position: _slideOutPrevProgressDigit,
          child: FadeTransition(
            opacity: _prevProgressDigitOpacity,
            child: Text(
              _prevProgressDigit.toString(),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        SlideTransition(
          position: _slideInPrevProgressDigit,
          child: FadeTransition(
            opacity: _progressDigitOpacity,
            child: Text(
              _progressDigit.toString(),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
