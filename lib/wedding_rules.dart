import 'package:flutter/material.dart';
import 'package:timelines/timelines.dart';

class WeddingRulesList extends StatelessWidget {
  const WeddingRulesList({Key? key, required this.rules}) : super(key: key);

  final List<WeddingRules> rules;

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: const TextStyle(
        color: Color(0xff9b9b9b),
        fontSize: 12.5,
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: FixedTimeline.tileBuilder(
          theme: TimelineThemeData(
            nodePosition: 0,
            color: const Color(0xff989898),
            indicatorTheme: const IndicatorThemeData(
              position: 0,
              size: 52.0,
            ),
            connectorTheme: const ConnectorThemeData(
              thickness: 8,
            ),
          ),
          builder: TimelineTileBuilder.connected(
            connectionDirection: ConnectionDirection.after,
            itemCount: rules.length,
            contentsBuilder: (_, index) {
              return Padding(
                padding: const EdgeInsetsDirectional.only(
                  start: 16,
                  end: 16,
                  bottom: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      rules[index].title,
                      style: DefaultTextStyle.of(context).style.copyWith(
                        fontSize: 18.0,
                      ),
                    ),
                    Text(
                      rules[index].description,
                      style: DefaultTextStyle.of(context).style.copyWith(
                          fontSize: 12.0, fontStyle: FontStyle.italic),
                    ),
                  ],
                ),
              );
            },
            indicatorBuilder: (_, index) => const DotIndicator(
              color: Color(0xffE5B80B),
              child: Icon(
                Icons.church_outlined,
                size: 36.0,
              ),
            ),
            connectorBuilder: (_, index, ___) =>
            const SolidLineConnector(color: Color(0xffE5B80B)),
          ),
        ),
      ),
    );
  }
}

List<WeddingRules> _data() => [
  WeddingRules(
    'Package Process',
    'This is a really long text testing the timeline behavior could be good or could look horrible',
  ),
  WeddingRules(
    'In Transit',
    'This is a really long text testing the timeline behavior could be good or could look horrible',
  ),
  WeddingRules(
    'In Transit',
    'This is a really long text testing the timeline behavior could be good or could look horrible',
  ),
  WeddingRules(
    'Completed',
    'This is a really long text testing the timeline behavior could be good or could look horrible',
  ),
];

class WeddingRules {
  final String title;
  final String description;

  WeddingRules(this.title, this.description);
}