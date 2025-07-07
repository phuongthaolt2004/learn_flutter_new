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
  String _expression = '';
  String _result = '';
  List<String> _history = [];
  bool _showHistory = false;

  void _onPressed(String value) {
    setState(() {
      if (value == 'AC') {
        _expression = '';
        _result = '';
      } else if (value == 'DEL') {
        if (_expression.isNotEmpty) {
          _expression = _expression.substring(0, _expression.length - 1);
        }
      } else if (value == '=') {
        try {
          final exp = _expression
              .replaceAll('×', '*')
              .replaceAll('÷', '/');
          _result = _evaluate(exp);
          if (_expression.isNotEmpty && _result != 'Lỗi') {
            _history.insert(0, '$_expression = $_result');
          }
        } catch (e) {
          _result = 'Lỗi';
        }
      } else {
        _expression += value;
      }
    });
  }

  String _evaluate(String exp) {
    try {
      // Xử lý phép chia lấy dư %
      exp = exp.replaceAllMapped(
        RegExp(r'(\d+)\s*%\s*(\d+)'),
        (match) {
          final a = int.parse(match.group(1)!);
          final b = int.parse(match.group(2)!);
          return (a % b).toString();
        },
      );

      Parser p = Parser();
      Expression expression = p.parse(exp);
      ContextModel cm = ContextModel();
      double eval = expression.evaluate(EvaluationType.REAL, cm);

      if (eval == eval.toInt()) {
        return eval.toInt().toString();
      }
      return eval.toStringAsFixed(2);
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
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.all(0),
        ),
        child: Text(label, style: const TextStyle(fontSize: 22)),
      ),
    );
  }

  Widget _buildKeyboard() {
    final buttons = [
      ['AC', 'DEL', '%', '÷'],
      ['7', '8', '9', '×'],
      ['4', '5', '6', '-'],
      ['1', '2', '3', '+'],
      ['0', '.', '=', '']
    ];

    return Column(
      children: buttons
          .map(
            (row) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: row.map((label) {
                  if (label == '') {
                    return const SizedBox(width: 60, height: 60);
                  }
                  Color? buttonColor;
                  if (label == 'AC') {
                    buttonColor = Colors.red;
                  } else if (label == 'DEL') {
                    buttonColor = Colors.orange[200];
                  } else {
                    buttonColor = Colors.grey[300];
                  }

                  return _buildButton(label, color: buttonColor);
                }).toList(),
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildHistoryView() {
    return Expanded(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Lịch sử',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    _history.clear();
                  });
                },
                icon: const Icon(Icons.delete, color: Colors.red),
              )
            ],
          ),
          const Divider(),
          Expanded(
            child: _history.isEmpty
                ? const Center(child: Text('Không có lịch sử'))
                : ListView.builder(
                    itemCount: _history.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(_history[index]),
                      );
                    },
                  ),
          ),
        ],
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
          actions: [
            IconButton(
              icon: Icon(_showHistory ? Icons.calculate : Icons.history),
              onPressed: () {
                setState(() {
                  _showHistory = !_showHistory;
                });
              },
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              if (!_showHistory)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        _expression,
                        style: const TextStyle(fontSize: 28),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        _result,
                        style: const TextStyle(
                            fontSize: 36, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildKeyboard(),
                  ],
                )
              else
                _buildHistoryView(),
            ],
          ),
        ),
      ),
    );
  }
}
