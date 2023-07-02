import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sports/constants/colors.dart';
import 'package:sports/constants/images.dart';
import 'package:sports/services/router.dart';

class LoginPage extends StatefulHookConsumerWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final mailController = useTextEditingController();
    final loginController = useTextEditingController();
    final passwordController = useTextEditingController();

    return Scaffold(
        backgroundColor: Colors.grey[200],
        body: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: Stack(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 16.0),
                                  child: IconButton(
                                      onPressed: () {},
                                      icon: Icon(Icons.arrow_back)),
                                ),
                                Align(
                                  alignment: Alignment.center,
                                  child: Image(
                                      width: 200,
                                      height: 200,
                                      image: AssetImage(Images.login)),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              SizedBox(height: 20),
                              TextFormField(
                                controller: loginController,
                                decoration: InputDecoration(
                                    label: Text(
                                      "Login",
                                      style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    border: OutlineInputBorder()),
                              ),
                              SizedBox(height: 10),
                              TextFormField(
                                controller: mailController,
                                decoration: InputDecoration(
                                    label: Text(
                                      "Mail",
                                      style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    border: OutlineInputBorder()),
                              ),
                              SizedBox(height: 10),
                              TextFormField(
                                controller: passwordController,
                                decoration: InputDecoration(
                                    label: Text(
                                      "Password",
                                      style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    border: OutlineInputBorder(),
                                    suffixIcon: IconButton(
                                      icon: Icon(Icons.visibility),
                                      onPressed: () {
                                        //TODO: Visibility Password
                                      },
                                    )),
                              ),
                              SizedBox(height: 10),
                              Text("OR",
                                  style: TextStyle(
                                      fontSize: 19,
                                      fontWeight: FontWeight.w600,
                                      color: ColorsCustom.darkGrey)),
                              SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  //TODO: Login Functions
                                  OutlinedIconButton(
                                      function: () {},
                                      icon: FontAwesomeIcons.facebook,
                                      color: Colors.blueAccent),
                                  OutlinedIconButton(
                                    function: () {},
                                    icon: FontAwesomeIcons.google,
                                    color: Colors.red,
                                  ),
                                  OutlinedIconButton(
                                    function: () {},
                                    icon: FontAwesomeIcons.apple,
                                    color: Colors.grey[500],
                                  ),
                                  OutlinedIconButton(
                                    function: () {},
                                    icon: FontAwesomeIcons.twitter,
                                    color: Colors.blue,
                                  ),
                                ],
                              ),
                              SizedBox(height: 30),
                              Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () {
                                        //TODO: Login Button
                                        RouterServices.router
                                            .goNamed("recipes");
                                      },
                                      child: Text(
                                        "Login",
                                        style: TextStyle(
                                            fontSize: 19,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      style: ButtonStyle(
                                          minimumSize: MaterialStatePropertyAll(
                                              Size(0, 60))),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}

class OutlinedIconButton extends ConsumerStatefulWidget {
  const OutlinedIconButton(
      {super.key, required this.function, required this.icon, this.color});
  final VoidCallback function;
  final IconData icon;
  final Color? color;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _OutlinedIconButtonState();
}

class _OutlinedIconButtonState extends ConsumerState<OutlinedIconButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: widget.function,
      child: Ink(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey[500]!)),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Icon(
            widget.icon,
            color: widget.color ?? Colors.grey[700]!,
          ),
        ),
      ),
    );
  }
}
