import 'package:sps/common/constants/route_list.dart';
import 'package:sps/common/constants/theme.dart';
import 'package:sps/common/widgets/card_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              SizedBox(
                width: 120.0,
                child: Image.asset(
                  'assets/images/the_union.png',
                  fit: BoxFit.cover,
                ),
              ),
              Flexible(
                // width: 120.0,

                child: Image.asset(
                  'assets/images/USAID.jpg',
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
          backgroundColor: ColorTheme.primary,
          elevation: 0,
          actions: [
            IconButton(
              icon: const Icon(
                Icons.settings,
                color: Colors.white,
                size: 25.0,
              ),
              onPressed: () {
                context.push(RouteName.setting);
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [
              CardButton(
                color: ColorTheme.primary,
                press: () {
                  context.push(RouteName.patient);
                },
                title: "လူနာစာရင်း",
                image: "all_patient.png",
              ),
              CardButton(
                color: ColorTheme.primary,
                press: () {
                  context.push(RouteName.report);
                },
                title: "အနှစ်ချုပ်",
                image: "summary.png",
              ),
              CardButton(
                color: ColorTheme.primary,
                press: () {
                  context.push(RouteName.note);
                },
                title: "မှတ်စု",
                image: "handout.png",
              )
            ],
          ),
        ));
  }
}
