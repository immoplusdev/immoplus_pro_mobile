import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/features/create_furniture/utils/furniture_creation_manager.dart';

/// Step 3 du stepper de création de meuble : Prix.

class StepPrixPage extends StatefulWidget {
  const StepPrixPage({super.key});

  static String name = 'step_prix_page';

  @override
  State<StepPrixPage> createState() => _StepPrixPageState();
}

class _StepPrixPageState extends State<StepPrixPage> {
  final _manager = FurnitureCreationManager();
  late final MoneyMaskedTextController _controller;

  @override
  void initState() {
    super.initState();
    _controller = MoneyMaskedTextController(
      decimalSeparator: '',
      thousandSeparator: ' ',
      precision: 0,
      initialValue: (_manager.prix ?? 0).toDouble(),
      rightSymbol: ' FCFA',
    );
    _controller.addListener(() {
      log(_controller.numberValue.toString(), name: 'PRIX_VALUE', level: 2);
      _manager.prix = _controller.numberValue.toInt();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Form(
        child: CustomScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
              sliver: SliverToBoxAdapter(
                child: Text(
                  'Quel est le prix de votre meuble ?',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 50)),
            SliverToBoxAdapter(
              child: TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                enableInteractiveSelection: false,
                autofocus: true,
                keyboardType: TextInputType.number,
                controller: _controller,
                cursorWidth: 3,
                decoration: InputDecoration(
                  filled: false,
                  errorStyle: GoogleFonts.inter(
                    color: Colors.red,
                    fontSize: 14,
                  ),
                ),
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .headlineLarge!
                    .copyWith(color: AppColors.furnitureViolet),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un montant';
                  }
                  try {
                    if (_controller.numberValue == 0) {
                      return 'Le montant ne peut pas être égal à 0';
                    }
                    if (_controller.numberValue % 100 != 0) {
                      return 'Le montant doit être un multiple de 100';
                    }
                  } catch (e) {
                    // ignore
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
