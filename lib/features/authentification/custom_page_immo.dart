import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class CustomPageImmo extends StatefulWidget {
  final String title;
  final Widget content;

  const CustomPageImmo({super.key, required this.title, required this.content});

  @override
  State<CustomPageImmo> createState() => _ChooseAccountTypePageState();
}

class _ChooseAccountTypePageState extends State<CustomPageImmo> {
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
                          widget.title,
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
                    child: widget.content,
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
