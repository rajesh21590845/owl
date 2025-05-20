import 'package:flutter/material.dart';

class AnimatedSwitch extends StatefulWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
const AnimatedSwitch({
  Key? key,
  required this.value,
  required this.onChanged,
}) : super(key: key);

  @override
  State<AnimatedSwitch> createState() => _AnimatedSwitchState();
}

class _AnimatedSwitchState extends State<AnimatedSwitch>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Switch(
      activeColor: Colors.deepPurpleAccent,
      value: widget.value,
      onChanged: widget.onChanged,
    );
  }
}
