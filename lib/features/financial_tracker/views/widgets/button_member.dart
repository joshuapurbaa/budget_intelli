import 'dart:typed_data';

import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/member/member_barrel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class ButtonMember extends StatefulWidget {
  const ButtonMember({
    super.key,
  });

  @override
  State<ButtonMember> createState() => _ButtonMemberState();
}

class _ButtonMemberState extends State<ButtonMember> {
  @override
  void initState() {
    super.initState();
    _getAllMember();
  }

  void _getAllMember() {
    context.read<MemberDbBloc>().add(
          const GetAllMemberDbEvent(),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MemberDbBloc, MemberDbState>(
      builder: (context, state) {
        final member = state.selectedMember;
        final iconPath = member?.iconPath;
        final icon = member?.icon;
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
              child: _MemberList(
                members: state.members,
                language: state.language,
              ),
            );
          },
          child: _IconMember(
            iconPath: iconPath,
            icon: icon,
            name: member?.name ?? 'Select Member',
            language: state.language,
          ),
        );
      },
    );
  }
}

class _MemberList extends StatelessWidget {
  const _MemberList({
    required this.members,
    this.language,
  });

  final List<Member> members;
  final String? language;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(
          members.length,
          (index) {
            final iconPath = members[index].iconPath;
            final icon = members[index].icon;
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
                  context.read<MemberDbBloc>().add(
                        SelectMemberDbEvent(
                          members[index],
                        ),
                      );
                  context.pop();
                },
                child: _IconMember(
                  iconPath: iconPath,
                  icon: icon,
                  name: members[index].name,
                  language: language,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _IconMember extends StatefulWidget {
  const _IconMember({
    required this.name, this.iconPath,
    this.icon,
    this.language,
  });

  final String? iconPath;
  final Uint8List? icon;
  final String name;
  final String? language;

  @override
  State<_IconMember> createState() => _IconMemberState();
}

class _IconMemberState extends State<_IconMember> {
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
    if (widget.language == null) {
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
            text: _setName(widget.language!, widget.name),
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
            text: _setName(widget.language!, widget.name),
            style: StyleType.bodSm,
            color: context.color.primary,
          ),
        ],
      );
    }
  }
}
