// import 'package:credit_card_form/credit_card_form.dart';
// import 'package:flutter/material.dart';
// import 'package:project4_flutter/features/property_detail/models/booking.dart';
//
// class TransactionModal extends StatefulWidget {
//   final Booking booking;
//   const TransactionModal({Key? key, required this.booking}) : super(key: key);
//   @override
//   State<TransactionModal> createState() => _TransactionState();
// }
//
// class _TransactionState extends State<TransactionModal> {
//   late Booking booking;
//   @override
//   @override
//   void initState() {
//     super.initState();
//     booking = widget.booking;
//   }
//
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Transaction Details'),
//       ),
//       body: const SingleChildScrollView(
//         child: Padding(
//           padding: EdgeInsets.all(16.0),
//           child: Column(
//             children: [
//               Text(
//                 'Transaction Details',
//                 style: TextStyle(
//                   color: Colors.white, // White title color
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:project4_flutter/features/property_detail/models/booking.dart';
import 'package:project4_flutter/features/property_detail/models/transaction.dart';
import 'package:project4_flutter/features/property_detail/property_detail.dart';
import 'package:project4_flutter/features/property_detail/widgets/show_popup_transaction.dart';
import 'package:project4_flutter/features/travel/travel.dart';
import 'package:project4_flutter/shared/bloc/booking/date_booking.dart';
import 'package:project4_flutter/shared/bloc/booking/transaction.dart';

class TransactionModal extends StatefulWidget {
  final Booking booking;

  const TransactionModal({Key? key, required this.booking}) : super(key: key);

  @override
  State<TransactionModal> createState() => _TransactionState();
}

class _TransactionState extends State<TransactionModal> {
  bool isValidate = false;
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;
  bool awaitTransaction = false;
  late Booking booking;
  final OutlineInputBorder border = OutlineInputBorder(
    borderSide: BorderSide(
      color: Colors.grey.withOpacity(0.7),
      width: 2.0,
    ),
  );
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    booking = widget.booking;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        context.read<DateBookingCubit>().updateDates(null, null);
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const Travel()),
          (route) => false,
        );
        return true;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: BlocBuilder<TransactionCubit, TransactionState>(
            builder: (context, state) {
          return Container(
            color: Colors.black, // Set background color to black
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Transaction Details',
                    style: TextStyle(
                      color: Colors.white, // White title color
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                CreditCardWidget(
                  isChipVisible: false,
                  cardNumber: cardNumber,
                  expiryDate: expiryDate,
                  cardHolderName: cardHolderName,
                  cvvCode: cvvCode,
                  bankName: 'Credit Card',
                  showBackView: isCvvFocused,
                  obscureCardNumber: true,
                  obscureCardCvv: true,
                  cardType: CardType.otherBrand,
                  isHolderNameVisible: true,
                  cardBgColor: isValidate
                      ? AppColors.cardBgLightColor
                      : AppColors.cardBgColor,
                  isSwipeGestureEnabled: true,
                  onCreditCardWidgetChange:
                      (CreditCardBrand creditCardBrand) {},
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        CreditCardForm(
                          formKey: formKey,
                          obscureCvv: true,
                          obscureNumber: true,
                          cardNumber: cardNumber,
                          cvvCode: cvvCode,
                          isHolderNameVisible: true,
                          isCardNumberVisible: true,
                          isExpiryDateVisible: true,
                          cardHolderName: cardHolderName,
                          expiryDate: expiryDate,
                          inputConfiguration: const InputConfiguration(
                            cardNumberDecoration: InputDecoration(
                              labelText: 'Number',
                              hintText: 'XXXX XXXX XXXX XXXX',
                              labelStyle: TextStyle(color: Colors.white),
                              hintStyle: TextStyle(color: Colors.white),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                            ),
                            expiryDateDecoration: InputDecoration(
                              labelText: 'Expired Date',
                              hintText: 'XX/XX',
                              labelStyle: TextStyle(color: Colors.white),
                              hintStyle: TextStyle(color: Colors.white),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                            ),
                            cvvCodeDecoration: InputDecoration(
                              labelText: 'CVV',
                              hintText: 'XXX',
                              labelStyle: TextStyle(color: Colors.white),
                              hintStyle: TextStyle(color: Colors.white),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                            ),
                            cardHolderDecoration: InputDecoration(
                              labelText: 'Card Holder',
                              labelStyle: TextStyle(color: Colors.white),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                            ),
                          ),
                          onCreditCardModelChange: onCreditCardModelChange,
                        ),
                        const SizedBox(height: 20),
                        GestureDetector(
                          onTap: _onValidate,
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: <Color>[
                                  AppColors.colorB58D67,
                                  AppColors.colorB58D67,
                                  AppColors.colorE5D1B2,
                                  AppColors.colorF9EED2,
                                  AppColors.colorEFEFED,
                                  AppColors.colorF9EED2,
                                  AppColors.colorB58D67,
                                ],
                                begin: Alignment(-1, -4),
                                end: Alignment(1, 4),
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(8),
                              ),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            alignment: Alignment.center,
                            child: awaitTransaction
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                : const Text(
                                    'Pay',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'halter',
                                      fontSize: 14,
                                      package: 'flutter_credit_card',
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  void _onValidate() {
    print("Booking on transaction : " + booking.amount.toString());
    if (formKey.currentState?.validate() ?? false) {
      setState(() {
        awaitTransaction = true;
        isValidate = true;
      });
      print("Validated: $isValidate");
      createTransaction(context); // Corrected here
    } else {
      setState(() {
        awaitTransaction = false;
        isValidate = false;
      });
      print("Not Validated: $isValidate");
    }
  }

  Future<void> createTransaction(BuildContext context) async {
    print("Hello chay toi day roi ne");
    final transactionCubit = context.read<TransactionCubit>();

    final transaction = Transaction(
      bookingId: booking.id,
      amount: booking.amount,
    );
    var result = await transactionCubit.initTransactionProcess(transaction);

    if (context.mounted) {
      final state = context.read<TransactionCubit>().state;
      String message = "";
      awaitTransaction = false;
      if (state is TransactionFail) {
        message = state.message;
        showErrorDialogTransaction(context, message, "Error");
      }
      if (result) {
        showErrorDialogTransaction(
            context, "Transaction Successful!", "Success");
      } else {
        showErrorDialogTransaction(context, message, "Error");
      }
    }
  }

  void onCreditCardModelChange(CreditCardModel creditCardModel) {
    setState(() {
      cardNumber = creditCardModel.cardNumber;
      expiryDate = creditCardModel.expiryDate;
      cardHolderName = creditCardModel.cardHolderName;
      cvvCode = creditCardModel.cvvCode;
      isCvvFocused = creditCardModel.isCvvFocused;
    });
  }
}

class AppColors {
  static const Color colorE5D1B2 = Color(0xFFE5D1B2);
  static const Color cardBgLightColor = Color(0xFFEFEFED);
  static const Color cardBgColor = Color(0xFF333333);
  static const Color colorB58D67 = Color(0xFFB58D67);
  static const Color colorF9EED2 = Color(0xFFF9EED2);
  static const Color colorEFEFED = Color(0xFFEFEFED);
}
