import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:sports/constants/images.dart';
import 'package:sports/services/local_database.dart';
import 'package:sports/services/router.dart';

class EntryPage extends ConsumerStatefulWidget {
  const EntryPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EntryPageState();
}

class _EntryPageState extends ConsumerState<EntryPage> {
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Stack(
        children: [
          PageView(
            controller: pageController,
            children: [
              EntryPageButton(
                controller: pageController,
                first: true,
                image: Images.start_1,
              ),
              EntryPageButton(
                controller: pageController,
                image: Images.start_2,
                title: "To the best place for people who deserve best food...",
              ),
              EntryPageButton(
                controller: pageController,
                image: Images.start_3,
                title: "...from our best chefs!",
              ),
              EntryPageButton(
                controller: pageController,
                image: Images.start_4,
                title: "Look for a new recipe right away!",
                last: true,
              ),
            ],
          ),
          Column(
            children: [
              Expanded(child: Container()),
              SmoothPageIndicator(
                controller: pageController,
                count: 4,
                effect: WormEffect(activeDotColor: Colors.green[800]!),
              ),
              SizedBox(height: 30)
            ],
          )
        ],
      ),
    );
  }
}

class EntryPageButton extends ConsumerStatefulWidget {
  const EntryPageButton({
    super.key,
    required this.controller,
    this.first,
    this.last,
    this.title,
    this.titleStyle,
    required this.image,
  });
  final PageController controller;
  final bool? first;
  final String? title;
  final TextStyle? titleStyle;
  final String image;
  final bool? last;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EntryPageButtonState();
}

class _EntryPageButtonState extends ConsumerState<EntryPageButton> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.first != true
            ? Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 16, top: 16),
                  child: IconButton(
                      onPressed: () {
                        widget.controller.previousPage(
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeIn);
                      },
                      icon: Icon(Icons.arrow_back)),
                ),
              )
            : Container(),
        Column(
          children: [
            SizedBox(
              height: 50,
            ),
            Image(width: 220, height: 220, image: AssetImage(widget.image)),
            Expanded(child: Container()),
            widget.first == true
                ? RichText(
                    text: TextSpan(
                        children: [
                          TextSpan(text: "Welcome to "),
                          TextSpan(
                              text: "Delicious",
                              style: TextStyle(
                                  color: Colors.green[800],
                                  fontWeight: FontWeight.w900)),
                          TextSpan(text: "!")
                        ],
                        style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w700,
                            color: Colors.grey[800])),
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: Text(
                      widget.title ?? "Welcome to Delicious",
                      textAlign: TextAlign.center,
                      style: widget.titleStyle ??
                          TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w700,
                              color: Colors.grey[800]),
                    ),
                  ),
            Expanded(child: Container()),
            Row(children: [
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: ElevatedButton(
                    style: ButtonStyle(
                        minimumSize: MaterialStatePropertyAll(Size(0, 60))),
                    onPressed: () {
                      widget.last == true
                          ? {
                              DatabaseServices.addToBox().then((value) {
                                RouterServices.router.goNamed("login");
                              }),
                            }
                          : widget.controller.nextPage(
                              duration: Duration(milliseconds: 300),
                              curve: Curves.ease);
                    },
                    child: Text(
                      widget.last == true ? "Log In" : "Continue",
                      style:
                          TextStyle(fontSize: 19, fontWeight: FontWeight.w600),
                    )),
              ))
            ]),
            SizedBox(height: 10),
            widget.last == true
                ? Row(children: [
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40.0),
                      child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStatePropertyAll(Colors.grey[100]),
                              elevation: MaterialStatePropertyAll(0),
                              side: MaterialStatePropertyAll(BorderSide(
                                  color: Colors.grey[800]!, width: 2)),
                              minimumSize:
                                  MaterialStatePropertyAll(Size(0, 60))),
                          onPressed: () {
                            DatabaseServices.addToBox().then((value) {
                              RouterServices.router.goNamed("recipes");
                            });
                          },
                          child: Text(
                            "Skip",
                            style: TextStyle(
                                color: Colors.grey[800],
                                fontSize: 19,
                                fontWeight: FontWeight.w600),
                          )),
                    ))
                  ])
                : Container(),
            SizedBox(
              height: 80,
            )
          ],
        ),
      ],
    );
  }
}
