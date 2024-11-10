import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/settings/settings_barrel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart';

class MemberNameLocalization extends StatefulWidget {
  const MemberNameLocalization({
    super.key,
    required this.name,
    this.style,
    this.color,
  });

  final String name;
  final StyleType? style;
  final Color? color;

  @override
  State<MemberNameLocalization> createState() => _MemberNameLocalizationState();
}

class _MemberNameLocalizationState extends State<MemberNameLocalization> {
  String language = 'English';

  String setNameLocalization(String language, String name) {
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
    final language = context.watch<SettingBloc>().state.selectedLanguage;

    return AppText(
      text: setNameLocalization(language.text, widget.name),
      style: widget.style ?? StyleType.bodSm,
      color: widget.color ?? context.color.primary,
    );
  }
}
