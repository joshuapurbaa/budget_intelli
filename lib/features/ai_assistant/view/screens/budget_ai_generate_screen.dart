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

  bool myInterceptor(_, RouteInfo info) {
    context.pop();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final localize = textLocalizer(context);
    return PopScope(
      onPopInvoked: (didPop) {
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
                  AppToast.showToastError(
                    context,
                    localize.failedToGenerateBudgetPleaseTryAgain,
                  );
                }
              },
              builder: (context, state) {
                // final loading = state.loadingGenerateBudget;
                final language = state.language;
                String hintText;

                List<BudgetMethodModel>? listBudgetMethod;
                if (language == 'English') {
                  listBudgetMethod = listBudgetMethodEnglish;
                  hintText =
                      'Add Additional context...\nExample: I have debt 10000, My goals are to save 1200, I have 3 dependents, I have 1 house, I have 1 pet, Maximum budget for food is 1000';
                } else {
                  listBudgetMethod = listBudgetMethodIndonesia;
                  hintText =
                      'Tambah konteks tambahan...\nContoh: Saya memiliki hutang 1200000, Tujuan saya adalah menyimpan 500000, Saya memiliki 1 rumah, Anggaran maksimum untuk makanan adalah 1200000';
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
                            decoration: InputDecoration(
                              hintText: '${localize.budgetName}...',
                              hintStyle: textStyle(
                                context,
                                StyleType.bodSm,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onChanged: (value) {
                              context
                                  .read<PromptCubit>()
                                  .setBudgetName(budgetName: value);
                            },
                          ),
                          Gap.vertical(16),
                          TextFormField(
                            focusNode: _incomeFocusNode,
                            controller: _incomeController,
                            inputFormatters: [
                              CurrencyTextInputFormatter.currency(
                                locale: state.currency?.locale,
                                symbol: '${state.currency?.symbol} ',
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
                              hintStyle: textStyle(
                                context,
                                StyleType.bodSm,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onChanged: (value) {
                              context
                                  .read<PromptCubit>()
                                  .setIncomeAmount(incomeAmount: value);
                            },
                          ),
                          Gap.vertical(16),
                          TextFormField(
                            focusNode: _additionalContextFocusNode,
                            controller: _additionalContextController,
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
                              hintStyle: textStyle(
                                context,
                                StyleType.bodSm,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onChanged: (value) {
                              context
                                  .read<PromptCubit>()
                                  .setAdditionalTextInputs(
                                    additionalTextInputs: value,
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
                            child: Wrap(
                              spacing: 8,
                              children: List.generate(
                                listBudgetMethod.length,
                                (index) {
                                  final method = listBudgetMethod![index];
                                  return ChoiceChip(
                                    label: Text(
                                      method.methodName,
                                      style: textStyle(
                                        context,
                                        StyleType.bodSm,
                                      ),
                                    ),
                                    selected: state.budgetMethod == method,
                                    onSelected: (selected) {
                                      _incomeFocusNode.unfocus();
                                      _additionalContextFocusNode.unfocus();
                                      _budgetNameFocusNode.unfocus();

                                      if (method.methodName == 'No method') {
                                        context
                                            .read<PromptCubit>()
                                            .setBudgetMethod(
                                              budgetMethod: null,
                                            );
                                        setState(() {
                                          _selectedBudgetMethod = null;
                                        });
                                      } else {
                                        context
                                            .read<PromptCubit>()
                                            .setBudgetMethod(
                                              budgetMethod: method,
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
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: _selectedBudgetMethod?.methodName ??
                                        localize.noMethodSelected,
                                    style: textStyle(
                                      context,
                                      StyleType.bodSm,
                                    ),
                                  ),
                                  TextSpan(
                                    text: '\n\n',
                                    style: textStyle(
                                      context,
                                      StyleType.bodSm,
                                    ),
                                  ),
                                  TextSpan(
                                    text: _selectedBudgetMethod
                                            ?.methodDescription ??
                                        '',
                                    style: textStyle(
                                      context,
                                      StyleType.bodSm,
                                    ),
                                  ),
                                ],
                              ),
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
                                context.read<PromptCubit>().submitPrompt();
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
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _setLanguage() async {
    await context.read<PromptCubit>().setLanguage();
  }

  Future<void> _setCurrency() async {
    await context.read<PromptCubit>().setCurrency();
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
                StyleType.bodMd,
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
