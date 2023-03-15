import 'dart:io';

import 'package:flutter/material.dart';

class ImageDialog extends StatelessWidget {
  const ImageDialog({super.key, required this.imgUrl});

  final String imgUrl;
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        width: double.tryParse(MediaQuery.of(context).orientation.toString()),
        // height: 200,
        // decoration: BoxDecoration(
        //     image: DecorationImage(
        //         image: FileImage(File(imgUrl)), fit: BoxFit.cover)),
        child: Image(image: FileImage(File(imgUrl))),
      ),
    );
  }
}
