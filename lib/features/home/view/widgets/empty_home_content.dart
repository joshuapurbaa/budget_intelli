import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/budget/budget_barrel.dart';
import 'package:budget_intelli/features/home/home_barrel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class EmptyHomeContent extends StatefulWidget {
  const EmptyHomeContent({
    super.key,
    this.loading = false,
  });

  final bool loading;

  @override
  State<EmptyHomeContent> createState() => _EmptyHomeContentState();
}

class _EmptyHomeContentState extends State<EmptyHomeContent>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 3,
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    final localize = textLocalizer(context);
    return CustomScrollView(
      slivers: [
        SliverPersistentHeader(
          pinned: true,
          floating: true,
          delegate: SliverAppBarDelegate(
            minHeight: 80.h,
            maxHeight: 80.h,
            child: ColoredBox(
              color: context.color.surface,
              child: Column(
                children: [
                  Padding(
                    padding: getEdgeInsets(left: 16, right: 16),
                    child: const AppBarWidget(),
                  ),
                  DefaultTabController(
                    length: 3,
                    child: TabBar(
                      tabAlignment: TabAlignment.center,
                      labelPadding: getEdgeInsets(left: 16, right: 16),
                      controller: _tabController,
                      labelStyle: textStyle(
                        context,
                        StyleType.bodMd,
                      ).copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      tabs: [
                        Tab(
                          text: localize.planned,
                        ),
                        Tab(
                          text: localize.spent,
                        ),
                        Tab(
                          text: localize.remaining,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (widget.loading)
          const SliverFillRemaining(
            child: Center(
              child: CircularProgressIndicator.adaptive(),
            ),
          ),
        if (!widget.loading)
          SliverFillRemaining(
            child: TabBarView(
              controller: _tabController,
              children: [
                ColoredBox(
                  color: context.color.surface,
                  child: Center(
                    child: AppText(
                      text: localize.noDataAvailable,
                      style: StyleType.headSm,
                    ),
                  ),
                ),
                ColoredBox(
                  color: context.color.surface,
                  child: Center(
                    child: AppText(
                      text: localize.noDataAvailable,
                      style: StyleType.headSm,
                    ),
                  ),
                ),
                ColoredBox(
                  color: context.color.surface,
                  child: Center(
                    child: AppText(
                      text: localize.noDataAvailable,
                      style: StyleType.headSm,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class EmptyHomeContentWithAddBudgetButton extends StatefulWidget {
  const EmptyHomeContentWithAddBudgetButton({
    super.key,
    this.loading = false,
  });

  final bool loading;

  @override
  State<EmptyHomeContentWithAddBudgetButton> createState() =>
      _EmptyHomeContentWithAddBudgetButtonState();
}

class _EmptyHomeContentWithAddBudgetButtonState
    extends State<EmptyHomeContentWithAddBudgetButton>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 3,
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    final localize = textLocalizer(context);
    return CustomScrollView(
      slivers: [
        SliverPersistentHeader(
          pinned: true,
          floating: true,
          delegate: SliverAppBarDelegate(
            minHeight: 80.h,
            maxHeight: 80.h,
            child: ColoredBox(
              color: context.color.surface,
              child: Column(
                children: [
                  Padding(
                    padding: getEdgeInsets(left: 16, right: 16),
                    child: const AppBarWidget(),
                  ),
                  DefaultTabController(
                    length: 3,
                    child: TabBar(
                      tabAlignment: TabAlignment.center,
                      labelPadding: getEdgeInsets(left: 16, right: 16),
                      controller: _tabController,
                      labelStyle: textStyle(
                        context,
                        StyleType.bodMd,
                      ).copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      tabs: [
                        Tab(
                          text: localize.overview,
                        ),
                        Tab(
                          text: localize.tracking,
                        ),
                        Tab(
                          text: localize.insight,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (widget.loading)
          const SliverFillRemaining(
            child: Center(
              child: CircularProgressIndicator.adaptive(),
            ),
          ),
        if (!widget.loading)
          SliverFillRemaining(
            child: TabBarView(
              controller: _tabController,
              children: [
                _AddBudget(localize: localize),
                _AddBudget(localize: localize),
                _AddBudget(localize: localize),
              ],
            ),
          ),
      ],
    );
  }
}

class _AddBudget extends StatelessWidget {
  const _AddBudget({
    required this.localize,
  });

  final AppLocalizations localize;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: context.color.surface,
      child: Center(
        child: GestureDetector(
          onTap: () {
            context.read<BudgetFormBloc>().add(
                  BudgetFormToInitial(),
                );

            context.pushNamed(
              MyRoute.addNewBudgetScreen.noSlashes(),
            );
          },
          child: AppGlass(
            margin: getEdgeInsets(left: 16, right: 16, bottom: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Expanded(
                  child: SizedBox(),
                ),
                Icon(
                  CupertinoIcons.add,
                  color: context.color.primary,
                ),
                Gap.horizontal(10),
                Expanded(
                  flex: 2,
                  child: AppText(
                    text: localize.newBudget,
                    style: StyleType.bodMd,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
