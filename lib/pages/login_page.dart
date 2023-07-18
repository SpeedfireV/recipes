import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sports/constants/colors.dart';
import 'package:sports/constants/images.dart';
import 'package:sports/constants/styles.dart';
import 'package:sports/services/auth.dart';
import 'package:sports/services/item_page.dart';
import 'package:sports/services/router.dart';
import 'package:sports/widgets/problem_snackbar.dart';

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
    final passwordController = useTextEditingController();

    final mailNode = useFocusNode();
    final passwordNode = useFocusNode();

    bool visible = ref.watch(passwordVisibleProvider);
    ref.watch(loggedInProvider);
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
                                      onPressed: () {
                                        RouterServices.router
                                            .goNamed("recipes");
                                      },
                                      icon: Icon(Icons.close)),
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
                                focusNode: mailNode,
                                controller: mailController,
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) {
                                  if (!RegExp(
                                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                      .hasMatch(value!)) {
                                    return "Provide a Valid Mail";
                                  }
                                  return null;
                                },
                                onFieldSubmitted: (value) {
                                  _formKey.currentState!.validate();
                                  mailNode.nextFocus();
                                },
                                onEditingComplete: () {
                                  _formKey.currentState!.validate();
                                },
                                onSaved: (value) {
                                  _formKey.currentState!.validate();
                                },
                                decoration: InputDecoration(
                                    label:
                                        Text("Mail", style: Styles.inputStyle),
                                    border: OutlineInputBorder()),
                              ),
                              SizedBox(height: 10),
                              TextFormField(
                                keyboardType: TextInputType.visiblePassword,
                                focusNode: passwordNode,
                                onFieldSubmitted: (value) {
                                  _formKey.currentState!.validate();
                                  mailNode.nextFocus();
                                },
                                onEditingComplete: () {
                                  _formKey.currentState!.validate();
                                },
                                onSaved: (value) {
                                  _formKey.currentState!.validate();
                                },
                                validator: (value) {
                                  if (value!.length <= 5) {
                                    return "Password Must Be At Least 5 Characters Long";
                                  }
                                  return null;
                                },
                                obscureText: !visible,
                                controller: passwordController,
                                decoration: InputDecoration(
                                    label: Text("Password",
                                        style: Styles.inputStyle),
                                    border: OutlineInputBorder(),
                                    suffixIcon: IconButton(
                                      color: ColorsCustom.lightGreen,
                                      icon: Icon(visible
                                          ? Icons.visibility
                                          : Icons.visibility_off),
                                      onPressed: () {
                                        //TODO: Visibility Password
                                        ref
                                            .read(passwordVisibleProvider
                                                .notifier)
                                            .state = !visible;
                                      },
                                    )),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        if (_formKey.currentState!.validate()) {
                                          try {
                                            await AuthService.registerUser(
                                                mailController.text,
                                                passwordController.text);
                                          } on FirebaseAuthException catch (e) {
                                            await AuthService.loginUser(
                                                mailController.text,
                                                passwordController.text);
                                          }
                                          ref
                                              .read(loggedInProvider.notifier)
                                              .state = true;
                                          RouterServices.router
                                              .goNamed("recipes");
                                        }
                                      },
                                      child: Text(
                                        "Login",
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      style: ButtonStyle(
                                          minimumSize: MaterialStatePropertyAll(
                                              Size(0, 60))),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 20),
                              Text("OR",
                                  style: TextStyle(
                                      fontSize: 19,
                                      fontWeight: FontWeight.w600,
                                      color: ColorsCustom.darkGrey)),
                              SizedBox(height: 20),
                              OutlinedIconButton(
                                function: () async {
                                  final google =
                                      await AuthService.signInWithGoogle();
                                  if (google != null) {
                                    ref.read(loggedInProvider.notifier).state =
                                        true;
                                    RouterServices.router.goNamed("recipes");
                                  } else {
                                    showProblemSnackbar(
                                        "Login Unsuccessful", context);
                                  }
                                },
                                icon: FontAwesomeIcons.google,
                                color: Colors.red,
                                text: "Continue With Google",
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
      {super.key,
      required this.function,
      required this.icon,
      this.color,
      this.text,
      this.errorText,
      this.borderColor});
  final VoidCallback function;
  final IconData icon;
  final Color? color;
  final String? text;
  final String? errorText;
  final Color? borderColor;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _OutlinedIconButtonState();
}

class _OutlinedIconButtonState extends ConsumerState<OutlinedIconButton> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: widget.function,
          child: Ink(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                    color: widget.borderColor ?? Colors.grey[500]!, width: 1)),
            child: widget.text == null
                ? Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Icon(
                      widget.icon,
                      color: widget.errorText != null
                          ? ColorsCustom.error
                          : widget.color ?? Colors.grey[700]!,
                    ))
                : Padding(
                    padding: const EdgeInsets.symmetric(vertical: 1.5),
                    child: Row(
                      children: [
                        Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Icon(
                              widget.icon,
                              color: widget.color ?? Colors.grey[700]!,
                            )),
                        Text(
                          widget.text!,
                          style: TextStyle(
                              color: ColorsCustom.darkGrey,
                              fontSize: 16,
                              fontWeight: FontWeight.w500),
                        ),
                        Expanded(child: Container())
                      ],
                    ),
                  ),
          ),
        ),
        widget.errorText != null
            ? Padding(
                padding: const EdgeInsets.only(left: 12.0, top: 8),
                child: Text(
                  widget.errorText!,
                  style: TextStyle(
                    fontSize: 12,
                    color: ColorsCustom.error,
                  ),
                ),
              )
            : Container()
      ],
    );
  }
}
