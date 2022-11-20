import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoadMoreButton extends StatelessWidget {
  VoidCallback onPressed;

  LoadMoreButton(this.onPressed);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: Text(
        "Load more",
        style: TextStyle(color: Colors.blue),
      ),
      onPressed: onPressed,
    );
  }
}
