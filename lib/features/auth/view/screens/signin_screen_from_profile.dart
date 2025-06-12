import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/auth/view/controller/auth/auth_bloc.dart';
import 'package:budget_intelli/features/settings/settings_barrel.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SignInScreenFromProfile extends StatefulWidget {
  const SignInScreenFromProfile({super.key});

  @override
  State<SignInScreenFromProfile> createState() =>
      _SignInScreenFromProfileState();
}

class _SignInScreenFromProfileState extends State<SignInScreenFromProfile> {
  bool _isObscureText = true;
  bool checkBoxValue = false;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  void _unfocusField() {
    _emailFocus.unfocus();
    _passwordFocus.unfocus();
  }

  void _onSuccessAuth(AuthSuccess state) {
    final user = state.user;

    context.read<SettingBloc>().add(SetUserUidEvent(user.uid));

    context.pushReplacement(MyRoute.main);
  }

  @override
  Widget build(BuildContext context) {
    final canPop = context.canPop();
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
        final localize = textLocalizer(context);
        final loading = state is AuthLoading;

        return Scaffold(
          appBar: canPop
              ? appBarPrimary(
                  context: context,
                )
              : null,
          body: CustomScrollView(
            slivers: [
              SliverFillRemaining(
                fillOverscroll: true,
                child: Padding(
                  padding: getEdgeInsetsSymmetric(horizontal: 16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // AppText.color(
                        //   text: localize.signInScreenTitle,
                        //   color: Theme.of(context).colorScheme.primary,
                        //   style: StyleType.disSm,
                        // ),
                        // Gap.vertical(32),
                        Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              appBoxShadow(
                                context,
                              ),
                            ],
                          ),
                          child: TextFormField(
                            focusNode: _emailFocus,
                            controller: _emailController,
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
                            focusNode: _passwordFocus,
                            controller: _passwordController,
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
                        // Align(
                        //   alignment: Alignment.centerRight,
                        //   child: GestureDetector(
                        //     onTap: () {
                        //       // context.push(RouteName);
                        //     },
                        //     child: AppText.color(
                        //       text: localize.forgotPassTitle,
                        //       color: Theme.of(context).colorScheme.primary,
                        //       style: StyleType.bodMd,
                        //       fontWeight: FontWeight.w500,
                        //     ),
                        //   ),
                        // ),

                        Gap.vertical(32),
                        if (loading)
                          const SizedBox(
                            height: 50,
                            width: 50,
                            child: CircularProgressIndicator(),
                          ),
                        if (!loading)
                          AppButton.darkLabel(
                            label: localize.signInLabel,
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                context.read<AuthBloc>().add(
                                      SignInEvent(
                                        email: _emailController.text.trim(),
                                        password: _passwordController.text,
                                      ),
                                    );
                                _unfocusField();
                              }
                            },
                          ),
                        Gap.vertical(32),
                        Center(
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: localize.signInFooter,
                                  style: textStyle(
                                    context,
                                    style: StyleType.titSm,
                                  ).copyWith(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                TextSpan(
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      context.pop();
                                    },
                                  text: ' ${localize.signUpLabel}',
                                  style:
                                      textStyle(context, style: StyleType.titSm)
                                          .copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: context.color.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Row(
                        //   children: [
                        //     const Expanded(child: AppDivider()),
                        //     Padding(
                        //       padding: getEdgeInsetsSymmetric(horizontal: 16),
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
                        // Gap.vertical(80),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
