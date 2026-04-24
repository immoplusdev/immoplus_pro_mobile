import 'package:flutter/material.dart';
import 'package:immoplus_pro/data/models/payment/operator_model.dart';
import 'package:immoplus_pro/utils/easy_loading_handler.dart';

class OperatorSelector extends StatelessWidget {
  final List<OperatorModel> operators;
  final OperatorModel? selectedOperator;
  final ValueChanged<OperatorModel> onChanged;

  const OperatorSelector({
    super.key,
    required this.operators,
    required this.selectedOperator,
    required this.onChanged,
  });

  void _showOperatorModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      // backgroundColor: AppColors.scafold,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      builder: (_) {
        return ListView(
          children: operators.map((operator) {
            return ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(
                  operator.logo,
                  // width: 32,
                  // height: 32,
                  // errorBuilder: (_, __, ___) =>
                  //     const Icon(Icons.image_not_supported),
                ),
              ),
              title: Text(operator.name),
              subtitle: Text('Frais: ${operator.fee}%'),
              selected: operator == selectedOperator,
              onTap: () {
                if (operator.id == 0) {
                  EasyLoadingHandler.toast(
                      text:
                          "Ce moyen de retrait n'est pas disponible pour le moment");
                } else {
                  Navigator.pop(context);
                  onChanged(operator);
                }
              },
            );
          }).toList(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      leading: selectedOperator != null
          ? CircleAvatar(
              backgroundImage: NetworkImage(
                selectedOperator!.logo,
                // width: 32,
                // height: 32,
                // errorBuilder: (_, __, ___) =>
                //     const Icon(Icons.image_not_supported),
              ),
            )
          : const Icon(Icons.account_balance_wallet),
      title: Text(selectedOperator?.name ?? 'Sélectionner un opérateur'),
      trailing: selectedOperator != null
          ? Text('Frais: ${selectedOperator!.fee}%')
          : null,
      // trailing: const Icon(Icons.arrow_drop_down),
      onTap: () => _showOperatorModal(context),
    );
  }
}
