import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:test1/util.dart';



typedef LightsSelectedCallback = void Function(List<bool>);

class LightCheckboxDialog extends StatefulWidget {
  final List<bool> initialLights;
  final LightsSelectedCallback onLightsSelected;

  LightCheckboxDialog({required this.initialLights, required this.onLightsSelected});

  @override
  _LightCheckboxDialogState createState() => _LightCheckboxDialogState();
}

class _LightCheckboxDialogState extends State<LightCheckboxDialog> {
  late List<bool> _lights;

  @override
  void initState() {
    super.initState();
    _lights = List<bool>.from(widget.initialLights);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,

      title: Text('Select Lights'),
      content: SingleChildScrollView(
        child: ListBody(
          children: List<Widget>.generate(lightsCount, (index) {
            return CheckboxListTile(
              activeColor: Colors.black,
              title: Text('Light ${index + 1}'),
              value: _lights[index],
              onChanged: (bool? value) {
                setState(() {
                  _lights[index] = value ?? false;
                });
              },
            );
          }),
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel',style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: Color.fromRGBO(0, 0, 0, 1),

          )),
        ),
        TextButton(
          onPressed: () {
            widget.onLightsSelected(_lights);
            Navigator.of(context).pop();
          },
          child: Text('OK', style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: Color.fromRGBO(0, 0, 0, 1),

          )),
        ),
      ],
    );
  }
}
