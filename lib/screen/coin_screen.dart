import 'package:api/constants/constants.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../model/crypto_model.dart';

class CoinScreen extends StatefulWidget {
  const CoinScreen({super.key, required this.crypto});

  final List<Crypto> crypto;

  @override
  State<CoinScreen> createState() => _CoinScreenState();
}

class _CoinScreenState extends State<CoinScreen> {
  TextEditingController _search = TextEditingController();
  late List<Crypto> crypto;
  @override
  void initState() {
    crypto = widget.crypto;
    super.initState();
  }

  List<Crypto> filterList = [];
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: blackColor,
        title: const Text(
          'کریپتو بازار',
          style: TextStyle(fontFamily: 'mh'),
        ),
      ),
      backgroundColor: blackColor,
      // backgroundColor: Colors.blueGrey[400],
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                child: Container(
                  decoration: BoxDecoration(
                    color: greenColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: TextField(
                      style: const TextStyle(
                        fontFamily: 'mh',
                      ),
                      controller: _search,
                      onChanged: (String value) {
                        setState(() {
                          filterList = crypto
                              .where(
                                (element) => element.name
                                    .toLowerCase()
                                    .contains(_search.text.toLowerCase()),
                              )
                              .toList();
                        });
                      },
                      decoration: const InputDecoration(
                        hintStyle:
                            TextStyle(fontFamily: 'mh', color: Colors.white),
                        hintText: "اسم رمز ارز معتبر خودتون رو سرچ کنید",
                        border: InputBorder.none,
                      ),
                      // textDirection: TextDirection.rtl,
                      textAlign: TextAlign.end,
                    ),
                  ),
                ),
              ),
              if (filterList.isEmpty && _search.text.isNotEmpty)
                const Center(
                  heightFactor: 30,
                  child: Text(
                    'چیزی پیدا نشد',
                    style: TextStyle(
                      color: greenColor,
                      fontFamily: 'mh',
                    ),
                  ),
                )
              else
                RefreshIndicator(
                  backgroundColor: greenColor,
                  color: blackColor,
                  onRefresh: () async {
                    List<Crypto> refreshInfo = await getData();
                    setState(() {
                      crypto = refreshInfo;
                    });
                  },
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: size.height * 0.83,
                            child: ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              shrinkWrap: true,
                              itemBuilder: (BuildContext context, int index) {
                                if (filterList.isNotEmpty ||
                                    _search.text.isNotEmpty) {
                                  return getListTileItem(index, filterList);
                                } else {
                                  return getListTileItem(index, crypto);
                                }
                              },
                              itemCount: _search.text.isNotEmpty
                                  ? filterList.length
                                  : crypto.length,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget getListTileItem(int index, List<Crypto> list) {
    return ListTile(
      title: Text(
        list[index].name,
        style: const TextStyle(color: greenColor),
      ),
      subtitle: Text(
        list[index].symbol,
        style: const TextStyle(color: greyColor),
      ),
      leading: SizedBox(
        width: 30,
        child: Center(
          child: Text(
            list[index].rank.toString(),
            style: const TextStyle(color: greyColor),
          ),
        ),
      ),
      trailing: SizedBox(
        width: 150,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Text(
                  list[index].priceUsd.toStringAsFixed(2),
                  style: const TextStyle(color: greyColor),
                ),
                Text(
                  list[index].changePercent24Hr.toStringAsFixed(2),
                  style: TextStyle(
                      color: _getColorChangePercent24(
                          list[index].changePercent24Hr)),
                )
              ],
            ),
            const SizedBox(width: 5),
            SizedBox(
              width: 10,
              child: Center(
                child: _getIconChangePercent24(
                  list[index].changePercent24Hr,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getIconChangePercent24(double changePercent24Hr) {
    return changePercent24Hr >= 0
        ? const Icon(
            Icons.trending_up,
            color: greenColor,
          )
        : const Icon(
            Icons.trending_down,
            color: redColor,
          );
  }

  Color _getColorChangePercent24(double changePercent24Hr) {
    return changePercent24Hr >= 0 ? greenColor : redColor;
  }

  Future<List<Crypto>> getData() async {
    var response = await Dio().get('https://api.coincap.io/v2/assets');

    List<Crypto> cryptoList = response.data['data']
        .map<Crypto>((object) => Crypto.fromJson(object))
        .toList();

    return cryptoList;
  }
}
