library treasury_direct;

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:treasury_direct/src/debt_list.dart';

class TreasuryDirect {
  Future<DebtList> downloadDebtFeedAsync(
      {int pagesize = 10, int pagenum = 0, int filterscount = 0}) async {
    final result = await http.get(urlString(
        pagesize: pagesize, pagenum: pagenum, filterscount: filterscount));

    var body = result.body;
    final jsonResponse = json.decode(body);

    var debtList = DebtList.listFromJSON(jsonResponse);

    return debtList;
  }

  String urlString({int pagesize = 10, int pagenum = 0, int filterscount = 0}) {
    var provider =
        'https://www.treasurydirect.gov/NP_WS/debt/jqsearch.json?filterscount=$filterscount&pagenum=$pagenum&pagesize=$pagesize';
    final url = provider;
    return url;
  }
}
