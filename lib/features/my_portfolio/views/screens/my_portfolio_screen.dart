import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/my_portfolio/views/views.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class MyPortfolioListScreen extends StatelessWidget {
  const MyPortfolioListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final myPortfolioList =
        context.watch<MyPortfolioDbBloc>().state.myPortfolios;

    final localize = textLocalizer(context);

    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverAppBarPrimary(
                title: localize.myPortfolio,
              ),
              if (myPortfolioList.isEmpty)
                SliverFillRemaining(
                  child: Center(
                    child: AppText(
                      text: localize.noPortfolio,
                      style: StyleType.bodLg,
                    ),
                  ),
                ),
              SliverList.builder(
                itemCount: myPortfolioList.length,
                itemBuilder: (context, index) {
                  return PortfolioItem(
                    myPortfolio: myPortfolioList[index],
                    onTap: () {
                      context.pushNamed(
                        MyRoute.detailPortfolio.noSlashes(),
                      );
                    },
                  );
                },
              ),
              const SliverToBoxAdapter(
                child: SizedBox(height: 100),
              ),
            ],
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: BottomSheetParent(
                isWithBorderTop: true,
                child: AppButton(
                  label: localize.addPortfolio,
                  onPressed: () async {
                    await context.pushNamed(
                      MyRoute.addPortfolio.noSlashes(),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
