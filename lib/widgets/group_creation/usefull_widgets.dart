import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class FormCreator {
  static TextFormField getTextFormField(
      {String labelText,
      GlobalKey<FormFieldState> key,
      void Function(String) onSaved,
      String Function(String) validator,
      int maxLines = 1,
      double fontSize = 10}) {
    return TextFormField(
      key: key,
      keyboardType: TextInputType.text,
      onSaved: onSaved,
      maxLines: maxLines,
      validator: validator,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(
          decorationStyle: TextDecorationStyle.solid,
          fontSize: fontSize,
        ),
      ),
    );
  }

  static TypeAheadFormField getTypeAheadFormField(
      {GlobalKey<FormFieldState> key,
      List<String> Function(String) suggestionCallBack,
      void Function(dynamic) onSuggestionSelected,
      String Function(String) validator,
      void Function(String) onSaved,
      TextEditingController controller,
      String labelText}) {
    return TypeAheadFormField(
      key: key,
      suggestionsCallback: suggestionCallBack,
      itemBuilder: (context, suggestion) => ListTile(
        title: Text(suggestion),
      ),
      transitionBuilder: (context, suggestionBox, controller) => suggestionBox,
      onSuggestionSelected: onSuggestionSelected,
      validator: validator,
      onSaved: onSaved,
      textFieldConfiguration: TextFieldConfiguration(
          autofocus: true,
          controller: controller,
          decoration: InputDecoration(labelText: labelText)),
    );
  }
}

class IconTextButton extends StatelessWidget {
  final Color color;
  final Color textColor;
  final IconData icon;
  final String text;
  final EdgeInsetsGeometry padding;
  final void Function() onPressed;

  IconTextButton(
      {this.color,
      this.padding,
      this.textColor = Colors.white,
      @required this.icon,
      @required this.text,
      @required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
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

class UserListTile extends StatelessWidget {
  final String name;
  final Widget trailing;
  final Image image;

  UserListTile({@required this.name, this.image, this.trailing});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: image ?? Icon(Icons.person_pin, size: 40.0),
      title: Container(
        alignment: Alignment.center,
        child: Text(
          name,
          style: TextStyle(fontWeight: FontWeight.w400),
        ),
      ),
      trailing: trailing,
    );
  }
}
