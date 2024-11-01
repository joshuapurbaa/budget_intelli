import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/core/widgets/app_field_calculator.dart';
import 'package:budget_intelli/features/net_worth/net_worth_barrel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

class AddAssetAccountScreen extends StatefulWidget {
  const AddAssetAccountScreen({super.key});

  @override
  State<AddAssetAccountScreen> createState() => _AddAssetAccountScreenState();
}

class _AddAssetAccountScreenState extends State<AddAssetAccountScreen> {
  final _assetNameController = TextEditingController();
  final _assetDescriptionController = TextEditingController();

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
            title: localize.addAsset,
          ),
          SliverPadding(
            padding: paddingLTR,
            sliver: SliverToBoxAdapter(
              child: Column(
                children: [
                  AppGlass(
                    padding: getEdgeInsetsAll(5),
                    child: AppFormField(
                      controller: _assetNameController,
                      hintText: '${localize.assetName}*',
                      onChanged: (value) {},
                      hintStyle: textStyle(
                        context,
                        StyleType.bodMd,
                      ).copyWith(
                        fontWeight: _assetNameController.text.isEmpty
                            ? FontWeight.normal
                            : FontWeight.bold,
                        color: context.color.onSurface.withOpacity(0.5),
                      ),
                    ),
                  ),
                  Gap.vertical(10),
                  AppGlass(
                    height: 65.h,
                    child: AppFieldCalculator(
                      label: '${localize.value}*',
                    ),
                  ),
                  Gap.vertical(10),
                  AppGlass(
                    padding: getEdgeInsetsAll(5),
                    child: AppFormField(
                      controller: _assetDescriptionController,
                      hintText:
                          '${localize.description} (${localize.optional})',
                      onChanged: (value) {},
                      hintStyle: textStyle(
                        context,
                        StyleType.bodMd,
                      ).copyWith(
                        fontWeight: _assetDescriptionController.text.isEmpty
                            ? FontWeight.normal
                            : FontWeight.bold,
                        color: context.color.onSurface.withOpacity(0.5),
                      ),
                    ),
                  ),
                  Gap.vertical(16),
                  BlocConsumer<NetWorthBloc, NetWorthState>(
                    listener: (context, state) {
                      if (state.insertSuccess) {
                        _reset();
                        context.read<NetWorthBloc>().add(GetAssetList());
                        context.pop();
                      }
                    },
                    builder: (context, state) {
                      return AppButton(
                        label: localize.add,
                        onPressed: () {
                          final value = ControllerHelper.getAmount(context);

                          if (value != null &&
                              _assetNameController.text.isNotEmpty) {
                            final assetValue = value.toDouble();
                            final assetEntity = AssetEntity(
                              name: _assetNameController.text,
                              amount: assetValue,
                              description: _assetDescriptionController.text,
                              id: const Uuid().v4(),
                              createdAt: DateTime.now().toString(),
                              updatedAt: DateTime.now().toString(),
                            );
                            context.read<NetWorthBloc>().add(
                                  AddAssetEvent(assetEntity),
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
