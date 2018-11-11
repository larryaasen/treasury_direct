import 'debt_entry.dart';

class DebtList {
  final int totalRows;
  final List<DebtEntry> mostRecentList;

  DebtList({this.totalRows = 0, this.mostRecentList});

  static DebtList listFromJSON(Map<String, dynamic> json) {
    final totalRows = json['totalRows'];
    final entries = json['entries'];

    var newEntries = List<DebtEntry>();

    if (entries is List<dynamic>) {
      for (final entry in entries) {
        if (entry is Map<String, dynamic>) {
          final newEntry = DebtEntry.debtFromJSON(entry);
          newEntries.add(newEntry);
        }
      }
    }

    // Compute the diffs
    int index = 0;
    for (final entryLater in newEntries) {
      if (index + 1 < newEntries.length) {
        final entryEarlier = newEntries[index + 1];
        entryLater.change = entryLater.totalDebt - entryEarlier.totalDebt;
      }
      index++;
    }

    var newList = DebtList(totalRows: totalRows, mostRecentList: newEntries);

    return newList;
  }
}
