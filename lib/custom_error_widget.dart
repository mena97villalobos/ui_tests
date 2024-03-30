import 'package:flutter/material.dart';

class CustomErrorWidget extends StatelessWidget {
  const CustomErrorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Image(image: AssetImage("assets/common/sad_face.png")),
              const SizedBox(height: 16),
              Text(
                "We ran into an issue loading this page",
                style: theme.textTheme.displayMedium,
                textAlign: TextAlign.center,
              ),
              Text(
                "There was a problem loading this page. \n Please try again later",
                style: theme.textTheme.labelLarge,
              ),
            ],
          ),
        )
    );
  }
}
