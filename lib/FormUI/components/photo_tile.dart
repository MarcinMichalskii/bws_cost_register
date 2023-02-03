import 'package:bws_agreement_creator/FormUI/components/touchable_opacity.dart';
import 'package:bws_agreement_creator/utils/colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class PhotoTile extends StatelessWidget {
  const PhotoTile(
      {Key? key, required this.onTap, required this.data, this.title})
      : super(key: key);

  final VoidCallback onTap;
  final Uint8List data;
  final String? title;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
              ),
              height: 80,
              width: 60,
              child: Image.memory(
                data,
                fit: BoxFit.cover,
              )),
          if (title != null)
            Container(
              margin: const EdgeInsets.only(top: 4),
              child: Text(
                title!,
                style: const TextStyle(
                    color: CustomColors.gray, fontWeight: FontWeight.w500),
              ),
            )
        ],
      ),
    );
  }
}
