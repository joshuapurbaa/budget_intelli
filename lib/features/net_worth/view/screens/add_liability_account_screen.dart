import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/core/widgets/app_field_calculator.dart';
import 'package:budget_intelli/features/net_worth/net_worth_barrel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

class AddLiabilityAccountScreen extends StatefulWidget {
  const AddLiabilityAccountScreen({super.key});

  @override
  State<AddLiabilityAccountScreen> createState() =>
      _AddLiabilityAccountScreenState();
}

class _AddLiabilityAccountScreenState extends State<AddLiabilityAccountScreen> {
  final _liabilityNameController = TextEditingController();
  final _liabilityDescriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _reset();
  }

  @override
  Widget build(BuildContext context) {
    final localize = textLocalizer(context);
    final paddingLTR = getEdgeInsets(left: 16, right: 16, top: 16);
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBarPrimary(
            title: localize.addLiability,
          ),
          SliverPadding(
            padding: paddingLTR,
            sliver: SliverToBoxAdapter(
              child: Column(
                children: [
                  AppGlass(
                    padding: getEdgeInsetsAll(5),
                    child: AppFormField(
                      controller: _liabilityNameController,
                      hintText: '${localize.liability}*',
                      onChanged: (value) {},
                      hintStyle: textStyle(
                        context,
                        StyleType.bodMd,
                      ).copyWith(
                        fontWeight: _liabilityNameController.text.isEmpty
                            ? FontWeight.normal
                            : FontWeight.bold,
                        color: context.color.onSurface.withValues(alpha: 0.5),
                      ),
                    ),
                  ),
                  Gap.vertical(10),
                  AppGlass(
                    height: 65.h,
                    child: AppFieldCalculator(
                      label: '${localize.amountFieldLabel}*',
                    ),
                  ),
                  Gap.vertical(10),
                  AppGlass(
                    padding: getEdgeInsetsAll(5),
                    child: AppFormField(
                      controller: _liabilityDescriptionController,
                      hintText:
                          '${localize.description} (${localize.optional})',
                      onChanged: (value) {},
                      hintStyle: textStyle(
                        context,
                        StyleType.bodMd,
                      ).copyWith(
                        fontWeight: _liabilityDescriptionController.text.isEmpty
                            ? FontWeight.normal
                            : FontWeight.bold,
                        color: context.color.onSurface.withValues(alpha: 0.5),
                      ),
                    ),
                  ),
                  Gap.vertical(16),
                  BlocConsumer<NetWorthBloc, NetWorthState>(
                    listener: (context, state) {
                      if (state.insertSuccess) {
                        _reset();
                        context.read<NetWorthBloc>().add(GetLiabilityList());
                        context.pop();
                      }
                    },
                    builder: (context, state) {
                      return AppButton(
                        label: localize.add,
                        onPressed: () {
                          final value = ControllerHelper.getAmount(context);

                          if (value != null &&
                              _liabilityNameController.text.isNotEmpty) {
                            final liabilityAmount = value;
                            final liabilityEntity = LiabilityEntity(
                              name: _liabilityNameController.text,
                              amount: liabilityAmount,
                              description: _liabilityDescriptionController.text,
                              id: const Uuid().v4(),
                              createdAt: DateTime.now().toString(),
                              updatedAt: DateTime.now().toString(),
                            );
                            context.read<NetWorthBloc>().add(
                                  AddLiabilityEvent(liabilityEntity),
                                );
                          } else {
                            AppToast.showToastError(
                              context,
                              localize.pleaseFillAllRequiredFields,
                            );
                          }
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _reset() {
    context.read<NetWorthBloc>().add(SetToInitial());
    context.read<BoxCalculatorCubit>().unselect();
  }
}
