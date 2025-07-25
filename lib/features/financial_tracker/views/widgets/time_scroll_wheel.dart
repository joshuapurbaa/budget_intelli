import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/financial_tracker/financial_tracker_barrel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TimeScrollWheel extends StatefulWidget {
  const TimeScrollWheel({super.key});

  @override
  State<TimeScrollWheel> createState() => _TimeScrollWheelState();
}

class _TimeScrollWheelState extends State<TimeScrollWheel> {
  late int selectedHourIndex;
  late int selectedMinuteIndex;
  late FixedExtentScrollController hourController;
  late FixedExtentScrollController minuteController;

  @override
  void initState() {
    super.initState();
    selectedHourIndex =
        hourList.indexOf(DateTime.now().hour.toString().padLeft(2, '0'));
    selectedMinuteIndex =
        minuteList.indexOf(DateTime.now().minute.toString().padLeft(2, '0'));
    hourController =
        FixedExtentScrollController(initialItem: selectedHourIndex);
    minuteController =
        FixedExtentScrollController(initialItem: selectedMinuteIndex);

    context.read<TimeScrollWheelCubit>().setSelectedHourWheel(
          hourList[selectedHourIndex],
        );
    context.read<TimeScrollWheelCubit>().setSelectedMinuteWheel(
          minuteList[selectedMinuteIndex],
        );
  }

  @override
  void dispose() {
    hourController.dispose();
    minuteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimeScrollWheelCubit, TimeScrollWheelState>(
      builder: (context, state) {
        return Row(
          children: [
            Expanded(
              child: ListWheelScrollView.useDelegate(
                controller: hourController,
                itemExtent: 40,
                diameterRatio: 1.5,
                perspective: 0.010,
                onSelectedItemChanged: (index) {
                  setState(() {
                    selectedHourIndex = index;
                    context.read<TimeScrollWheelCubit>().setSelectedHourWheel(
                          hourList[index],
                        );
                  });
                },
                physics: const FixedExtentScrollPhysics(),
                childDelegate: ListWheelChildBuilderDelegate(
                  builder: (context, index) {
                    final isSelected = index == selectedHourIndex;
                    return Center(
                      child: AppText(
                        text: hourList[index],
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                        color: isSelected
                            ? context.color.primary
                            : context.color.onSurface.withValues(alpha: 0.2),
                      ),
                    );
                  },
                  childCount: hourList.length,
                ),
              ),
            ),
            const AppText(
              text: ':',
              style: StyleType.bodLg,
            ),
            Expanded(
              child: ListWheelScrollView.useDelegate(
                controller: minuteController,
                itemExtent: 40,
                diameterRatio: 1.5,
                perspective: 0.010,
                onSelectedItemChanged: (index) {
                  setState(() {
                    selectedMinuteIndex = index;
                    context.read<TimeScrollWheelCubit>().setSelectedMinuteWheel(
                          minuteList[index],
                        );
                  });
                },
                physics: const FixedExtentScrollPhysics(),
                childDelegate: ListWheelChildBuilderDelegate(
                  builder: (context, index) {
                    final isSelected = index == selectedMinuteIndex;
                    return Center(
                      child: AppText(
                        text: minuteList[index],
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                        color: isSelected
                            ? context.color.primary
                            : context.color.onSurface.withValues(alpha: 0.2),
                      ),
                    );
                  },
                  childCount: minuteList.length,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
