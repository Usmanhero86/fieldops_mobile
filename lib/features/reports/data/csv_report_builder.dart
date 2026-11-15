import 'dart:io';

import 'package:path_provider/path_provider.dart';

import 'reports_local_dao.dart';

/// Builds a UTF-8 CSV file from a list of [BeneficiaryCsvRow] and returns
/// the [File] path so it can be shared via `share_plus`.
class CsvReportBuilder {
  const CsvReportBuilder._();

  static const _header = [
    'Beneficiary ID',
    'First Name',
    'Last Name',
    'Gender',
    'LGA',
    'Ward',
    'Community',
    'Project',
    'Date Registered',
    'Latitude',
    'Longitude',
    'Field Officer',
  ];

  /// Writes the CSV to the app's temp directory and returns the file path.
  static Future<String> build(
    List<BeneficiaryCsvRow> rows, {
    required String projectName,
  }) async {
    final buffer = StringBuffer();

    // Header row
    buffer.writeln(_header.map(_escape).join(','));

    // Data rows
    for (final r in rows) {
      buffer.writeln([
        _escape(r.id),
        _escape(r.firstName),
        _escape(r.lastName),
        _escape(r.gender),
        _escape(r.lga),
        _escape(r.ward),
        _escape(r.communityName),
        _escape(r.projectName),
        _escape(_formatDate(r.dateRegistered)),
        _escape(r.latitude?.toStringAsFixed(6) ?? ''),
        _escape(r.longitude?.toStringAsFixed(6) ?? ''),
        _escape(r.fieldOfficerId),
      ].join(','));
    }

    final dir = await getApplicationDocumentsDirectory();
    final filename = '${_slugify(projectName)}_beneficiaries_'
        '${_stamp(DateTime.now())}.csv';
    final file = File('${dir.path}/$filename');
    await file.writeAsString(buffer.toString(), encoding: utf8Encoding);
    return file.path;
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  static const utf8Encoding = SystemEncoding();

  /// RFC 4180 cell escaping: wrap in double-quotes if the value contains a
  /// comma, double-quote, or newline, doubling any internal double-quotes.
  static String _escape(String value) {
    if (value.contains(',') ||
        value.contains('"') ||
        value.contains('\n') ||
        value.contains('\r')) {
      return '"${value.replaceAll('"', '""')}"';
    }
    return value;
  }

  static String _formatDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/'
      '${d.month.toString().padLeft(2, '0')}/'
      '${d.year}';

  static String _stamp(DateTime d) =>
      '${d.year}${d.month.toString().padLeft(2, '0')}'
      '${d.day.toString().padLeft(2, '0')}';

  static String _slugify(String s) =>
      s.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '_');
}
