import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/auth/view/controller/auth/auth_bloc.dart';
import 'package:budget_intelli/features/settings/settings_barrel.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SignInScreenInitial extends StatefulWidget {
  const SignInScreenInitial({super.key});

  @override
  State<SignInScreenInitial> createState() => _SignInScreenInitialState();
}

class _SignInScreenInitialState extends State<SignInScreenInitial> {
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

  Future<void> _onSuccessAuth(AuthSuccess state) async {
    final user = state.user;
    context.read<SettingBloc>()
      ..add(SetUserIntelli(user))
      ..add(SetUserIsLoggedIn(isLoggedIn: true))
      ..add(SetUserName(user.name))
      ..add(SetUserEmail(user.email))
      ..add(SetUserUidEvent(user.uid))
      ..add(SetUserIsPremiumUser(isPremiumUser: user.premium ?? false))
      ..add(GetUserSettingEvent());

    final prefs = await context
        .read<PreferenceCubit>()
        .getAlreadySetInitialCreateBudget();

    if (!prefs) {
      if (!mounted) return;
      context.go(MyRoute.createNewBudgetInitial);
    } else {
      if (!mounted) return;
      context.go(MyRoute.main);
    }
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
          if (canPop) {
            context.pop(true);
          } else {
            context.go(MyRoute.main);
          }
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
                        Gap.vertical(32),
                        if (loading)
                          const SizedBox(
                            height: 50,
                            width: 50,
                            child: CircularProgressIndicator(),
                          ),
                        if (!loading) ...[
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
                                        context.push(
                                          MyRoute.signUpInitial,
                                        );
                                      },
                                    text: ' ${localize.signUpLabel}',
                                    style: textStyle(context,
                                            style: StyleType.titSm)
                                        .copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: context.color.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
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
