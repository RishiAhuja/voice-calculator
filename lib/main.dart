import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:desktop_window/desktop_window.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer_util.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:google_fonts/google_fonts.dart';
import '../conversion.dart';
import '../currency.dart';
import 'help.dart';
import 'percentage.dart';
import '../discount.dart';

bool globalThemeState = true;

Color multiThemeColor = Colors.indigo;

Color themeColor = Colors.indigo;

Color backgroundColor = Colors.grey[200];

Color buttonColor = Colors.black;

Color equalButton = Colors.indigo;

Color buttonBack = Colors.white;

Color equalToButton = Colors.indigo;

Color extraButton = Colors.indigo;

Color backToggleColor = Colors.indigo;

Color backToggleColor2 = Colors.grey.shade200;

Color iconColor = Colors.white;

bool themeChoice;

double _windowWidth;

double _windowHeight;

List<LogicalKeyboardKey> key = [];

final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
void main() async{
  runApp(Calculator());

}

class Calculator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      //return LayoutBuilder
      builder: (context, constraints) {
        return OrientationBuilder(
          //return OrientationBuilder
          builder: (context, orientation) {
            //initialize SizerUtil()
            SizerUtil().init(constraints, orientation); //initialize SizerUtil
            return MaterialApp(
              theme: ThemeData(
                primarySwatch: Colors.indigo,
              ),
              debugShowCheckedModeBanner: false,
              home: Home()
            );
          },
        );
      },
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

Color text;
String equation = '0';
String expression = '';
bool isSwitched = false;
stt.SpeechToText _speech;
bool _isListening = false;
String _text = 'Press the button and start speaking';
String _result;

class _HomeState extends State<Home> {
  @override
  void initState() {
    themeChoice = true;
    super.initState();
    getBoolValuesSF();
    _getWindowSize();
    _speech = stt.SpeechToText();
  }

  Future _getWindowSize() async {
    await DesktopWindow.setWindowSize(
        Size(360, 690));
    var size = await DesktopWindow.getWindowSize();
    await DesktopWindow.setMinWindowSize(Size(330, 690));
    setState(() {
      print('${size.width} x ${size.height}');
      _windowHeight = size.height;
      _windowWidth = size.width;
    });
  }

  buttonPressed(String buttonText) {
    setState(() {
      if (buttonText == 'C') {
        equation = '0';
      } else if (buttonText == '⌫') {
        equation = equation.substring(0, equation.length - 1);
        if (equation == '') {
          equation = '0';
        }
      } else if (buttonText == '=') {
        expression = equation;
        expression = expression.replaceAll('×', '*');
        expression = expression.replaceAll('÷', '/');
        expression = expression.replaceAll('√', 'sqrt');
        expression = expression.replaceAll('X', '*');
        print("Null");

        try {
          Parser p = new Parser();
          Expression exp = p.parse(expression);

          ContextModel cm = ContextModel();
          equation = '${exp.evaluate(EvaluationType.REAL, cm)}';
        } catch (e) {
          equation = 'Error';
        }
      } else {
        if (equation == '0') {
          equation = buttonText;
        } else {
          equation = equation + buttonText;
        }
      }
    });
  }

  Widget buildButton(String buttonText, Color buttonColor, double _flex,
      int _flexit, Color textColor) {
    setState(() {
      text = textColor;
    });
    if (SizerUtil.orientation == Orientation.portrait) {
      return Expanded(
        flex: _flexit,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
          child: RaisedButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            elevation: 5,
            color: buttonColor,
            onPressed: () => buttonPressed(buttonText),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 5),
              child: Text(
                buttonText,
                style: GoogleFonts.montserrat(
                    textStyle: TextStyle(
                        color: textColor,
                        // fontWeight: FontWeight.bold,
                        fontSize: _flex)),
              ),
            ),
          ),
        ),
      );
    } else {
      return SizedBox(
        width: MediaQuery.of(context).size.width / 4,
        height: MediaQuery.of(context).size.height / 10,
        child: Container(
          child: RaisedButton(
            elevation: 5,
            color: buttonColor,
            onPressed: () => buttonPressed(buttonText),
            child: Text(
              buttonText,
              style: GoogleFonts.montserrat(
                  textStyle: TextStyle(
                fontSize: 25,
                color: textColor,
                // fontWeight: FontWeight.bold
              )),
            ),
          ),
        ),
      );
    }
  }

  Widget extraBuild() {
    if (SizerUtil.orientation == Orientation.portrait) {
      return Row(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: FlatButton(
              onPressed: () {
                setState(() {
                  if (equation == '0') {
                    equation = '√';
                  } else {
                    equation = equation + '√';
                  }
                });
              },
              child: Text(
                '√',
                style: TextStyle(fontSize: 45, color: extraButton),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Align(
              alignment: Alignment.centerLeft,
              child: FlatButton(
                onPressed: () {
                  setState(() {
                    if (equation == '0') {
                      equation = '^';
                    } else {
                      equation = equation + '^';
                    }
                  });
                },
                child: Text(
                  '^',
                  style: TextStyle(fontSize: 45, color: extraButton),
                ),
              ),
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width - 240,
          ),
          GestureDetector(
            onLongPress: () {
              setState(() {
                equation = "0";
              });
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        equation = equation.substring(0, equation.length - 1);
                        if (equation == '') {
                          equation = '0';
                        }
                      });
                    },
                    icon: Icon(
                      Icons.backspace,
                      color: extraButton,
                    ),
                    iconSize: 30,
                  )),
            ),
          ),
        ],
      );
    } else {
      return Row(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: FlatButton(
              onPressed: () {
                setState(() {
                  if (equation == '0') {
                    equation = '√';
                  } else {
                    equation = equation + '√';
                  }
                });
              },
              child: Text(
                '√',
                style: TextStyle(fontSize: 25, color: extraButton),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Align(
              alignment: Alignment.centerLeft,
              child: FlatButton(
                onPressed: () {
                  setState(() {
                    if (equation == '0') {
                      equation = '^';
                    } else {
                      equation = equation + '^';
                    }
                  });
                },
                child: Text(
                  '^',
                  style: TextStyle(fontSize: 25, color: extraButton),
                ),
              ),
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width - 240,
          ),
          GestureDetector(
            onLongPress: () {
              setState(() {
                equation = "0";
              });
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        equation = equation.substring(0, equation.length - 1);
                        if (equation == '') {
                          equation = '0';
                        }
                      });
                    },
                    icon: Icon(
                      Icons.backspace,
                      color: extraButton,
                    ),
                    iconSize: 20,
                  )),
            ),
          ),
        ],
      );
    }
  }

  Widget lastBuild() {
    if (SizerUtil.orientation == Orientation.portrait) {
      return Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              children: <Widget>[
                buildButton('C', buttonBack, 30, 1, equalButton),
                buildButton('(', buttonBack, 30, 1, equalButton),
                buildButton(')', buttonBack, 30, 1, equalButton),
                buildButton('÷', buttonBack, 30, 1, equalButton),
              ],
            ),
            Row(
              children: <Widget>[
                buildButton('7', buttonBack, 30, 1, buttonColor),
                buildButton('8', buttonBack, 30, 1, buttonColor),
                buildButton('9', buttonBack, 30, 1, buttonColor),
                buildButton('×', buttonBack, 30, 1, equalButton),
              ],
            ),
            Row(
              children: <Widget>[
                buildButton('4', buttonBack, 30, 1, buttonColor),
                buildButton('5', buttonBack, 30, 1, buttonColor),
                buildButton('6', buttonBack, 30, 1, buttonColor),
                buildButton('+', buttonBack, 30, 1, equalButton),
              ],
            ),
            Row(
              children: <Widget>[
                buildButton('1', buttonBack, 30, 1, buttonColor),
                buildButton('2', buttonBack, 30, 1, buttonColor),
                buildButton('3', buttonBack, 30, 1, buttonColor),
                buildButton('-', buttonBack, 30, 1, equalButton),
              ],
            ),
            Row(
              children: <Widget>[
                buildButton('0', buttonBack, 30, 1, buttonColor),
                buildButton('00', buttonBack, 26, 1, buttonColor),
                buildButton('.', buttonBack, 30, 1, buttonColor),
                buildButton('=', equalToButton, 30, 1, Colors.white),
              ],
            ),
          ],
        ),
      );
    } else {
      return Container(
        height: MediaQuery.of(context).size.height / 2,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              children: <Widget>[
                buildButton('C', buttonBack, 20, 1, equalButton),
                buildButton('(', buttonBack, 18, 1, equalButton),
                buildButton(')', buttonBack, 20, 1, equalButton),
                buildButton('÷', buttonBack, 20, 1, equalButton),
              ],
            ),
            Row(
              children: <Widget>[
                buildButton('7', buttonBack, 20, 1, buttonColor),
                buildButton('8', buttonBack, 20, 1, buttonColor),
                buildButton('9', buttonBack, 20, 1, buttonColor),
                buildButton('×', buttonBack, 20, 1, equalButton),
              ],
            ),
            Row(
              children: <Widget>[
                buildButton('4', buttonBack, 20, 1, buttonColor),
                buildButton('5', buttonBack, 20, 1, buttonColor),
                buildButton('6', buttonBack, 20, 1, buttonColor),
                buildButton('+', buttonBack, 20, 1, equalButton),
              ],
            ),
            Row(
              children: <Widget>[
                buildButton('1', buttonBack, 20, 1, buttonColor),
                buildButton('2', buttonBack, 20, 1, buttonColor),
                buildButton('3', buttonBack, 20, 1, buttonColor),
                buildButton('-', buttonBack, 20, 1, equalButton),
              ],
            ),
            Row(
              children: <Widget>[
                buildButton('0', buttonBack, 20, 1, buttonColor),
                buildButton('00', buttonBack, 20, 1, buttonColor),
                buildButton('.', buttonBack, 20, 1, buttonColor),
                buildButton('=', equalToButton, 20, 1, Colors.white),
              ],
            ),
          ],
        ),
      );
    }
  }

  Widget buildText() {
    if (SizerUtil.orientation == Orientation.portrait) {
      return GestureDetector(
        onLongPress: () {
          Clipboard.setData(new ClipboardData(text: equation));
          _scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text('Copied to clipboard'),
            duration: Duration(seconds: 2),
          ));
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
          child: Align(
            alignment: Alignment.centerRight,
            child: AutoSizeText('$equation',
                maxLines: 1,
                minFontSize: 7,
                overflowReplacement: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(
                      Icons.warning_amber_outlined,
                      color: Colors.redAccent,
                      size: 30,
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Maximum Characters Reached',
                      style: TextStyle(color: Colors.redAccent, fontSize: 15),
                    ),
                  ],
                ),
                style: GoogleFonts.montserrat(
                    textStyle: TextStyle(fontSize: 85, color: extraButton))),
          ),
        ),
      );
    } else {
      return Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.0),
          child: Align(
            alignment: Alignment.centerRight,
            child: AutoSizeText('$equation',
                maxLines: 1,
                minFontSize: 7,
                overflowReplacement: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(
                      Icons.warning_amber_outlined,
                      color: Colors.redAccent,
                      size: 30,
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Maximum Characters Reached',
                      style: TextStyle(color: Colors.redAccent, fontSize: 15),
                    ),
                  ],
                ),
                style: GoogleFonts.montserrat(
                    textStyle: TextStyle(fontSize: 35, color: extraButton))),
          ),
        ),
      );
    }
  }

  Widget appBar() {
    if (SizerUtil.orientation == Orientation.portrait) {
      return AppBar(
        centerTitle: true,
        title:
        Container(
          height: 40,
          decoration: BoxDecoration(
              border: Border.all(color: themeColor),
              borderRadius: BorderRadius.circular(15)),
          child: Wrap(
            children: [
              Container(
                  height: 38,
                  width: 40,
                  decoration: BoxDecoration(
                      color: backToggleColor,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          bottomLeft: Radius.circular(15))),
                  child: IconButton(
                      icon: Icon(
                        Icons.wb_sunny,
                        color: iconColor,
                      ),
                      onPressed: addBoolToSF2)),
              Container(
                  height: 38,
                  width: 1,
                  child: VerticalDivider(thickness: 1.4, color: themeColor)),
              Container(
                height: 38,
                width: 40,
                decoration: BoxDecoration(
                  color: backToggleColor2,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(15),
                      bottomRight: Radius.circular(15)),
                ),
                child: IconButton(
                    icon: Icon(
                      Icons.nightlight_round,
                      color: themeColor,
                    ),
                    onPressed: addBoolToSF),
              )
            ],
          ),
        ),
        titleSpacing: 2,
        elevation: 0.0,
        backgroundColor: backgroundColor,
        iconTheme: new IconThemeData(color: themeColor),

      );
    } else {
      return PreferredSize(
        preferredSize: Size.fromHeight(30.0),
        child: AppBar(
          elevation: 0.0,
          backgroundColor: backgroundColor,
          iconTheme: new IconThemeData(color: themeColor),
          // actions: <Widget>[
          //   Padding(
          //     padding: const EdgeInsets.symmetric(horizontal: 6),
          //     child: IconButton(
          //       icon: Icon(
          //         _isListening ? Icons.mic : Icons.mic_none,
          //         color: themeColor,
          //         size: 25,
          //       ),
          //       onPressed: () {
          //         _listen();
          //       },
          //     ),
          //   )
          // ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      autofocus: true,
      focusNode: FocusNode(),
      onKey: (event){
        setState(() {
          // if(event is RawKeyDownEvent){
            // if(event.logicalKey.toString().contains('Shift Right') && event.logicalKey.toString().contains('*')){
              key.add(event.logicalKey);
              // print(key);
            // }
          // }else{
          //   key.remove(event.logicalKey);
          //   key.clear();
          // }


        });



        if(equation == "0"){
          if(event.isKeyPressed(LogicalKeyboardKey.digit0)){
            setState(() {
              equation = "0";
              print(equation);
              print('0 pressed');
            });
          } if(event.isKeyPressed(LogicalKeyboardKey.digit1)){
            setState(() {
              equation = "1";
              print(equation);
              print('1 pressed');
            });
          } if(event.isKeyPressed(LogicalKeyboardKey.digit2)){
            setState(() {
              equation = "2";
              print(equation);
              print('2 pressed');
            });
          } if(event.isKeyPressed(LogicalKeyboardKey.digit3)){
            setState(() {
              equation = "3";
              print(equation);
              print('3 pressed');
            });
          }if(event.isKeyPressed(LogicalKeyboardKey.digit4)){
            setState(() {
              equation = "4";
              print(equation);
              print('4 pressed');
            });
          }if(event.isKeyPressed(LogicalKeyboardKey.digit5)){
            setState(() {
              equation = "5";
              print(equation);
              print('5 pressed');
            });
          }if(event.isKeyPressed(LogicalKeyboardKey.digit6)){
            setState(() {
              equation = "6";
              print(equation);
              print('6 pressed');
            });
          }if(event.isKeyPressed(LogicalKeyboardKey.digit7)){
            setState(() {
              equation = "7";
              print(equation);
              print('7 pressed');
            });
          }if(event.isKeyPressed(LogicalKeyboardKey.digit8)){
            setState(() {
              equation = "8";
              print(equation);
              print('8 pressed');
            });
          }if(event.isKeyPressed(LogicalKeyboardKey.digit9)){
            setState(() {
              equation = "9";
              print(equation);
              print('9 pressed');
            });
          }
        }else{

          if(!key.toString().contains('Shift Right') && !key.toString().contains('*')){

          }
          if(event.isKeyPressed(LogicalKeyboardKey.digit0)){
            setState(() {
              key.clear();
              equation += "0";
              print(equation);
              print('0 pressed');
              key.clear();
            });
          } if(event.isKeyPressed(LogicalKeyboardKey.digit1)){
            setState(() {
              key.clear();
              equation += "1";
              print(equation);
              print('1 pressed');
              key.clear();

            });
          } if(event.isKeyPressed(LogicalKeyboardKey.digit2)){
            setState(() {
              key.clear();
              equation += "2";
              print(equation);
              print('2 pressed');
              key.clear();

            });
          } if(event.isKeyPressed(LogicalKeyboardKey.digit3)){
            setState(() {
              key.clear();
              equation += "3";
              print(equation);
              print('3 pressed');
              key.clear();

            });
          }if(event.isKeyPressed(LogicalKeyboardKey.digit4)){
            setState(() {
              key.clear();
              equation += "4";
              print(equation);
              print('4 pressed');
              key.clear();

            });
          }if(event.isKeyPressed(LogicalKeyboardKey.digit5)){
            setState(() {
              key.clear();
              equation += "5";
              print(equation);
              print('5 pressed');
              key.clear();

            });
          }if(event.isKeyPressed(LogicalKeyboardKey.digit6)){
            setState(() {
              key.clear();
              equation += "6";
              print(equation);
              print('6 pressed');
              key.clear();

            });
          }if(event.isKeyPressed(LogicalKeyboardKey.digit7)){
            setState(() {
              key.clear();
              equation += "7";
              print(equation);
              print('7 pressed');
              key.clear();

            });
          }if(event.isKeyPressed(LogicalKeyboardKey.digit8)){
            setState(() {
              key.clear();
              equation += "8";
              print(equation);
              print('8 pressed');
              key.clear();

            });
          }if(event.isKeyPressed(LogicalKeyboardKey.digit9)){
            setState(() {
              key.clear();
              equation += "9";
              print(equation);
              print('9 pressed');


            });
          }if(event.isKeyPressed(LogicalKeyboardKey.backspace)){

             setState(() {
               equation = equation.substring(0, equation.length - 1);
               print(equation);
               print('9 pressed');
               if (equation == '') {
                 equation = '0';
               }
             });

          }

        }
        if(event.isKeyPressed(LogicalKeyboardKey.minus)){
          setState(() {
            equation += "-";
            print(equation);
            print('- pressed');
          });
        }

        if(key.toString().contains('Shift Right') && key.toString().contains('+')){
          setState(() {
            key.clear();
             equation += "+";
             print(equation);
             print('+ pressed');
             key.clear();
           });
        }
        if(key.toString().contains('Shift Right') && key.toString().contains('*')){
          setState(() {
            key.clear();
            equation += "×";
            print(equation);
            print('+ pressed');
            key.clear();
          });
        }
        // try{
        //   if(key.isNotEmpty){
        //     if(key[0].keyLabel == "Shift Right" && key[1].keyLabel == "+"){
        //       setState(() {
        //         equation += "+";
        //         print(equation);
        //         print('+ pressed');
        //       });
        //     }
        //   }if(key.isNotEmpty){
        //     if(key[0].keyLabel == "Shift Right" && key[1].keyLabel == "8"){
        //       setState(() {
        //         equation += "+";
        //         print(equation);
        //         print('+ pressed');
        //       });
        //     }
        //   }
        // }catch(e){print(e);}
        if(event.isKeyPressed(LogicalKeyboardKey.slash)){
          setState(() {
            equation += "÷";
            print(equation);
            print('÷ pressed');
          });
        }
        },
      child: Scaffold(
        key: _scaffoldKey,
        appBar: appBar(),
        drawer: Theme(
          data: Theme.of(context).copyWith(
            canvasColor:
                backgroundColor, //This will change the drawer background to blue.
            //other styles
          ),
          child: Drawer(
            child: ListView(
              children: [
                Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [
                    Colors.blue[600],
                    Colors.blue[700],
                    Colors.indigo
                  ])),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text('v.3.0.9'),
                        ),
                      ),
                      SizedBox(
                        height: 60,
                        width: 60,
                        child: Container(
                          margin:
                              EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                          decoration: BoxDecoration(
                              color: backgroundColor, shape: BoxShape.circle),
                          child: IconButton(
                              icon: Icon(
                                Icons.close,
                                color: buttonColor,
                              ),
                              onPressed: () => (Navigator.pop(context))),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [
                    Colors.blue[600],
                    Colors.blue[700],
                    Colors.indigo
                  ])),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 30, right: 30, top: 5, bottom: 50),
                    child: SizedBox(
                        height: 120,
                        width: 120,
                        child: Image.asset('assets/icon.png')),
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      'More Calculators!',
                      style: TextStyle(
                          color: buttonColor,
                          fontSize: 22,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CurrencyConverter()),
                      );
                    },
                    title: Text(
                      'Currency Converter',
                      style: TextStyle(
                          color: buttonColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                    leading: CircleAvatar(child: Image.asset('assets/money.png')),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Discount()),
                      );
                    },
                    title: Text(
                      'Discount Calculator',
                      style: TextStyle(
                          color: buttonColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                    leading:
                        CircleAvatar(child: Image.asset('assets/discount.png')),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Conversion()),
                      );
                    },
                    title: Text(
                      'Unit Converter',
                      style: TextStyle(
                          color: buttonColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                    leading:
                        CircleAvatar(child: Image.asset('assets/exchange.png')),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Percent()),
                      );
                    },
                    title: Text(
                      'Percent Calculator',
                      style: TextStyle(
                          color: buttonColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                    leading:
                        CircleAvatar(child: Image.asset('assets/percentage.png')),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Container(
                    color: Colors.black,
                    width: double.infinity,
                    height: 0.3,
                  ),
                ),
                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 10),
                //   child: ListTile(
                //     onTap: () {
                //       Navigator.push(
                //         context,
                //         MaterialPageRoute(builder: (context) => Settings()),
                //       );
                //     },
                //     title: Text(
                //       'Settings',
                //       style: TextStyle(
                //           color: buttonColor,
                //           fontWeight: FontWeight.bold,
                //           fontSize: 16),
                //     ),
                //     leading:
                //         CircleAvatar(child: Image.asset('assets/settings.png')),
                //   ),
                // ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Help()),
                      );
                    },
                    title: Text(
                      'Contact us',
                      style: TextStyle(
                          color: buttonColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                    leading:
                        CircleAvatar(child: Image.asset('assets/contacts.png')),
                  ),
                ),
              ],
            ),
          ),
        ),
        backgroundColor: backgroundColor,
        body: SafeArea(
          child: Stack(
            children: [
              Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[buildText(), extraBuild(), lastBuild()]),
            ],
          ),
        ),
      ),
    );
  }

  // void _listen() async {
  //   bool voiceCheck = true;
  //   var connectivityResult = await (Connectivity().checkConnectivity());
  //   if (connectivityResult == ConnectivityResult.mobile) {
  //     print('connected to mobile network');
  //   } else if (connectivityResult == ConnectivityResult.wifi) {
  //     print('connected to wifi network');
  //   } else {
  //     print('Not Connected');
  //     setState(() {
  //       voiceCheck = false;
  //       _isListening = false;
  //     });
  //   }
  //   await flutterTts.setLanguage("en-US");
  //   await flutterTts.setSpeechRate(1.5);
  //   await flutterTts.setVolume(1.0);
  //   await flutterTts.setPitch(1.0);
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return voiceCheck
  //           ? VoicePay()
  //           : AlertDialog(
  //               title: SizedBox(
  //                   height: 150,
  //                   width: 150,
  //                   child: Image.asset('assets/error2.gif')),
  //               content: Container(
  //                 child: Text(
  //                   'No Internet connection. Make sure your Mobile data or Wi-fi is turned on to use voice recognition functionality',
  //                   textAlign: TextAlign.center,
  //                 ),
  //               ),
  //               actions: [
  //                 FlatButton(
  //                   onPressed: () {
  //                     Navigator.pop(context);
  //                   },
  //                   color: themeColor,
  //                   child: Text(
  //                     'Ok',
  //                     style: TextStyle(color: Colors.white),
  //                   ),
  //                 )
  //               ],
  //             );
  //     },
  //   );
  //   if (!_isListening && voiceCheck) {
  //     bool available = await _speech.initialize(
  //       onStatus: (val) => print('onStatus: $val'),
  //       onError: (val) async {
  //         _speech.stop();
  //         Navigator.pop(context);
  //         await flutterTts.speak("Please Try Again");
  //         print('onError: $val');
  //         setState(() {
  //           _isListening = false;
  //         });
  //       },
  //     );
  //     if (available) {
  //       setState(() => _isListening = true);
  //       _speech.listen(
  //         onResult: (val) => setState(() {
  //           _text = val.recognizedWords;
  //           if (val.hasConfidenceRating && val.confidence > 0) {
  //             setState(() => _isListening = false);
  //             //_speech.stop();
  //             Navigator.pop(context);
  //             print(_text);
  //             setState(() async {
  //               if (_text.toLowerCase().contains('divided')) {
  //                 print("true");
  //                 _text = _text.replaceAll('divided by', '');
  //                 _text = _text.replaceAll('  ', '÷');
  //                 equation = _text;
  //                 print(_text);
  //               }
  //               if (_text.toLowerCase().contains('divide')) {
  //                 _text = _text.replaceAll('divide', '');
  //                 _text = _text.replaceAll('  ', '÷');
  //                 equation = _text;
  //                 print(_text);
  //               }
  //               if (_text.toLowerCase().contains('subtract')) {
  //                 _text = _text.replaceAll("subtract", "-");
  //               }
  //               if (_text.toLowerCase().contains('x')) {
  //                 _text = _text.replaceAll("x", "×");
  //               }
  //               if (_text.toLowerCase().contains('multiply') ||
  //                   _text.toLowerCase().contains('multiple') ||
  //                   _text.toLowerCase().contains('into')) {
  //                 _text = _text.replaceAll("into", "×");
  //                 _text = _text.replaceAll("multiply", "×");
  //                 _text = _text.replaceAll("multiple", "×");
  //                 _text = _text.replaceAll("by", "");
  //               }
  //               if (_text.toLowerCase().contains('oneplus')) {
  //                 _text = _text.replaceAll("oneplus", "1 +");
  //               }
  //               if (_text.toLowerCase().contains('plus')) {
  //                 _text = _text.replaceAll("plus", "+");
  //               }
  //               equation = _text;
  //
  //               expression = equation;
  //               expression = expression.replaceAll('×', '*');
  //               expression = expression.replaceAll('÷', '/');
  //               expression = expression.replaceAll('√', 'sqrt');
  //               expression = expression.replaceAll('X', '*');
  //
  //               try {
  //                 Parser p = new Parser();
  //                 Expression exp = p.parse(expression);
  //
  //                 ContextModel cm = ContextModel();
  //                 _result = '${exp.evaluate(EvaluationType.REAL, cm)}';
  //               } catch (e) {
  //                 equation = 'Error';
  //                 _result = 'Error';
  //               }
  //               equation = '$equation = $_result';
  //               if (equation.toLowerCase().contains('error')) {
  //                 await flutterTts.speak("Please Try Again");
  //                 setState(() {
  //                   equation = 'Error';
  //                 });
  //               } else {
  //                 await flutterTts.speak("$equation");
  //               }
  //               print(equation);
  //             });
  //           }
  //         }),
  //       );
  //     }
  //   }
  //   else {
  //     setState(() => _isListening = false);
  //     _speech.stop();
  //   }
  //

  //}

  addBoolToSF() async {
    themeChoice = false;
    setState(() {
      themeColor = Colors.grey;
      backgroundColor = Colors.grey.shade900;
      buttonColor = Colors.white;
      buttonBack = Colors.grey.shade800;
      equalButton = Colors.indigoAccent.shade400;
      extraButton = Colors.grey[500];

      backToggleColor = Colors.grey.shade800;
      backToggleColor2 = Colors.indigo.shade500;
      iconColor = Colors.grey;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('boolValue', themeChoice);
    print('saved');
  }

  addBoolToSF2() async {
    themeChoice = true;
    setState(() {
      themeColor = Colors.indigo;
      backgroundColor = Colors.grey[200];
      buttonColor = Colors.black;
      equalButton = Colors.indigo;
      buttonBack = Colors.white;
      extraButton = Colors.indigo;
      equalToButton = Colors.indigo;

      backToggleColor = Colors.indigo;
      backToggleColor2 = Colors.grey.shade200;
      iconColor = Colors.white;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('boolValue', themeChoice);
    print('saved');
  }

  getBoolValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return bool
    bool boolValue = prefs.getBool('boolValue');
    if (boolValue == false) {
      themeColor = Colors.grey;
      backgroundColor = Colors.grey.shade900;
      buttonColor = Colors.white;
      buttonBack = Colors.grey.shade800;
      equalButton = Colors.indigoAccent.shade400;
      extraButton = Colors.grey[500];

      backToggleColor = Colors.grey.shade800;
      backToggleColor2 = Colors.indigo.shade500;
      iconColor = Colors.grey;
      print('yeah');
    }
    if (boolValue == true) {
      themeColor = Colors.indigo;
      backgroundColor = Colors.grey[200];
      buttonColor = Colors.black;
      equalButton = Colors.indigo;
      buttonBack = Colors.white;
      extraButton = Colors.indigo;
      equalToButton = Colors.indigo;

      backToggleColor = Colors.indigo.shade500;
      backToggleColor2 = Colors.grey.shade200;
      iconColor = Colors.white;
      print('nah');
    }
    setState(() {});
    print("function value $boolValue");
    return boolValue;
  }



}

