import 'debt_entry.dart';

/// A list of debt entries.
class DebtList {
  final int totalRows;
  final List<DebtEntry> mostRecentList;

  DebtList({this.totalRows = 0, this.mostRecentList});

  /// Create a list from JSON data.
  static DebtList listFromJSON(Map<String, dynamic> json) {
    final meta = json['meta'];
    final totalCount = meta['total-count'];

    final data = json['data'];

    var newEntries = <DebtEntry>[];

    if (data is List<dynamic>) {
      for (final entry in data) {
        if (entry is Map<String, dynamic>) {
          final newEntry = DebtEntry.debtFromJSON(entry);
          newEntries.add(newEntry);
        }
      }
    }

    // Compute the diffs
    var index = 0;
    for (final entryLater in newEntries) {
      if (index + 1 < newEntries.length) {
        final entryEarlier = newEntries[index + 1];
        entryLater.change = entryLater.totalDebt - entryEarlier.totalDebt;
      }
      index++;
    }

    var newList = DebtList(totalRows: totalCount, mostRecentList: newEntries);

    return newList;
  }
}
