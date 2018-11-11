import 'package:intl/intl.dart';

/// One entry for the debt for the day
class DebtEntry {
  // Raw data
  String effectiveDate;
  double governmentHoldings;
  double totalDebt;
  double change;

  DebtEntry({
    this.effectiveDate = "",
    this.governmentHoldings = 0.0,
    this.totalDebt = 0.0,
    this.change = 0.0,
  });

  // Keep a cached version of the effectiveDate
  DateTime _date;
  DateTime date() {
    if (_date == null) {
      _date = convertToDate(effectiveDate);
    }
    return _date;
  }

  @override
  String toString() => 'DebtEntry{totalDebt: $totalDebt}';

  static DebtEntry debtFromJSON(Map<String, dynamic> json) {
    final effectiveDate = json['effectiveDate'];
    final governmentHoldings = json['governmentHoldings'];
    final totalDebt = json['totalDebt'];
    final change = 1.0;

    return DebtEntry(
      effectiveDate: effectiveDate,
      governmentHoldings: governmentHoldings,
      totalDebt: totalDebt,
      change: change,
    );
  }

  static DateTime convertToDate(String sDate) {
    if (sDate == null) return null;

    final fmt = DateFormat.yMMMMd("en_US");
    if (fmt == null) return null;

    var newDate;
    try {
      newDate = fmt.parse(sDate);
    }
    on Exception {
      print("cannot parse date ($sDate). using now.");
      newDate = DateTime.now();
    }

    return newDate;
  }

  static String dateFormatted(String value) {
    final date = convertToDate(value);

    final dateString = DateFormat("MMM d, y").format(date);
    return dateString;
  }

  static String currencyShortened(double value, bool includePrefix) {
    var short = _shortened(value, value);

    if (includePrefix) {
      var prefix = value > 0.0 ? "+" : value < 0.0 ? "-" : "";
      return prefix + short;
    }

    return short;
  }

  static double trillions(double value) {
    return value/1000000000000;
  }

  static String _shortened(double value, double originalValue) {
    if (value < 0.0) {
      return _shortened(-value, originalValue);
    }

    if (value < 1) return (value*100).toInt().toString() + "¢";
    if (value < 1000) return "\$" + value.toStringAsFixed(2);
    if (value < 1000000) return "\$" + (value/1000).toStringAsFixed(2) + "K";
    if (value < 1000000000) return "\$" + (value/1000000).toStringAsFixed(2) + "M";
    if (value < 1000000000000) return "\$" + (value/1000000000).toStringAsFixed(2) + "B";
    if (value < 1000000000000000) return "\$" + (value/1000000000000).toStringAsFixed(2) + "T";

    return value.toStringAsFixed(2);
  }
}

/*

{
	"totalRows": 6381,
	"entries": [{
		"effectiveDate": "June 11, 2018 EDT",
		"governmentHoldings": 5672830188653.26,
		"publicDebt": 15420109283609.04,
		"totalDebt": 21092939472262.30
	}, {
		"effectiveDate": "June 8, 2018 EDT",
		"governmentHoldings": 5669544814167.62,
		"publicDebt": 15419575371855.33,
		"totalDebt": 21089120186022.95
	}, {
		"effectiveDate": "June 7, 2018 EDT",
		"governmentHoldings": 5681014484078.07,
		"publicDebt": 15419090263839.35,
		"totalDebt": 21100104747917.42
	}, {
		"effectiveDate": "June 6, 2018 EDT",
		"governmentHoldings": 5676467447251.19,
		"publicDebt": 15425885426743.22,
		"totalDebt": 21102352873994.41
	}, {
		"effectiveDate": "June 5, 2018 EDT",
		"governmentHoldings": 5675531809567.35,
		"publicDebt": 15425827743823.57,
		"totalDebt": 21101359553390.92
	}]
}
 */
