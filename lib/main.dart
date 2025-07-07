import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatefulWidget {
  const CalculatorApp({super.key});

  @override
  State<CalculatorApp> createState() => _CalculatorAppState();
}

class _CalculatorAppState extends State<CalculatorApp> {
  String _expression = ''; //lưu biểu thức toán học
  String _result = '';
  List<String> _history = [];

  void _onPressed(String value) {
    setState(() {
      if (value == 'AC') {
        _expression = '';
        _result = '';
      } else if (value == '=') {
        try {
          final exp = _expression.replaceAll('×', '*').replaceAll('÷', '/');
          _result = _evaluate(exp);
          if (_expression.isNotEmpty && _result != 'Lỗi') {
            _history.insert(0, '$_expression = $_result');
          }
        } catch (e) {
          _result = 'Lỗi tính';
        }
      } else {
        _expression += value;
      }
    });
  }

  String _evaluate(String exp) {
    try {
      Parser p = Parser();
      Expression expression = p.parse(exp);
      ContextModel cm = ContextModel();
      double eval = expression.evaluate(EvaluationType.REAL, cm);

      if (eval == eval.toInt()) {
        return eval.toInt().toString();
      }
      return eval.toString();
    } catch (e) {
      return 'Lỗi';
    }
  }

  Widget _buildButton(String label, {Color? color}) {
    return SizedBox(
      width: 60,
      height: 60,
      child: ElevatedButton(
        onPressed: () => _onPressed(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: color ?? const Color.fromARGB(255, 243, 142, 184),
          foregroundColor: const Color.fromARGB(255, 214, 102, 181),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.all(0),
        ),
        child: Text(label, style: const TextStyle(fontSize: 22)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Calculator'),
          backgroundColor: const Color.fromARGB(255, 244, 156, 185),
          foregroundColor: Colors.white,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // Hiển thị lịch sử
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: _history
                    .take(2)
                    .map((item) => Text(
                          item,
                          style: const TextStyle(
                              fontSize: 20, color: Colors.black45),
                        ))
                    .toList(),
              ),
              const SizedBox(height: 10),

              // Biểu thức
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  _expression,
                  style: const TextStyle(fontSize: 28),
                ),
              ),
              const SizedBox(height: 8),

              // Kết quả
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  _result,
                  style: const TextStyle(
                      fontSize: 36, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 20),

              
              ...[
                ['AC', '%', '÷', '×'],
                ['7', '8', '9', '-'],
                ['4', '5', '6', '+'],
                ['1', '2', '3', '='],
                ['0', '.', '', ''],
              ].map((row) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: row.map((label) {
                        if (label == '') {
                          return const SizedBox(width: 60, height: 60);
                        }
                        return _buildButton(
                          label,
                          color: label == 'AC'
                              ? Colors.orange[200]
                              : Colors.grey[300],
                        );
                      }).toList(),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}