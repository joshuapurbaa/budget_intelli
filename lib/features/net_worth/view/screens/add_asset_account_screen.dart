import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/net_worth/net_worth_barrel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

class AddAssetAccountScreen extends StatefulWidget {
  const AddAssetAccountScreen({
    super.key,
    this.asset,
  });

  final AssetEntity? asset;

  @override
  State<AddAssetAccountScreen> createState() => _AddAssetAccountScreenState();
}

class _AddAssetAccountScreenState extends State<AddAssetAccountScreen> {
  final _assetNameController = TextEditingController();
  final _assetDescriptionController = TextEditingController();
  final _assetNameFocusNode = FocusNode();
  final _assetDescriptionFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _reset();
    if (widget.asset != null) {
      _assetNameController.text = widget.asset?.name ?? '';
      _assetDescriptionController.text = widget.asset?.description ?? '';
      context.read<BoxCalculatorCubit>().select(
          widget.asset?.amount.toString() ?? '',
          onUpdateFromState: true);
    }
  }

  void _unFocus() {
    _assetNameFocusNode.unfocus();
    _assetDescriptionFocusNode.unfocus();
  }

  @override
  void dispose() {
    _assetNameController.dispose();
    _assetDescriptionController.dispose();
    _assetNameFocusNode.dispose();
    _assetDescriptionFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localize = textLocalizer(context);
    final paddingLTR = getEdgeInsets(left: 16, right: 16, top: 16);
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBarPrimary(
            title:
                widget.asset != null ? localize.editAsset : localize.addAsset,
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
                      focusNode: _assetNameFocusNode,
                      autofocus: true,
                      onChanged: (value) {},
                      hintStyle: textStyle(
                        context,
                        style: StyleType.bodMed,
                      ).copyWith(
                        fontWeight: _assetNameController.text.isEmpty
                            ? FontWeight.normal
                            : FontWeight.bold,
                        color: context.color.onSurface.withValues(alpha: 0.5),
                      ),
                    ),
                  ),
                  Gap.vertical(10),
                  BoxCalculator(
                    label: '${localize.value}*',
                    height: 65.h,
                    onComplete: _unFocus,
                  ),
                  Gap.vertical(10),
                  AppGlass(
                    padding: getEdgeInsetsAll(5),
                    child: AppFormField(
                      controller: _assetDescriptionController,
                      hintText:
                          '${localize.description} (${localize.optional})',
                      focusNode: _assetDescriptionFocusNode,
                      onChanged: (value) {},
                      hintStyle: textStyle(
                        context,
                        style: StyleType.bodMed,
                      ).copyWith(
                        fontWeight: _assetDescriptionController.text.isEmpty
                            ? FontWeight.normal
                            : FontWeight.bold,
                        color: context.color.onSurface.withValues(alpha: 0.5),
                      ),
                    ),
                  ),
                  Gap.vertical(16),
                  BlocConsumer<NetWorthBloc, NetWorthState>(
                    listener: (context, state) {
                      if (state.insertSuccess ||
                          state.updateSuccess ||
                          state.deleteSuccess) {
                        if (context.canPop()) {
                          if (state.deleteSuccess) {
                            context
                              ..pop()
                              ..pop();
                          } else {
                            context.pop();
                          }
                        }

                        _reset();
                        context.read<NetWorthBloc>().add(GetAssetList());
                      }
                    },
                    builder: (context, state) {
                      return Column(
                        children: [
                          AppButton(
                            label: widget.asset != null
                                ? localize.update
                                : localize.add,
                            onPressed: () {
                              final value = ControllerHelper.getAmount(context);
                              final assetId = widget.asset?.id;
                              final createdAt = widget.asset?.createdAt;

                              if (value != null &&
                                  _assetNameController.text.isNotEmpty) {
                                final assetValue = value;
                                final assetEntity = AssetEntity(
                                  name: _assetNameController.text,
                                  amount: assetValue,
                                  description: _assetDescriptionController.text,
                                  id: assetId ?? const Uuid().v4(),
                                  createdAt:
                                      createdAt ?? DateTime.now().toString(),
                                  updatedAt: DateTime.now().toString(),
                                );
                                if (assetId != null) {
                                  context.read<NetWorthBloc>().add(
                                        UpdateAssetEvent(assetEntity),
                                      );
                                } else {
                                  context.read<NetWorthBloc>().add(
                                        AddAssetEvent(assetEntity),
                                      );
                                }
                              } else {
                                AppToast.showToastError(
                                  context,
                                  localize.pleaseFillAllRequiredFields,
                                );
                              }
                            },
                          ),
                          Gap.vertical(10),
                          AppButton.outlined(
                            label: localize.delete,
                            onPressed: () {
                              _showDeleteDialog(context);
                            },
                          ),
                        ],
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

  void _showDeleteDialog(BuildContext context) {
    final localize = textLocalizer(context);
    AppDialog.showCustomDialog(
      context,
      title: AppText(
        text: localize.delete,
        style: StyleType.headSm,
        color: context.color.error,
        textAlign: TextAlign.center,
      ),
      content: AppText(
        text: localize.areYouSureYouWantToDeleteThisAsset,
        textAlign: TextAlign.center,
      ),
      actions: [
        AppButton(
          height: 40,
          label: localize.cancel,
          onPressed: () {
            context.pop();
          },
        ),
        AppButton.outlined(
          height: 40,
          label: localize.delete,
          onPressed: () {
            context
                .read<NetWorthBloc>()
                .add(DeleteAssetEvent(widget.asset?.id ?? ''));
          },
        ),
      ],
    );
  }

  void _reset() {
    context.read<NetWorthBloc>().add(SetToInitial());
    context.read<BoxCalculatorCubit>().unselect();
  }
}
