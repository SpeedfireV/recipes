import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sports/constants/images.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Padding(
          padding: const EdgeInsets.only(left: 40.0, right: 40.0, top: 16.0),
          child: Column(
            children: [
              Image(width: 220, height: 220, image: AssetImage(Images.login)),
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                    label: Text(
                      "Login",
                      style:
                          TextStyle(fontSize: 19, fontWeight: FontWeight.w600),
                    ),
                    border: OutlineInputBorder()),
              ),
              SizedBox(height: 10),
              TextFormField(
                decoration: InputDecoration(
                    label: Text(
                      "Mail",
                      style:
                          TextStyle(fontSize: 19, fontWeight: FontWeight.w600),
                    ),
                    border: OutlineInputBorder()),
              ),
              SizedBox(height: 10),
              TextFormField(
                decoration: InputDecoration(
                    label: Text(
                      "Password",
                      style:
                          TextStyle(fontSize: 19, fontWeight: FontWeight.w600),
                    ),
                    border: OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.visibility),
                      onPressed: () {
                        //TODO: Visibility Password
                      },
                    )),
              ),
              Expanded(child: Container()),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        //TODO: Login Button
                      },
                      child: Text(
                        "Login",
                        style: TextStyle(
                            fontSize: 19, fontWeight: FontWeight.w600),
                      ),
                      style: ButtonStyle(
                          minimumSize: MaterialStatePropertyAll(Size(0, 60))),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              )
            ],
          ),
        ));
  }
}
