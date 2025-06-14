import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/ai_assistant/ai_assistant_barrel.dart';
import 'package:budget_intelli/features/ai_assistant/models/budget_method_model.dart';
import 'package:budget_intelli/features/budget/budget_barrel.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class BudgetAiGenerateScreen extends StatefulWidget {
  const BudgetAiGenerateScreen({super.key});

  @override
  State<BudgetAiGenerateScreen> createState() => _BudgetAiGenerateScreenState();
}

class _BudgetAiGenerateScreenState extends State<BudgetAiGenerateScreen> {
  final _incomeController = TextEditingController();
  final _additionalContextController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  BudgetMethodModel? _selectedBudgetMethod;
  final _incomeFocusNode = FocusNode();
  final _additionalContextFocusNode = FocusNode();
  final _budgetNameController = TextEditingController();
  final _budgetNameFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    BackButtonInterceptor.add(myInterceptor);
    context.read<PromptCubit>().resetPrompt();
    _setLanguage();
    _setCurrency();
  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(myInterceptor);
    super.dispose();
  }

  bool myInterceptor(dynamic _, RouteInfo info) {
    context.pop();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final localize = textLocalizer(context);

    return PopScope(
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) {
          return;
        }
      },
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBarPrimary(
              title: localize.generateWithAI,
            ),
            BlocConsumer<PromptCubit, PromptState>(
              builder: (context, state) {
                // final loading = state.loadingGenerateBudget;
                final language = state.language;
                String hintText;

                final hintTextStyle = textStyle(
                  context,
                  style: StyleType.bodSm,
                ).copyWith(
                  color: context.color.onSurface.withValues(alpha: 0.5),
                );

                List<BudgetMethodModel>? listBudgetMethod;
                if (language == 'English') {
                  listBudgetMethod = listBudgetMethodEnglish;
                  hintText = localize.addAdditionalContextDesc;
                } else {
                  listBudgetMethod = listBudgetMethodIndonesia;
                  hintText = localize.addAdditionalContextDesc;
                }
                return SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: Form(
                    key: _formKey,
                    child: SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          Gap.vertical(16),
                          TextFormField(
                            controller: _budgetNameController,
                            focusNode: _budgetNameFocusNode,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return localize.pleaseInputYourBudgetName;
                              }
                              return null;
                            },
                            style: textStyle(
                              context,
                              style: StyleType.bodMed,
                            ),
                            decoration: InputDecoration(
                              hintText: '${localize.budgetName}...',
                              hintStyle: hintTextStyle,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onChanged: (value) {
                              context
                                  .read<PromptCubit>()
                                  .updateBudgetName(value);
                            },
                          ),
                          Gap.vertical(16),
                          TextFormField(
                            focusNode: _incomeFocusNode,
                            controller: _incomeController,
                            style: textStyle(
                              context,
                              style: StyleType.bodMed,
                            ),
                            inputFormatters: [
                              CurrencyTextInputFormatter.currency(
                                locale: state.currency?.locale,
                                symbol: state.currency?.symbol,
                                decimalDigits: 0,
                              ),
                            ],
                            validator: (value) {
                              if (value!.isEmpty) {
                                return localize.pleaseInputYourIncome;
                              }
                              return null;
                            },
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: localize.myIncomeIs,
                              hintStyle: hintTextStyle,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onChanged: (value) {
                              context
                                  .read<PromptCubit>()
                                  .updateIncomeAmount(value);
                            },
                          ),
                          Gap.vertical(16),
                          TextFormField(
                            focusNode: _additionalContextFocusNode,
                            controller: _additionalContextController,
                            style: textStyle(
                              context,
                              style: StyleType.bodMed,
                            ),
                            keyboardType: TextInputType.text,
                            maxLines: 4,
                            maxLength: 500,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return localize.pleaseInputAdditionalContext;
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              hintText: hintText,
                              hintStyle: hintTextStyle,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onChanged: (value) {
                              context
                                  .read<PromptCubit>()
                                  .updateAdditionalTextInputs(
                                    value,
                                  );
                            },
                          ),
                          Gap.vertical(16),
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: Colors.grey,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppText(
                                  text: localize.selectBudgetMethod,
                                  style: StyleType.bodMed,
                                ),
                                Gap.vertical(8),
                                const AppDivider(),
                                Gap.vertical(8),
                                Wrap(
                                  spacing: 8,
                                  children: List.generate(
                                    listBudgetMethod.length,
                                    (index) {
                                      final method = listBudgetMethod![index];
                                      return ChoiceChip(
                                        label: Text(
                                          method.methodName,
                                          style: state.budgetMethod == method
                                              ? textStyle(
                                                  context,
                                                  style: StyleType.bodSm,
                                                )
                                              : hintTextStyle,
                                        ),
                                        selected: state.budgetMethod == method,
                                        onSelected: (selected) {
                                          _incomeFocusNode.unfocus();
                                          _additionalContextFocusNode.unfocus();
                                          _budgetNameFocusNode.unfocus();

                                          if (method.methodName ==
                                              'No method') {
                                            context
                                                .read<PromptCubit>()
                                                .updateBudgetMethod(
                                                  null,
                                                );
                                            setState(() {
                                              _selectedBudgetMethod = null;
                                            });
                                          } else {
                                            context
                                                .read<PromptCubit>()
                                                .updateBudgetMethod(
                                                  method,
                                                );
                                            setState(() {
                                              _selectedBudgetMethod = method;
                                            });
                                          }
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Gap.vertical(10),
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: Colors.grey,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _selectedBudgetMethod?.methodName ??
                                      localize.noMethodSelected,
                                  style: textStyle(
                                    context,
                                    style: StyleType.bodSm,
                                  ),
                                ),
                                Gap.vertical(8),
                                const AppDivider(),
                                Gap.vertical(8),
                                if (_selectedBudgetMethod?.methodDescription !=
                                    null) ...[
                                  Text(
                                    _selectedBudgetMethod?.methodDescription ??
                                        '',
                                    style: textStyle(
                                      context,
                                      style: StyleType.bodSm,
                                    ),
                                  ),
                                ]
                              ],
                            ),
                          ),
                          Gap.vertical(16),
                          // if (loading)
                          //   const Center(
                          //     child: CircularProgressIndicator.adaptive(),
                          //   ),
                          // if (!loading)
                          AppButton(
                            label: localize.generateWithAI,
                            onPressed: () {
                              context.read<PromptCubit>().resetStatus();
                              if (state.generateSuccess) {
                                _showSuccessDialog(state);
                                return;
                              }

                              if (_formKey.currentState!.validate()) {
                                _incomeFocusNode.unfocus();
                                _additionalContextFocusNode.unfocus();
                                _budgetNameFocusNode.unfocus();
                                context
                                    .read<PromptCubit>()
                                    .retryGenerateBudget();
                              } else {
                                AppToast.showToastError(
                                  context,
                                  localize.pleaseFillAllRequiredFields,
                                );
                              }
                            },
                          ),
                          Gap.vertical(16),
                        ],
                      ),
                    ),
                  ),
                );
              },
              listener: (context, state) {
                if (state.loadingGenerateBudget) {
                  AppDialog.showLoading(
                    context,
                    message: localize.generatingBudget,
                  );
                }

                if (state.generateSuccess) {
                  context.read<BudgetFormBloc>()
                    ..add(BudgetFormToInitial())
                    ..add(
                      BudgetFormInitial(
                        generateBudgetAI: true,
                        budgetGenerate: state.budgetGenerate,
                      ),
                    );
                  _showSuccessDialog(state);
                  return;
                }

                if (state.generateBudgetFailure) {
                  context.pop();

                  // Show different error messages based on error type
                  if (state.networkError) {
                    AppToast.showToastError(
                      context,
                      localize.networkError,
                    );
                  } else {
                    AppToast.showToastError(
                      context,
                      localize.failedToGenerateBudgetPleaseTryAgain,
                    );
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _setLanguage() async {
    await context.read<PromptCubit>().loadLanguageSettings();
  }

  Future<void> _setCurrency() async {
    await context.read<PromptCubit>().loadCurrencySettings();
  }

  void _showSuccessDialog(PromptState state) {
    final localize = textLocalizer(context);

    AppDialog.showCustomDialog(
      context,
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppText(
              text: '${localize.budgetGeneratedSuccessfully} 🎉',
              style: StyleType.headMed,
              textAlign: TextAlign.center,
            ),
            Gap.vertical(16),
            Text(
              state.budgetGenerate!.notes,
              style: textStyle(
                context,
                style: StyleType.bodMed,
              ),
            ),
          ],
        ),
      ),
      actions: [
        AppButton(
          label: localize.back,
          onPressed: () {
            final budgetName = _budgetNameController.text;
            context.pop(budgetName);
          },
        ),
      ],
    ).whenComplete(
      () async {
        final prefsAi = AiAssistantPreferences();
        final totalGenerateBudget = await prefsAi.getTotalGenerateBudget();

        await prefsAi.setTotalGenerateBudget(totalGenerateBudget + 1);
        final budgetName = _budgetNameController.text;
        context
          ..pop(budgetName)
          ..pop(budgetName);
      },
    );
  }
}
