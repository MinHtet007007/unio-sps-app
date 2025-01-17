import 'package:sps/common/constants/theme.dart';
import 'package:sps/common/widgets/custom_label_widget.dart';
import 'package:flutter/material.dart';

class CardButton extends StatelessWidget {
  String title;
  String image;
  Color color;
  VoidCallback press;
  CardButton(
      {Key? key,
      required this.color,
      required this.image,
      required this.title,
      required this.press})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: press,
      child: Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                color: Colors.white,
                spreadRadius: 3,
                blurRadius: 3,
                offset: Offset(0, 2), // changes position of shadow
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(vertical: 20),
          width: size.width * 0.9,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset('assets/images/$image', width: 80, height: 80),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28.0),
                child: CustomLabelWidget(
                  text: title,
                  align: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              )
            ],
          )),
    );
  }
}
