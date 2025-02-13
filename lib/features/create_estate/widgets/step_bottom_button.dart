import 'package:flutter/cupertino.dart';
import 'package:gap/gap.dart';
import 'package:immoplus_pro/features/shared_widgets/custom_button.dart';

class StepBottomButton extends StatefulWidget {
  const StepBottomButton({
    super.key,
    required this.onNext,
    required this.onPreview,
  });
  final void Function()? onNext;
  final void Function()? onPreview;
  @override
  State<StepBottomButton> createState() => _StepBottomButtonState();
}

class _StepBottomButtonState extends State<StepBottomButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          Flexible(
            child: CustomButtom(
              text: 'Précedent',
              onClick: widget.onPreview,
            ),
          ),
          Gap(10),
          Flexible(
            child: CustomButtom(
              text: 'Suivant',
              onClick: widget.onNext,
            ),
          ),
        ],
      ),
    );
  }
}
