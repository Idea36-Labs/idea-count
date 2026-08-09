import 'package:flutter/material.dart';
// Manter o último valor
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/counter_button.dart';

/// Tela principal do Idea Count.
///
/// Responsável por:
/// - exibir o valor atual do contador;
/// - controlar o estado do contador;
/// - organizar os elementos visuais da tela.
///
/// Como o aplicativo é simples, o gerenciamento de estado será feito
/// utilizando StatefulWidget + setState().
class CounterPage extends StatefulWidget {
  /// Construtor padrão da tela.
  const CounterPage({super.key});

  @override
  State<CounterPage> createState() => _CounterPageState();
}

/// Estado interno da CounterPage.
///
/// Guarda o valor atual do contador e atualiza a interface
/// sempre que esse valor mudar.
class _CounterPageState extends State<CounterPage> {
  // Manter o último valor
  // Chave para identificar o valor no armazenamento interno
  static const String _counterKey = 'saved_counter_value';
  
  /// Valor inicial do contador.
  ///
  /// Conforme definido no produto, o contador começa sempre em zero.
  int _count = 0;

  @override
  void initState() {
    super.initState();
    _loadCounter(); // Busca o valor salvo assim que a tela abre
  }

  /// Carrega o valor salvo no SharedPreferences.
  Future<void> _loadCounter() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _count = prefs.getInt(_counterKey) ?? 0;
    });
  }

  /// Salva o valor atual do contador.
  Future<void> _saveCounter(int value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_counterKey, value);
  }

  /// Incrementa o contador em 1.
  void _increment() {
    setState(() {
      _count++;
    });
    _saveCounter(_count); // <-- Linha adicionada
  }

  /// Decrementa o contador em 1.
  ///
  /// O contador não permite valores negativos.
  void _decrement() {
    if (_count > 0) {
      setState(() {
        _count--;
      });
      _saveCounter(_count); // <-- Linha adicionada
    }
  }

  /// Reseta o contador para zero.
  ///
  /// O botão de reset faz parte do design criado pelo Stitch.
  void _reset() {
    setState(() {
      _count = 0;
    });
    _saveCounter(0); // <-- Linha adicionada
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Cabeçalho da aplicação.
            //
            // Mantido simples para seguir a proposta minimalista.
            const Padding(
              padding: EdgeInsets.only(top: 24),
              child: Text(
                'IDEA COUNT',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1A1A1A),
                ),
              ),
            ),

            // Área central contendo o número do contador.
            Expanded(
              child: Center(
                child: Text(
                  '$_count',

                  // O número é o elemento principal da interface.
                  style: const TextStyle(
                    fontSize: 120,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -4,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
              ),
            ),

            // Área inferior dos controles.
            Padding(
              padding: const EdgeInsets.only(
                bottom: 40,
                left: 24,
                right: 24,
              ),
              child: Column(
                children: [
                  // Botões principais + e -.
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CounterButton(
                        icon: Icons.remove,
                        onPressed: _decrement,
                      ),

                      const SizedBox(width: 32),

                      CounterButton(
                        icon: Icons.add,
                        onPressed: _increment,
                        isPrimary: true, // <-- Ativa a cor amarela
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Botão secundário de reset.
                  TextButton(
                    onPressed: _reset,
                    child: const Text(
                      'RESET COUNT',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}