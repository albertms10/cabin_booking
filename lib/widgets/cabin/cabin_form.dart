import 'package:cabin_booking/model/cabin.dart';
import 'package:cabin_booking/widgets/cabin/cabin_icon.dart';
import 'package:cabin_booking/widgets/layout/submit_button.dart';
import 'package:flutter/material.dart';

class CabinForm extends StatefulWidget {
  final Cabin cabin;
  final int newCabinNumber;

  const CabinForm({
    this.cabin,
    this.newCabinNumber,
  });

  @override
  _CabinFormState createState() => _CabinFormState();
}

class _CabinFormState extends State<CabinForm> {
  final _formKey = GlobalKey<FormState>();

  Cabin _cabin;

  @override
  void initState() {
    super.initState();

    _cabin = widget.cabin..number = widget.newCabinNumber;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          CabinIcon(number: _cabin.number),
          DataTable(
            columns: const [
              DataColumn(
                label: Text('Element'),
              ),
              DataColumn(
                label: Text('Quantity'),
                numeric: true,
              ),
            ],
            rows: [
              DataRow(
                cells: [
                  DataCell(
                    const Text('Pianos'),
                    onTap: () {},
                    showEditIcon: true,
                  ),
                  DataCell(
                    const Text('1'),
                    onTap: () {},
                    showEditIcon: true,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 32.0),
          SubmitButton(
            shouldAdd: widget.newCabinNumber != null,
            onPressed: () {
              if (_formKey.currentState.validate()) {
                _formKey.currentState.save();

                Navigator.of(context).pop<Cabin>(_cabin);
              }
            },
          ),
        ],
      ),
    );
  }
}
