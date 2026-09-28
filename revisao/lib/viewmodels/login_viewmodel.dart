import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import '../models/usuario.dart';
import '../services/banco_service.dart';

class LoginViewModel extends ChangeNotifier {
  final BancoService _bancoService = BancoService();

  bool carregando = false;
  String? erro;

  Future<bool> login(
    String email,
    String senha,
  ) async {
    erro = null;

    if (email.isEmpty || senha.isEmpty) {
      erro = 'Preencha todos os campos.';
      notifyListeners();

      return false;
    }

    carregando = true;
    notifyListeners();

    final usuario = await _bancoService.realizarLogin(
      email,
      senha,
    );

    carregando = false;

    if (usuario == null) {
      erro = 'E-mail ou senha inválidos.';
      notifyListeners();

      return false;
    }

    notifyListeners();

    return true;
  }

  Future<bool> cadastrar(
    String nome,
    String email,
    String senha,
  ) async {
    erro = null;

    if (nome.isEmpty || email.isEmpty || senha.isEmpty) {
      erro = 'Preencha todos os campos.';
      notifyListeners();

      return false;
    }

    carregando = true;
    notifyListeners();

    final usuario = Usuario(
      nome: nome,
      email: email,
      senha: senha,
    );

    try {
      await _bancoService.inserirUsuario(usuario);

      carregando = false;
      notifyListeners();

      return true;
    } on DatabaseException {
      carregando = false;
      erro = 'Este e-mail já está cadastrado.';

      notifyListeners();

      return false;
    }
  }

  void limparErro() {
    erro = null;
    notifyListeners();
  }
}