# treasury_direct

A Dart library package to access the debt of the United States from the US Treasury Direct site.

## Example

```dart
import 'package:treasury_direct/treasury_direct.dart';
import 'package:treasury_direct/src/debt_entry.dart';

void main() async {
  final td = TreasuryDirect();
  final list = await td.downloadDebtFeedAsync(pagesize: 15);

  print('Total possible rows: ${list.totalRows}');

  print('Total row received: ${list.mostRecentList.length}');
  for (DebtEntry entry in list.mostRecentList) {
    print('${DebtEntry.dateFormatted(entry.effectiveDate)}: ${DebtEntry.currencyShortened(entry.totalDebt, false)}');
  }
}
```

## Treasury Direct API Docs:
https://www.treasurydirect.gov/webapis/webapisdebt.htm
