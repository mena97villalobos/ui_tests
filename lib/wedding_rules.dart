// Automatic FlutterFlow imports
import 'package:ui_tests/wedding_rule_element_struct.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:timelines/timelines.dart';

class WeddingRulesTimeline extends StatefulWidget {
  const WeddingRulesTimeline({
    super.key,
    this.width,
    this.height,
    required this.rules,
  });

  final double? width;
  final double? height;
  final List<WeddingRuleElementStruct> rules;

  @override
  State<WeddingRulesTimeline> createState() => _WeddingRulesTimelineState();
}

class _WeddingRulesTimelineState extends State<WeddingRulesTimeline> {
  List<IconData> icons = [
    Icons.no_stroller,
    Icons.checkroom,
    Icons.color_lens,
    Icons.church_outlined,
    Icons.airport_shuttle
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: FlutterFlowTheme.of(context).headlineSmall.override(
        color: FlutterFlowTheme.of(context).accent2,
        fontSize: 12.5,
        letterSpacing: 0.0,
        useGoogleFonts: false,
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: FixedTimeline.tileBuilder(
          theme: TimelineThemeData(
            nodePosition: 0,
            color: FlutterFlowTheme.of(context).accent2,
            indicatorTheme: const IndicatorThemeData(
              position: 0,
              size: 100.0,
            ),
            connectorTheme: const ConnectorThemeData(
              thickness: 10,
            ),
          ),
          builder: TimelineTileBuilder.connected(
            connectionDirection: ConnectionDirection.after,
            itemCount: widget.rules.length,
            contentsBuilder: (_, index) {
              return Padding(
                  padding: const EdgeInsets.only(left: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.rules[index].title,
                      style: FlutterFlowTheme.of(context).headlineSmall.override(
                        useGoogleFonts: false,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      widget.rules[index].description,
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                        useGoogleFonts: false,
                        fontFamily:
                        FlutterFlowTheme.of(context).displayLargeFamily,
                      ),
                    ),
                    const SizedBox(height: 25),
                  ],
                ),
              );
            },
            indicatorBuilder: (_, index) => OutlinedDotIndicator(
              color: FlutterFlowTheme.of(context).primary,
              child: Icon(
                color: FlutterFlowTheme.of(context).primary,
                icons[index],
                size: 22.0,
              ),
            ),
            connectorBuilder: (_, index, ___) =>
                SolidLineConnector(color: FlutterFlowTheme.of(context).primary, thickness: 3,),
          ),
        ),
      ),
    );
  }
}