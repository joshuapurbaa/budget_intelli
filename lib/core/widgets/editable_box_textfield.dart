import 'package:budget_intelli/core/core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EditableBoxTextField extends StatefulWidget {
  const EditableBoxTextField({
    required this.hintText,
    required this.prefixIcon,
    required this.useAppBoxSvg,
    super.key,
  });

  final String hintText;
  final String prefixIcon;
  final bool useAppBoxSvg;

  @override
  State<EditableBoxTextField> createState() => _EditableBoxTextFieldState();
}

class _EditableBoxTextFieldState extends State<EditableBoxTextField> {
  bool isEditing = false;
  late TextEditingController _textEditingController;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _toggleEditing() {
    setState(() {
      isEditing = !isEditing;
    });

    if (!isEditing) {
      _focusNode.unfocus();
    } else {
      _focusNode.requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBoxChild(
      height: widget.useAppBoxSvg ? null : 60,
      child: Row(
        children: [
          Visibility(
            visible: widget.useAppBoxSvg,
            child: AppBoxSvg(
              icon: widget.prefixIcon,
              height: 25,
              width: 25,
            ),
          ),
          Visibility(
            visible: !widget.useAppBoxSvg,
            child: getSvgPicture(
              widget.prefixIcon,
            ),
          ),
          Gap.horizontal(16),
          Expanded(
            child: TextField(
              controller: _textEditingController,
              focusNode: _focusNode,
              keyboardType: TextInputType.number,
              onTap: _toggleEditing,
              onSubmitted: (value) {
                _toggleEditing();
              },
              style: AppTextStyle.style(
                context,
                style: StyleType.bodMd,
              ).copyWith(
                fontWeight: FontWeight.w700,
              ),
              decoration: InputDecoration(
                contentPadding:
                    widget.useAppBoxSvg ? null : getEdgeInsets(bottom: 12),
                border: InputBorder.none,
                hintText: widget.hintText,
                hintStyle: AppTextStyle.style(
                  context,
                  style: StyleType.bodMd,
                ).copyWith(
                  fontWeight: isEditing ? FontWeight.w400 : FontWeight.w700,
                  color: isEditing
                      ? Theme.of(context).colorScheme.onSurfaceVariant
                      : Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
          ),
          Gap.horizontal(16),
          GestureDetector(
            onTap: _toggleEditing,
            child: Visibility(
              visible: !isEditing,
              replacement: const Icon(
                CupertinoIcons.checkmark,
                color: AppColor.white,
              ),
              child: getSvgPicture(
                editPenWhite,
                width: 20,
                height: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
