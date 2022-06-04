import 'package:treasury_direct/treasury_direct.dart';

void main() async {
  final td = TreasuryDirect();
  final list = await td.downloadDebtFeedAsync(pagesize: 10000);

  print('Total possible rows: ${list.totalRows}');

  if (list.mostRecentList != null) {
    print('Total row received: ${list.mostRecentList!.length}');
    for (final entry in list.mostRecentList!) {
      print(
          '${DebtEntry.dateFormatted(entry.effectiveDate ?? '')}: ${DebtEntry.currencyShortened(entry.totalDebt ?? 0, false)}');
    }
  }
}
