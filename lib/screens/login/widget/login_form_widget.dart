import 'package:sps/common/constants/theme.dart';
import 'package:sps/common/widgets/custom_label_widget.dart';
import 'package:flutter/material.dart';

class LoginForm extends StatefulWidget {
  final onSubmit;

  const LoginForm({super.key, required this.onSubmit});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isObscureText = true;

  @override
  void dispose() {
    _codeController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding:
            const EdgeInsets.only(top: 150, bottom: 150, left: 20, right: 20),
        child: Column(children: [
          CustomLabelWidget(
            text:
                "လူနာ၏ကိုယ်ရေးအချက်အလက်များကို ဦးစားပေးလျှို့ဝှက်ချက်အနေဖြင့်(သက်ဆိုင်သူမှအပ အပြင်သို့မပေါက်ကြားအောင်) ထိန်းသိမ်းထားပါသည်။",
            align: TextAlign.center,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(
            height: 40,
          ),
          // SizedBox(
          //   child: Image.asset(
          //     "assets/images/the_union.png",
          //     height: 100,
          //   ),
          // ),
          // const SizedBox(
          //   height: 30,
          // ),
          const Text(
            "SPS",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: ColorTheme.primary),
          ),
          const Center(
            child: Text(
              'version 1',
              style: TextStyle(
                fontSize: 12.0,
                color: ColorTheme.secondary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Center(
            child: SizedBox(
              width: 200,
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          // Lottie.asset("assets/lottiefiles/pills.json", width: 250, height: 250),
          Container(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextFormField(
                    controller: _codeController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      labelText: "Code",
                      prefixIcon: const Icon(Icons.code),
                    ),
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    validator: (val) {
                      if (val!.isEmpty) {
                        return "Code is required";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      labelText: "Password",
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            isObscureText = !isObscureText;
                          });
                        },
                        child: Icon(
                          isObscureText
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: ColorTheme.primary,
                        ),
                      ),
                    ),
                    obscureText: isObscureText,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Your Password is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  ConstrainedBox(
                    constraints: BoxConstraints.tightFor(
                        width: MediaQuery.of(context).size.width),
                    child: ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            widget.onSubmit(
                                _codeController.text, _passwordController.text);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: ColorTheme.primary,
                            foregroundColor: Colors.white,
                            maximumSize: const Size(147, 50),
                            minimumSize: const Size(147, 50),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10))),
                        child: const Text('Login')),
                  )
                ],
              ),
            ),
          )
        ]),
      ),
    );
  }
}
