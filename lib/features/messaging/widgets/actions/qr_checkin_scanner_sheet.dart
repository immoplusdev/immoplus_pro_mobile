import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:iconsax/iconsax.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/data/repositories/messaging_repository.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QrCheckinScannerSheet extends StatefulWidget {
  const QrCheckinScannerSheet({
    super.key,
    required this.onScanned,
  });

  final VoidCallback onScanned;

  static Future<void> show(
    BuildContext context, {
    required VoidCallback onScanned,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      showDragHandle: true,
      builder: (_) => QrCheckinScannerSheet(onScanned: onScanned),
    );
  }

  @override
  State<QrCheckinScannerSheet> createState() => _QrCheckinScannerSheetState();
}

class _QrCheckinScannerSheetState extends State<QrCheckinScannerSheet> {
  final MobileScannerController _controller = MobileScannerController();
  bool _isProcessing = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleBarcode(BarcodeCapture capture) async {
    if (_isProcessing) return;
    final barcodes = capture.barcodes;
    if (barcodes.isEmpty) return;
    final code = barcodes.first.rawValue;
    if (code == null || code.isEmpty) return;

    setState(() => _isProcessing = true);
    EasyLoading.show(status: 'Validation du QR code...');

    try {
      final res = await MessagingRepository.validatePresenceQr(code);
      EasyLoading.dismiss();
      if (!mounted) return;

      final checkinValid = res['checkinValide'] == true;
      if (checkinValid) {
        EasyLoading.showSuccess('Présence validée avec succès !');
        widget.onScanned();
        Navigator.of(context).pop();
      } else {
        EasyLoading.showError('QR Code invalide ou non reconnu.');
        setState(() => _isProcessing = false);
      }
    } catch (e) {
      EasyLoading.dismiss();
      if (!mounted) return;
      EasyLoading.showError('Échec de la validation du QR code.');
      setState(() => _isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Iconsax.scan, color: AppColors.primary, size: 24),
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  'Scanner le QR Présence',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Scannez le QR code présenté par le client pour valider son arrivée.',
            style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: MobileScanner(
                controller: _controller,
                onDetect: _handleBarcode,
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: OutlinedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(60),
                ),
              ),
              child: const Text('Fermer'),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
