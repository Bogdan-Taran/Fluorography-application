import 'package:flutter/material.dart';

class AnimatedDateContainer extends StatefulWidget {
  final String dateStr;
  final bool isOverdue;
  final bool isShaking;
  final VoidCallback? onTap;

  const AnimatedDateContainer({
    Key? key,
    required this.dateStr,
    required this.isOverdue,
    this.isShaking = false,
    this.onTap,
  }) : super(key: key);

  @override
  State<AnimatedDateContainer> createState() => _AnimatedDateContainerState();
}

class _AnimatedDateContainerState extends State<AnimatedDateContainer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200), // Уменьшил длительность для более резкой анимации
      vsync: this,
    );

    // Используем TweenSequence с более резкими изменениями
    _shakeAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 0.0, end: 3.0).chain(
          CurveTween(curve: Curves.easeInOut),
        ),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 3.0, end: -3.0).chain(
          CurveTween(curve: Curves.easeInOut),
        ),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: Tween(begin: -3.0, end: 2.0).chain(
          CurveTween(curve: Curves.easeInOut),
        ),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 2.0, end: -2.0).chain(
          CurveTween(curve: Curves.easeInOut),
        ),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: Tween(begin: -2.0, end: 1.0).chain(
          CurveTween(curve: Curves.easeInOut),
        ),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: -1.0).chain(
          CurveTween(curve: Curves.easeInOut),
        ),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: Tween(begin: -1.0, end: 0.0).chain(
          CurveTween(curve: Curves.easeInOut),
        ),
        weight: 1,
      ),
    ]).animate(_controller);
  }

  @override
  void didUpdateWidget(AnimatedDateContainer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isShaking != oldWidget.isShaking) {
      if (widget.isShaking) {
        _controller.forward().then((_) {
          if (!widget.isShaking) {
            _controller.reset();
          }
        });
      } else {
        _controller.reset();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _shakeAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(_shakeAnimation.value, 0),
          child: Container(
            width: 85,
            height: 24,
            decoration: BoxDecoration(
              color: widget.isOverdue
                  ? const Color(0xffF29393)
                  : Colors.lightBlueAccent.shade100,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(15),
                onTap: widget.onTap,
                child: Center(
                  child: Text(
                    widget.dateStr,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xff26292B),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}