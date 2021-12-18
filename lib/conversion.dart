import 'package:auto_size_text/auto_size_text.dart';
import 'package:calculator_desktop/main.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() => runApp(Conversion());

class Conversion extends StatefulWidget {
  @override
  _ConversionState createState() => _ConversionState();
}

class _ConversionState extends State<Conversion> {


  String _startMeasure;
  String _convertedMeasure;
  double _numberForm;
  String _resultMessage;

  void initState() {
    _numberForm = 0;
    super.initState();
  }

  final List<String> _measures = [
    'METERS',
    'KILOMETERS',
    'GRAMS',
    'KILOGRAMS',
    'FEET',
    'MILES',
    'POUNDS (LBS)',
    'OUNCES',
  ];
  final Map<String, int> _measuresMap = {
    'METERS': 0,
    'KILOMETERS': 1,
    'GRAMS': 2,
    'KILOGRAMS': 3,
    'FEET': 4,
    'MILES': 5,
    'POUNDS (LBS)': 6,
    'OUNCES': 7,
  };

  dynamic _formulas = {
    '0': [1, 0.001, 0, 0, 3.28084, 0.000621371, 0, 0],
    '1': [1000, 1, 0, 0, 3280.84, 0.621371, 0, 0],
    '2': [0, 0, 1, 0.0001, 0, 0, 0.00220462, 0.035274],
    '3': [0, 0, 1000, 1, 0, 0, 2.20462, 35.274],
    '4': [0.3048, 0.0003048, 0, 0, 1, 0.000189394, 0, 0],
    '5': [1609.34, 1.60934, 0, 0, 5280, 1, 0, 0],
    '6': [0, 0, 453.592, 0.453592, 0, 0, 1, 16],
    '7': [0, 0, 28.3495, 0.0283495, 3.28084, 0, 0.0625, 1],
  };


  void convert(double value, String from, String to) {
    int nFrom = _measuresMap[from];
    int nTo = _measuresMap[to];
    var multiplier = _formulas[nFrom.toString()][nTo];
    var result = value * multiplier;
    if (result == 0) {
      _resultMessage = 'This conversion cannot be performed';
    } else {
      setState(() {
        _resultMessage =
        '${result.toString()}';
      });
    }
    // setState(() {
    //   '${result.toString()}' = _resultMessage;
    // });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Measures Converter',
      home: Scaffold(
        backgroundColor: backgroundColor,
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: Text(
              'Measures Converter',
              style: GoogleFonts.montserrat(
                  textStyle: TextStyle(
                      fontWeight: FontWeight.bold
                  )
              )
          ),
          leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: () {Navigator.pop(context);},),
        ),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(50.0),
                child: SizedBox(
                  height: 150,
                  width: 150,
                  child: Image.asset('assets/exchange.png'),
                ),
              ),
              Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: DropdownButton(
                      hint: Text(
                        "SELECT",
                          style: GoogleFonts.montserrat(
                              textStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                   color: buttonColor
                              )
                          )
                      ),
                      items: _measures.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                              value,
                              style: GoogleFonts.montserrat(
                                  textStyle: TextStyle(
                                      fontWeight: FontWeight.bold,
                                  )
                              )
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _startMeasure = value;
                        });
                      },
                      value: _startMeasure,
                    ),
                  ),
                  Flexible(
                    child: TextField(
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      style: GoogleFonts.montserrat(
                          textStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                            color:  buttonColor
                          )
                      ),
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                      ),
                      onChanged: (text) {
                        var rv = double.tryParse(text);
                        if (rv != null) {
                          setState(() {
                            _numberForm = rv;
                          });
                        }

                      if (_startMeasure.isEmpty ||
                        _convertedMeasure.isEmpty ||
                        _numberForm == 0) {
                          return;
                      } else {
                          convert(_numberForm, _startMeasure, _convertedMeasure);
                      }

                      },
                    ),
                  ),
                ],
              ),
              Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  DropdownButton(
                    hint: Text(
                      "SELECT",
                        style: GoogleFonts.montserrat(
                            textStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: buttonColor
                            )
                        )
                    ),
                    items: _measures.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                            style: GoogleFonts.montserrat(
                                textStyle: TextStyle(
                                    fontWeight: FontWeight.bold
                                )
                            )
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _convertedMeasure = value;
                      });
                    },
                    value: _convertedMeasure,
                  ),
                  SizedBox(
                    width: (MediaQuery.of(context).size.width/2)-20,
                    height: 60,
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.blue, width: 2),
                          borderRadius: BorderRadius.circular(4)
                      ),
                      child: Align(
                        alignment: Alignment.center,
                        child: AutoSizeText(
                            (_resultMessage == null) ? '' : _resultMessage,
                            style: GoogleFonts.montserrat(
                              textStyle: TextStyle(
                                  color: buttonColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 23
                              ),
                            ),
                          maxLines: 1,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Spacer(
                flex: 1,
              ),
              Spacer(
                flex: 8,
              ),
            ],
          ),
        ),
      ),
    );
  }
}