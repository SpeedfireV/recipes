import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomElevatedButton extends ConsumerStatefulWidget {
  const CustomElevatedButton(
      {super.key,
      required this.function,
      required this.text,
      this.center,
      this.icon,
      this.disabled});
  final Function function;
  final String text;
  final IconData? icon;
  final bool? center;
  final bool? disabled;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CustomElevatedButtonState();
}

class _CustomElevatedButtonState extends ConsumerState<CustomElevatedButton> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: widget.icon != null
                ? ElevatedButton.icon(
                    style: ButtonStyle(
                        shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24))),
                        alignment: widget.center == true
                            ? Alignment.center
                            : Alignment.centerLeft,
                        minimumSize:
                            const MaterialStatePropertyAll(Size(0, 60))),
                    onPressed: widget.disabled == true
                        ? null
                        : () {
                            widget.function.call();
                          },
                    icon: Padding(
                      padding: EdgeInsets.only(right: 8, left: 8),
                      child: Icon(
                        widget.icon,
                        size: 28,
                      ),
                    ),
                    label: Text(
                      widget.text,
                      style: const TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 17),
                    ),
                  )
                : ElevatedButton(
                    style: ButtonStyle(
                        shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24))),
                        alignment: widget.center == true
                            ? Alignment.center
                            : Alignment.centerLeft,
                        minimumSize:
                            const MaterialStatePropertyAll(Size(0, 60))),
                    onPressed: widget.disabled == true
                        ? null
                        : () {
                            widget.function.call();
                          },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.text,
                          style: const TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 17),
                        ),
                      ],
                    ),
                  ))
      ],
    );
  }
}
