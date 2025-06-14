import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/ai_assistant/ai_assistant_barrel.dart';
import 'package:budget_intelli/features/budget/budget_barrel.dart';
import 'package:budget_intelli/features/settings/settings_barrel.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

part 'budget_form_event.dart';
part 'budget_form_state.dart';

class BudgetFormBloc extends Bloc<BudgetFormEvent, BudgetFormState> {
  BudgetFormBloc({
    required SettingPreferenceRepo preferenceRepository,
    required InsertGroupCategoryHistoryUsecase saveGroupCategory,
    required InsertItemCategoryHistoriesUsecase saveItemCategory,
    required InsertBudgetUsecase saveBudgetToDB,
    required InsertGroupCategoryUsecase insertGroupCategoryUsecase,
    required InsertItemCategoryUsecase insertItemCategoryUsecase,
    required GetItemCategoryHistoriesUsecase getItemCategoryHistoriesUsecase,
  })  : _preferenceRepository = preferenceRepository,
        _insertGroupCategoryHistory = saveGroupCategory,
        _insertItemCategoryHistory = saveItemCategory,
        _insertBudgetUsecase = saveBudgetToDB,
        _insertGroupCategoryUsecase = insertGroupCategoryUsecase,
        _insertItemCategoryUsecase = insertItemCategoryUsecase,
        _getItemCategoryHistoriesUsecase = getItemCategoryHistoriesUsecase,
        super(
          const BudgetFormState(
            groupCategoryHistories: [],
            totalPlanExpense: 0,
            totalPlanIncome: 0,
            loading: false,
          ),
        ) {
    on<BudgetFormInitial>(_onBudgetFormInitial);
    on<BudgetFormDefaultValues>(_onBudgetFormToInitial);
    on<BudgetFormInitialNew>(_onBudgetFormInitialNew);
    on<RemoveItemCategoryFromInitial>(_onRemoveItemCategoryFromInitial);
    on<RemoveItemCategoryFromInside>(_onRemoveItemCategoryFromInside);
    on<AddItemCategoryHistory>(_onAddItemCategoryHistory);
    on<UpdateItemCategoryEventInitialCreate>(
      _onUpdateItemCategoryInitialCreate,
    );
    on<UpdateItemCategoryHistoryEvent>(_onUpdateItemCategoryHistoryEvent);
    on<AddGroupCategoryHistory>(_onAddGroupCategoryHistory);
    on<RemoveGroupCategoryHistory>(_onRemoveGroupCategoryHistory);
    on<UpdateGroupCategoryHistory>(_onUpdateGroupCategoryHistory);
    on<InsertBudgetsToDatabase>(_onInsertBudgetToDatabase);
    on<SelectDateRange>(_onSelectDateRange);
    on<ResetSuccess>(_onResetSuccess);
    on<UpdateGroupCategoryHistoryType>(_onUpdateGroupCategoryHistoryType);
    on<UpdateSelectedGroupCategories>(_onUpdateSelectedCategory);
    on<ApplyGroupCategoryHistories>(_onApplyGroupCategoryHistories);
    on<RemoveGroupCategory>(_onRemoveGroupCategory);
    on<GetAllItemCategoryHistoriesEvent>(_onGetItemCategoryHistories);
    on<UpdateSelectedItemCategoryHistories>(
      _onUpdateSelectedItemCategoryHistories,
    );
    on<BudgetFormNew>(_onBudgetFormNewBudget);
    on<UpdatePortionsEvent>(_onUpdatePortionsEvent);
  }

  final SettingPreferenceRepo _preferenceRepository;
  final InsertGroupCategoryHistoryUsecase _insertGroupCategoryHistory;
  final InsertItemCategoryHistoriesUsecase _insertItemCategoryHistory;
  final InsertBudgetUsecase _insertBudgetUsecase;
  final InsertGroupCategoryUsecase _insertGroupCategoryUsecase;
  final InsertItemCategoryUsecase _insertItemCategoryUsecase;
  final GetItemCategoryHistoriesUsecase _getItemCategoryHistoriesUsecase;

  Future<void> _onBudgetFormToInitial(
    BudgetFormDefaultValues event,
    Emitter<BudgetFormState> emit,
  ) async {
    emit(BudgetFormState.initial());
  }

  Future<void> _onBudgetFormInitial(
    BudgetFormInitial event,
    Emitter<BudgetFormState> emit,
  ) async {
    var groupCategoryCustom = <GroupCategoryHistory>[];
    final language = await _preferenceRepository.getLanguage();
    final groupNameIncome = language != 'Indonesia' ? 'Income' : 'Pendapatan';
    final itemNameSalary = language != 'Indonesia' ? 'Salary' : 'Gaji';

    if (!event.generateBudgetAI) {
      if (language != 'Indonesia') {
        groupCategoryCustom = BudgetTemplate.groupCategoryCustomEN();
      } else {
        groupCategoryCustom = BudgetTemplate.groupCategoryCustomID();
      }
    } else {
      final groupIdIncome = const Uuid().v1();
      final incomeGroup = GroupCategoryHistory(
        id: groupIdIncome,
        groupName: groupNameIncome,
        type: AppStrings.incomeType,
        groupId: const Uuid().v1(),
        createdAt: DateTime.now().toString(),
        hexColor: 0xFF4CAF50,
        itemCategoryHistories: [
          ItemCategoryHistory(
            id: const Uuid().v1(),
            name: itemNameSalary,
            groupHistoryId: groupIdIncome,
            itemId: const Uuid().v1(),
            type: AppStrings.incomeType,
            createdAt: DateTime.now().toString(),
            isExpense: false,
            groupName: groupNameIncome,
            amount: event.budgetGenerate?.incomeAmount ?? 0,
          ),
        ],
      );

      groupCategoryCustom.add(incomeGroup);

      for (final generate in event.budgetGenerate?.expense ?? []) {
        final groupId = const Uuid().v1();
        final expense = generate as ExpenseGroupGenerate;
        final color = expense.color.replaceAll('#', '');
        final formattedColor = '0xFF$color';
        final hexColor = int.parse(formattedColor);

        final group = GroupCategoryHistory(
          id: groupId,
          groupName: expense.groupName,
          type: AppStrings.expenseType,
          groupId: const Uuid().v1(),
          createdAt: DateTime.now().toString(),
          hexColor: hexColor,
          itemCategoryHistories: expense.itemCategories
              .map(
                (e) => ItemCategoryHistory(
                  id: const Uuid().v1(),
                  name: e.itemCategoryName,
                  groupHistoryId: groupId,
                  itemId: const Uuid().v1(),
                  type: AppStrings.expenseType,
                  createdAt: DateTime.now().toString(),
                  isExpense: true,
                  groupName: expense.groupName,
                  amount: e.amount,
                ),
              )
              .toList(),
        );

        groupCategoryCustom.add(group);
      }
    }

    final totalIncome = groupCategoryCustom.isNotEmpty
        ? groupCategoryCustom
            .firstWhere((element) => element.type == AppStrings.incomeType)
            .itemCategoryHistories
            .map((e) => e.amount)
            .fold(0.0, (previousValue, element) => previousValue + element)
        : 0.0;

    final totalExpense = groupCategoryCustom
        .where((element) => element.type != AppStrings.incomeType)
        .map(
          (e) => e.itemCategoryHistories
              .map((e) => e.amount)
              .fold(0.0, (previousValue, element) => previousValue + element),
        )
        .fold(0.0, (previousValue, element) => previousValue + element);

    final totalBalance = totalIncome - totalExpense;

    add(
      UpdatePortionsEvent(
        groupCategories: groupCategoryCustom,
      ),
    );

    emit(
      state.copyWith(
        groupCategoryHistories: groupCategoryCustom,
        totalBalance: totalBalance,
        totalPlanIncome: totalIncome,
        totalPlanExpense: totalExpense,
        budgetName: event.budgetGenerate?.budgetName ?? '',
      ),
    );
  }

  Future<void> _onBudgetFormNewBudget(
    BudgetFormNew event,
    Emitter<BudgetFormState> emit,
  ) async {
    var groupCategoryHistories = <GroupCategoryHistory>[];
    final language = await _preferenceRepository.getLanguage();
    final groupNameIncome = language != 'Indonesia' ? 'Income' : 'Pendapatan';
    final itemNameSalary = language != 'Indonesia' ? 'Salary' : 'Gaji';

    final newGroupId1 = const Uuid().v1();
    final newItemId1 = const Uuid().v1();
    final newGroupId2 = const Uuid().v1();
    final newItemId2 = const Uuid().v1();

    const groupNameInitialEN = 'Group Name';
    const groupNameInitialID = 'Nama Grup';
    const categoryNameInitialEN = 'Category Name';
    const categoryNameInitialID = 'Nama Kategori';

    if (!event.generateBudgetAI) {
      if (language != AppStrings.indonesia) {
        groupCategoryHistories = [
          GroupCategoryHistory(
            id: newGroupId1,
            groupName: groupNameInitialEN,
            type: AppStrings.incomeType,
            groupId: const Uuid().v1(),
            createdAt: DateTime.now().toString(),
            hexColor: 0xFF4CAF50,
            itemCategoryHistories: [
              ItemCategoryHistory(
                id: newItemId1,
                groupHistoryId: newGroupId1,
                itemId: const Uuid().v1(),
                name: categoryNameInitialEN,
                type: AppStrings.incomeType,
                createdAt: DateTime.now().toString(),
                isExpense: true,
                groupName: groupNameInitialEN,
              ),
            ],
          ),
          GroupCategoryHistory(
            id: newGroupId2,
            groupName: groupNameInitialEN,
            type: AppStrings.expenseType,
            groupId: const Uuid().v1(),
            createdAt: DateTime.now().toString(),
            hexColor: 0xFFF44336,
            itemCategoryHistories: [
              ItemCategoryHistory(
                id: newItemId2,
                groupHistoryId: newGroupId2,
                itemId: const Uuid().v1(),
                name: categoryNameInitialEN,
                type: AppStrings.expenseType,
                createdAt: DateTime.now().toString(),
                isExpense: true,
                groupName: groupNameInitialEN,
              ),
            ],
          ),
        ];
      } else {
        groupCategoryHistories = [
          GroupCategoryHistory(
            id: newGroupId1,
            groupName: groupNameInitialID,
            type: AppStrings.incomeType,
            groupId: const Uuid().v1(),
            createdAt: DateTime.now().toString(),
            hexColor: 0xFF4CAF50,
            itemCategoryHistories: [
              ItemCategoryHistory(
                id: newItemId1,
                groupHistoryId: newGroupId1,
                itemId: const Uuid().v1(),
                name: categoryNameInitialID,
                type: AppStrings.incomeType,
                createdAt: DateTime.now().toString(),
                isExpense: true,
                groupName: groupNameInitialID,
              ),
            ],
          ),
          GroupCategoryHistory(
            id: newGroupId2,
            groupName: groupNameInitialID,
            type: AppStrings.expenseType,
            groupId: const Uuid().v1(),
            createdAt: DateTime.now().toString(),
            hexColor: 0xFFF44336,
            itemCategoryHistories: [
              ItemCategoryHistory(
                id: newItemId2,
                groupHistoryId: newGroupId2,
                itemId: const Uuid().v1(),
                name: categoryNameInitialID,
                type: AppStrings.expenseType,
                createdAt: DateTime.now().toString(),
                isExpense: true,
                groupName: groupNameInitialID,
              ),
            ],
          ),
        ];
      }
    } else {
      final groupIdIncome = const Uuid().v1();
      final incomeGroup = GroupCategoryHistory(
        id: groupIdIncome,
        groupName: groupNameIncome,
        type: AppStrings.incomeType,
        groupId: const Uuid().v1(),
        createdAt: DateTime.now().toString(),
        hexColor: 0xFF4CAF50,
        itemCategoryHistories: [
          ItemCategoryHistory(
            id: const Uuid().v1(),
            name: itemNameSalary,
            groupHistoryId: groupIdIncome,
            itemId: const Uuid().v1(),
            type: AppStrings.incomeType,
            createdAt: DateTime.now().toString(),
            isExpense: false,
            groupName: groupNameIncome,
            amount: event.budgetGenerate?.incomeAmount ?? 0,
          ),
        ],
      );

      groupCategoryHistories.add(incomeGroup);

      for (final generate in event.budgetGenerate?.expense ?? []) {
        final groupId = const Uuid().v1();
        final expense = generate as ExpenseGroupGenerate;

        final color = expense.color.replaceAll('#', '');
        final formattedColor = '0xFF$color';
        final hexColor = int.parse(formattedColor);

        final group = GroupCategoryHistory(
          id: groupId,
          groupName: expense.groupName,
          type: AppStrings.expenseType,
          groupId: const Uuid().v1(),
          createdAt: DateTime.now().toString(),
          hexColor: hexColor,
          itemCategoryHistories: expense.itemCategories
              .map(
                (e) => ItemCategoryHistory(
                  id: const Uuid().v1(),
                  name: e.itemCategoryName,
                  groupHistoryId: groupId,
                  itemId: const Uuid().v1(),
                  type: AppStrings.expenseType,
                  createdAt: DateTime.now().toString(),
                  isExpense: true,
                  groupName: expense.groupName,
                  amount: e.amount,
                ),
              )
              .toList(),
        );

        groupCategoryHistories.add(group);
      }
    }

    final totalIncome = groupCategoryHistories.isNotEmpty
        ? groupCategoryHistories
            .firstWhere((element) => element.type == AppStrings.incomeType)
            .itemCategoryHistories
            .map((e) => e.amount)
            .fold(0.0, (previousValue, element) => previousValue + element)
        : 0.0;

    final totalExpense = groupCategoryHistories
        .where((element) => element.type != AppStrings.incomeType)
        .map(
          (e) => e.itemCategoryHistories
              .map((e) => e.amount)
              .fold(0.0, (previousValue, element) => previousValue + element),
        )
        .fold(0.0, (previousValue, element) => previousValue + element);

    final totalBalance = totalIncome - totalExpense;

    add(
      UpdatePortionsEvent(
        groupCategories: groupCategoryHistories,
      ),
    );

    emit(
      state.copyWith(
        groupCategoryHistories: groupCategoryHistories,
        totalBalance: totalBalance,
        totalPlanIncome: totalIncome,
        totalPlanExpense: totalExpense,
      ),
    );
  }

  Future<void> _onUpdateSelectedCategory(
    UpdateSelectedGroupCategories event,
    Emitter<BudgetFormState> emit,
  ) async {
    emit(
      state.copyWith(
        selectedGroupCategories: event.groupCategories,
      ),
    );

    add(
      ApplyGroupCategoryHistories(
        budgetId: event.budgetId,
      ),
    );
  }

  Future<void> _onBudgetFormInitialNew(
    BudgetFormInitialNew event,
    Emitter<BudgetFormState> emit,
  ) async {
    var groupCategoryCustom = <GroupCategoryHistory>[];
    final language = await _preferenceRepository.getLanguage();
    final groupId = const Uuid().v1();
    int? hexColor;
    if (event.isExpenses) {
      hexColor = 0xFFF44336;
    } else {
      hexColor = 0xFF4CAF50;
    }

    if (language != 'Indonesia') {
      groupCategoryCustom = [
        GroupCategoryHistory(
          id: groupId,
          groupName: 'Group Name',
          type: event.categoryType,
          groupId: const Uuid().v1(),
          createdAt: DateTime.now().toString(),
          hexColor: hexColor,
          itemCategoryHistories: [
            ItemCategoryHistory(
              id: const Uuid().v1(),
              name: 'Category Name',
              type: event.categoryType,
              itemId: const Uuid().v1(),
              groupHistoryId: groupId,
              createdAt: DateTime.now().toString(),
              isExpense: event.isExpenses,
              budgetId: event.budgetId,
              groupName: '',
            ),
          ],
        ),
      ];
    } else {
      groupCategoryCustom = [
        GroupCategoryHistory(
          id: groupId,
          groupName: 'Nama Grup',
          type: event.categoryType,
          groupId: const Uuid().v1(),
          createdAt: DateTime.now().toString(),
          hexColor: hexColor,
          itemCategoryHistories: [
            ItemCategoryHistory(
              id: const Uuid().v1(),
              name: 'Nama Kategori',
              type: event.categoryType,
              itemId: const Uuid().v1(),
              groupHistoryId: groupId,
              createdAt: DateTime.now().toString(),
              isExpense: event.isExpenses,
              budgetId: event.budgetId,
              groupName: '',
            ),
          ],
        ),
      ];
    }

    emit(
      state.copyWith(
        groupCategoryHistories: groupCategoryCustom,
        insertBudgetSuccess: false,
        loading: false,
      ),
    );
  }

  void _onUpdateGroupCategoryHistoryType(
    UpdateGroupCategoryHistoryType event,
    Emitter<BudgetFormState> emit,
  ) {
    final newGroupCategory = state.groupCategoryHistories.map((e) {
      if (e.id == event.groupId) {
        return e.copyWith(
          type: event.type,
          itemCategories: e.itemCategoryHistories.map((item) {
            return item.copyWith(
              type: event.type,
              isExpense: event.isExpenses,
            );
          }).toList(),
        );
      }
      return e;
    }).toList();

    emit(
      state.copyWith(
        groupCategoryHistories: newGroupCategory,
      ),
    );
  }

  void _onRemoveItemCategoryFromInitial(
    RemoveItemCategoryFromInitial event,
    Emitter<BudgetFormState> emit,
  ) {
    try {
      final newGroupCategory = state.copyWith(
        groupCategoryHistories: state.groupCategoryHistories.map((e) {
          if (e.id == event.groupHistoId) {
            return e.copyWith(
              itemCategories: e.itemCategoryHistories
                  .where((element) => element.id != event.itemHistoId)
                  .toList(),
            );
          }
          return e;
        }).toList(),
      );

      final totalIncome = newGroupCategory.groupCategoryHistories.isNotEmpty
          ? newGroupCategory.groupCategoryHistories
              .firstWhere((element) => element.type == AppStrings.incomeType)
              .itemCategoryHistories
              .map((e) => e.amount)
              .fold(0.0, (previousValue, element) => previousValue + element)
          : 0.0;

      // kurangi total income dengan exp312ense yang berasal dari group selain Income
      final totalExpense = newGroupCategory.groupCategoryHistories
          .where((element) => element.type != AppStrings.incomeType)
          .map(
            (e) => e.itemCategoryHistories
                .map((e) => e.amount)
                .fold(0.0, (previousValue, element) => previousValue + element),
          )
          .fold(0.0, (previousValue, element) => previousValue + element);

      add(
        UpdatePortionsEvent(
          groupCategories: newGroupCategory.groupCategoryHistories,
        ),
      );

      emit(
        newGroupCategory.copyWith(
          totalBalance: totalIncome - totalExpense,
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          insertBudgetSuccess: false,
          message: e.toString(),
        ),
      );
    }
  }

  void _onRemoveItemCategoryFromInside(
    RemoveItemCategoryFromInside event,
    Emitter<BudgetFormState> emit,
  ) {
    try {
      final newGroupCategory = state.copyWith(
        groupCategoryHistories: state.groupCategoryHistories.map((e) {
          if (e.id == event.groupId) {
            return e.copyWith(
              itemCategories: e.itemCategoryHistories
                  .where((element) => element.id != event.itemId)
                  .toList(),
            );
          }
          return e;
        }).toList(),
      );

      emit(newGroupCategory);
    } on Exception catch (e) {
      emit(
        state.copyWith(
          insertBudgetSuccess: false,
          message: e.toString(),
        ),
      );
    }
  }

  void _onAddItemCategoryHistory(
    AddItemCategoryHistory event,
    Emitter<BudgetFormState> emit,
  ) {
    final newGroupCategory = state.copyWith(
      groupCategoryHistories: state.groupCategoryHistories.map((e) {
        if (e.id == event.groupId) {
          return e.copyWith(
            itemCategories: [...e.itemCategoryHistories, event.itemCategory],
          );
        }
        return e;
      }).toList(),
    );

    emit(newGroupCategory);
  }

  void _onUpdateItemCategoryInitialCreate(
    UpdateItemCategoryEventInitialCreate event,
    Emitter<BudgetFormState> emit,
  ) {
    try {
      final newGroupCategory = state.copyWith(
        groupCategoryHistories: state.groupCategoryHistories.map((e) {
          if (e.id == event.groupHistoId) {
            return e.copyWith(
              itemCategories: e.itemCategoryHistories.map((item) {
                if (item.id == event.itemHistoId) {
                  return event.itemCategoryHistory;
                }
                return item;
              }).toList(),
            );
          }
          return e;
        }).toList(),
      );

      final totalIncome = newGroupCategory.groupCategoryHistories.isNotEmpty
          ? newGroupCategory.groupCategoryHistories
              .firstWhere(
                (element) => element.type == AppStrings.incomeType,
              )
              .itemCategoryHistories
              .map((e) => e.amount)
              .fold(0.0, (previousValue, element) => previousValue + element)
          : 0.0;

      final totalExpense = newGroupCategory.groupCategoryHistories
          .where(
            (element) => element.type != AppStrings.incomeType,
          )
          .map(
            (e) => e.itemCategoryHistories
                .map((e) => e.amount)
                .fold(0.0, (previousValue, element) => previousValue + element),
          )
          .fold(0.0, (previousValue, element) => previousValue + element);

      final total = totalIncome - totalExpense;

      add(
        UpdatePortionsEvent(
          groupCategories: newGroupCategory.groupCategoryHistories,
        ),
      );

      emit(
        newGroupCategory.copyWith(
          totalPlanIncome: totalIncome,
          totalPlanExpense: totalExpense,
          totalBalance: total,
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          insertBudgetSuccess: false,
          message: e.toString(),
        ),
      );
    }
  }

  void _onUpdatePortionsEvent(
    UpdatePortionsEvent event,
    Emitter<BudgetFormState> emit,
  ) {
    final groups = event.groupCategories;

    final amount = <double>[];
    final name = <String>[];
    final portion = <double>[0];

    for (var i = 0; i < groups.length; i++) {
      final group = groups[i];
      if (group.type == AppStrings.incomeType) {
        continue;
      }
      final itemCategories = group.itemCategoryHistories;
      var total = 0.0;
      for (var j = 0; j < itemCategories.length; j++) {
        final itemCategory = itemCategories[j];
        total += itemCategory.amount;
      }
      amount.add(total);
      name.add(group.groupName);
    }

    final totalExpense = amount.reduce((value, element) => value + element);

    // calculate portion of each group
    for (var i = 0; i < amount.length; i++) {
      final value = ((amount[i] / totalExpense) * 100).roundToDouble();
      portion.add(value);
    }

    emit(
      state.copyWith(
        portions: portion,
      ),
    );
  }

  void _onUpdateItemCategoryHistoryEvent(
    UpdateItemCategoryHistoryEvent event,
    Emitter<BudgetFormState> emit,
  ) {
    try {
      final newGroupCategory = state.copyWith(
        groupCategoryHistories: state.groupCategoryHistories.map((e) {
          if (e.id == event.groupId) {
            return e.copyWith(
              itemCategories: e.itemCategoryHistories.map((item) {
                if (item.id == event.itemId) {
                  return event.itemCategory;
                }
                return item;
              }).toList(),
            );
          }
          return e;
        }).toList(),
      );

      emit(newGroupCategory);
    } on Exception catch (e) {
      emit(
        state.copyWith(
          insertBudgetSuccess: false,
          message: e.toString(),
        ),
      );
    }
  }

  void _onAddGroupCategoryHistory(
    AddGroupCategoryHistory event,
    Emitter<BudgetFormState> emit,
  ) {
    final newGroupCategory = state.copyWith(
      groupCategoryHistories: [
        ...state.groupCategoryHistories,
        event.groupCategoryHisto,
      ],
    );

    emit(newGroupCategory);

    add(
      UpdatePortionsEvent(
        groupCategories: state.groupCategoryHistories,
      ),
    );
  }

  void _onRemoveGroupCategoryHistory(
    RemoveGroupCategoryHistory event,
    Emitter<BudgetFormState> emit,
  ) {
    // remove group category and all item category inside it
    final newGroupCategory = state.copyWith(
      groupCategoryHistories: state.groupCategoryHistories
          .where((element) => element.id != event.groupHistoId)
          .toList(),
    );

    for (final element in newGroupCategory.groupCategoryHistories) {
      element.itemCategoryHistories.removeWhere(
        (element) => element.groupHistoryId == event.groupHistoId,
      );
    }

    add(
      UpdatePortionsEvent(
        groupCategories: newGroupCategory.groupCategoryHistories,
      ),
    );

    emit(newGroupCategory);
  }

  void _onRemoveGroupCategory(
    RemoveGroupCategory event,
    Emitter<BudgetFormState> emit,
  ) {
    // remove group category and all item category inside it
    final newGroupCategory = state.copyWith(
      selectedGroupCategories: state.selectedGroupCategories
          .where((element) => element.id != event.groupId)
          .toList(),
    );

    emit(newGroupCategory);
  }

  void _onUpdateGroupCategoryHistory(
    UpdateGroupCategoryHistory event,
    Emitter<BudgetFormState> emit,
  ) {
    final newGroupCategory = state.copyWith(
      groupCategoryHistories: state.groupCategoryHistories.map((e) {
        if (e.id == event.groupCategoryHistory.id) {
          return event.groupCategoryHistory;
        }
        return e;
      }).toList(),
    );

    emit(newGroupCategory);
  }

  Future<void> _onInsertBudgetToDatabase(
    InsertBudgetsToDatabase event,
    Emitter<BudgetFormState> emit,
  ) async {
    try {
      for (final itemCategory in event.itemCategoryHistories) {
        final item = ItemCategory(
          id: itemCategory.itemId,
          categoryName: itemCategory.name,
          type: itemCategory.type,
          createdAt: itemCategory.createdAt,
          updatedAt: itemCategory.updatedAt,
          iconPath: itemCategory.iconPath,
          hexColor: itemCategory.hexColor,
        );

        final insertItemResult = await _insertItemCategory(
          item,
          event.itemCategories,
          fromInitial: event.fromInitial,
        );

        if (insertItemResult) {
          final result = await _insertItemCategoryHistory.call(itemCategory);

          result.fold(
            (l) => emit(
              state.copyWith(
                insertItemSuccess: false,
                message: l.message,
                initial: false,
              ),
            ),
            (r) {
              emit(
                state.copyWith(
                  insertItemSuccess: true,
                  initial: false,
                ),
              );
            },
          );
        } else {
          emit(
            state.copyWith(
              insertItemSuccess: false,
              message: 'Failed to insert item category',
              initial: false,
            ),
          );
        }
      }

      if (state.insertItemSuccess == true) {
        for (final groupCategory in event.groupCategoryHistories) {
          final insertGroupResult = await _insertGroupCategory(
            GroupCategory(
              id: groupCategory.groupId,
              groupName: groupCategory.groupName,
              type: groupCategory.type,
              createdAt: DateTime.now().toString(),
              updatedAt: DateTime.now().toString(),
              iconPath: null,
              hexColor: groupCategory.hexColor,
            ),
            event.groupCategories,
            fromInitial: event.fromInitial,
          );

          if (insertGroupResult) {
            final result = await _insertGroupCategoryHistory.call(
              groupCategory,
            );

            result.fold(
              (l) => emit(
                state.copyWith(
                  insertGroupSuccess: false,
                  message: l.message,
                  initial: false,
                ),
              ),
              (r) => emit(
                state.copyWith(
                  insertGroupSuccess: true,
                  initial: false,
                ),
              ),
            );
          } else {
            emit(
              state.copyWith(
                insertGroupSuccess: false,
                message: 'Failed to insert group category',
                initial: false,
              ),
            );
          }
        }
      }

      if (state.insertGroupSuccess == true) {
        final result = await _insertBudgetUsecase.call(event.budget);

        result.fold(
          (l) => emit(
            state.copyWith(
              insertBudgetSuccess: false,
              message: l.message,
              initial: false,
            ),
          ),
          (r) => emit(
            state.copyWith(
              insertBudgetSuccess: true,
              initial: false,
              groupCategoryHistoriesParams: event.groupCategoryHistories,
              itemCategoryHistoriesParams: event.itemCategoryHistories,
              budgetParams: event.budget,
              groupCategoriesParams: event.groupCategories,
              itemCategoriesParams: event.itemCategories,
            ),
          ),
        );
      }
    } on Exception catch (e) {
      emit(
        state.copyWith(
          insertBudgetSuccess: false,
          message: e.toString(),
          initial: false,
        ),
      );
    }
  }

  void _onSelectDateRange(
    SelectDateRange event,
    Emitter<BudgetFormState> emit,
  ) {
    emit(
      state.copyWith(
        dateRange: event.dateRange,
      ),
    );
  }

  void _onResetSuccess(
    ResetSuccess event,
    Emitter<BudgetFormState> emit,
  ) {
    emit(
      state.copyWith(
        insertBudgetSuccess: false,
        loading: false,
      ),
    );
  }

  Future<bool> _insertGroupCategory(
    GroupCategory groupCategory,
    List<GroupCategory>? groupCategories, {
    required bool fromInitial,
  }) async {
    if (fromInitial) {
      final result = await _insertGroupCategoryUsecase.call(groupCategory);

      return result.fold(
        (l) {
          return false;
        },
        (r) => true,
      );
    }

    if (groupCategories != null) {
      final exist =
          groupCategories.any((element) => element.id == groupCategory.id);

      if (exist) {
        return true;
      } else {
        final result = await _insertGroupCategoryUsecase.call(groupCategory);

        return result.fold(
          (l) => false,
          (r) => true,
        );
      }
    } else {
      return true;
    }
  }

  Future<bool> _insertItemCategory(
    ItemCategory itemCategory,
    List<ItemCategory>? itemCategories, {
    required bool fromInitial,
  }) async {
    if (fromInitial) {
      final result = await _insertItemCategoryUsecase.call(itemCategory);

      return result.fold(
        (l) => false,
        (r) => true,
      );
    }

    if (itemCategories != null) {
      final exist =
          itemCategories.any((element) => element.id == itemCategory.id);

      if (exist) {
        return true;
      } else {
        final result = await _insertItemCategoryUsecase.call(itemCategory);

        return result.fold(
          (l) => false,
          (r) => true,
        );
      }
    } else {
      return true;
    }
  }

  void _onApplyGroupCategoryHistories(
    ApplyGroupCategoryHistories event,
    Emitter<BudgetFormState> emit,
  ) {
    final selectedGroupCategories = state.selectedGroupCategories;
    final newGroupHistories = <GroupCategoryHistory>[];

    if (selectedGroupCategories.isNotEmpty) {
      for (final groupCategory in selectedGroupCategories) {
        final categoryHistories = state.allItemCategoryHistories
            .where((element) => element.groupName == groupCategory.groupName)
            .toList();

        final groupHistory = GroupCategoryHistory(
          id: const Uuid().v1(),
          groupName: groupCategory.groupName,
          type: groupCategory.type,
          groupId: groupCategory.id,
          createdAt: groupCategory.createdAt,
          updatedAt: groupCategory.updatedAt,
          hexColor: groupCategory.hexColor,
          itemCategoryHistories: List.generate(
            categoryHistories.length,
            (index) {
              return ItemCategoryHistory(
                id: const Uuid().v1(),
                name: categoryHistories[index].name,
                type: categoryHistories[index].type,
                groupHistoryId: groupCategory.id,
                itemId: categoryHistories[index].itemId,
                createdAt: DateTime.now().toString(),
                isExpense: groupCategory.type == AppStrings.expenseType,
                budgetId: event.budgetId,
                groupName: groupCategory.groupName,
              );
            },
          ),
        );

        newGroupHistories.add(groupHistory);
      }
    }

    emit(
      state.copyWith(
        groupCategoryHistories: newGroupHistories,
      ),
    );
  }

  Future<void> _onGetItemCategoryHistories(
    GetAllItemCategoryHistoriesEvent event,
    Emitter<BudgetFormState> emit,
  ) async {
    final result = await _getItemCategoryHistoriesUsecase.call(NoParams());

    result.fold(
      (l) => emit(
        state.copyWith(
          allItemCategoryHistories: [],
        ),
      ),
      (r) => emit(
        state.copyWith(
          allItemCategoryHistories: r,
        ),
      ),
    );
  }

  void _onUpdateSelectedItemCategoryHistories(
    UpdateSelectedItemCategoryHistories event,
    Emitter<BudgetFormState> emit,
  ) {
    emit(
      state.copyWith(
        selectedItemCategoryHistories: event.itemCategoryHistories,
      ),
    );
  }
}
