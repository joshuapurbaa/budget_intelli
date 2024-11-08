import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/member/member_barrel.dart';

final memberStaticList = <Member>[
  Member(
    id: '1-self',
    name: 'Self',
    createdAt: DateTime.now().toIso8601String(),
    updatedAt: DateTime.now().toIso8601String(),
    iconPath: selfPng,
  ),
  Member(
    id: '2-wife',
    name: 'Wife',
    createdAt: DateTime.now().toIso8601String(),
    updatedAt: DateTime.now().toIso8601String(),
    iconPath: wifePng,
  ),
  Member(
    id: '3-husband',
    name: 'Husband',
    createdAt: DateTime.now().toIso8601String(),
    updatedAt: DateTime.now().toIso8601String(),
    iconPath: husbandPng,
  ),
  Member(
    id: '4-child',
    name: 'Child',
    createdAt: DateTime.now().toIso8601String(),
    updatedAt: DateTime.now().toIso8601String(),
    iconPath: childPng,
  ),
  Member(
    id: '5-parents',
    name: 'Parents',
    createdAt: DateTime.now().toIso8601String(),
    updatedAt: DateTime.now().toIso8601String(),
    iconPath: parentsPng,
  ),
  Member(
    id: '6-pet',
    name: 'Pet',
    createdAt: DateTime.now().toIso8601String(),
    updatedAt: DateTime.now().toIso8601String(),
    iconPath: pawprintPetPng,
  ),
];
