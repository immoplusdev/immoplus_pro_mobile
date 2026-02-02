import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus_pro/core/network/utils/constants.dart';
import 'package:immoplus_pro/features/authentification/registration_content.dart';
import 'package:immoplus_pro/features/registration/models/data_router_registration.dart';
import 'package:immoplus_pro/features/registration/pages/enterprise_registration.dart';
import 'package:immoplus_pro/features/registration/pages/particulier_registration.dart';

class ChooseAccountTypePage extends StatefulWidget {
  final DataRouterRegistration dataRouterRegistration;
  const ChooseAccountTypePage(
      {super.key, required this.dataRouterRegistration});

  static const String name = 'choose-account-type';
  static String routePath() => '/choose-account-type';

  @override
  State<ChooseAccountTypePage> createState() => _ChooseAccountTypePageState();
}

class _ChooseAccountTypePageState extends State<ChooseAccountTypePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE9E9E9),
      body: Column(
        children: [
          Gap(100),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(50),
                ),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () => context.pop(),
                          child: Container(
                            width: 31,
                            height: 31,
                            decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                shape: BoxShape.circle),
                            child: Center(
                                child: Icon(Icons.arrow_back_ios, size: 10)),
                          ),
                        ),
                        Expanded(
                            child: Text(
                          "Création de compte",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                        SizedBox(
                          width: 31,
                          height: 31,
                        )
                      ],
                    ),
                  ),
                  Divider(),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(appPadding),
                      child: SingleChildScrollView(
                        child: RegistrationContent(
                          entrepriseOnTap: () {
                            context.pushReplacementNamed(
                              EnterpriseRegistrationPage.name,
                              extra: widget.dataRouterRegistration,
                            );
                          },
                          particulierOnTap: () {
                            context.pushReplacementNamed(
                              ParticulierRegistration.name,
                              extra: widget.dataRouterRegistration,
                            );
                          },
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
  }
}
