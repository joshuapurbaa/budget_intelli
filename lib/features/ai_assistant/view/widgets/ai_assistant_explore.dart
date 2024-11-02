import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/google_generative_ai/data/datasources/db/sqflite_db.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AiAssistantExplore extends StatefulWidget {
  const AiAssistantExplore({super.key});

  @override
  State<AiAssistantExplore> createState() => _AiAssistantExploreState();
}

class _AiAssistantExploreState extends State<AiAssistantExplore> {
  @override
  void initState() {
    super.initState();
    DatabaseHelper();
  }

  @override
  Widget build(BuildContext context) {
    final localize = textLocalizer(context);
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: getEdgeInsetsAll(16),
          sliver: SliverFillRemaining(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Gap.vertical(50),
                AppText(
                  text: localize.explore,
                  style: StyleType.disSm,
                ),
                Gap.vertical(20),
                Expanded(
                  child: GridView.count(
                    padding: EdgeInsets.zero,
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    children: [
                      AppGlass(
                        onTap: () {
                          context.push(
                            MyRoute.chatScreen,
                          );
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            getSvgAsset(
                              chatBot,
                              width: 50,
                              height: 50,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                            Gap.vertical(22),
                            AppText(
                              text: localize.chatWithAi,
                              style: StyleType.headSm,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
