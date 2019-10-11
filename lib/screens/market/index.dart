import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../store/store.dart';
import 'advert.dart';

class Market extends StatefulWidget {
  @override
  _MarketState createState() => _MarketState();
}

class _MarketState extends State<Market> {
  @override
  Widget build(BuildContext context) {
    Map _adverts = Provider.of<Store>(context).getPosts;

    return ListView.builder(
      itemBuilder: (context, index) {
        var id = _adverts.keys.toList().elementAt(index);
        return Advert(advert: _adverts[id], id: id);
      },
      itemCount: _adverts.keys.length,
    );
  }
}
