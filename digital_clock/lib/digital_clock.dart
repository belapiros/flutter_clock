// Copyright 2020 Bela Piros. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:flutter_clock_helper/model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// A basic digital clock.
///
/// You can do better than this!
/// I will try xD
class DigitalClock extends StatefulWidget {
  const DigitalClock(this.model);

  final ClockModel model;

  @override
  _DigitalClockState createState() => _DigitalClockState();
}

class _DigitalClockState extends State<DigitalClock> {
  DateTime _dateTime = DateTime.now();
  Timer _timer;
  bool _cursorVisible = true;

  @override
  void initState() {
    super.initState();
    widget.model.addListener(_updateModel);
    _updateTime();
    _updateModel();
  }

  @override
  void didUpdateWidget(DigitalClock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.model != oldWidget.model) {
      oldWidget.model.removeListener(_updateModel);
      widget.model.addListener(_updateModel);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    widget.model.removeListener(_updateModel);
    widget.model.dispose();
    super.dispose();
  }

  void _updateModel() {
    setState(() {
      // Cause the clock to rebuild when the model changes.
    });
  }

  void _updateTime() {
    setState(() {
      _dateTime = DateTime.now();
      // Update once per minute. If you want to update every second, use the
      // following code.
      // _timer = Timer(
      //   Duration(minutes: 1) -
      //       Duration(seconds: _dateTime.second) -
      //       Duration(milliseconds: _dateTime.millisecond),
      //   _updateTime,
      // );
      //  Update once per second, but make sure to do it at the beginning of each
      //  new second, so that the clock is accurate.
      _timer = Timer(
        Duration(seconds: 1) -
            Duration(milliseconds: _dateTime.millisecond) -
            Duration(microseconds: _dateTime.microsecond),
        () {
          _updateTime();
          _blinkCursor();
        },
      );
    });
  }

  void _blinkCursor() {
    setState(() {
      _cursorVisible = !_cursorVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    final hour =
        DateFormat(widget.model.is24HourFormat ? 'HH' : 'hh').format(_dateTime);
    final hourTens = hour[0];
    final hourOnes = hour[1];
    final minute = DateFormat('mm').format(_dateTime);
    final minuteTens = minute[0];
    final minuteOnes = minute[1];

    final imageWidth = MediaQuery.of(context).size.width / 5;

    final cursorHeight = (MediaQuery.of(context).size.height / 3) * 1.8;
    final cursorThickness = 2.0;
    final cursorColor = _cursorVisible
        ? Color.fromRGBO(53, 205, 232, 1.0)
        : Color.fromRGBO(53, 205, 232, 0.0);

    return Container(
      color: Colors.black,
      child: Stack(
        children: <Widget>[
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  'assets/images/${hourTens}.png',
                  width: imageWidth,
                ),
                Image.asset(
                  'assets/images/${hourOnes}.png',
                  width: imageWidth,
                ),
                SizedBox(
                  width: 10.0,
                ),
                Image.asset(
                  'assets/images/${minuteTens}.png',
                  width: imageWidth,
                ),
                Image.asset(
                  'assets/images/${minuteOnes}.png',
                  width: imageWidth,
                ),
              ],
            ),
          ),
          Center(
            child: AnimatedContainer(
              width: cursorThickness,
              height: cursorHeight,
              color: cursorColor,
              duration: Duration(milliseconds: 500),
              curve: Curves.linear,
            ),
          ),
        ],
      ),
    );
  }
}
