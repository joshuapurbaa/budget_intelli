import 'package:budget_intelli/core/core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ListIconScreen extends StatefulWidget {
  const ListIconScreen({super.key});

  @override
  State<ListIconScreen> createState() => _ListIconScreenState();
}

class _ListIconScreenState extends State<ListIconScreen> {
  List<MapStringDynamic> iconPaths = [];
  final controller = TextEditingController();
  final focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    setState(() {
      iconPaths = iconPathList;
    });
  }

  // create function search icon from iconPathList
  List<Map<String, dynamic>> searchIcon(String query) {
    final searchResult = <Map<String, dynamic>>[];
    for (final icon in iconPathList) {
      final name = icon['name'] as String;
      if (name.toLowerCase().contains(query.toLowerCase())) {
        searchResult.add(icon);
      }
    }
    return searchResult;
  }

  @override
  void dispose() {
    controller.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localize = textLocalizer(context);
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBarPrimary(
            title: localize.iconList,
          ),
          SliverPersistentHeader(
            delegate: SliverAppBarDelegate(
              minHeight: 60,
              maxHeight: 60,
              child: Padding(
                padding: getEdgeInsets(left: 16, right: 16),
                child: AppSearch(
                  hintText: localize.searchIcon,
                  controller: controller,
                  focusNode: focusNode,
                  onChanged: (value) {
                    setState(() {
                      iconPaths = searchIcon(value);
                    });
                  },
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        iconPaths = searchIcon('');
                        controller.clear();
                      });
                    },
                    icon: const Icon(
                      CupertinoIcons.clear_circled_solid,
                    ),
                  ),
                ),
              ),
            ),
            pinned: true,
          ),
          SliverFillRemaining(
            child: GridView.builder(
              padding: getEdgeInsetsAll(16),
              itemCount: iconPaths.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
              ),
              itemBuilder: (context, index) {
                final icon = iconPaths[index];
                final name = icon['name'] as String;
                final path = icon['path'] as String;
                return GestureDetector(
                  onTap: () {
                    context.pop(path);
                  },
                  child: Column(
                    children: [
                      Image.asset(
                        path,
                        width: 30,
                      ),
                      Gap.vertical(8),
                      AppText(
                        text: name,
                        textAlign: TextAlign.center,
                        style: StyleType.labLg,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
