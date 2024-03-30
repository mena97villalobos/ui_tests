import 'package:flutter/material.dart';

import 'package:slide_countdown/slide_countdown.dart';

class DateCountDown extends StatefulWidget {
  const DateCountDown({
    Key? key,
    this.width,
    this.height,
    required this.weddingDate,
  }) : super(key: key);

  final double? width;
  final double? height;
  final DateTime weddingDate;

  @override
  _DateCountDownState createState() => _DateCountDownState();
}

class _DateCountDownState extends State<DateCountDown> {
  late final Duration streamDuration;

  @override
  void initState() {
    final difference = widget.weddingDate.difference(DateTime.now()).inSeconds;
    streamDuration = Duration(seconds: difference);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: SlideCountdownSeparated(
        duration: streamDuration,
        separatorType: SeparatorType.title,
        separatorStyle: const TextStyle(
          color: Color(0xFF000000),
          fontWeight: FontWeight.w300,
          fontStyle: FontStyle.italic
        ),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          color: Color.fromARGB(255, 231, 168, 146),
        ),
        durationTitle: const DurationTitle(
            days: "days",
            hours: "hours",
            minutes: "minutes",
            seconds: "seconds"),
      ),
    );
  }
}
