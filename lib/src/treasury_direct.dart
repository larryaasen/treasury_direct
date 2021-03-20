library treasury_direct;

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:treasury_direct/src/debt_list.dart';

/// Downloads the Debt to the Penny dataset from the US Treasury API.
class TreasuryDirect {
  /// Downloads the Debt to the Penny dataset from the US Treasury API,
  /// asynchronously.
  Future<DebtList> downloadDebtFeedAsync(
      {int pagesize = 10, int pagenum = 1}) async {
    final result =
        await http.get(urlString(pagesize: pagesize, pagenum: pagenum));

    var body = result.body;
    final jsonResponse = json.decode(body);

    var debtList = DebtList.listFromJSON(jsonResponse);

    return debtList;
  }

  /// Creates the URL to the endpoint.
  ///Documentation: https://fiscaldata.treasury.gov/datasets/debt-to-the-penny/
  String urlString({int pagesize = 10, int pagenum = 1}) {
    var provider =
        'https://www.transparency.treasury.gov/services/api/fiscal_service/v2/accounting/od/debt_to_penny?page[number]=$pagenum&page[size]=$pagesize&sort=-record_date';
    final url = provider;
    return url;
  }
}
