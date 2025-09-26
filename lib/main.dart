import 'package:flutter/material.dart';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const Calculator(),
    );
  }
}

class Calculator extends StatefulWidget {
  const Calculator({super.key});

  @override
  State<Calculator> createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  String _display = '0';
  String _expression = '';
  String _firstOperand = '';
  String _operator = '';
  bool _waitingForOperand = false;
  bool _justCalculated = false;

  void _inputNumber(String number) {
    setState(() {
      if (_waitingForOperand) {
        _display = _firstOperand + ' ' + _operator + ' ' + number;
        _expression = _display;
        _waitingForOperand = false;
      } else if (_justCalculated) {
        _display = number;
        _expression = number;
        _justCalculated = false;
      } else {
        if (_display == '0') {
          _display = number;
          _expression = number;
        } else {
          _display = _display + number;
          _expression = _expression + number;
        }
      }
    });
  }

  void _inputOperator(String operator) {
    setState(() {
      if (_firstOperand.isEmpty) {
        _firstOperand = _justCalculated ? _display : (_expression.isEmpty ? _display : _expression.split(' ')[0]);
        _display = _firstOperand + ' ' + operator;
        _expression = _display;
      } else if (!_waitingForOperand) {
        _calculate();
        _firstOperand = _display;
        _display = _firstOperand + ' ' + operator;
        _expression = _display;
      } else {
        // Replace the operator if user clicks a different operator
        _display = _firstOperand + ' ' + operator;
        _expression = _display;
      }
      
      _operator = operator;
      _waitingForOperand = true;
      _justCalculated = false;
    });
  }

  void _calculate() {
    if (_firstOperand.isEmpty || _operator.isEmpty || _waitingForOperand) {
      return;
    }

    // Extract the second operand from the current expression
    String secondOperand = _expression.split(' ').last;
    
    double first = double.parse(_firstOperand);
    double second = double.parse(secondOperand);
    double result = 0;

    switch (_operator) {
      case '+':
        result = first + second;
        break;
      case '-':
        result = first - second;
        break;
      case '*':
        result = first * second;
        break;
      case '/':
        if (second == 0) {
          _display = 'Error';
          _clear();
          return;
        }
        result = first / second;
        break;
    }

    setState(() {
      String resultString = result == result.toInt() ? result.toInt().toString() : result.toString();
      _display = resultString;
      _expression = '';
      _firstOperand = '';
      _operator = '';
      _waitingForOperand = false;
      _justCalculated = true;
    });
  }

  void _clear() {
    setState(() {
      _display = '0';
      _expression = '';
      _firstOperand = '';
      _operator = '';
      _waitingForOperand = false;
      _justCalculated = false;
    });
  }

  Widget _buildButton(String text, {Color? color, Color? textColor, VoidCallback? onPressed}) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(4),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: color ?? Colors.grey[300],
            foregroundColor: textColor ?? Colors.black,
            padding: const EdgeInsets.all(20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: onPressed,
          child: Text(
            text,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculator'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          // Display Area
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              _display,
              style: const TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.right,
            ),
          ),
          
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  // First row: Clear and operators
                  Expanded(
                    child: Row(
                      children: [
                        _buildButton('C', 
                          color: Colors.red[400], 
                          textColor: Colors.white,
                          onPressed: _clear
                        ),
                        _buildButton('/', 
                          color: Colors.orange[400], 
                          textColor: Colors.white,
                          onPressed: () => _inputOperator('/')
                        ),
                        _buildButton('*', 
                          color: Colors.orange[400], 
                          textColor: Colors.white,
                          onPressed: () => _inputOperator('*')
                        ),
                        _buildButton('-', 
                          color: Colors.orange[400], 
                          textColor: Colors.white,
                          onPressed: () => _inputOperator('-')
                        ),
                      ],
                    ),
                  ),
                  
                  // Second row: 7, 8, 9, +
                  Expanded(
                    child: Row(
                      children: [
                        _buildButton('7', onPressed: () => _inputNumber('7')),
                        _buildButton('8', onPressed: () => _inputNumber('8')),
                        _buildButton('9', onPressed: () => _inputNumber('9')),
                        _buildButton('+', 
                          color: Colors.orange[400], 
                          textColor: Colors.white,
                          onPressed: () => _inputOperator('+')
                        ),
                      ],
                    ),
                  ),
                  
                  // Third row: 4, 5, 6
                  Expanded(
                    child: Row(
                      children: [
                        _buildButton('4', onPressed: () => _inputNumber('4')),
                        _buildButton('5', onPressed: () => _inputNumber('5')),
                        _buildButton('6', onPressed: () => _inputNumber('6')),
                        Container(
                          margin: const EdgeInsets.all(4),
                          child: const SizedBox(width: 80), // Placeholder for alignment
                        ),
                      ],
                    ),
                  ),
                  
                  // Fourth row: 1, 2, 3, =
                  Expanded(
                    child: Row(
                      children: [
                        _buildButton('1', onPressed: () => _inputNumber('1')),
                        _buildButton('2', onPressed: () => _inputNumber('2')),
                        _buildButton('3', onPressed: () => _inputNumber('3')),
                        _buildButton('=', 
                          color: Colors.blue[600], 
                          textColor: Colors.white,
                          onPressed: _calculate
                        ),
                      ],
                    ),
                  ),
                  
                  // Fifth row: 0
                  Expanded(
                    child: Row(
                      children: [
                        _buildButton('0', onPressed: () => _inputNumber('0')),
                        Container(
                          margin: const EdgeInsets.all(4),
                          child: const SizedBox(width: 80), // Placeholder
                        ),
                        Container(
                          margin: const EdgeInsets.all(4),
                          child: const SizedBox(width: 80), // Placeholder
                        ),
                        Container(
                          margin: const EdgeInsets.all(4),
                          child: const SizedBox(width: 80), // Placeholder
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
