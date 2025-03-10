import 'dart:io';

import 'package:ai_text_extracter_app/constants/colors.dart';
import 'package:flutter/material.dart';

class ImagePreview extends StatelessWidget {
  final String? imagePath;
  const ImagePreview({
    super.key,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 300,
      decoration: BoxDecoration(
        color: mainColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: mainColor.withValues(alpha: 0.2),
          width: 2,
        ),
      ),
      child: imagePath == null
          ? Center(
              child: Icon(
                Icons.image,
                size: 300,
                color: Colors.black45,
              ),
            )
          : Image.file(
              File(imagePath!),
              fit: BoxFit.contain,
            ),
    );
  }
}
