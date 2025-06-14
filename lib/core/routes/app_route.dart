part of 'app_route_import.dart';

class AppRoute {
  static final router = GoRouter(
    debugLogDiagnostics: true,
    initialLocation: MyRoute.initialScreen,
    redirect: (context, state) async {
      final initialSettingDone =
          await serviceLocator<SettingPreferenceRepo>().getInitialSetting();
      final initialCreateBudget =
          await serviceLocator<SettingPreferenceRepo>().getIntialCreateBudget();
      final continueWithoutLogin =
          await serviceLocator<UserPreferenceRepo>().getContinueWithoutLogin();
      final onlyFinancialTracker = await serviceLocator<SettingPreferenceRepo>()
          .getOnlyFinancialTracker();
      final onInitialScreen = state.fullPath == MyRoute.initialScreen;

      if (onlyFinancialTracker &&
          onInitialScreen &&
          continueWithoutLogin &&
          initialSettingDone) {
        return MyRoute.financialDashboardTracker;
      }

      if (onInitialScreen &&
          initialSettingDone &&
          initialCreateBudget &&
          continueWithoutLogin) {
        return MyRoute.main;
      } else if (!initialSettingDone &&
          !initialCreateBudget &&
          !continueWithoutLogin) {
        return MyRoute.initialSetting;
      } else if (onInitialScreen && continueWithoutLogin) {
        return MyRoute.initialCreateBudgetPlan;
      }
      return null;
    },
    routes: [
      GoRoute(
        path: MyRoute.initialScreen,
        pageBuilder: (context, state) => _customTransitionPage(
          const InitialScreen(),
          rightToLeft: true,
        ),
      ),
      GoRoute(
        path: MyRoute.initialSetting,
        pageBuilder: (context, state) => _customTransitionPage(
          const InitialSettingScreen(),
          rightToLeft: true,
        ),
      ),
      GoRoute(
        path: MyRoute.onboarding,
        pageBuilder: (context, state) => const MaterialPage(
          child: OnboardingScreen(),
        ),
      ),
      GoRoute(
        path: MyRoute.main,
        pageBuilder: (context, state) => const MaterialPage(
          child: MainNavigation(),
        ),
        routes: [
          GoRoute(
            path: MyRoute.addTransaction.noSlashes(),
            name: MyRoute.addTransaction.noSlashes(),
            pageBuilder: (context, state) => _customTransitionPage(
              const AddTransactionScreen(),
              bottomToTop: true,
            ),
          ),
          GoRoute(
            path: MyRoute.detailCategory.noSlashes(),
            name: MyRoute.detailCategory.noSlashes(),
            pageBuilder: (context, state) => _customTransitionPage(
              const DetailCategoryScreen(),
              rightToLeft: true,
            ),
            routes: [
              GoRoute(
                path: MyRoute.addIncomeLocal.noSlashes(),
                name: MyRoute.addIncomeLocal.noSlashes(),
                pageBuilder: (context, state) => _customTransitionPage(
                  const AddIncomeIncomeTransactionScreen(),
                  bottomToTop: true,
                ),
              ),
              GoRoute(
                path: MyRoute.addExpense.noSlashes(),
                name: MyRoute.addExpense.noSlashes(),
                pageBuilder: (context, state) => _customTransitionPage(
                  const AddExpenseTransactionScreen(),
                  bottomToTop: true,
                ),
              ),
              GoRoute(
                path: MyRoute.updateItemCategoryTransaction.noSlashes(),
                name: MyRoute.updateItemCategoryTransaction.noSlashes(),
                pageBuilder: (context, state) => _customTransitionPage(
                  const UpdateItemCategoryTransactionScreen(),
                  rightToLeft: true,
                ),
              ),
            ],
          ),
          GoRoute(
            path: MyRoute.addGroupCategory.noSlashes(),
            name: MyRoute.addGroupCategory.noSlashes(),
            pageBuilder: (context, state) => _customTransitionPage(
              const AddGroupCategoryScreen(),
              rightToLeft: true,
            ),
          ),
          GoRoute(
            path: MyRoute.addNewBudgetScreen.noSlashes(),
            name: MyRoute.addNewBudgetScreen.noSlashes(),
            pageBuilder: (context, state) => _customTransitionPage(
              const AddNewBudgetScreen(),
              rightToLeft: true,
            ),
          ),
          GoRoute(
            path: MyRoute.schedulePaymentsList.noSlashes(),
            name: MyRoute.schedulePaymentsList.noSlashes(),
            pageBuilder: (context, state) => _customTransitionPage(
              const SchedulePaymentListScreen(),
              rightToLeft: true,
            ),
            routes: [
              GoRoute(
                path: MyRoute.addSchedulePayment.noSlashes(),
                name: MyRoute.addSchedulePayment.noSlashes(),
                pageBuilder: (context, state) => _customTransitionPage(
                  const AddSchedulePaymentsScreen(),
                  rightToLeft: true,
                ),
              ),
              GoRoute(
                path: MyRoute.schedulePaymentsDetail.noSlashes(),
                name: MyRoute.schedulePaymentsDetail.noSlashes(),
                pageBuilder: (context, state) => const MaterialPage(
                  child: SchedulePaymentsDetailScreen(),
                ),
              ),
            ],
          ),
          GoRoute(
            path: MyRoute.goalList.noSlashes(),
            name: MyRoute.goalList.noSlashes(),
            pageBuilder: (context, state) => _customTransitionPage(
              const GoalListScreen(),
              rightToLeft: true,
            ),
            routes: [
              GoRoute(
                path: MyRoute.addGoal.noSlashes(),
                name: MyRoute.addGoal.noSlashes(),
                pageBuilder: (context, state) => _customTransitionPage(
                  const AddGoalScreen(),
                  rightToLeft: true,
                ),
              ),
              GoRoute(
                path: MyRoute.detailGoal.noSlashes(),
                name: MyRoute.detailGoal.noSlashes(),
                pageBuilder: (context, state) => _customTransitionPage(
                  const GoalDetailScreen(),
                  rightToLeft: true,
                ),
              ),
            ],
          ),
          GoRoute(
            path: MyRoute.myPortfolio.noSlashes(),
            name: MyRoute.myPortfolio.noSlashes(),
            pageBuilder: (context, state) => _customTransitionPage(
              const MyPortfolioListScreen(),
              rightToLeft: true,
            ),
            routes: [
              GoRoute(
                path: MyRoute.addPortfolio.noSlashes(),
                name: MyRoute.addPortfolio.noSlashes(),
                pageBuilder: (context, state) => _customTransitionPage(
                  const AddMyPortfolioScreen(),
                  rightToLeft: true,
                ),
              ),
              GoRoute(
                path: MyRoute.detailPortfolio.noSlashes(),
                name: MyRoute.detailPortfolio.noSlashes(),
                pageBuilder: (context, state) => _customTransitionPage(
                  const DetailMyPortfolioScreen(),
                  rightToLeft: true,
                ),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: MyRoute.welcome,
        pageBuilder: (context, state) => const MaterialPage(
          child: WelcomeScreen(),
        ),
      ),
      GoRoute(
        path: MyRoute.signUpInitial,
        pageBuilder: (context, state) => _customTransitionPage(
          const SignUpScreenInitial(),
          rightToLeft: true,
        ),
      ),
      GoRoute(
        path: MyRoute.signInInitial,
        pageBuilder: (context, state) => _customTransitionPage(
          const SignInScreenInitial(),
          rightToLeft: true,
        ),
      ),

      // GoRoute(
      //   path: MyRoute.schedulePaymentsList,
      //   pageBuilder: (context, state) => const MaterialPage(
      //     child: SchedulePaymentsListScreen(),
      //   ),
      // ),

      // GoRoute(
      //   path: MyRoute.splashScreen,
      //   pageBuilder: (context, state) => const MaterialPage(
      //     child: SplashScreen(),
      //   ),
      // ),
      GoRoute(
        path: MyRoute.chatScreen,
        pageBuilder: (context, state) => const MaterialPage(
          child: ChatScreen(),
        ),
      ),
      GoRoute(
        path: MyRoute.netWorthTracker,
        pageBuilder: (context, state) => _customTransitionPage(
          const NetWorthTrackerScreen(),
          rightToLeft: true,
        ),
      ),
      GoRoute(
        path: MyRoute.initialCreateBudgetPlan,
        pageBuilder: (context, state) => _customTransitionPage(
          const InitialCreateBudgetPlanScreen(),
          bottomToTop: true,
        ),
        routes: [
          GoRoute(
            path: MyRoute.budgetAiGenerateScreen.noSlashes(),
            name: MyRoute.budgetAiGenerateScreen.noSlashes(),
            pageBuilder: (context, state) => _customTransitionPage(
              const AiBudgetGenerateScreen(),
              rightToLeft: true,
            ),
          ),
        ],
      ),
      GoRoute(
        path: MyRoute.budgetList,
        pageBuilder: (context, state) => const MaterialPage(
          child: BudgetListScreen(),
        ),
      ),

      GoRoute(
        path: MyRoute.listIconScreen,
        pageBuilder: (context, state) => _customTransitionPage(
          const ListIconScreen(),
          rightToLeft: true,
        ),
      ),

      GoRoute(
        path: MyRoute.addAssetAccount,
        pageBuilder: (context, state) => _customTransitionPage(
          const AddAssetAccountScreen(),
          rightToLeft: true,
        ),
      ),
      GoRoute(
        path: MyRoute.addLiabilityAccount,
        pageBuilder: (context, state) => _customTransitionPage(
          const AddLiabilityAccountScreen(),
          rightToLeft: true,
        ),
      ),
      GoRoute(
        path: MyRoute.addItemCategory,
        pageBuilder: (context, state) => _customTransitionPage(
          const AddItemCategoryScreen(),
          rightToLeft: true,
        ),
      ),
      GoRoute(
        path: MyRoute.accountScreen,
        pageBuilder: (context, state) => _customTransitionPage(
          const AccountScreen(),
          rightToLeft: true,
        ),
      ),
      GoRoute(
        path: MyRoute.addAccountScreen,
        pageBuilder: (context, state) => _customTransitionPage(
          const AddAccountScreen(),
          rightToLeft: true,
        ),
      ),
      GoRoute(
        path: MyRoute.accountTransactionScreen,
        pageBuilder: (context, state) => _customTransitionPage(
          const AccountTransactionScreen(),
          rightToLeft: true,
        ),
      ),
      GoRoute(
        path: MyRoute.accountTransferScreen,
        pageBuilder: (context, state) => _customTransitionPage(
          const AccountTransferScreen(),
          rightToLeft: true,
        ),
      ),
      GoRoute(
        path: MyRoute.signInFromProfile,
        pageBuilder: (context, state) => _customTransitionPage(
          const SignInScreenFromProfile(),
          rightToLeft: true,
        ),
      ),
      GoRoute(
        path: MyRoute.signUpFromProfile,
        pageBuilder: (context, state) => _customTransitionPage(
          const SignUpScreenFromProfile(),
          rightToLeft: true,
        ),
      ),
      GoRoute(
        path: MyRoute.financialCalculator,
        pageBuilder: (context, state) => _customTransitionPage(
          const FinancialCalculatorScreen(),
          rightToLeft: true,
        ),
      ),
      GoRoute(
        path: MyRoute.mortgageCalculator,
        pageBuilder: (context, state) => _customTransitionPage(
          const MortgageCalculatorScreen(),
          rightToLeft: true,
        ),
      ),
      GoRoute(
        path: MyRoute.financialDashboardTracker,
        pageBuilder: (context, state) => _customTransitionPage(
          const FinancialTrackerDashboard(),
          rightToLeft: true,
        ),
        routes: [
          GoRoute(
            path: MyRoute.setting.noSlashes(),
            name: MyRoute.setting.noSlashes(),
            pageBuilder: (context, state) => _customTransitionPage(
              const SettingScreen(),
              leftToRight: true,
            ),
          ),
          GoRoute(
            path: MyRoute.accountScreenFinancialTracker.noSlashes(),
            name: MyRoute.accountScreenFinancialTracker.noSlashes(),
            pageBuilder: (context, state) => _customTransitionPage(
              const AccountScreen(),
              bottomToTop: true,
            ),
          ),
          GoRoute(
            path: MyRoute.member.noSlashes(),
            name: MyRoute.member.noSlashes(),
            pageBuilder: (context, state) => _customTransitionPage(
              const MemberScreen(),
              leftToRight: true,
            ),
          ),
        ],
      ),
    ],
  );

  static CustomTransitionPage<dynamic> _customTransitionPage(
    Widget child, {
    bool bottomToTop = false,
    bool rightToLeft = false,
    bool leftToRight = false,
  }) {
    return CustomTransitionPage(
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        Offset? begin;
        Offset? end;
        Curve? curve;
        if (bottomToTop) {
          begin = const Offset(0, 1);
          end = Offset.zero;
          curve = Curves.ease;
        } else if (rightToLeft) {
          begin = const Offset(1, 0);
          end = Offset.zero;
          curve = Curves.ease;
        } else if (leftToRight) {
          begin = const Offset(-1, 0);
          end = Offset.zero;
          curve = Curves.ease;
        } else {
          begin = const Offset(0, -1);
          end = Offset.zero;
          curve = Curves.ease;
        }

        return SlideTransition(
          position: Tween<Offset>(
            begin: begin,
            end: end,
          ).animate(
            CurvedAnimation(
              parent: animation,
              curve: curve,
            ),
          ),
          child: child,
        );
      },
    );
  }
}
