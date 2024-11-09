import 'dart:typed_data';

import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/financial_tracker/financial_tracker_barrel.dart';
import 'package:budget_intelli/features/member/member_barrel.dart';
import 'package:budget_intelli/features/settings/settings_barrel.dart';
import 'package:budget_intelli/init_dependencies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class ButtonMember extends StatelessWidget {
  const ButtonMember({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FinancialTransactionBloc, FinancialTransactionState>(
      builder: (context, state) {
        final member = state.selectedMember;
        final iconPath = member.iconPath;
        final icon = member.icon;
        return ElevatedButton(
          style: ElevatedButton.styleFrom(
            fixedSize: Size(85.w, 65.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            padding: EdgeInsets.zero,
            backgroundColor: context.color.primaryContainer,
          ),
          onPressed: () {
            AppDialog.showAnimationDialog(
              context: context,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(
                    memberStaticList.length,
                    (index) {
                      final iconPath = memberStaticList[index].iconPath;
                      final icon = memberStaticList[index].icon;
                      return Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            fixedSize: Size(85.w, 70.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: EdgeInsets.zero,
                            backgroundColor: context.color.primaryContainer,
                          ),
                          onPressed: () {
                            context.read<FinancialTransactionBloc>().add(
                                  SelectMemberEvent(
                                    memberStaticList[index],
                                  ),
                                );
                            context.pop();
                          },
                          child: _IconMember(
                            iconPath: iconPath,
                            icon: icon,
                            name: memberStaticList[index].name,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            );
          },
          child: _IconMember(
            iconPath: iconPath,
            icon: icon,
            name: member.name,
          ),
        );
      },
    );
  }
}

class _IconMember extends StatefulWidget {
  const _IconMember({
    super.key,
    this.iconPath,
    this.icon,
    required this.name,
  });

  final String? iconPath;
  final Uint8List? icon;
  final String name;

  @override
  State<_IconMember> createState() => _IconMemberState();
}

class _IconMemberState extends State<_IconMember> {
  String? language;

  @override
  void initState() {
    super.initState();
    _getLanguage();
  }

  Future<void> _getLanguage() async {
    language = await serviceLocator<SettingPreferenceRepo>().getLanguage();
    setState(() {
      language = language;
    });
  }

  String _setName(String language, String name) {
    if (language == 'Indonesia') {
      if (name == 'Self') {
        return 'Sendiri';
      } else if (name == 'Wife') {
        return 'Istri';
      } else if (name == 'Husband') {
        return 'Suami';
      } else if (name == 'Child') {
        return 'Anak';
      } else if (name == 'Parents') {
        return 'Orang Tua';
      } else if (name == 'Pet') {
        return 'Peliharaan';
      }
    }
    return name;
  }

  @override
  Widget build(BuildContext context) {
    if (language == null) {
      return const CircularProgressIndicator.adaptive();
    }

    if (widget.iconPath != null) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          getPngAsset(
            widget.iconPath!,
            width: 30,
            height: 30,
            color: context.color.primary,
          ),
          Gap.vertical(2),
          AppText(
            text: _setName(language!, widget.name),
            style: StyleType.bodSm,
            color: context.color.primary,
          ),
        ],
      );
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.memory(
            widget.icon!,
            width: 30,
            height: 30,
          ),
          Gap.vertical(3),
          AppText(
            text: _setName(language!, widget.name),
            style: StyleType.bodSm,
            color: context.color.primary,
          ),
        ],
      );
    }
  }
}
