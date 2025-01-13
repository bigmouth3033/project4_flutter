import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:project4_flutter/features/qr_scanner/bloc/qr_scanner_cubit.dart';
import 'package:project4_flutter/features/qr_scanner/widgets/qr_code_check.dart';
import 'package:project4_flutter/shared/utils/token_storage.dart';

import '../../main.dart';

class QrScanner extends StatefulWidget {
  const QrScanner({super.key});

  @override
  State<QrScanner> createState() => _QrScannerState();
}

class _QrScannerState extends State<QrScanner> {
  TokenStorage tokenStorage = TokenStorage();

  @override
  Widget build(BuildContext context) {
    return MobileScanner(
      controller:
          MobileScannerController(detectionSpeed: DetectionSpeed.noDuplicates),
      onDetect: (capture) {
        final List<Barcode> barcodes = capture.barcodes;
        final Uint8List? image = capture.image;
        if (barcodes.first.rawValue != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BlocProvider(
                create: (_) => QrScannerCubit(),
                child: QrCodeCheck(barcodes.first.rawValue!),
              ),
            ),
          );
        }
      },
    );
  }
}
