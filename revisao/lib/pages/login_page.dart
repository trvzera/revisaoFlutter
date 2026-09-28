import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodels/login_viewmodel.dart';
import 'cadastro_page.dart';
import 'pedidos_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({
    super.key,
  });

  @override
  State<LoginPage> createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final senhaController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    senhaController.dispose();

    super.dispose();
  }

  Future<void> entrar() async {
    final viewModel = context.read<LoginViewModel>();

    final sucesso = await viewModel.login(
      emailController.text.trim(),
      senhaController.text,
    );

    if (!mounted) {
      return;
    }

    if (sucesso) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) {
            return const PedidosPage();
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<LoginViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'The Bear',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Login',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(
              height: 30,
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
                    : entrar,
                child: viewModel.carregando
                    ? const CircularProgressIndicator()
                    : const Text(
                        'Entrar',
                      ),
              ),
            ),

            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) {
                      return const CadastroPage();
                    },
                  ),
                );
              },
              child: const Text(
                'Não possui conta? Cadastre-se',
              ),
            ),
          ],
        ),
      ),
    );
  }
}