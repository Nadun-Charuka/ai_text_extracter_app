import 'package:ai_text_extracter_app/constants/colors.dart';
import 'package:flutter/material.dart';

class RecognizedTextPreview extends StatelessWidget {
  final String recognizedText;
  const RecognizedTextPreview({
    super.key,
    required this.recognizedText,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: Scrollbar(
        child: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: mainColor.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: mainColor.withValues(alpha: 0.2),
                width: 2,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(recognizedText),
            ),
          ),
        ),
      ),
    );
  }
}
