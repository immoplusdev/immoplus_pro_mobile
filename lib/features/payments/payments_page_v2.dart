import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/features/notification/notification_page.dart';
import 'package:immoplus_pro/features/payments/components/wallet_transaction_list.dart';
import 'package:immoplus_pro/features/payments/components/withdrawal_request_list.dart';
import 'package:immoplus_pro/features/payments/logic/wallet_cubit.dart';
import 'package:immoplus_pro/features/payments/screen/withdraw_form_screen_v2.dart';
import 'package:immoplus_pro/gen/assets.gen.dart';
import 'package:immoplus_pro/utils/session_manager.dart';
import 'package:immoplus_pro/utils/utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:immoplus_pro/data/schemas/user_model_schema.dart';

class PaymentsPageV2 extends StatefulWidget {
  const PaymentsPageV2({super.key});
  static String name = 'PaymentsPageV2';
  static const String routePath = '/payments_v2';

  @override
  State<PaymentsPageV2> createState() => _PaymentsPageV2State();
}

class _PaymentsPageV2State extends State<PaymentsPageV2> {
  UserModelSchema? currentUser;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            // Blue header inspired directly from HomePageV2 with back chevron
            _buildBlueHeader(context),

            // Tabbar styled perfectly matching mockup
            TabBar(
              tabs: const [
                Tab(text: "Transactions"),
                Tab(text: "Demandes"),
              ],
              labelColor: AppColors.primary,
              unselectedLabelColor: Colors.grey.shade500,
              indicatorColor: AppColors.primary,
              indicatorWeight: 2.0,
              indicatorSize: TabBarIndicatorSize.label,
              labelStyle: GoogleFonts.sen(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              unselectedLabelStyle: GoogleFonts.sen(
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),

            const Gap(10),

            // TabBarView for list contents
            const Expanded(
              child: TabBarView(
                children: [
                  WalletTransactionList(),
                  WithdrawalRequestList(),
                ],
              ),
            ),
          ],
        ),

        // Fully rounded capsule blue button matching the mockup
        // floatingActionButton: FloatingActionButton.extended(
        //   onPressed: () async {
        //     await context.pushNamed(WithdrawFormScreenV2.name);
        //     pagingControllerWidrawalList.refresh();
        //     if (mounted) {
        //       context.read<WalletCubit>().onGetWallet();
        //     }
        //   },
        //   backgroundColor: AppColors.primary,
        //   foregroundColor: Colors.white,
        //   elevation: 4,
        //   shape: RoundedRectangleBorder(
        //     borderRadius: BorderRadius.circular(26),
        //   ),
        //   icon: SvgPicture.asset(Assets.svgs.retraitDollars),
        //   label: Text(
        //     "Retrait",
        //     style: GoogleFonts.sen(
        //       fontWeight: FontWeight.bold,
        //       fontSize: 16,
        //     ),
        //   ),
        // ),
      ),
    );
  }

  Widget _buildBlueHeader(BuildContext context) {
    currentUser = SessionManager().currentUser;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
          top: 10 + MediaQuery.of(context).padding.top,
          bottom: 20,
          left: 16,
          right: 16),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Row(
        children: [
          // Back button
          IconButton(
            icon: const Icon(Icons.chevron_left, color: Colors.white, size: 36),
            onPressed: () => context.pop(),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),

          const Gap(12),

          // User Avatar
          CircleAvatar(
            radius: 24,
            backgroundColor: Colors.white,
            backgroundImage: (currentUser?.avatar != null)
                ? CachedNetworkImageProvider(
                    Utils.getImagePath(id: currentUser!.avatar!),
                  )
                : const NetworkImage(
                    "https://static.vecteezy.com/system/resources/previews/005/129/844/non_2x/profile-user-icon-isolated-on-white-background-eps10-free-vector.jpg",
                  ) as ImageProvider,
          ),

          const Gap(12),

          // Greeting & Welcome Texts
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  currentUser?.greetingText ?? "Bonjour ",
                  style: GoogleFonts.sen(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 3,
                ),
                Text(
                  "Bienvenue dans votre dashboard",
                  style: GoogleFonts.sen(
                    color: Colors.white70,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),

          // Notification Button
          IconButton(
            onPressed: () => context.push(NotificationPage.routePath()),
            icon: const Icon(
              Iconsax.notification,
              color: Colors.white,
              size: 22,
            ),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }
}
