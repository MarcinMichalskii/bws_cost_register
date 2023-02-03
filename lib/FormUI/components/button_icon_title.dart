import 'package:bws_agreement_creator/FormUI/components/touchable_opacity.dart';
import 'package:bws_agreement_creator/utils/colors.dart';
import 'package:flutter/material.dart';

class ButtonIconTitle extends StatelessWidget {
  const ButtonIconTitle(
      {Key? key, required this.onTap, required this.title, required this.icon})
      : super(key: key);

  final VoidCallback onTap;
  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return TouchableOpacity(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 36,
            color: CustomColors.applicationColorMain,
          ),
          Container(
            margin: const EdgeInsets.only(top: 4),
            child: Text(
              title,
              style: const TextStyle(color: CustomColors.gray),
            ),
          )
        ],
      ),
    );
  }
}
