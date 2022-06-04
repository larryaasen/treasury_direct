import 'package:intl/intl.dart';

/// One entry for the debt for the day.
/// Reference: https://fiscaldata.treasury.gov/datasets/debt-to-the-penny/debt-to-the-penny
class DebtEntry {
  /// The date that data was published.
  String? effectiveDate;

  ///  Holdings	Government Account Series (GAS) securities held by Government trust funds, revolving funds, and special funds; and Federal Financing Bank (FFB) securities.
  double? governmentHoldings;

  ///Total of intragovernmental holdings and debt held by the public.
  double? totalDebt;

  /// The amount of change from the previous entry.
  double change;

  DebtEntry({
    this.effectiveDate = '',
    this.governmentHoldings = 0.0,
    this.totalDebt = 0.0,
    this.change = 0.0,
  });

  static final DateFormat _fmt = DateFormat('y-M-d');

  // Keep a cached version of the effectiveDate
  DateTime? _date;

  /// The effectiveDate as a [DateTime].
  DateTime? date() {
    _date ??= convertToDate(effectiveDate);
    return _date;
  }

  /// A string representation of this object.
  @override
  String toString() => 'DebtEntry{totalDebt: $totalDebt}';

  /// Convert map to [DebtEntry].
  static DebtEntry debtFromJSON(Map<String, dynamic> json) {
    final effectiveDate = json['record_date'];
    double governmentHoldings = 0.0, totalDebt = 0.0;
    try {
      final amt = json['intragov_hold_amt'];
      if (amt != null && amt != 'null') {
        governmentHoldings = double.parse(amt);
      }
    } catch (e) {
      print("DebtEntry.debtFromJSON: intragov_hold_amt exception: $e");
      print("DebtEntry.debtFromJSON: json: $json");
    }
    try {
      totalDebt = double.parse(json['tot_pub_debt_out_amt']);
    } catch (e) {
      print("DebtEntry.debtFromJSON: tot_pub_debt_out_amt exception: $e");
      print("DebtEntry.debtFromJSON: json: $json");
    }
    final change = 1.0;

    return DebtEntry(
      effectiveDate: effectiveDate,
      governmentHoldings: governmentHoldings,
      totalDebt: totalDebt,
      change: change,
    );
  }

  /// Convert value to date.
  static DateTime? convertToDate(String? sDate) {
    if (sDate == null) return null;

    var newDate;
    try {
      newDate = _fmt.parse(sDate);
    } catch (e) {
      print('DebtEntry: cannot parse date ($sDate): $e');
      return null;
    }

    return newDate;
  }

  /// Format the date.
  static String? dateFormatted(String value) {
    final date = convertToDate(value);
    if (date == null) return null;

    final dateString = DateFormat('MMM d, y').format(date);
    return dateString;
  }

  /// Convert current value to a shortened version.
  static String currencyShortened(double value, bool includePrefix) {
    var short = _shortened(value, value);

    if (includePrefix) {
      var prefix = value > 0.0
          ? '+'
          : value < 0.0
              ? '-'
              : '';
      return prefix + short;
    }

    return short;
  }

  /// Convert value to trillions.
  static double trillions(double value) {
    return value / 1000000000000;
  }

  static String _shortened(double value, double originalValue) {
    if (value < 0.0) {
      return _shortened(-value, originalValue);
    }
    if (value < 1) {
      return (value * 100).toInt().toString() + '¢';
    }
    if (value < 1000) {
      return '\$' + value.toStringAsFixed(2);
    }
    if (value < 1000000) {
      return '\$' + (value / 1000).toStringAsFixed(2) + 'K';
    }

    if (value < 1000000000) {
      return '\$' + (value / 1000000).toStringAsFixed(2) + 'M';
    }
    if (value < 1000000000000) {
      return '\$' + (value / 1000000000).toStringAsFixed(2) + 'B';
    }
    if (value < 1000000000000000) {
      return '\$' + (value / 1000000000000).toStringAsFixed(2) + 'T';
    }

    return value.toStringAsFixed(2);
  }
}

/*

{
	"data": [{
			"record_date": "2020-07-16",
			"debt_held_public_amt": "20611921079550.83",
			"intragov_hold_amt": "5917339138678.45",
			"tot_pub_debt_out_amt": "26529260218229.28",
			"src_line_nbr": "1",
			"record_fiscal_year": "2020",
			"record_fiscal_quarter": "4",
			"record_calendar_year": "2020",
			"record_calendar_quarter": "3",
			"record_calendar_month": "07",
			"record_calendar_day": "16"
		},
		{
			"record_date": "2020-07-15",
			"debt_held_public_amt": "20574380830507.80",
			"intragov_hold_amt": "5911091609553.12",
			"tot_pub_debt_out_amt": "26485472440060.92",
			"src_line_nbr": "1",
			"record_fiscal_year": "2020",
			"record_fiscal_quarter": "4",
			"record_calendar_year": "2020",
			"record_calendar_quarter": "3",
			"record_calendar_month": "07",
			"record_calendar_day": "15"
		}
	],
	"meta": {
		"count": 2,
		"labels": {
			"record_date": "Record Date",
			"debt_held_public_amt": "Debt Held by the Public",
			"intragov_hold_amt": "Intragovernmental Holdings",
			"tot_pub_debt_out_amt": "Total Public Debt Outstanding",
			"src_line_nbr": "Source Line Number",
			"record_fiscal_year": "Fiscal Year",
			"record_fiscal_quarter": "Fiscal Quarter Number",
			"record_calendar_year": "Calendar Year",
			"record_calendar_quarter": "Calendar Quarter Number",
			"record_calendar_month": "Calendar Month Number",
			"record_calendar_day": "Calendar Day Number"
		},
		"dataTypes": {
			"record_date": "DATE",
			"debt_held_public_amt": "CURRENCY",
			"intragov_hold_amt": "CURRENCY",
			"tot_pub_debt_out_amt": "CURRENCY",
			"src_line_nbr": "NUMBER",
			"record_fiscal_year": "YEAR",
			"record_fiscal_quarter": "QUARTER",
			"record_calendar_year": "YEAR",
			"record_calendar_quarter": "QUARTER",
			"record_calendar_month": "MONTH",
			"record_calendar_day": "DAY"
		},
		"dataFormats": {
			"record_date": "YYYY-MM-DD",
			"debt_held_public_amt": "$10.20",
			"intragov_hold_amt": "$10.20",
			"tot_pub_debt_out_amt": "$10.20",
			"src_line_nbr": "10.2",
			"record_fiscal_year": "YYYY",
			"record_fiscal_quarter": "Q",
			"record_calendar_year": "YYYY",
			"record_calendar_quarter": "Q",
			"record_calendar_month": "MM",
			"record_calendar_day": "DD"
		},
		"total-count": 3716,
		"total-pages": 1858
	},
	"links": {
		"self": "&page%5Bnumber%5D=1&page%5Bsize%5D=2",
		"first": "&page%5Bnumber%5D=1&page%5Bsize%5D=2",
		"prev": null,
		"next": "&page%5Bnumber%5D=2&page%5Bsize%5D=2",
		"last": "&page%5Bnumber%5D=1858&page%5Bsize%5D=2"
	}
}

 */
