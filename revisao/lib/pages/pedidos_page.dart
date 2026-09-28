import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodels/pedido_viewmodel.dart';

class PedidosPage extends StatefulWidget {
  const PedidosPage({
    super.key,
  });

  @override
  State<PedidosPage> createState() {
    return _PedidosPageState();
  }
}

class _PedidosPageState extends State<PedidosPage> {
  final clienteController = TextEditingController();
  final pratoController = TextEditingController();
  final quantidadeController = TextEditingController();
  final valorController = TextEditingController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        context
            .read<PedidoViewModel>()
            .carregarPedidos();
      },
    );
  }

  @override
  void dispose() {
    clienteController.dispose();
    pratoController.dispose();
    quantidadeController.dispose();
    valorController.dispose();

    super.dispose();
  }

  Future<void> cadastrarPedido() async {
    final viewModel = context.read<PedidoViewModel>();

    final sucesso = await viewModel.cadastrarPedido(
      cliente: clienteController.text.trim(),
      prato: pratoController.text.trim(),
      quantidade: quantidadeController.text.trim(),
      valorUnitario: valorController.text.trim(),
    );

    if (!mounted) {
      return;
    }

    if (!sucesso) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Preencha os dados corretamente.',
          ),
        ),
      );

      return;
    }

    clienteController.clear();
    pratoController.clear();
    quantidadeController.clear();
    valorController.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Pedido cadastrado!',
        ),
      ),
    );
  }

  String formatarDinheiro(double valor) {
    return 'R\$ ${valor.toStringAsFixed(2).replaceAll('.', ',')}';
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<PedidoViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pedidos - The Bear',
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'Novo Pedido',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(
              height: 20,
            ),

            TextField(
              controller: clienteController,
              decoration: const InputDecoration(
                labelText: 'Cliente',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(
              height: 10,
            ),

            TextField(
              controller: pratoController,
              decoration: const InputDecoration(
                labelText: 'Prato',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(
              height: 10,
            ),

            TextField(
              controller: quantidadeController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Quantidade',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(
              height: 10,
            ),

            TextField(
              controller: valorController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(
                labelText: 'Valor Unitário',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(
              height: 15,
            ),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: cadastrarPedido,
                child: const Text(
                  'Cadastrar Pedido',
                ),
              ),
            ),

            const SizedBox(
              height: 30,
            ),

            const Divider(),

            const SizedBox(
              height: 10,
            ),

            const Text(
              'Pedidos',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(
              height: 15,
            ),

            if (viewModel.carregando)
              const CircularProgressIndicator(),

            if (!viewModel.carregando &&
                viewModel.pedidos.isEmpty)
              const Text(
                'Nenhum pedido cadastrado.',
              ),

            ...viewModel.pedidos.map(
              (pedido) {
                return Card(
                  margin: const EdgeInsets.only(
                    bottom: 15,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(
                      16,
                    ),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${pedido.cliente} | ${pedido.prato}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(
                          height: 8,
                        ),

                        Text(
                          'Quantidade: ${pedido.quantidade}',
                        ),

                        Text(
                          'Valor unitário: ${formatarDinheiro(pedido.valorUnitario)}',
                        ),

                        Text(
                          'Total: ${formatarDinheiro(pedido.total)}',
                        ),

                        const SizedBox(
                          height: 8,
                        ),

                        Text(
                          'Classificação: ${pedido.classificacao}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        Text(
                          'Status: ${pedido.status}',
                        ),

                        const SizedBox(
                          height: 12,
                        ),

                        Row(
                          children: [
                            if (pedido.status ==
                                'Pendente')
                              ElevatedButton(
                                onPressed: () {
                                  viewModel
                                      .finalizarPedido(
                                    pedido.id!,
                                  );
                                },
                                child: const Text(
                                  'FINALIZAR',
                                ),
                              ),

                            const SizedBox(
                              width: 10,
                            ),

                            ElevatedButton(
                              onPressed: () {
                                viewModel
                                    .excluirPedido(
                                  pedido.id!,
                                );
                              },
                              child: const Text(
                                'EXCLUIR',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}