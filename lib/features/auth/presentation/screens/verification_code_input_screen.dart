import 'package:dubts/core/utils/responsive_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class VerificationCodeInput extends StatefulWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onCompleted;
  final int length;

  const VerificationCodeInput({
    super.key,
    required this.controller,
    this.onCompleted,
    this.length = 6,
  });

  @override
  State<VerificationCodeInput> createState() => _VerificationCodeInputState();
}

class _VerificationCodeInputState extends State<VerificationCodeInput> {
  late List<FocusNode> _focusNodes;
  late List<TextEditingController> _controllers;

  @override
  void initState() {
    super.initState();
    _focusNodes = List.generate(widget.length, (index) => FocusNode());
    _controllers = List.generate(widget.length, (index) => TextEditingController());

    // Listen to changes in the main controller
    widget.controller.addListener(_updateDigitControllers);
  }

  @override
  void dispose() {
    for (var node in _focusNodes) {
      node.dispose();
    }
    for (var controller in _controllers) {
      controller.dispose();
    }
    widget.controller.removeListener(_updateDigitControllers);
    super.dispose();
  }

  void _updateDigitControllers() {
    final text = widget.controller.text;
    for (int i = 0; i < widget.length; i++) {
      if (i < text.length) {
        _controllers[i].text = text[i];
      } else {
        _controllers[i].text = '';
      }
    }
  }

  void _updateMainController() {
    widget.controller.text = _controllers.map((c) => c.text).join();
    if (widget.controller.text.length == widget.length) {
      widget.onCompleted?.call(widget.controller.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = ResponsiveUtils.screenWidth(context);
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(
        widget.length,
        (index) => SizedBox(
          width: screenWidth * 0.12,
          child: TextField(
            controller: _controllers[index],
            focusNode: _focusNodes[index],
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            maxLength: 1,
            decoration: InputDecoration(
              counterText: '',
              contentPadding: EdgeInsets.zero,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.grey),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFFE53935)),
              ),
            ),
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
            onChanged: (value) {
              if (value.isNotEmpty) {
                _updateMainController();
                if (index < widget.length - 1) {
                  _focusNodes[index + 1].requestFocus();
                }
              } else if (index > 0) {
                _focusNodes[index - 1].requestFocus();
              }
            },
          ),
        ),
      ),
    );
  }
}