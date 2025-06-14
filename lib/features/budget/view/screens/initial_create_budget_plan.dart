import 'dart:async';

import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/core/l10n/app_localizations.dart';
import 'package:budget_intelli/features/ai_assistant/ai_assistant_barrel.dart';
import 'package:budget_intelli/features/auth/auth_barrel.dart';
import 'package:budget_intelli/features/budget/budget_barrel.dart';
import 'package:budget_intelli/features/budget/view/widgets/budget_form_field_initial.dart';
import 'package:budget_intelli/features/settings/settings_barrel.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

class InitialCreateBudgetPlanScreen extends StatefulWidget {
  const InitialCreateBudgetPlanScreen({super.key});

  @override
  State<InitialCreateBudgetPlanScreen> createState() =>
      _InitialCreateBudgetPlanScreenState();
}

class _InitialCreateBudgetPlanScreenState
    extends State<InitialCreateBudgetPlanScreen> {
  // Constants
  static const int _maxAiGenerateBudgetLimit = 3;
  static const int _maxDaysForWeeklyBudget = 25;
  static const double _calendarDialogWidthRatio = 0.9;
  static const double _calendarDialogHeight = 400.0;
  static const double _adWidgetHeight = 50.0;

  // Default names for validation
  static const String _groupNameInitialEN = 'Group Name';
  static const String _groupNameInitialID = 'Nama Grup';
  static const String _categoryNameInitialEN = 'Category Name';
  static const String _categoryNameInitialID = 'Nama Kategori';

  // Controllers and state
  final _scrollController = ScrollController();
  final _budgetNameController = TextEditingController();
  final _budgetNameFocus = FocusNode();
  final String budgetID = const Uuid().v1();
  final CollectionReference<Map<String, dynamic>> users =
      FirebaseFirestore.instance.collection('users');

  StreamSubscription<DocumentSnapshot>? userSubscription;
  bool _showOptionCreateBudget = true;

  @override
  void initState() {
    super.initState();
    _initializeScreen();
  }

  @override
  void dispose() {
    _disposeResources();
    super.dispose();
  }

  // Initialization Methods
  void _initializeScreen() {
    _initData();
    _getUserData();
    _setupScrollListener();
  }

  void _initData() {
    context.read<BudgetFormBloc>().add(
          BudgetFormInitial(generateBudgetAI: false),
        );
  }

  void _setupScrollListener() {
    _scrollController.addListener(() {
      if (mounted) setState(() {});
    });
  }

  void _disposeResources() {
    _scrollController.dispose();
    _budgetNameController.dispose();
    _budgetNameFocus.dispose();
    userSubscription?.cancel();
  }

  // AI Budget Generation Methods
  Future<void> _onAiCreateBudget() async {
    final prefsAi = AiAssistantPreferences();
    final totalGenerateBudget = await prefsAi.getTotalGenerateBudget();
    final isValidated = totalGenerateBudget <= _maxAiGenerateBudgetLimit;
    await _handleAiCreateBudgetValidation(isValidated);
  }

  Future<void> _handleAiCreateBudgetValidation(bool isValidated) async {
    if (isValidated) {
      await _navigateToAiGenerateScreen();
    } else {
      _showRequestLimitExceededError();
    }
  }

  Future<void> _navigateToAiGenerateScreen() async {
    setState(() => _showOptionCreateBudget = false);

    await context
        .pushNamed<String>(MyRoute.budgetAiGenerateScreen.noSlashes())
        .whenComplete(_handleAiGenerateScreenReturn);
  }

  void _handleAiGenerateScreenReturn() {
    if (mounted) {
      final budgetName = context.read<BudgetFormBloc>().state.budgetName;
      if (budgetName != null && budgetName.isNotEmpty) {
        setState(() => _budgetNameController.text = budgetName);
      }
    }
  }

  void _showRequestLimitExceededError() {
    AppToast.showToastError(
      context,
      textLocalizer(context).requestLimitExceeded,
    );
  }

  // User Authentication Methods
  Future<void> _getUserData() async {
    final userId = await context.read<PreferenceCubit>().getUserUid();
    if (userId != null) {
      _subscribeToUserData(userId);
    } else {
      _getUserSettingEvent();
    }
  }

  void _subscribeToUserData(String userId) {
    userSubscription = users.doc(userId).snapshots().listen(
      (event) {
        final documentData = event.data();
        if (documentData != null) {
          final user = UserIntelli.fromMap(documentData);
          _handleSuccessfulAuth(user);
        }
      },
    );
  }

  void _getUserSettingEvent() {
    if (mounted) {
      context.read<SettingBloc>().add(GetUserSettingEvent());
    }
  }

  void _handleSuccessfulAuth(UserIntelli user) {
    context.read<SettingBloc>()
      ..add(SetUserIntelli(user))
      ..add(SetUserIsLoggedIn(isLoggedIn: true))
      ..add(SetUserName(user.name))
      ..add(SetUserEmail(user.email))
      ..add(SetUserUidEvent(user.uid))
      ..add(SetUserIsPremiumUser(isPremiumUser: user.premium ?? false))
      ..add(GetUserSettingEvent());
  }

  // Date Selection Methods
  Future<void> _handleDateSelection() async {
    _budgetNameFocus.unfocus();
    final results = await _showDatePicker();
    if (results != null && results.length == 2) {
      _selectDateRange(results);
    }
  }

  Future<List<DateTime?>?> _showDatePicker() async {
    final now = DateTime.now();
    final width = context.screenWidth * _calendarDialogWidthRatio;
    final state = context.read<BudgetFormBloc>().state;

    return showCalendarDatePicker2Dialog(
      context: context,
      config: CalendarDatePicker2WithActionButtonsConfig(
        calendarType: CalendarDatePicker2Type.range,
        firstDate: now,
        controlsTextStyle: textStyle(context, style: StyleType.bodLg),
      ),
      dialogSize: Size(width, _calendarDialogHeight),
      value: state.dateRange,
      borderRadius: BorderRadius.circular(15),
    );
  }

  void _selectDateRange(List<DateTime?> results) {
    if (results.isNotEmpty) {
      context.read<BudgetFormBloc>().add(SelectDateRange(dateRange: results));
    }
  }

  // Save and Validation Methods
  void _onSaveButtonPressed(BudgetFormState state, BuildContext context) {
    if (_validateForm(state)) {
      _processBudgetSave(state);
    }
  }

  bool _validateForm(BudgetFormState state) {
    return _validateBudgetName() &&
        _validateGroupsAndCategories(state) &&
        _validateDateRange(state);
  }

  bool _validateBudgetName() {
    if (_budgetNameController.text.isEmpty) {
      _showValidationError(textLocalizer(context).budgetNameCannotBeEmpty);
      return false;
    }
    return true;
  }

  bool _validateGroupsAndCategories(BudgetFormState state) {
    for (final groupHistory in state.groupCategoryHistories) {
      if (!_validateGroupName(groupHistory.groupName)) return false;
      if (!_validateCategoryItems(groupHistory)) return false;
    }
    return true;
  }

  bool _validateGroupName(String groupName) {
    if (_isInvalidGroupName(groupName)) {
      _showValidationError(textLocalizer(context).groupNameCannotBeEmpty);
      return false;
    }
    return true;
  }

  bool _isInvalidGroupName(String groupName) {
    return groupName.isEmpty ||
        groupName == _groupNameInitialEN ||
        groupName == _groupNameInitialID;
  }

  bool _validateCategoryItems(GroupCategoryHistory groupHistory) {
    for (final item in groupHistory.itemCategoryHistories) {
      if (_isInvalidCategoryItem(item)) {
        _showValidationError(
            textLocalizer(context).categoryNameAndAmountCannotBeEmpty);
        return false;
      }
    }
    return true;
  }

  bool _isInvalidCategoryItem(ItemCategoryHistory item) {
    return item.name.isEmpty ||
        item.name == _categoryNameInitialID ||
        item.name == _categoryNameInitialEN ||
        item.amount == 0;
  }

  bool _validateDateRange(BudgetFormState state) {
    if (state.dateRange.isEmpty) {
      _showValidationError(textLocalizer(context).pleaseSelectDateRange);
      return false;
    }
    return true;
  }

  void _showValidationError(String message) {
    AppToast.showToastError(
      context,
      message,
      gravity: ToastGravity.CENTER,
    );
  }

  void _processBudgetSave(BudgetFormState state) {
    final (groupCategoryHistory, itemCategoriesParams) =
        _buildCategoryData(state);
    final budget = _buildBudgetData(state);

    _resetPromptAndSave(groupCategoryHistory, itemCategoriesParams, budget);
  }

  (List<GroupCategoryHistory>, List<ItemCategoryHistory>) _buildCategoryData(
      BudgetFormState state) {
    final groupCategoryHistory = <GroupCategoryHistory>[];
    final itemCategoriesParams = <ItemCategoryHistory>[];

    for (final groupHistory in state.groupCategoryHistories) {
      final groupParams = _createGroupCategoryHistory(groupHistory);
      groupCategoryHistory.add(groupParams);

      final itemParams = _createItemCategoryHistories(groupHistory);
      itemCategoriesParams.addAll(itemParams);
    }

    return (groupCategoryHistory, itemCategoriesParams);
  }

  GroupCategoryHistory _createGroupCategoryHistory(
      GroupCategoryHistory groupHistory) {
    return GroupCategoryHistory(
      id: groupHistory.id,
      groupName: groupHistory.groupName,
      method: groupHistory.method,
      type: groupHistory.type,
      budgetId: budgetID,
      groupId: groupHistory.groupId,
      createdAt: groupHistory.createdAt,
      updatedAt: groupHistory.createdAt,
      hexColor: groupHistory.hexColor,
    );
  }

  List<ItemCategoryHistory> _createItemCategoryHistories(
      GroupCategoryHistory groupHistory) {
    return groupHistory.itemCategoryHistories
        .map((item) => ItemCategoryHistory(
              id: item.id,
              name: item.name,
              groupHistoryId: groupHistory.id,
              itemId: item.itemId,
              amount: item.amount,
              type: item.type,
              createdAt: item.createdAt,
              isExpense: item.isExpense,
              budgetId: budgetID,
              groupName: groupHistory.groupName,
            ))
        .toList();
  }

  Budget _buildBudgetData(BudgetFormState state) {
    final selectedRangeDate = state.dateRange;
    final startDate = selectedRangeDate[0].toString();
    final endDate = selectedRangeDate[1]!;
    final endDateStr = _formatEndDate(endDate);
    final (isWeekly, isMonthly) = _determineBudgetType(selectedRangeDate);

    return Budget(
      id: budgetID,
      budgetName: _budgetNameController.text,
      createdAt: DateTime.now().toString(),
      startDate: startDate,
      endDate: endDateStr,
      isActive: true,
      isMonthly: isMonthly,
      isWeekly: isWeekly,
      month: selectedRangeDate[0]!.month,
      year: selectedRangeDate[0]!.year,
      totalPlanExpense: state.totalPlanExpense,
      totalPlanIncome: state.totalPlanIncome,
    );
  }

  String _formatEndDate(DateTime endDate) {
    return '${endDate.year}-${endDate.month.toString().padLeft(2, '0')}-${endDate.day.toString().padLeft(2, '0')} 23:59';
  }

  (bool, bool) _determineBudgetType(List<DateTime?> selectedRangeDate) {
    if (selectedRangeDate.isEmpty) return (false, false);

    final startDate = selectedRangeDate[0]!;
    final endDate = selectedRangeDate[1]!;
    final totalDays = endDate.difference(startDate).inDays;

    return totalDays < _maxDaysForWeeklyBudget ? (true, false) : (false, true);
  }

  void _resetPromptAndSave(
    List<GroupCategoryHistory> groupCategoryHistory,
    List<ItemCategoryHistory> itemCategoriesParams,
    Budget budget,
  ) {
    context.read<PromptCubit>().resetPrompt();
    context.read<BudgetFormBloc>().add(
          InsertBudgetsToDatabase(
            groupCategoryHistories: groupCategoryHistory,
            itemCategoryHistories: itemCategoriesParams,
            budget: budget,
            fromInitial: true,
          ),
        );
  }

  // Success Handling Methods
  Future<void> _handleSuccessfulBudgetSave(BudgetFormState state) async {
    _updateUserSettings();
    await _insertToFirestore(state);
  }

  void _updateUserSettings() {
    context.read<SettingBloc>()
      ..add(
        SetUserLastSeenBudgetId(lastSeenBudgetId: budgetID),
      )
      ..add(
        SetUserAlreadySetInitialCreateBudget(
          alreadySetInitialCreateBudget: true,
        ),
      );
  }

  Future<void> _insertToFirestore(BudgetFormState state) async {
    final settingState = context.read<SettingBloc>().state;
    final userIntellie = settingState.user;
    final isPremium = userIntellie?.premium ?? false;

    if (isPremium) {
      await _insertPremiumBudgetToFirestore(state, userIntellie);
    } else {
      _handleNonPremiumSave();
    }
  }

  Future<void> _insertPremiumBudgetToFirestore(
      BudgetFormState state, UserIntelli? userIntellie) async {
    await context.read<BudgetFirestoreCubit>().insertBudgetToFirestore(
          groupCategoryHistoriesParams: state.groupCategoryHistoriesParams,
          itemCategoryHistoriesParams: state.itemCategoryHistoriesParams,
          budgetParams: state.budgetParams!,
          fromInitial: true,
          user: userIntellie,
          fromSync: false,
        );
  }

  void _handleNonPremiumSave() {
    AppToast.showToastSuccess(
      context,
      textLocalizer(context).saveSuccessfully,
    );
    _navigateToMain();
  }

  void _navigateToMain() {
    context.read<BudgetBloc>().add(GetBudgetsByIdEvent(id: budgetID));
    context.go(MyRoute.main);
  }

  // Title Generation Methods
  (String, String) _generateTitle(BudgetFormState state) {
    final localize = textLocalizer(context);

    if (!_isScrolled()) {
      return (localize.budgetPlan, '');
    }

    if (_isAllAssigned(state)) {
      return (localize.allAssigned, '');
    }

    if (state.totalBalance != null) {
      return _generateBalanceTitle(state, localize);
    }

    return (localize.budgetPlan, '');
  }

  bool _isScrolled() =>
      _scrollController.hasClients && _scrollController.offset > 0;

  bool _isAllAssigned(BudgetFormState state) {
    return state.totalBalance == 0 &&
        state.totalPlanExpense != 0 &&
        state.totalPlanIncome != 0;
  }

  (String, String) _generateBalanceTitle(
      BudgetFormState state, AppLocalizations localize) {
    final balance = state.totalBalance!;
    final money = NumberFormatter.formatToMoneyDouble(context, balance);

    if (balance < 0) {
      return (money, localize.exceedsBudget);
    } else {
      return (money, localize.notAssignedYet);
    }
  }

  // Premium Modal Methods
  void _showPremiumModal(UserIntelli? user) {
    final statusBarHeight = MediaQuery.of(context).padding.top;
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height - statusBarHeight,
      ),
      builder: (context) => PremiumModal(user: user),
    );
  }

  // UI Building Methods
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingBloc, SettingState>(
      builder: (context, settingState) {
        if (settingState.loading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator.adaptive()),
          );
        }

        return _buildMainContent(settingState.user?.premium ?? false);
      },
    );
  }

  Widget _buildMainContent(bool isPremium) {
    return BlocConsumer<BudgetFormBloc, BudgetFormState>(
      listenWhen: (previous, current) =>
          previous.insertBudgetSuccess != current.insertBudgetSuccess ||
          previous.budgetName != current.budgetName,
      listener: _handleBudgetFormStateChanges,
      builder: (context, state) => _buildScaffold(state, isPremium),
    );
  }

  void _handleBudgetFormStateChanges(
      BuildContext context, BudgetFormState state) {
    if (state.insertBudgetSuccess != null) {
      if (state.insertBudgetSuccess == true) {
        _handleSuccessfulBudgetSave(state);
      } else {
        _handleFailedBudgetSave();
      }
    }
  }

  void _handleFailedBudgetSave() {
    AppToast.showToastError(
      context,
      textLocalizer(context).failedToSave,
    );
    _budgetNameFocus.unfocus();
  }

  Widget _buildScaffold(BudgetFormState state, bool isPremium) {
    return Scaffold(
      body: Stack(
        children: [
          _buildScrollableContent(state, isPremium),
          if (_showOptionCreateBudget) _buildCreateBudgetOptionOverlay(),
        ],
      ),
    );
  }

  Widget _buildScrollableContent(BudgetFormState state, bool isPremium) {
    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        _buildSliverAppBar(state),
        _buildHeaderSection(state),
        if (state.groupCategoryHistories.isNotEmpty) _buildBudgetFormField(),
        _buildSaveSection(state, isPremium),
      ],
    );
  }

  Widget _buildCreateBudgetOptionOverlay() {
    return Stack(
      children: [
        GestureDetector(
          onTap: () => setState(() => _showOptionCreateBudget = false),
          child: Container(
            width: context.screenWidth,
            height: context.screenHeight,
            color: Colors.transparent,
          ),
        ),
        Align(
          child: CreateBudgetOptionDialog(
            onManualPressed: () =>
                setState(() => _showOptionCreateBudget = false),
            onAiPressed: () async {
              await _onAiCreateBudget();
              setState(() => _showOptionCreateBudget = false);
            },
          ),
        ),
      ],
    );
  }

  SliverAppBar _buildSliverAppBar(BudgetFormState state) {
    final (firstTitle, secondTitle) = _generateTitle(state);
    final onSurfaceColor = context.color.onSurface.withValues(alpha: 0.5);

    return SliverAppBar(
      centerTitle: true,
      title: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: firstTitle,
              style: textStyle(context, style: StyleType.headMed),
            ),
            if (secondTitle.isNotEmpty)
              TextSpan(
                text: ' $secondTitle',
                style: textStyle(context, style: StyleType.bodMed).copyWith(
                  fontStyle: FontStyle.italic,
                  color: onSurfaceColor,
                ),
              ),
          ],
        ),
      ),
      floating: true,
      pinned: true,
    );
  }

  SliverPadding _buildHeaderSection(BudgetFormState state) {
    return SliverPadding(
      padding: getEdgeInsets(left: 16, top: 16, right: 16, bottom: 8),
      sliver: SliverToBoxAdapter(
        child: Column(
          children: [
            _buildAiGenerateButton(),
            _buildBudgetNameField(),
            Gap.vertical(8),
            _buildDateRangeSelector(state),
          ],
        ),
      ),
    );
  }

  Widget _buildAiGenerateButton() {
    final localize = textLocalizer(context);
    return GestureDetector(
      onTap: _onAiCreateBudget,
      child: AppGlass(
        margin: getEdgeInsets(bottom: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppText(
              text: localize.generateWithAI,
              style: StyleType.bodLg,
              textAlign: TextAlign.center,
            ),
            Gap.horizontal(16),
            const Icon(CupertinoIcons.chevron_right),
          ],
        ),
      ),
    );
  }

  Widget _buildBudgetNameField() {
    return AppBoxFormField(
      hintText: textLocalizer(context).budgetName,
      prefixIcon: budgetPng,
      controller: _budgetNameController,
      focusNode: _budgetNameFocus,
      isPng: true,
    );
  }

  Widget _buildDateRangeSelector(BudgetFormState state) {
    final onSurfaceColor = context.color.onSurface.withValues(alpha: 0.5);

    return GestureDetector(
      onTap: _handleDateSelection,
      child: AppGlass(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppText(
              text: formatDateRangeDateList(state.dateRange, context),
              style: StyleType.bodMed,
              textAlign: TextAlign.center,
              fontWeight: state.dateRange.isEmpty ? null : FontWeight.w700,
              maxLines: 2,
              color: state.dateRange.isEmpty
                  ? onSurfaceColor
                  : context.color.onSurface,
            ),
            Gap.horizontal(16),
            getPngAsset(
              chevronDownPng,
              color: context.color.primary,
              width: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBudgetFormField() {
    return BudgetFormFieldInitial(
      key: const ValueKey('budget_form_field_initial'),
      fromInitial: true,
      budgetId: budgetID,
      groupCategories:
          context.read<BudgetFormBloc>().state.groupCategoryHistories,
      portions: context.read<BudgetFormBloc>().state.portions,
    );
  }

  Widget _buildSaveSection(BudgetFormState state, bool isPremium) {
    return SliverPadding(
      padding: getEdgeInsetsSymmetric(horizontal: 16, vertical: 10),
      sliver: SliverToBoxAdapter(
        child: Column(
          children: [
            _buildSaveButton(state),
            if (!isPremium) _buildAdSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildSaveButton(BudgetFormState state) {
    return BlocConsumer<BudgetFirestoreCubit, BudgetFirestoreState>(
      listener: _handleFirestoreStateChanges,
      builder: (context, fireState) {
        if (fireState.loadingFirestore) {
          return const Center(child: CircularProgressIndicator.adaptive());
        }

        return AppButton(
          label: textLocalizer(context).save,
          onPressed: () => _onSaveButtonPressed(state, context),
        );
      },
    );
  }

  void _handleFirestoreStateChanges(
      BuildContext context, BudgetFirestoreState fireState) {
    if (fireState.insertBudgetToFirestoreSuccess) {
      AppToast.showToastSuccess(
        context,
        textLocalizer(context).saveSuccessfully,
      );
      _navigateToMain();
    }
  }

  Widget _buildAdSection() {
    return Column(
      children: [
        Gap.vertical(8),
        AdWidgetRepository(
          height: _adWidgetHeight,
          child: Container(color: context.color.surface),
        ),
      ],
    );
  }
}
