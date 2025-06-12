import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/auth/view/controller/auth/auth_bloc.dart';
import 'package:budget_intelli/features/settings/settings_barrel.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SignUpScreenInitial extends StatefulWidget {
  const SignUpScreenInitial({super.key});

  @override
  State<SignUpScreenInitial> createState() => _SignUpScreenInitialState();
}

class _SignUpScreenInitialState extends State<SignUpScreenInitial> {
  bool _isObscureText = true;

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _nameFocus.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  void _unfocusField() {
    _nameFocus.unfocus();
    _emailFocus.unfocus();
    _passwordFocus.unfocus();
  }

  Future<void> _onSuccessAuth(AuthSuccess state) async {
    context.read<SettingBloc>()
      ..add(SetUserIntelli(state.user))
      ..add(SetUserIsLoggedIn(isLoggedIn: true))
      ..add(SetUserName(state.user.name))
      ..add(SetUserEmail(state.user.email))
      ..add(SetUserUidEvent(state.user.uid))
      ..add(GetUserSettingEvent());

    final prefsState = await context
        .read<PreferenceCubit>()
        .getAlreadySetInitialCreateBudget();

    if (!prefsState) {
      if (!mounted) return;
      context.go(MyRoute.initialCreateBudgetPlan);
    } else {
      if (!mounted) return;
      context.go(MyRoute.main);
    }
  }

  @override
  Widget build(BuildContext context) {
    final localize = textLocalizer(context);
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthFailure) {
          AppToast.showToastError(
            context,
            state.message,
          );
          _unfocusField();
        } else if (state is AuthSuccess) {
          _unfocusField();
          _onSuccessAuth(state);
        }
      },
      builder: (context, state) {
        final loading = state is AuthLoading;
        return Scaffold(
          appBar: appBarPrimary(
            context: context,
            title: '',
          ),
          body: CustomScrollView(
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              appBoxShadow(
                                context,
                              ),
                            ],
                          ),
                          child: TextFormField(
                            controller: _nameController,
                            focusNode: _nameFocus,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return localize.nameIsRequired;
                              }
                              return null;
                            },
                            decoration: appInputDecoration(
                              context,
                              hintText: localize.nameFieldLabel,
                              prefixIcon: nameSvg,
                            ),
                          ),
                        ),

                        Gap.vertical(16),
                        Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              appBoxShadow(
                                context,
                              ),
                            ],
                          ),
                          child: TextFormField(
                            controller: _emailController,
                            focusNode: _emailFocus,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return localize.emailIsRequired;
                              }
                              return null;
                            },
                            decoration: appInputDecoration(
                              context,
                              hintText: 'Email',
                              prefixIcon: emailSvg,
                            ),
                          ),
                        ),

                        Gap.vertical(16),
                        Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              appBoxShadow(
                                context,
                              ),
                            ],
                          ),
                          child: TextFormField(
                            controller: _passwordController,
                            focusNode: _passwordFocus,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return localize.passwordIsRequired;
                              }
                              return null;
                            },
                            obscureText: _isObscureText,
                            obscuringCharacter: '●',
                            decoration: appInputDecoration(
                              context,
                              hintText: 'Password',
                              prefixIcon: passwordLock,
                              suffixIcon: _isObscureText
                                  ? hideOutlineIcon
                                  : eyeOutlineWhiteIcon,
                              onTapSuffixIcon: () {
                                setState(() {
                                  _isObscureText = !_isObscureText;
                                });
                              },
                            ),
                          ),
                        ),
                        // Gap.vertical(16),
                        // Row(
                        //   children: [
                        //     Checkbox(
                        //       value: checkBoxValue,
                        //       onChanged: (value) {
                        //         _unfocusField();
                        //         setState(() {
                        //           checkBoxValue = value!;
                        //         });
                        //       },
                        //     ),
                        //     Expanded(
                        //       child: RichText(
                        //         text: TextSpan(
                        //           children: [
                        //             TextSpan(
                        //               text: localize.termConditionFirst,
                        //               style: textStyle(
                        //                 context,
                        //                 StyleType.mediumDef14,
                        //               ).copyWith(
                        //                 fontWeight: FontWeight.w500,
                        //               ),
                        //             ),
                        //             TextSpan(
                        //               text: ' ${localize.termConditionSecond}',
                        //               style: textStyle(
                        //                 context,
                        //                 StyleType.mediumDef14,
                        //               ).copyWith(
                        //                 fontWeight: FontWeight.w500,
                        //                 color: AppColor.primary,
                        //               ),
                        //             ),
                        //           ],
                        //         ),
                        //       ),
                        //     ),
                        //   ],
                        // ),
                        if (!loading) ...[
                          Gap.vertical(50),
                          Center(
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: localize.signUpBody1,
                                    style: textStyle(context,
                                            style: StyleType.titSm)
                                        .copyWith(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  TextSpan(
                                    text: ' ${localize.signInLabel}',
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        context.pop();
                                      },
                                    style: textStyle(
                                      context,
                                      style: StyleType.titSm,
                                    ).copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: context.color.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                        // Row(
                        //   children: [
                        //     const Expanded(child: AppDivider()),
                        //     Padding(
                        //       padding: getEdgeInsetsSymmetric(
                        //         horizontal: 16,
                        //       ),
                        //       child: Text(
                        //         localize.textDividerSignUpSignInScreen,
                        //         style: textStyle(context, StyleType.h6def18).copyWith(
                        //           fontWeight: FontWeight.w500,
                        //         ),
                        //       ),
                        //     ),
                        //     const Expanded(
                        //       child: AppDivider(),
                        //     ),
                        //   ],
                        // ),
                        // Gap.vertical(20),
                        // IconTextButton(
                        //   label: localize.googleButtonLabel,
                        //   iconPath: googleColorfulIcon,
                        //   onPressed: () {},
                        //   side: const BorderSide(
                        //     color: AppColor.dark5,
                        //   ),
                        // ),
                        // Gap.vertical(20),
                        // IconTextButton(
                        //   label: localize.appleButtonLabel,
                        //   iconPath: appleWhiteBoldIcon,
                        //   onPressed: () {},
                        //   side: const BorderSide(
                        //     color: AppColor.dark5,
                        //   ),
                        // ),
                        Gap.vertical(80),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          bottomSheet: BottomSheetParent(
            isWithBorderTop: true,
            child: loading
                ? const SizedBox(
                    height: 50,
                    width: 50,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : AppButton.darkLabel(
                    label: localize.signUpLabel,
                    isActive: true,
                    onPressed: () {
                      _unfocusField();
                      if (_formKey.currentState!.validate()) {
                        context.read<AuthBloc>().add(
                              SignUpEvent(
                                name: _nameController.text,
                                email: _emailController.text.trim(),
                                password: _passwordController.text,
                              ),
                            );
                      }
                    },
                  ),
          ),
        );
      },
    );
  }
}
