import 'dart:convert';

import 'package:ex1/moedas.dart';
import 'package:flutter/material.dart';
// necessário aplicar o comando: flutter pub add intl
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  var conteudo = '';
  String msg = '';
  String msg1 = '';
  String msg2 = '';
  TextEditingController contData = TextEditingController();
  TextEditingController contRes = TextEditingController();

  void initState() {
    super.initState();
    // Formata a data de hoje e a exibe no TextField
    String formattedDate = DateFormat('dd/MM/yyyy').format(DateTime.now());
    contData.text = formattedDate;
  }

  void validaData(String input) {
    msg1 = '';
    msg2 = '';
    // Tenta fazer o parse da data no formato dd/MM/yyyy
    if (input.length != 10) {
      setState(() {
        msg2 = 'Data inválida. Use o formato dd/MM/yyyy.';
      });
    } else {
      try {
        // necessário aplicar o comando: flutter pub add intl
        DateTime parsedDate = DateFormat('dd/MM/yyyy').parseStrict(input);
        setState(() {
          msg1 = 'Data válida: ${DateFormat('dd/MM/yyyy').format(parsedDate)}';
        });
      } catch (e) {
        setState(() {
          msg2 = 'Data inválida. Use o formato dd/MM/yyyy.';
        });
      }
    }
  }

  void pesquisa(String dataInf, int qtdeAnos) async {
    // define variavel url
    String url = '';
    String resultadoParc = '';
    String resultado = '';
    String txtMoeda = '';
    String dataPesq = '';

    resultadoParc = 'Cotações do Dólar nos últimos 3 anos';

    try {
      // Data informada é formatada na variavel tipo datetime
      DateTime dataAtual = DateFormat('dd/MM/yyyy').parse(dataInf);
      //print('Data original: $dataInf');
      print('Data convertida: $dataAtual');
      // Loop
      for (int i = 0; i <= qtdeAnos; i++) {
        DateTime dataProx =
            DateTime(dataAtual.year - i, dataAtual.month, dataAtual.day);
        print(
            'Data incrementada por $i anos: ${DateFormat('dd/MM/yyyy').format(dataProx)}');
        dataPesq = DateFormat('yyyyMMdd').format(dataProx);

        String url =
            'https://economia.awesomeapi.com.br/json/daily/USD-BRL?start_date=$dataPesq&end_date=$dataPesq';
        print(url);
        // objeto Json retornado da APi
        // exige pacote flutter pub add http
        final resposta = await http.get(Uri.parse(url));
        if (resposta.statusCode == 200) {
          // resposta 200 OK
          // o body contém JSON
          // obtem todo conteudo de json
          var jsonValor = jsonDecode(resposta.body);

          print(jsonValor);
          // aplico conversão a partir de corpo do json
          var moedas = Moeda.fromJson(jsonValor[0]);
          txtMoeda = moedas.valorHigh.toString();

          resultadoParc = resultadoParc +
              '\nEm ${DateFormat('dd/MM/yyyy').format(dataProx)}: $txtMoeda';
          print(resultadoParc);
        }

        setState(() {
          resultado = resultadoParc;
          contRes.text = resultado;
        });
      }
    } catch (e) {
      print(
          'Não foi possível validar a data/realizar a pesquisa. O formato é dd/MM/yyyy?');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: TextField(
                  controller: contData,
                  decoration: InputDecoration(
                      labelText: 'Informe a data (dd/mm/yyyy):',
                      // aqui exige retirar o const no InputDecoration
                      hintText: msg1,
                      errorText: msg2),
                  keyboardType: TextInputType.datetime,
                  onChanged: (value) {
                    validaData(value);
                  },
                ),
              ),
              TextButton(
                onPressed: () {
                  pesquisa(contData.text, 3);
                },
                child: const Text('Realizar Pesquisa'),
              ),
              Text('Resultado: $msg'),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                    controller: contRes,
                    maxLines: 7,
                    decoration: const InputDecoration(labelText: 'Resultado')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
