import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/goals/goals_barrel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class GoalUpdateWidget extends StatefulWidget {
  const GoalUpdateWidget({
    required this.goal,
    required this.onGoalUpdated,
    super.key,
  });

  final GoalModel goal;
  final VoidCallback onGoalUpdated;

  @override
  State<GoalUpdateWidget> createState() => _GoalUpdateWidgetState();
}

class _GoalUpdateWidgetState extends State<GoalUpdateWidget> {
  bool _isExpanded = false;
  List<GoalHistoryModel> _history = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    setState(() => _isLoading = true);
    try {
      final database = GoalDatabase();
      final history = await database.getGoalsHistoryByGoalId(widget.goal.id);
      setState(() {
        _history = history;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _addToGoal() async {
    final amount = ControllerHelper.getAmount(context);
    final localize = textLocalizer(context);

    if (amount == null || amount <= 0) {
      AppToast.showToast(
        context,
        localize.pleaseEnterValidAmount,
      );
      return;
    }

    try {
      setState(() => _isLoading = true);

      // Create history entry
      final historyEntry = GoalHistoryModel(
        id: const Uuid().v1(),
        goalId: widget.goal.id,
        savedAmount: amount.toString(),
        createdAt: DateTime.now().toIso8601String(),
        updatedAt: DateTime.now().toIso8601String(),
      );

      // Update goal's remaining amount
      final updatedGoal = GoalModel(
        id: widget.goal.id,
        goalName: widget.goal.goalName,
        goalAmount: widget.goal.goalAmount,
        perDayAmount: widget.goal.perDayAmount,
        perMonthAmount: widget.goal.perMonthAmount,
        startGoalDate: widget.goal.startGoalDate,
        endGoalDate: widget.goal.endGoalDate,
        remainingAmount:
            (widget.goal.remainingAmount - amount).clamp(0, double.infinity),
        createdAt: widget.goal.createdAt,
        updatedAt: DateTime.now().toIso8601String(),
      );

      final database = GoalDatabase();

      // Insert history and update goal
      await database.insertGoalHistory(historyEntry);
      await database.updateGoal(updatedGoal);

      // Clear form and refresh

      await _loadHistory();

      // Notify parent to refresh
      widget.onGoalUpdated();

      setState(() => _isLoading = false);

      if (mounted) {
        context.read<BoxCalculatorCubit>().unselect();

        AppToast.showToast(
          context,
          localize.goalUpdatedSuccessfully,
        );
      }
    } on Exception catch (_) {
      setState(() => _isLoading = false);
      if (mounted) {
        final localize = textLocalizer(context);
        AppToast.showToast(
          context,
          localize.somethingWentWrong,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final localize = textLocalizer(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppBoxBorder(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const AppText(
                    text: 'Update Progress 💰',
                    style: StyleType.bodMed,
                    fontWeight: FontWeight.bold,
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isExpanded = !_isExpanded;
                      });
                    },
                    child: Icon(
                      _isExpanded
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      color: context.color.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
              if (_isExpanded) ...[
                Gap.vertical(16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      text: localize.addAmountToYourGoal,
                      style: StyleType.bodSm,
                      color: context.color.onSurface.withValues(alpha: 0.7),
                    ),
                    Gap.vertical(8),
                    BoxCalculator(
                      label: localize.addAmountToYourGoal,
                    ),
                    Gap.vertical(16),
                    SizedBox(
                      child: AppButton(
                        label:
                            _isLoading ? localize.updating : localize.addToGoal,
                        onPressed: () async {
                          await _addToGoal();
                        },
                      ),
                    ),
                  ],
                ),

                Gap.vertical(20),
                AppDivider(
                  color: context.color.onSurface.withValues(alpha: 0.1),
                ),
                Gap.vertical(16),

                // History Section
                Row(
                  children: [
                    AppText(
                      text: localize.updateHistory,
                      style: StyleType.bodMed,
                      fontWeight: FontWeight.bold,
                    ),
                    Gap.horizontal(8),
                    if (_history.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: context.color.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: AppText(
                          text: '${_history.length}',
                          style: StyleType.bodSm,
                          color: context.color.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                  ],
                ),
                Gap.vertical(12),

                if (_isLoading)
                  const Center(
                    child: CircularProgressIndicator(),
                  )
                else if (_history.isEmpty)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: context.color.onSurface.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: AppText(
                      text: localize.noUpdatesYet,
                      style: StyleType.bodSm,
                      color: context.color.onSurface.withValues(alpha: 0.6),
                      textAlign: TextAlign.center,
                    ),
                  )
                else
                  Expanded(
                    child: ListView.builder(
                      itemCount: _history.length,
                      itemBuilder: (context, index) {
                        final entry = _history[index];
                        final date = DateTime.parse(entry.createdAt);
                        final languageVal =
                            ControllerHelper.getLanguage(context);

                        return Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color:
                                context.color.onSurface.withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: context.color.onSurface
                                  .withValues(alpha: 0.1),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AppText(
                                      text: NumberFormatter.formatToMoneyDouble(
                                        context,
                                        double.parse(entry.savedAmount),
                                      ),
                                      style: StyleType.bodMed,
                                      fontWeight: FontWeight.w600,
                                      color: context.color.primary,
                                    ),
                                    Gap.vertical(2),
                                    AppText(
                                      text: DateFormat.yMMMd(languageVal)
                                          .add_jm()
                                          .format(date),
                                      style: StyleType.labSm,
                                      color: context.color.onSurface
                                          .withValues(alpha: 0.6),
                                    ),
                                  ],
                                ),
                              ),
                              Icon(
                                Icons.trending_up,
                                color: context.color.primary
                                    .withValues(alpha: 0.7),
                                size: 20,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),

                if (_history.length > 5)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Center(
                      child: AppText(
                        text: '+${_history.length - 5} ${localize.moreEntries}',
                        style: StyleType.labSm,
                        color: context.color.onSurface.withValues(alpha: 0.5),
                      ),
                    ),
                  ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
