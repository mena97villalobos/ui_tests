// Automatic FlutterFlow imports
import 'package:ui_tests/ScheduleItem.dart';
import 'package:ui_tests/wedding_rule_element_struct.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:timelines/timelines.dart';

class ScheduleComponent extends StatefulWidget {
  const ScheduleComponent({
    super.key,
    this.width,
    this.height,
    required this.events,
  });

  final double? width;
  final double? height;
  final List<ScheduleItem> events;

  @override
  State<ScheduleComponent> createState() => _ScheduleComponentState();
}

class _ScheduleComponentState extends State<ScheduleComponent> {
  List<IconData> icons = [
    Icons.church_outlined,
    Icons.camera_alt_outlined,
    Icons.emoji_transportation,
    Icons.emoji_food_beverage_outlined,
    Icons.favorite_border_outlined,
    Icons.local_restaurant_outlined,
    Icons.celebration_outlined,
    Icons.liquor_outlined,
    Icons.night_shelter_outlined,
  ];

  @override
  Widget build(BuildContext context) {
    return FixedTimeline.tileBuilder(
      builder: TimelineTileBuilder.connected(
        contentsAlign: ContentsAlign.reverse,
        oppositeContentsBuilder: (_, index) {
          return Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
                border: Border.all(color: FlutterFlowTheme.of(context).primary),
                color: FlutterFlowTheme.of(context).secondaryBackground
            ),
            child: Padding(
              padding: const EdgeInsetsDirectional.all(16),
              child: Text(
                widget.events[index].description,
                style: FlutterFlowTheme.of(context).headlineSmall.override(
                  useGoogleFonts: false,
                  fontSize: 16,
                ),
              ),
            ),
          );
        },
        contentsBuilder: (_, index) {
          return Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
                border: Border.all(color: FlutterFlowTheme.of(context).primary),
                color: FlutterFlowTheme.of(context).secondaryBackground
            ),
            child: Padding(
              padding: const EdgeInsetsDirectional.all(16),
              child: Text(
                widget.events[index].time,
                style: FlutterFlowTheme.of(context).headlineSmall.override(
                  useGoogleFonts: false,
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                ),
              ),
            ),
          );
        },
        itemCount: widget.events.length,
        indicatorBuilder: (_, index) => OutlinedDotIndicator(
          color: FlutterFlowTheme.of(context).primary,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Icon(
              color: FlutterFlowTheme.of(context).primary,
              icons[index],
              size: 36.0,
            ),
          ),
        ),
        connectorBuilder: (_, index, ___) =>
            SolidLineConnector(color: FlutterFlowTheme.of(context).primary, thickness: 3,),
      ),
    );
  }
}