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

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBarPrimary(
            title: 'My Portfolio',
          ),
          if (myPortfolioList.isEmpty)
            const SliverFillRemaining(
              child: Center(
                child: AppText(
                  text: 'No Portfolio',
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
      bottomSheet: BottomSheetParent(
        isWithBorderTop: true,
        child: AppButton(
          label: 'Add Portfolio',
          onPressed: () async {
            final result = await context.pushNamed(
              MyRoute.addPortfolio.noSlashes(),
            );
          },
        ),
      ),
    );
  }
}
