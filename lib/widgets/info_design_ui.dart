import 'package:flutter/material.dart';
class InfoDesignUIWidget extends StatefulWidget {

  String? textInfo;
  IconData? iconData;

  InfoDesignUIWidget({
    this.textInfo,
    this.iconData
  });

  @override
  State<InfoDesignUIWidget> createState() => _InfoDesignUIWidgetState();
}

class _InfoDesignUIWidgetState extends State<InfoDesignUIWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
        color: Color(0xFFff725e),
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
      child: ListTile(
        leading: Icon(
          widget.iconData,
          color: Colors.white,
        ),
        title: Text(
          widget.textInfo!,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: "Ubuntu",
            fontSize: 16,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
