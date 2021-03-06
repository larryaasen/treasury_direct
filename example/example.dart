import 'package:treasury_direct/treasury_direct.dart';
import 'package:treasury_direct/src/debt_entry.dart';

void main() async {
  final td = TreasuryDirect();
  final list = await td.downloadDebtFeedAsync(pagesize: 10000);

  print('Total possible rows: ${list.totalRows}');

  print('Total row received: ${list.mostRecentList.length}');
  for (var entry in list.mostRecentList) {
    print(
        '${DebtEntry.dateFormatted(entry.effectiveDate)}: ${DebtEntry.currencyShortened(entry.totalDebt, false)}');
  }
}
