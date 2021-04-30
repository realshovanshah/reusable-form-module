import 'package:clean_forms/constants/enums.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        body: FormScreen(),
      ),
    );
  }
}

class FormScreen extends StatefulWidget {
  FormScreen({Key? key}) : super(key: key);

  @override
  _FormScreenState createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    final screenOptions = ['Customer', 'Venue'];

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: FormBuilder(
        key: _formKey,
        autovalidateMode: AutovalidateMode.disabled,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Text(
                "Upload to cloud.",
                style: TextStyle(color: Colors.black87, fontSize: 30),
              ),
            ),
            SizedBox(height: 20),
            FormBuilderTextField(
              name: 'venue',
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                labelText: 'Venue',
              ),
              // onChanged: (value) {},
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(context),
                FormBuilderValidators.max(context, 20),
              ]),
              keyboardType: TextInputType.name,
            ),
            FormBuilderChoiceChip(
              name: 'status_choice',
              decoration: InputDecoration(
                border: InputBorder.none,
                labelText: 'Booking Status',
              ),
              options: [
                FormBuilderFieldOption(
                  value: 'booked',
                  child: Text('Booked'),
                ),
                FormBuilderFieldOption(
                  value: 'available',
                  child: Text('Available'),
                ),
              ],
              spacing: 8,
            ),
            FormBuilderDropdown(
                name: 'screen_type',
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  labelText: 'Screen Type',
                ),
                allowClear: true,
                hint: Text('Screen Type'),
                validator: FormBuilderValidators.compose(
                    [FormBuilderValidators.required(context)]),
                items: (ScreenType.values)
                    .map((screenOption) => DropdownMenuItem(
                          value: screenOption,
                          child: Text('${screenOption.getEnumValue()}'),
                        ))
                    .toList()),
            SizedBox(height: 20),
            Container(
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
                border: Border(
                  bottom: BorderSide(width: 1, color: Colors.grey),
                  top: BorderSide(width: 1, color: Colors.grey),
                  left: BorderSide(width: 1, color: Colors.grey),
                  right: BorderSide(width: 1, color: Colors.grey),
                ),
              ),
              padding: EdgeInsets.all(16),
              child: Center(
                child: Text("Click here to select a file."),
              ),
            ),
            SizedBox(height: 20),
            Row(
              children: <Widget>[
                Expanded(
                  child: CupertinoButton(
                    color: Theme.of(context).accentColor,
                    child: Text(
                      "Reset",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      _formKey.currentState?.reset();
                    },
                  ),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: CupertinoButton(
                    color: Theme.of(context).accentColor,
                    child: Text(
                      "Done",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      _formKey.currentState?.save();
                      if (_formKey.currentState?.validate() == true) {
                        print(_formKey.currentState?.value);
                      } else {
                        print("validation failed");
                      }
                    },
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
