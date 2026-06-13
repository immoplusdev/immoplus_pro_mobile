// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:get_it/get_it.dart';
// import 'package:go_router/go_router.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:immoplus_pro/constantes/app_colors.dart';
// import 'package:immoplus_pro/features/pin_code/logic/cubit/pin_code_cubit.dart';
// import 'package:toastification/toastification.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:local_auth/local_auth.dart';

// class PinCodePage extends StatefulWidget {
//   final VoidCallback onSuccess;

//   const PinCodePage({super.key, required this.onSuccess});
//   static String name = 'pin_code';

//   @override
//   State<PinCodePage> createState() => _PinCodePageState();
// }

// class _PinCodePageState extends State<PinCodePage>
//     with SingleTickerProviderStateMixin {
//   String _pin = '';
//   final int _pinLength = 4;
//   late AnimationController _controller;
//   late Animation<double> _offsetAnimation;

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       duration: const Duration(milliseconds: 500),
//       vsync: this,
//     );
//     _offsetAnimation = Tween<double>(begin: 0.0, end: 24.0)
//         .chain(CurveTween(curve: Curves.elasticIn))
//         .animate(_controller)
//       ..addStatusListener((status) {
//         if (status == AnimationStatus.completed) {
//           _controller.reverse();
//         }
//       });
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => GetIt.I<PinCodeCubit>()..checkStatus(),
//       child: BlocConsumer<PinCodeCubit, PinCodeState>(
//         listener: (context, state) {
//           state.maybeWhen(
//             error: (message) {
//               toastification.show(
//                 type: ToastificationType.error,
//                 context: context,
//                 title: const Text("Oops, quelque chose s'est mal passé."),
//                 description: Text(
//                   message,
//                   maxLines: 6,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//                 autoCloseDuration: const Duration(seconds: 5),
//                 showProgressBar: false,
//                 alignment: Alignment.bottomCenter,
//                 style: ToastificationStyle.flatColored,
//               );
//               setState(() {
//                 _pin = '';
//               });
//               _controller.forward(from: 0.0);
//             },
//             pinVerified: () {
//               // toastification.show(
//               //   type: ToastificationType.success,
//               //   context: context,
//               //   title: const Text("Succès"),
//               //   description: const Text("Code PIN vérifié !"),
//               //   autoCloseDuration: const Duration(seconds: 3),
//               //   showProgressBar: false,
//               //   alignment: Alignment.bottomCenter,
//               //   style: ToastificationStyle.flatColored,
//               // );
//               widget.onSuccess();
//             },
//             pinSet: () {
//               toastification.show(
//                 type: ToastificationType.success,
//                 context: context,
//                 title: const Text("Succès"),
//                 description: const Text("Code PIN défini !"),
//                 autoCloseDuration: const Duration(seconds: 3),
//                 showProgressBar: false,
//                 alignment: Alignment.bottomCenter,
//                 style: ToastificationStyle.flatColored,
//               );
//               setState(() {
//                 _pin = '';
//               });
//               widget.onSuccess();
//             },
//             confirmPin: () {
//               setState(() {
//                 _pin = '';
//               });
//             },
//             biometricAvailable: (biometrics) {
//               // Auto trigger biometrics if desired
//               context.read<PinCodeCubit>().authenticateWithBiometrics();
//             },
//             orElse: () {},
//           );
//         },
//         builder: (context, state) {
//           final isDarkMode = Theme.of(context).brightness == Brightness.dark;
//           final textColor =
//               isDarkMode ? CupertinoColors.white : CupertinoColors.black;

//           String title = 'Entrez votre code';
//           state.maybeWhen(
//             createPin: () => title = 'Créez votre code PIN',
//             confirmPin: () => title = 'Confirmez votre code PIN',
//             orElse: () {},
//           );

//           return Scaffold(
//             backgroundColor: Theme.of(context).scaffoldBackgroundColor,
//             appBar: AppBar(
//               automaticallyImplyLeading: false,
//               toolbarHeight: 36,
//               actions: [
//                 IconButton(
//                   icon: const Icon(FontAwesomeIcons.solidCircleXmark),
//                   onPressed: () {
//                     context.pop();
//                   },
//                 ),
//               ],
//             ),
//             body: SafeArea(
//               child: Column(
//                 children: [
//                   const Spacer(flex: 1),
//                   // Title
//                   Text(
//                     title,
//                     style: GoogleFonts.sen(
//                       fontSize: 24,
//                       fontWeight: FontWeight.bold,
//                       color: textColor,
//                     ),
//                   ),
//                   const SizedBox(height: 40),
//                   // PIN Indicators
//                   AnimatedBuilder(
//                     animation: _offsetAnimation,
//                     builder: (context, child) {
//                       return Transform.translate(
//                         offset: Offset(
//                             _offsetAnimation.value *
//                                 (1 - (_controller.value * 2).floor() % 2 * 2),
//                             0),
//                         child: child,
//                       );
//                     },
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: List.generate(_pinLength, (index) {
//                         final bool isFilled = index < _pin.length;
//                         return Container(
//                           margin: const EdgeInsets.symmetric(horizontal: 12),
//                           width: 16,
//                           height: 16,
//                           decoration: BoxDecoration(
//                             shape: BoxShape.circle,
//                             color: isFilled
//                                 ? AppColors.primary
//                                 : (isDarkMode
//                                     ? Colors.grey[800]
//                                     : Colors.grey[300]),
//                             border: isFilled
//                                 ? null
//                                 : Border.all(
//                                     color: isDarkMode
//                                         ? Colors.grey[700]!
//                                         : Colors.grey[400]!,
//                                     width: 1.5,
//                                   ),
//                           ),
//                         );
//                       }),
//                     ),
//                   ),

//                   SizedBox(
//                     height: 100,
//                     child: Visibility(
//                       visible: state.maybeWhen(
//                         loading: () => true,
//                         orElse: () => false,
//                       ),
//                       child: Padding(
//                         padding: const EdgeInsets.only(top: 30),
//                         child: const CupertinoActivityIndicator(
//                           radius: 15,
//                         ),
//                       ),
//                     ),
//                   ),

//                   const Spacer(flex: 2),
//                   // Numeric Keypad
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 40),
//                     child: Column(
//                       children: [
//                         _buildKeyRow(context, ['1', '2', '3']),
//                         const SizedBox(height: 20),
//                         _buildKeyRow(context, ['4', '5', '6']),
//                         const SizedBox(height: 20),
//                         _buildKeyRow(context, ['7', '8', '9']),
//                         const SizedBox(height: 20),
//                         _buildLastRow(context, state),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(height: 40),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildKeyRow(BuildContext context, List<String> keys) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: keys.map((key) => _buildKey(context, key)).toList(),
//     );
//   }

//   Widget _buildLastRow(BuildContext context, PinCodeState state) {
//     bool showBiometric = false;
//     List<BiometricType> biometrics = [];
//     state.maybeWhen(
//       enterPin: (list) {
//         showBiometric = list.isNotEmpty;
//         biometrics = list;
//       },
//       biometricAvailable: (list) {
//         showBiometric = true;
//         biometrics = list;
//       },
//       orElse: () {},
//     );

//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         showBiometric
//             ? _buildBiometricButton(context, biometrics)
//             : const SizedBox(width: 80),
//         _buildKey(context, '0'),
//         _buildDeleteButton(context),
//       ],
//     );
//   }

//   Widget _buildKey(BuildContext context, String value) {
//     final isDarkMode = Theme.of(context).brightness == Brightness.dark;
//     return InkWell(
//       onTap: () {
//         HapticFeedback.lightImpact();
//         _onKeyPressed(context, value);
//       },
//       borderRadius: BorderRadius.circular(40),
//       child: Container(
//         width: 80,
//         height: 80,
//         alignment: Alignment.center,
//         decoration: const BoxDecoration(
//           shape: BoxShape.circle,
//         ),
//         child: Text(
//           value,
//           style: GoogleFonts.sen(
//             fontSize: 32,
//             fontWeight: FontWeight.w500,
//             color: isDarkMode ? CupertinoColors.white : CupertinoColors.black,
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildBiometricButton(
//       BuildContext context, List<BiometricType> biometrics) {
//     final isDarkMode = Theme.of(context).brightness == Brightness.dark;

//     Widget icon;
//     if (biometrics.contains(BiometricType.face)) {
//       icon = SvgPicture.asset(
//         'assets/svgs/icons/face_id.svg',
//         width: 32,
//         height: 32,
//         colorFilter: ColorFilter.mode(
//           isDarkMode ? CupertinoColors.white : CupertinoColors.black,
//           BlendMode.srcIn,
//         ),
//       );
//     } else if (biometrics.contains(BiometricType.fingerprint)) {
//       icon = Icon(
//         FontAwesomeIcons.fingerprint,
//         size: 32,
//         color: isDarkMode ? CupertinoColors.white : CupertinoColors.black,
//       );
//     } else {
//       // Default fallback if list is empty or other type (e.g. iris)
//       // Or if we are in enterPin state but haven't checked biometrics yet (shouldn't happen if logic is correct)
//       // We can default to fingerprint or a generic icon
//       icon = Icon(
//         FontAwesomeIcons.fingerprint,
//         size: 32,
//         color: isDarkMode ? CupertinoColors.white : CupertinoColors.black,
//       );
//     }

//     return InkWell(
//       onTap: () {
//         HapticFeedback.mediumImpact();
//         context.read<PinCodeCubit>().authenticateWithBiometrics();
//       },
//       borderRadius: BorderRadius.circular(40),
//       child: SizedBox(
//         width: 80,
//         height: 80,
//         child: Center(child: icon),
//       ),
//     );
//   }

//   Widget _buildDeleteButton(BuildContext context) {
//     final isDarkMode = Theme.of(context).brightness == Brightness.dark;
//     return InkWell(
//       onTap: () {
//         HapticFeedback.lightImpact();
//         _onDeletePressed();
//       },
//       borderRadius: BorderRadius.circular(40),
//       child: SizedBox(
//         width: 80,
//         height: 80,
//         child: Icon(
//           FontAwesomeIcons.deleteLeft,
//           size: 24,
//           color: isDarkMode ? CupertinoColors.white : CupertinoColors.black,
//         ),
//       ),
//     );
//   }

//   void _onKeyPressed(BuildContext context, String value) {
//     if (_pin.length < _pinLength) {
//       setState(() {
//         _pin += value;
//       });
//       if (_pin.length == _pinLength) {
//         final cubit = context.read<PinCodeCubit>();
//         cubit.state.maybeWhen(
//           createPin: () => cubit.setPin(_pin),
//           confirmPin: () => cubit.setPin(_pin),
//           orElse: () => cubit.verifyPin(_pin),
//         );
//       }
//     }
//   }

//   void _onDeletePressed() {
//     if (_pin.isNotEmpty) {
//       setState(() {
//         _pin = _pin.substring(0, _pin.length - 1);
//       });
//     }
//   }
// }
