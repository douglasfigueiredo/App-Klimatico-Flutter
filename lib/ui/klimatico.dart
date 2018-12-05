import 'package:flutter/material.dart';
import 'package:klimatico/services/api.dart';
import 'package:klimatico/telas/tela_cidade.dart';
import 'package:klimatico/util/util.dart' as util;


class Klimatico extends StatefulWidget {
  _KlimaticoState createState() => _KlimaticoState();
}

class _KlimaticoState extends State<Klimatico> {

  String _cidadeInserida;

  // Chamar uma nova tela
  Future _abrirNovaTela(BuildContext context) async {
    Map resultado = await Navigator
      .of(context)
      .push(MaterialPageRoute<Map>(
        builder: (BuildContext context) {
          return MudarCidade();
        }
      ));

      if (resultado != null && resultado.containsKey('cidade')) {
        _cidadeInserida = resultado['cidade'];
        debugPrint(_cidadeInserida);
      }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Klimático'),
        centerTitle: true,
        backgroundColor: Colors.redAccent,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.menu),
            onPressed: () => _abrirNovaTela(context),
          )
        ],
      ),
      body: Stack( // Widget para empilhar outros widgets
        children: <Widget>[
          Center( // Criando o background do App
            child: Image.asset(
              'assets/umbrella.png',
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Container(
            alignment: Alignment.topRight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Text(
                    "${_cidadeInserida == null ? util.mycity : _cidadeInserida}",
                    style: styleCidade(),
                  ),
                ),
              ],
            ),
          ),
          Container(
            alignment: Alignment.center,
            child: Image.asset('assets/light-rain.png'),
          ),
          atualizarTempWidget(_cidadeInserida), //Chama o Wiget para atualizar a cidade
        ],
      ),
    );
  }

  Widget atualizarTempWidget(String city) {
    return FutureBuilder(
      future: getWeather(util.appId, city == null ? util.mycity: city), // Pega os dados da API
      builder: (BuildContext context, AsyncSnapshot<Map> snapshot){
        if (snapshot.hasData) {
          Map conteudo = snapshot.data;

          return Container(
            margin: const EdgeInsets.fromLTRB(30, 250, 0, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ListTile(
                  title: Text(
                    conteudo['main']['temp'].toString() + "°C",
                    style: styleTemp(),
                  ),
                  subtitle: ListTile(
                    title: Text(
                        "Humidade: ${conteudo['main']['humidity'].toString()}\n"
                        "Min: ${conteudo['main']['temp_min'].toString()}°C\n"
                        "Max: ${conteudo['main']['temp_max'].toString()}°C\n",
                        style: extraTempo(),
                      ),
                  ),
                )
              ],
            ),
          );
        } else {
          return Container(
            child: Text("Falhou!"),
          );
        }
      }
    );
  }

  TextStyle extraTempo() {
    return TextStyle(
      color: Colors.white70,
      fontStyle: FontStyle.normal,
      fontSize: 17,  
    );
  }

  TextStyle styleCidade() {
    return TextStyle(
      color: Colors.white,
      fontSize: 23,
      fontStyle: FontStyle.italic,
    );
  }

  TextStyle styleTemp() {
    return TextStyle(
      color: Colors.white,
      fontSize: 44,
      fontWeight: FontWeight.w500,
      fontStyle: FontStyle.normal,
    );
  }
}
