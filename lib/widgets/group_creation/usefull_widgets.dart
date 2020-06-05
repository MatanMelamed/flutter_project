import 'package:flutter/material.dart';

class IconTextButton extends StatelessWidget {
  final Color color;
  final Color textColor;
  final IconData icon;
  final String text;
  final EdgeInsetsGeometry padding;
  final BorderRadius radius;
  final void Function() onPressed;

  IconTextButton(
      {this.color,
      this.padding,
      this.textColor = Colors.white,
      this.radius = BorderRadius.zero,
      @required this.icon,
      @required this.text,
      @required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      shape: RoundedRectangleBorder(
          borderRadius: radius, side: BorderSide(color: color)),
      padding: padding,
      color: color ?? Theme.of(context).primaryColor,
      textColor: textColor,
      child: Column(
        children: <Widget>[
          Icon(icon),
          Text(text),
        ],
      ),
      onPressed: onPressed,
    );
  }
}

class TextSwitch extends StatelessWidget {
  final String text;
  final bool switchValue;
  final void Function(bool) onChanged;

  TextSwitch(
      {@required this.text,
      @required this.switchValue,
      @required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(child: Text(text)),
        Switch(
          value: switchValue,
          onChanged: onChanged,
        )
      ],
    );
  }
}

class SuggestionTile extends StatelessWidget {
  final NetworkImage image;
  final String title;
  final Widget trailing;

  SuggestionTile({this.image, this.title, this.trailing});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: image != null
          ? CircleAvatar(
              backgroundImage: image,
            )
          : Icon(Icons.person_pin),
      title: Text(title ?? ""),
      trailing: trailing,
    );
  }
}
