import 'package:flutter/material.dart';
import 'package:flutter_simple_base_project/core/data_types.dart';

class TextFieldShow extends StatefulWidget {
  const TextFieldShow({
    Key? key,
    this.readOnly = false,
    this.suffixIcon,
    this.fillColor,
    required this.hint,
    this.maxLines = 1,
    this.onTap,
    this.suffixText,
    this.obscureText = false,
    this.value,
    this.listener,
    this.comment = true,
    this.prefixIcon,
    this.minLines = 1,
    this.validator,
    this.formKey,
    this.focusNode,
    this.autovalidateMode,
  }) : super(key: key);

  final bool readOnly;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final Key? formKey;
  final FocusNode? focusNode;

  final String hint;
  final String? value;
  final StringVs? listener;
  final int maxLines;
  final int minLines;
  final Function()? onTap;
  final String? suffixText;
  final bool obscureText;
  final bool comment;
  final Color? fillColor;
  final String? Function(String?)? validator;
  final AutovalidateMode? autovalidateMode;

  @override
  State<TextFieldShow> createState() => _TextFieldShowState();
}

class _TextFieldShowState extends State<TextFieldShow> {
  late TextEditingController _textEditingController;

  @override
  void initState() {
    super.initState();

    _textEditingController =
        TextEditingController(text: widget.value ?? widget.listener?.value);
    // widget.listener?.addListener(_handleListenerChanged);
  }

  _handleListenerChanged() {
    _textEditingController.text = widget.listener!.value;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _textEditingController.text =
        widget.value ?? widget.listener?.value ?? _textEditingController.text;
  }

  @override
  void didUpdateWidget(covariant TextFieldShow oldWidget) {
    super.didUpdateWidget(oldWidget);
    // if (context.debugDoingBuild || context.owner?.debugBuilding == true) return;
    _textEditingController.text =
        widget.value ?? widget.listener?.value ?? _textEditingController.text;
  }

  @override
  void dispose() {
    widget.listener?.removeListener(_handleListenerChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(boxShadow: [
        BoxShadow(
            color: Color(0x1A000000),
            offset: Offset(
              0,
              4,
            ),
            blurRadius: 15,
            spreadRadius: 0)
      ]),
      child: TextFormField(
        autovalidateMode: widget.autovalidateMode ??
            (widget.validator != null
                ? AutovalidateMode.onUserInteraction
                : null),
        focusNode: widget.focusNode,
        key: widget.formKey,
        validator: widget.validator,
        controller: _textEditingController,
        maxLines: widget.maxLines,
        minLines: widget.minLines,
        readOnly: widget.readOnly,
        onTap: widget.onTap ?? () {},
        onChanged: (value) {
          widget.listener?.value = value;
        },
        obscureText: widget.obscureText,
        // initialValue: widget.value,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Colors.black,
        ),
        decoration: InputDecoration(
          contentPadding: widget.comment
              ? EdgeInsets.symmetric(horizontal: 16).copyWith(top: 50)
              : EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          suffixIcon: widget.suffixIcon ?? const SizedBox.shrink(),
          suffixText: widget.suffixText,
          hintText: widget.hint,
          fillColor: widget.fillColor,
          hintStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Colors.grey,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
