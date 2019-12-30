import 'package:test/test.dart';

import 'package:treasury_direct/treasury_direct.dart';
import 'package:treasury_direct/src/debt_entry.dart';

/// Tests the Treasury Direct library.
void main() {
  test('download 10', () async {
    final td = TreasuryDirect();
    expect(td != null, true);

    final list = await td.downloadDebtFeedAsync();
    expect(list != null, true);
    expect(list.totalRows, greaterThan(6485));
    expect(list.mostRecentList.length, equals(10));
    for (var entry in list.mostRecentList) {
      validateDebtEntry(entry);
    }
  });

  test('download 1024', () async {
    final td = TreasuryDirect();
    expect(td != null, true);

    final list = await td.downloadDebtFeedAsync(pagesize: 1024);
    expect(list != null, true);
    expect(list.totalRows, greaterThan(6485));
    expect(list.mostRecentList.length, equals(1024));
  });

  test('urlString', () async {
    final td = TreasuryDirect();
    expect(td != null, true);

    expect(td.urlString(),
        'https://www.treasurydirect.gov/NP_WS/debt/jqsearch.json?filterscount=0&pagenum=0&pagesize=10');
    expect(td.urlString(pagesize: 25),
        'https://www.treasurydirect.gov/NP_WS/debt/jqsearch.json?filterscount=0&pagenum=0&pagesize=25');
    expect(td.urlString(pagenum: 25),
        'https://www.treasurydirect.gov/NP_WS/debt/jqsearch.json?filterscount=0&pagenum=25&pagesize=10');
    expect(td.urlString(filterscount: 25),
        'https://www.treasurydirect.gov/NP_WS/debt/jqsearch.json?filterscount=25&pagenum=0&pagesize=10');
    expect(td.urlString(pagesize: 25, pagenum: 25),
        'https://www.treasurydirect.gov/NP_WS/debt/jqsearch.json?filterscount=0&pagenum=25&pagesize=25');
    expect(td.urlString(pagesize: 25, pagenum: 25, filterscount: 25),
        'https://www.treasurydirect.gov/NP_WS/debt/jqsearch.json?filterscount=25&pagenum=25&pagesize=25');
  });

  test('DebtEntry.shortened', () {
    expect(DebtEntry.currencyShortened(-10.2, true), equals('-\$10.20'));
    expect(DebtEntry.currencyShortened(-10.12, true), equals('-\$10.12'));
    expect(DebtEntry.currencyShortened(-0.1, true), equals('-10¢'));
    expect(DebtEntry.currencyShortened(0.0, true), equals('0¢'));
    expect(DebtEntry.currencyShortened(0.10, true), equals('+10¢'));
    expect(DebtEntry.currencyShortened(1.11, true), equals('+\$1.11'));
    expect(DebtEntry.currencyShortened(12.12, true), equals('+\$12.12'));
    expect(DebtEntry.currencyShortened(123.13, true), equals('+\$123.13'));
    expect(DebtEntry.currencyShortened(1234.14, true), equals('+\$1.23K'));
    expect(DebtEntry.currencyShortened(12345.15, true), equals('+\$12.35K'));
    expect(DebtEntry.currencyShortened(123456.16, true), equals('+\$123.46K'));
    expect(DebtEntry.currencyShortened(1234567.17, true), equals('+\$1.23M'));
    expect(DebtEntry.currencyShortened(12345678.18, true), equals('+\$12.35M'));
    expect(
        DebtEntry.currencyShortened(123456789.19, true), equals('+\$123.46M'));
    expect(
        DebtEntry.currencyShortened(1234567890.20, true), equals('+\$1.23B'));
    expect(
        DebtEntry.currencyShortened(12345678901.21, true), equals('+\$12.35B'));
    expect(DebtEntry.currencyShortened(123456789012.22, true),
        equals('+\$123.46B'));
    expect(DebtEntry.currencyShortened(1234567890123.23, true),
        equals('+\$1.23T'));
  });
}

void validateDebtEntry(DebtEntry entry) {
  expect(entry.effectiveDate.length, greaterThan(10));
  expect(entry.governmentHoldings, greaterThan(10000));
  expect(entry.totalDebt, greaterThan(10000));
  expect(entry.change, isNot(0));
}
