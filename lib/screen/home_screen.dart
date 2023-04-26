import 'package:api/constants/constants.dart';
import 'package:api/model/crypto_model.dart';
import 'package:api/screen/coin_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: blackColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image.asset('assets/images/logo.png'),
            const SpinKitWave(
              color: Colors.white,
              size: 60,
            ),
          ],
        ),
      ),
    );
  }

  getData() async {
    var response = await Dio().get('https://api.coincap.io/v2/assets');

    List<Crypto> cryptoList = response.data['data']
        .map<Crypto>((object) => Crypto.fromJson(object))
        .toList();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => CoinScreen(
          crypto: cryptoList,
        ),
      ),
    );
  }
}
