import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:cupertino_stepper/cupertino_stepper.dart';

class CreatePlace extends StatefulWidget {
  const CreatePlace({super.key});
  static String name = "create_page";

  @override
  State<CreatePlace> createState() => _CreatePlaceState();
}

class _CreatePlaceState extends State<CreatePlace> {
  int _currentStep = 0;
  bool canCancel = true;
  bool canContinue = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: CupertinoStepper(
        currentStep: _currentStep,
        onStepTapped: (step) => setState(() => _currentStep = step),
        onStepCancel: canCancel ? () => setState(() => --_currentStep) : null,
        onStepContinue:
            canContinue ? () => setState(() => ++_currentStep) : null,
        physics: BouncingScrollPhysics(),
        type: StepperType.vertical,
        steps: [
          Step(
            title: Text('Étape 1'),
            subtitle: Text('Inforation de base'),
            state: StepState.editing,
            label: Text('Juste un label'),
            isActive: true,
            content: LimitedBox(
              maxWidth: 300,
              maxHeight: 300,
              child: Container(color: CupertinoColors.systemGrey),
            ),
          ),
          Step(
            title: Text('Étape 2'),
            subtitle: Text('Commodités'),
            //state: StepState.editing,
            isActive: true,
            content: LimitedBox(
              maxWidth: 300,
              maxHeight: 300,
              child: Container(color: CupertinoColors.systemGrey),
            ),
          ),
          Step(
            title: Text('Étape 1'),
            subtitle: Text('Inforation de base'),
            //state: StepState.editing,
            isActive: true,
            content: LimitedBox(
              maxWidth: 300,
              maxHeight: 300,
              child: Container(color: CupertinoColors.systemGrey),
            ),
            // Container(
            //   height: MediaQuery.of(context).size.height * 0.7,
            //   color: CupertinoColors.systemGrey,
            // ),
          ),
        ],
      ),
    );
  }
}
