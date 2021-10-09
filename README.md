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
Total possible rows: 7156
Total row received: 7156
Oct 7, 2021: $28.43T
Oct 6, 2021: $28.43T
Oct 5, 2021: $28.43T
Oct 4, 2021: $28.43T
Oct 1, 2021: $28.43T
Sep 30, 2021: $28.43T
Sep 29, 2021: $28.43T
Sep 28, 2021: $28.43T
Sep 27, 2021: $28.43T
Sep 24, 2021: $28.43T
Sep 23, 2021: $28.43T
Sep 22, 2021: $28.43T
Sep 21, 2021: $28.43T
Sep 20, 2021: $28.43T
Sep 17, 2021: $28.43T
...
```

## Debt to the Penny API Docs:
https://fiscaldata.treasury.gov/datasets/debt-to-the-penny/
