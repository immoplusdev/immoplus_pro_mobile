import 'package:flutter/cupertino.dart';
import 'package:gap/gap.dart';
import 'package:immoplus_pro/features/shared_widgets/custom_button.dart';

class StepBottomButton extends StatefulWidget {
  const StepBottomButton({
    super.key,
    required this.onNext,
    required this.onPrevious,
    this.onNextText,
    this.onPreviousText,
  });
  final void Function()? onNext;
  final void Function()? onPrevious;
  final String? onPreviousText;
  final String? onNextText;
  @override
  State<StepBottomButton> createState() => _StepBottomButtonState();
}

class _StepBottomButtonState extends State<StepBottomButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          Flexible(
            child: CustomButtom(
              text: widget.onPreviousText ?? 'Précedent',
              onClick: widget.onPrevious,
            ),
          ),
          const Gap(10),
          Flexible(
            child: CustomButtom(
              text: widget.onNextText ?? 'Suivant',
              onClick: widget.onNext,
            ),
          ),
        ],
      ),
    );
  }
}
