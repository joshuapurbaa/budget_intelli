import 'dart:async';

import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/auth/auth_barrel.dart';
import 'package:budget_intelli/features/auth/view/screens/profile_screen.dart';
import 'package:budget_intelli/features/bottom_navbar/widgets/explore.dart';
import 'package:budget_intelli/features/bottom_navbar/widgets/home.dart';
import 'package:budget_intelli/features/budget/budget_barrel.dart';
import 'package:budget_intelli/features/category/view/controllers/category/category_cubit.dart';
import 'package:budget_intelli/features/settings/settings_barrel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;
  bool onAiAssistant = false;
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  StreamSubscription<DocumentSnapshot>? userSubscription;
  late final AppLifecycleListener _listener;

  @override
  void initState() {
    super.initState();
    _listener = AppLifecycleListener(
      onStateChange: _onStateChanged,
    );

    _getUserData();
  }

  Future<void> _getUserData() async {
    final userId = await context.read<PreferenceCubit>().getUserUid();
    if (userId != null) {
      userSubscription = users.doc(userId).snapshots().listen(
        (event) {
          final documentData = event.data() as MapStringDynamic?;
          final user = UserIntelli.fromMap(documentData);
          _onSuccessAuth(user);
          // final isPremium = user.premium ?? false;
          // if (!isPremium) {
          //   _showPremiumModalBottom(user);
          // }
        },
      );
    } else {
      _getSetting();
      // _showPremiumModalBottom(null);
    }
  }

  void _getSetting() {
    context.read<SettingBloc>().add(
          GetUserSettingEvent(),
        );
  }

  @override
  void dispose() {
    userSubscription?.cancel();
    _listener.dispose();
    super.dispose();
  }

  Future<void> _onSuccessAuth(UserIntelli? user) async {
    if (user != null) {
      context.read<SettingBloc>()
        ..add(SetUserIntelli(user))
        ..add(SetUserIsLoggedIn(isLoggedIn: true))
        ..add(SetUserName(user.name))
        ..add(SetUserEmail(user.email))
        ..add(SetUserUidEvent(user.uid))
        ..add(SetUserIsPremiumUser(isPremiumUser: user.premium ?? false))
        ..add(GetUserSettingEvent());

      syncBudget(user);
    }
  }

  void syncBudget(UserIntelli user) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final result = await context.read<BudgetsCubit>().getBudgets();
      if (result != null) {
        final localBudgetIds = result.map((e) => e.id).toList();
        final firestoreBudgetIds = user.budgetIds;
        if (localBudgetIds.length != firestoreBudgetIds.length) {
          if (firestoreBudgetIds.length < localBudgetIds.length) {
            //   add non existing budget from local to firestore
            final diff = localBudgetIds
                .toSet()
                .difference(firestoreBudgetIds.toSet())
                .toList();

            for (final element in diff) {
              final budget = result.firstWhere((e) => e.id == element);
              if (!mounted) return;
              final groupCategoryHistoriesParams = await context
                  .read<CategoryCubit>()
                  .getGroupCategoryHistoryByBudgetId(budgetId: budget.id);
              if (!mounted) return;
              final itemCategoryHistoriesParams = await context
                  .read<CategoryCubit>()
                  .getItemCategoryHistoriesByBudgetId(budget.id);
              if (!mounted) return;
              final groupCategoriesParams =
                  await context.read<CategoryCubit>().getGroupCategories();
              if (!mounted) return;
              final itemCategoriesParams =
                  await context.read<CategoryCubit>().getItemCategories();

              await _insertToFirestore(
                premium: user.premium ?? false,
                userIntellie: user,
                budgetParams: budget,
                groupCategoryHistoriesParams: groupCategoryHistoriesParams,
                itemCategoryHistoriesParams: itemCategoryHistoriesParams,
                groupCategoriesParams: groupCategoriesParams,
                itemCategoriesParams: itemCategoriesParams,
              );
            }
          } else {
            // add non existing budget from firestore to local
            // final diff = firestoreBudgetIds.toSet().difference(localBudgetIds.toSet()).toList();
            // diff.forEach((element) {
            //   final budget = user.budgets!.firstWhere((e) => e.id == element);
            //   context.read<BudgetsCubit>().addBudget(budget);
            // });
          }
        }
      }
    });
  }

  Future<void> _insertToFirestore({
    required bool premium,
    required UserIntelli userIntellie,
    required Budget budgetParams,
    required List<GroupCategoryHistory> groupCategoryHistoriesParams,
    required List<ItemCategoryHistory> itemCategoryHistoriesParams,
    required List<GroupCategory> groupCategoriesParams,
    required List<ItemCategory> itemCategoriesParams,
  }) async {
    if (premium) {
      await context.read<BudgetFirestoreCubit>().insertBudgetToFirestore(
            groupCategoryHistoriesParams: groupCategoryHistoriesParams,
            itemCategoryHistoriesParams: itemCategoryHistoriesParams,
            budgetParams: budgetParams,
            fromInitial: false,
            user: userIntellie,
            groupCategoriesParams: groupCategoriesParams,
            itemCategories: itemCategoriesParams,
            fromSync: true,
          );
    }
  }

  // void _showPremiumModalBottom(UserIntelli? user) {
  //   final statusBarHeight = MediaQuery.of(context).padding.top;
  //   showModalBottomSheet<void>(
  //     context: context,
  //     isScrollControlled: true,
  //     constraints: BoxConstraints(
  //       maxHeight: MediaQuery.sizeOf(context).height - statusBarHeight,
  //     ),
  //     builder: (context) {
  //       return PremiumModal(
  //         user: user,
  //       );
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingBloc, SettingState>(
      builder: (context, state) {
        UserIntelli? user;

        if (state.user != null) {
          user = state.user;
        }

        if (state.loading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (state.useBiometrics && !state.isAuthenticated) {
          return const BimetricAuth();
        }

        return Scaffold(
          body: IndexedStack(
            index: _selectedIndex,
            children: [
              HomePage(
                user: user,
              ),
              // AiAssistantsPage(),
              ExplorePage(
                user: user,
              ),
              const ProfileScreen(),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            shape: const CircleBorder(),
            onPressed: () {
              context.pushNamed(
                MyRoute.addTransaction.noSlashes(),
              );
            },
            child: const Icon(Icons.add),
          ),
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: context.color.onSurfaceVariant,
                  width: 0.1,
                ),
              ),
              boxShadow: [
                BoxShadow(
                  color: context.color.onSurfaceVariant.withOpacity(0.1),
                  blurRadius: 10,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: BottomNavigationBar(
              elevation: 10,
              type: BottomNavigationBarType.fixed,
              currentIndex: _selectedIndex,
              onTap: (value) {
                if (value == 1) {
                  onAiAssistant = true;
                } else {
                  onAiAssistant = false;
                }

                setState(() {
                  _selectedIndex = value;
                });
              },
              items: [
                BottomNavigationBarItem(
                  icon: iconNavBar(
                    isActive: false,
                    unSelectedIconPath: houseCrackPng,
                  ),
                  activeIcon: iconNavBar(
                    isActive: true,
                    activeIconPath: houseCrackFilledPng,
                  ),
                  label: '',
                ),
                // BottomNavigationBarItem(
                //   icon: iconNavBar(
                //     isActive: false,
                //     unSelectedIconPath: artificialIntelligencePng,
                //     padding: getEdgeInsets(top: 12),
                //   ),
                //   activeIcon: iconNavBar(
                //     isActive: true,
                //     activeIconPath: artificialIntelligenceFilledPng,
                //     padding: getEdgeInsets(top: 12),
                //   ),
                //   label: '',
                // ),
                BottomNavigationBarItem(
                  icon: iconNavBar(
                    isActive: false,
                    unSelectedIconPath: exploreFlashlightPng,
                    padding: getEdgeInsets(top: 12),
                  ),
                  activeIcon: iconNavBar(
                    isActive: true,
                    activeIconPath: exploreFilledPng,
                    padding: getEdgeInsets(top: 12),
                  ),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: iconNavBar(
                    isActive: false,
                    unSelectedIconPath: userPng,
                  ),
                  activeIcon: iconNavBar(
                    isActive: true,
                    activeIconPath: userFilledPng,
                  ),
                  label: '',
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Padding iconNavBar({
    required bool isActive,
    String? activeIconPath,
    String? unSelectedIconPath,
    EdgeInsetsGeometry? padding,
  }) {
    if (isActive) {
      return Padding(
        padding: padding ?? getEdgeInsets(top: 12),
        child: getPngAsset(
          activeIconPath!,
          height: 20,
          color: context.color.primary,
        ),
      );
    } else {
      return Padding(
        padding: padding ?? getEdgeInsets(top: 12),
        child: getPngAsset(
          unSelectedIconPath!,
          color: context.color.onSurfaceVariant,
          height: 20,
        ),
      );
    }
  }

  // Listen to the app lifecycle state changes
  void _onStateChanged(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.detached:
        _onDetached();
      case AppLifecycleState.resumed:
        _onResumed();
      case AppLifecycleState.inactive:
        _onInactive();
      case AppLifecycleState.hidden:
        _onHidden();
      case AppLifecycleState.paused:
        _onPaused();
    }
  }

  void _onDetached() {}

  Future<void> _onResumed() async {
    final settingRepository = SettingPreferenceRepo();
    final authenticated = await settingRepository.getIsAuthenticated();

    if (!authenticated) {
      if (!mounted) {
        return;
      } else {
        setState(() {
          _selectedIndex = 0;
        });

        context.go(MyRoute.main);
        _getSetting();
      }
    }
  }

  void _onInactive() {}

  void _onHidden() {}

  void _onPaused() {}
}
