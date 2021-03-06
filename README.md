# treasury_direct

[![Build Status](https://travis-ci.org/larryaasen/treasury_direct.svg?branch=master)](https://travis-ci.org/larryaasen/treasury_direct)    [![codecov](https://codecov.io/gh/larryaasen/treasury_direct/branch/master/graph/badge.svg)](https://codecov.io/gh/larryaasen/treasury_direct) [![pub package](https://img.shields.io/pub/v/treasury_direct.svg)](https://pub.dartlang.org/packages/treasury_direct)

A Dart library package to access the debt of the United States from the US Treasury site. This package can be used in a command line app or in a Flutter app.

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

Expected output:
```text
Total possible rows: 6486
Total row received: 15
Nov 8, 2018: $21.73T
Nov 7, 2018: $21.69T
Nov 6, 2018: $21.69T
Nov 5, 2018: $21.68T
Nov 2, 2018: $21.68T
Nov 1, 2018: $21.68T
Oct 31, 2018: $21.70T
Oct 30, 2018: $21.70T
Oct 29, 2018: $21.70T
Oct 26, 2018: $21.69T
Oct 25, 2018: $21.70T
Oct 24, 2018: $21.67T
Oct 23, 2018: $21.68T
Oct 22, 2018: $21.67T
Oct 19, 2018: $21.67T
```

## Debt to the Penny API Docs:
https://fiscaldata.treasury.gov/datasets/debt-to-the-penny/
