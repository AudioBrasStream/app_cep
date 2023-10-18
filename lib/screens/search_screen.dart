import 'package:app_cep/screens/list_screen.dart';
import 'package:app_cep/services/back4app_service.dart';
import 'package:flutter/material.dart';
//import 'package:seu_app/cep_model.dart'; // Importe o modelo de dados CEP aqui
//import 'package:seu_app/back4app_service.dart'; // Importe o serviço do Back4App aqui
import 'package:dio/dio.dart'; // Importe o pacote Dio para requisições HTTP

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _formKey = GlobalKey<FormState>();
  final _cepController = TextEditingController();
  Back4AppService _back4AppService = Back4AppService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pesquisar CEP"),
        actions: [
          IconButton(
            icon: Icon(Icons.list),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ListScreen(), // Navega para a ListScreen
                ),
              );
            },
          ),
        ],
      ),
           body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height / 3,
                child: Image.asset("assets/logo.png"),
              ),
              TextFormField(
                controller: _cepController,
                decoration: InputDecoration(labelText: "CEP"),
                keyboardType: TextInputType.number,
                validator: (value) {
                if (value == null || value.isEmpty || value.length != 8) {
              return "CEP inválido";
}
                  return null;
                },
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    _searchCEP(_cepController.text);
                  }
                },
                child: Text("Pesquisar CEP"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _searchCEP(String cep) async {
    // Implemente a lógica para buscar o CEP no Back4App
    final ceps = await _back4AppService.fetchCEPsFromBack4App(cep);

    if (ceps.isNotEmpty) {
      // CEP encontrado no Back4App, exibir os resultados
      // Você pode navegar para outra tela para mostrar os resultados
      // Implemente a navegação aqui
    } else {
      // CEP não encontrado no Back4App, consultar o ViaCEP
      final viaCEPData = await _fetchCEPFromViaCEP(cep);

      if (viaCEPData != null) {
        // CEP encontrado no ViaCEP, perguntar se deseja cadastrar no Back4App
        // Implemente a lógica para perguntar e cadastrar aqui
      } else {
        // CEP não encontrado no ViaCEP
        // Trate o caso de CEP não encontrado
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("CEP não encontrado"),
          ),
        );
      }
    }
  }

  Future<Map<String, dynamic>?> _fetchCEPFromViaCEP(String cep) async {
    final dio = Dio();
    try {
      final response = await dio.get('https://viacep.com.br/ws/$cep/json/');
      if (response.statusCode == 200) {
        return response.data;
      }
    } catch (e) {
      print(e);
    }
    return null;
  }
}
