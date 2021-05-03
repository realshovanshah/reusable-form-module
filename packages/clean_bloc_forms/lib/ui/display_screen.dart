// import 'package:horizontal_data_table/horizontal_data_table.dart'; error importing
import 'package:clean_bloc_forms/bloc/form_bloc.dart';
import 'package:clean_bloc_forms/bloc/table_bloc.dart';
import 'package:clean_bloc_forms/clean_forms.dart';
import 'package:clean_bloc_forms/constants/enums.dart';
import 'package:clean_bloc_forms/models/local/form_model.dart';
import 'package:clean_bloc_forms/ui/form_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DisplayScreen extends StatefulWidget {
  const DisplayScreen({Key? key}) : super(key: key);

  @override
  _DisplayScreenState createState() => _DisplayScreenState();
}

class _DisplayScreenState extends State<DisplayScreen> {
  late final _bloc;
  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of<TableBloc>(context);
    _bloc.add(TableRequestedEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Your forms.",
          style: TextStyle(
            color: Colors.black,
            fontSize: 32,
          ),
        ),
        SizedBox(height: 40),
        Center(
          child: BlocBuilder<TableBloc, TableState>(
            builder: (context, state) {
              if (state is TableInitialState) {
                _bloc.add(TableRequestedEvent());
                return CircularProgressIndicator();
              }
              if (state is TableLoadingSuccessState) {
                return (state.forms.isNotEmpty)
                    ? SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        physics: BouncingScrollPhysics(),
                        child: DataTable(
                          showCheckboxColumn: false,
                          headingRowColor:
                              MaterialStateProperty.resolveWith<Color>(
                                  (Set<MaterialState> states) {
                            if (states.contains(MaterialState.pressed))
                              return Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withOpacity(0.08);
                            return Theme.of(context)
                                .accentColor; // Use the default value.
                          }),
                          rows: _buildTableRow(state.forms, context),
                          columns: _buildTableHeader(_columnHeadings),
                        ),
                      )
                    : Text('No forms found. Add them first!');
              } else {
                return CircularProgressIndicator();
              }
            },
          ),
        ),
        SizedBox(height: 50),
      ],
    );
  }

  final _columnHeadings = [
    'Venue',
    'File Url',
    'Status',
    'Screen Type',
    'Form Type',
    'Created At',
    'Updated At'
  ];

  List<DataColumn> _buildTableHeader(List<String> columnHeading) =>
      columnHeading
          .map((column) => DataColumn(
                label: Text(
                  column,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ))
          .toList();

  List<DataRow> _buildTableRow(List<FormModel> forms, context) =>
      forms.map((FormModel formModel) {
        final cells = [
          formModel.venue,
          formModel.fileUrl.substring(69, 80),
          (formModel.availableStatus) ? 'Available' : 'Booked',
          ScreenType.values[formModel.screenType].getEnumValue(),
          FormType.values[formModel.formType].getEnumValue(),
          formModel.createdAt.toDate(),
          formModel.updatedAt.toDate()
        ];
        return DataRow(
          onSelectChanged: (value) {
            showModalBottomSheet(
              backgroundColor: Colors.transparent,
              enableDrag: true,
              isScrollControlled: false,
              context: context,
              builder: (context) => Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColorLight,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 8.0, right: 8.0, top: 16),
                        child: ListTile(
                          leading: Icon(Icons.update),
                          title: Text('Update'),
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) {
                                return BlocProvider<TableBloc>.value(
                                  value: _bloc,
                                  child: BlocProvider.value(
                                      value: FormBloc(),
                                      child: FormScreen(
                                        formModel: formModel,
                                        title: 'Update form',
                                      )),
                                );
                              },
                            )).then((value) => Navigator.pop(context));
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 16),
                        child: ListTile(
                          leading: Icon(Icons.delete),
                          title: Text('Remove'),
                          onTap: () {
                            _bloc.add(TableDeletedEvent(
                                formModel.docId!, formModel.venue));
                            // _bloc.add(TableRq());
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ],
                  )),
            );
          },
          cells: _buildTableCells(cells),
          selected: true,
        );
      }).toList();

  List<DataCell> _buildTableCells(List<dynamic> cells) =>
      cells.map((cell) => DataCell(Center(child: Text('$cell')))).toList();
}
