import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodels/login_viewmodel.dart';

class CadastroPage extends StatefulWidget {
  const CadastroPage({
    super.key,
  });

  @override
  State<CadastroPage> createState() {
    return _CadastroPageState();
  }
}

class _CadastroPageState extends State<CadastroPage> {
  final nomeController = TextEditingController();
  final emailController = TextEditingController();
  final senhaController = TextEditingController();

  @override
  void dispose() {
    nomeController.dispose();
    emailController.dispose();
    senhaController.dispose();

    super.dispose();
  }

  Future<void> cadastrar() async {
    final viewModel = context.read<LoginViewModel>();

    final sucesso = await viewModel.cadastrar(
      nomeController.text.trim(),
      emailController.text.trim(),
      senhaController.text,
    );

    if (!mounted) {
      return;
    }

    if (sucesso) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Usuário cadastrado com sucesso!',
          ),
        ),
      );

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<LoginViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Cadastro',
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: nomeController,
              decoration: const InputDecoration(
                labelText: 'Nome completo',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(
              height: 15,
            ),

            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'E-mail',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(
              height: 15,
            ),

            TextField(
              controller: senhaController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Senha',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(
              height: 15,
            ),

            if (viewModel.erro != null)
              Text(
                viewModel.erro!,
                style: const TextStyle(
                  color: Colors.red,
                ),
              ),

            const SizedBox(
              height: 15,
            ),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: viewModel.carregando
                    ? null
                    : cadastrar,
                child: const Text(
                  'Cadastrar',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}