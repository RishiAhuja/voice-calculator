import 'dart:async';
import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:calculator_desktop/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

void main() => runApp(new MaterialApp(
  title: "Currency Converter",
  home: CurrencyConverter(),
));

class CurrencyConverter extends StatefulWidget {
  @override
  _CurrencyConverterState createState() => _CurrencyConverterState();
}

class _CurrencyConverterState extends State<CurrencyConverter> {
  final fromTextController = TextEditingController();
  List<String> currencies;
  String fromCurrency = "USD";
  String toCurrency = "INR";
  String result;

  @override
  void initState() {
    super.initState();
    _loadCurrencies();
  }

  Future<String> _loadCurrencies() async {
    String uri = "https://api.exchangeratesapi.io/latest";
    var response = await http
        .get(Uri.encodeFull(uri), headers: {"Accept": "application/json"});
    var responseBody = json.decode(response.body);
    Map curMap = responseBody['rates'];
    currencies = curMap.keys.toList();
    setState(() {});
    print(currencies);
    return "Success";
  }

  Future<String> _doConversion() async {
    String uri = "https://api.exchangeratesapi.io/latest?base=$fromCurrency&symbols=$toCurrency";
    var response = await http
        .get(Uri.encodeFull(uri), headers: {"Accept": "application/json"});
    var responseBody = json.decode(response.body);
    setState(() {
      result = (double.parse(fromTextController.text) * (responseBody["rates"][toCurrency])).toString();
    });
    print(result);
    return "Success";
  }

  _onFromChanged(String value) {
    setState(() {
      fromCurrency = value;
      print(value);
    });
  }

  _onToChanged(String value) {
    setState(() {
      toCurrency = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        elevation: 0,
        title: Text(
            "Currency Converter",
          style: GoogleFonts.montserrat(
            textStyle: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold
            )
          ),
        ),
      iconTheme: IconThemeData( color: Colors.white),
      ),
      body: currencies == null
          ? Center(child: CircularProgressIndicator())
          : ListView(
            children: [
              Container(
        child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                color: backgroundColor,
                elevation: 3.0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(50.0),
                      child: SizedBox(
                        height: 150,
                        width: 150,
                        child: Image.asset('assets/money.png'),
                      ),
                    ),
                    ListTile(
                      title: TextField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder()
                        ),
                        onChanged: (val){
                          setState(() async{
                            result = val;
                              String uri = "https://api.exchangeratesapi.io/latest?base=$fromCurrency&symbols=$toCurrency";
                              var response = await http
                                  .get(Uri.encodeFull(uri), headers: {"Accept": "application/json"});
                              var responseBody = json.decode(response.body);
                              setState(() {
                                result = (double.parse(fromTextController.text) * (responseBody["rates"][toCurrency])).toStringAsFixed(2);
                              });
                            print(result);
                          });

                          print(val);
                        },
                        controller: fromTextController,
                        style: GoogleFonts.montserrat(
                          textStyle: TextStyle(fontSize: 20.0, color: buttonColor),
                        ),
                        keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                      ),
                      trailing: _buildDropDownButton(fromCurrency),
                    ),
                    SizedBox(height: 20),
                    ListTile(
                      title: Container(
                        height: 60,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.indigo, width: 2),
                          borderRadius: BorderRadius.circular(4)
                        ),
                        child: result != null ? Align(
                            child: AutoSizeText(result,
                              style: GoogleFonts.montserrat(
                                textStyle: TextStyle(
                                  fontSize: 30,
                                  color: buttonColor
                                )
                              ),
                              maxLines: 1,
                            ),
                          alignment: Alignment.center,
                        )
                            :
                        Text(''),
                      ),
                      trailing: _buildDropDownButton(toCurrency),
                    ),
                    // ListTile(
                    //   title: Chip(
                    //     label: result != null ?
                    //     Text(
                    //       result,
                    //       style: Theme.of(context).textTheme.display1,
                    //     ) : Text('')
                    //   ),
                    //   trailing: _buildDropDownButton(toCurrency),
                    // ),
                    SizedBox(height: 50,)
                  ],
                ),
              ),
        ),
      ),

            ],
          ),
    );
  }

  Widget _buildDropDownButton(String currencyCategory) {
    return DropdownButton(
      dropdownColor: buttonColor,
      value: currencyCategory,
      items: currencies
          .map((String value) => DropdownMenuItem(
        value: value,
        child: Row(
          children: <Widget>[
            Text(value,
              style: GoogleFonts.montserrat(
                textStyle: TextStyle(
                  fontWeight: FontWeight.bold
                )
              ),
            ),
          ],
        ),
      ))
          .toList(),
      onChanged: (String value) {
        if(currencyCategory == fromCurrency){
          _onFromChanged(value);
        }else {
          _onToChanged(value);
        }
      },
    );
  }
}