import 'package:flutter/material.dart';

import '../models/pedido.dart';
import '../services/banco_service.dart';

class PedidoViewModel extends ChangeNotifier {
  final BancoService _bancoService = BancoService();

  List<Pedido> pedidos = [];

  bool carregando = false;

  Future<void> carregarPedidos() async {
    carregando = true;
    notifyListeners();

    pedidos = await _bancoService.listarPedidos();

    carregando = false;
    notifyListeners();
  }

  Future<bool> cadastrarPedido({
    required String cliente,
    required String prato,
    required String quantidade,
    required String valorUnitario,
  }) async {
    if (cliente.isEmpty ||
        prato.isEmpty ||
        quantidade.isEmpty ||
        valorUnitario.isEmpty) {
      return false;
    }

    final quantidadeConvertida = int.tryParse(
      quantidade,
    );

    final valorConvertido = double.tryParse(
      valorUnitario.replaceAll(',', '.'),
    );

    if (quantidadeConvertida == null ||
        valorConvertido == null ||
        quantidadeConvertida <= 0 ||
        valorConvertido <= 0) {
      return false;
    }

    final pedido = Pedido(
      cliente: cliente,
      prato: prato,
      quantidade: quantidadeConvertida,
      valorUnitario: valorConvertido,
    );

    await _bancoService.inserirPedido(
      pedido,
    );

    await carregarPedidos();

    return true;
  }

  Future<void> finalizarPedido(int id) async {
    await _bancoService.finalizarPedido(
      id,
    );

    await carregarPedidos();
  }

  Future<void> excluirPedido(int id) async {
    await _bancoService.excluirPedido(
      id,
    );

    await carregarPedidos();
  }
}