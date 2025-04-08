import 'package:admin_kdv/master/widget/custome_button_gradiant_widget.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class CommonDailog extends StatefulWidget {
  const CommonDailog({super.key, this.title, this.message, this.onTap});
  final String? title;
  final String? message;
  final void Function()? onTap;

  @override
  State<CommonDailog> createState() => CommonDailogState();
}

class CommonDailogState extends State<CommonDailog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: SizedBox(
        width: 390,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.title ?? '',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const Gap(30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomeButtonGradiantWidget(
                    buttonText: 'Cancel',
                    isUseContainerBorder: true,
                    width: 100,
                    height: 38,
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  const Gap(15),
                  CustomeButtonGradiantWidget(
                    buttonText: 'Yes',
                    isGradient: true,
                    width: 116,
                    height: 38,
                    onTap: widget.onTap,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
