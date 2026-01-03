import 'dart:io';
import 'package:csv/csv.dart';
import 'package:flutter/foundation.dart';
import 'package:insight_core/insight_core.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

/// Service for exporting analytics data to CSV and other formats
class ExportService {
  /// Export submissions to CSV format
  static Future<File> exportSubmissionsToCSV({
    required List<Submission> submissions,
    required Map<String, FormModel> forms,
    required Map<String, List<SubmissionAnswer>> answers,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final dateFormat = DateFormat('yyyy-MM-dd HH:mm');
    final List<List<String>> rows = [];
    
    // Add header row
    rows.add([
      'Submission ID',
      'Form Name',
      'Submitted By',
      'Submission Date',
      'Submission Time',
      'Status',
      'Completion Time',
      'Field Answers',
    ]);
    
    // Add data rows
    for (final submission in submissions) {
      final form = forms[submission.formId];
      final submissionAnswers = answers[submission.id] ?? [];
      
      // Format answers as key-value pairs
      final answerText = submissionAnswers
          .map((a) => '${a.fieldId}: ${a.answerValue ?? "No Response"}')
          .join('; ');
      
      rows.add([
        submission.id,
        form?.title ?? 'Unknown Form',
        submission.submittedBy,
        dateFormat.format(submission.submissionDate),
        dateFormat.format(submission.submissionTime),
        submission.status.toString().split('.').last,
        'N/A', // TODO: Add completionTime to Submission model
        answerText,
      ]);
    }
    
    // Convert to CSV string
    final csvString = const ListToCsvConverter().convert(rows);
    
    // Save to file
    final directory = await getApplicationDocumentsDirectory();
    final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
    final filename = 'submissions_export_$timestamp.csv';
    final file = File('${directory.path}/$filename');
    
    await file.writeAsString(csvString);
    
    return file;
  }
  
  /// Export detailed submissions with individual field columns
  static Future<File> exportDetailedSubmissionsToCSV({
    required List<Submission> submissions,
    required Map<String, FormModel> forms,
    required Map<String, List<SubmissionAnswer>> answers,
    required Map<String, List<Field>> formFields,
  }) async {
    final dateFormat = DateFormat('yyyy-MM-dd HH:mm');
    final List<List<String>> rows = [];
    
    // Collect all unique fields across all forms
    final allFields = <String, String>{}; // fieldId -> fieldLabel
    for (final fields in formFields.values) {
      for (final field in fields) {
        allFields[field.id] = field.label;
      }
    }
    
    // Add header row
    final headerRow = [
      'Submission ID',
      'Form Name',
      'Submitted By',
      'Submission Date',
      'Status',
      ...allFields.values,
    ];
    rows.add(headerRow);
    
    // Add data rows
    for (final submission in submissions) {
      final form = forms[submission.formId];
      final submissionAnswers = answers[submission.id] ?? [];
      
      // Create answer lookup map
      final answerMap = <String, String>{};
      for (final answer in submissionAnswers) {
        answerMap[answer.fieldId] = answer.answerValue?.toString() ?? 'No Response';
      }
      
      // Build row with values in the same order as headers
      final dataRow = [
        submission.id,
        form?.title ?? 'Unknown Form',
        submission.submittedBy,
        dateFormat.format(submission.submissionDate),
        submission.status.toString().split('.').last,
        ...allFields.keys.map((fieldId) => answerMap[fieldId] ?? ''),
      ];
      
      rows.add(dataRow);
    }
    
    // Convert to CSV string
    final csvString = const ListToCsvConverter().convert(rows);
    
    // Save to file
    final directory = await getApplicationDocumentsDirectory();
    final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
    final filename = 'submissions_detailed_$timestamp.csv';
    final file = File('${directory.path}/$filename');
    
    await file.writeAsString(csvString);
    
    return file;
  }
  
  /// Export form completion statistics
  static Future<File> exportStatisticsToCSV({
    required Map<String, FormModel> forms,
    required Map<String, int> submissionCounts,
    required Map<String, double> completionRates,
    required Map<String, Duration> avgCompletionTimes,
  }) async {
    final List<List<String>> rows = [];
    
    // Add header row
    rows.add([
      'Form Name',
      'Total Submissions',
      'Completion Rate',
      'Avg Completion Time',
      'Status',
    ]);
    
    // Add data rows
    for (final form in forms.values) {
      final count = submissionCounts[form.id] ?? 0;
      final rate = completionRates[form.id] ?? 0.0;
      final avgTime = avgCompletionTimes[form.id];
      
      rows.add([
        form.title,
        count.toString(),
        '${(rate * 100).toStringAsFixed(1)}%',
        avgTime != null 
            ? '${avgTime.inMinutes} min ${avgTime.inSeconds % 60} sec'
            : 'N/A',
        form.status.toString().split('.').last,
      ]);
    }
    
    // Convert to CSV string
    final csvString = const ListToCsvConverter().convert(rows);
    
    // Save to file
    final directory = await getApplicationDocumentsDirectory();
    final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
    final filename = 'form_statistics_$timestamp.csv';
    final file = File('${directory.path}/$filename');
    
    await file.writeAsString(csvString);
    
    return file;
  }
  
  /// Share a file using the system share dialog
  static Future<void> shareFile(File file) async {
    try {
      final xFile = XFile(file.path);
      await Share.shareXFiles(
        [xFile],
        text: 'Exported data from Insight',
      );
    } catch (e) {
      debugPrint('Error sharing file: $e');
      rethrow;
    }
  }
  
  /// Generate PDF report with analytics and charts
  static Future<File> generatePDFReport({
    required List<Submission> submissions,
    required Map<String, FormModel> forms,
    required Map<String, List<SubmissionAnswer>> answers,
    required Map<String, int> submissionCounts,
    required Map<String, double> completionRates,
    DateTime? startDate,
    DateTime? endDate,
    String? storeName,
  }) async {
    final pdf = pw.Document();
    final dateFormat = DateFormat('MMM d, yyyy');
    final now = DateTime.now();
    
    // Calculate summary statistics
    final totalSubmissions = submissions.length;
    final completedSubmissions = submissions.where((s) => s.status == SubmissionStatus.completed).length;
    final overallCompletionRate = totalSubmissions > 0 ? (completedSubmissions / totalSubmissions * 100) : 0.0;
    final activeForms = forms.values.where((f) => f.status == FormStatus.active).length;
    
    // Build PDF pages
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        build: (context) => [
          // Header
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        'Insight Analytics Report',
                        style: pw.TextStyle(
                          fontSize: 24,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      if (storeName != null)
                        pw.Text(
                          storeName,
                          style: const pw.TextStyle(
                            fontSize: 16,
                            color: PdfColors.grey700,
                          ),
                        ),
                    ],
                  ),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text(
                        'Generated: ${dateFormat.format(now)}',
                        style: const pw.TextStyle(fontSize: 10),
                      ),
                      if (startDate != null && endDate != null)
                        pw.Text(
                          'Period: ${dateFormat.format(startDate)} - ${dateFormat.format(endDate)}',
                          style: const pw.TextStyle(fontSize: 10),
                        ),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 10),
              pw.Divider(thickness: 2),
              pw.SizedBox(height: 20),
            ],
          ),
          
          // Summary Statistics
          pw.Text(
            'Summary Statistics',
            style: pw.TextStyle(
              fontSize: 18,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 15),
          
          pw.Row(
            children: [
              _buildStatCard(
                'Total Submissions',
                totalSubmissions.toString(),
                PdfColors.blue,
              ),
              pw.SizedBox(width: 15),
              _buildStatCard(
                'Completion Rate',
                '${overallCompletionRate.toStringAsFixed(1)}%',
                PdfColors.green,
              ),
              pw.SizedBox(width: 15),
              _buildStatCard(
                'Active Forms',
                activeForms.toString(),
                PdfColors.orange,
              ),
            ],
          ),
          
          pw.SizedBox(height: 30),
          
          // Form Performance Table
          pw.Text(
            'Form Performance',
            style: pw.TextStyle(
              fontSize: 18,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 15),
          
          pw.Table(
            border: pw.TableBorder.all(color: PdfColors.grey300),
            children: [
              // Header row
              pw.TableRow(
                decoration: const pw.BoxDecoration(
                  color: PdfColors.grey200,
                ),
                children: [
                  _buildTableCell('Form Name', isHeader: true),
                  _buildTableCell('Submissions', isHeader: true),
                  _buildTableCell('Completion Rate', isHeader: true),
                  _buildTableCell('Status', isHeader: true),
                ],
              ),
              // Data rows
              ...forms.values.map((form) {
                final count = submissionCounts[form.id] ?? 0;
                final rate = completionRates[form.id] ?? 0.0;
                return pw.TableRow(
                  children: [
                    _buildTableCell(form.title),
                    _buildTableCell(count.toString()),
                    _buildTableCell('${(rate * 100).toStringAsFixed(1)}%'),
                    _buildTableCell(form.status.toString().split('.').last),
                  ],
                );
              }).toList(),
            ],
          ),
          
          pw.SizedBox(height: 30),
          
          // Recent Submissions
          if (submissions.isNotEmpty) ...[
            pw.Text(
              'Recent Submissions',
              style: pw.TextStyle(
                fontSize: 18,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.SizedBox(height: 15),
            
            pw.Table(
              border: pw.TableBorder.all(color: PdfColors.grey300),
              children: [
                // Header row
                pw.TableRow(
                  decoration: const pw.BoxDecoration(
                    color: PdfColors.grey200,
                  ),
                  children: [
                    _buildTableCell('Form', isHeader: true),
                    _buildTableCell('Date', isHeader: true),
                    _buildTableCell('Status', isHeader: true),
                  ],
                ),
                // Show last 10 submissions
                ...submissions.take(10).map((submission) {
                  final form = forms[submission.formId];
                  return pw.TableRow(
                    children: [
                      _buildTableCell(form?.title ?? 'Unknown'),
                      _buildTableCell(dateFormat.format(submission.submissionDate)),
                      _buildTableCell(submission.status.toString().split('.').last),
                    ],
                  );
                }).toList(),
              ],
            ),
          ],
          
          // Footer
          pw.SizedBox(height: 40),
          pw.Divider(),
          pw.SizedBox(height: 10),
          pw.Text(
            'Generated by Insight Store Manager',
            style: const pw.TextStyle(
              fontSize: 8,
              color: PdfColors.grey600,
            ),
          ),
        ],
      ),
    );
    
    // Save to file
    final directory = await getApplicationDocumentsDirectory();
    final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
    final filename = 'insight_report_$timestamp.pdf';
    final file = File('${directory.path}/$filename');
    
    await file.writeAsBytes(await pdf.save());
    
    return file;
  }
  
  /// Build a stat card widget for PDF
  static pw.Widget _buildStatCard(String label, String value, PdfColor color) {
    return pw.Expanded(
      child: pw.Container(
        padding: const pw.EdgeInsets.all(15),
        decoration: pw.BoxDecoration(
          border: pw.Border.all(color: color, width: 2),
          borderRadius: pw.BorderRadius.circular(8),
        ),
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              label,
              style: pw.TextStyle(
                fontSize: 10,
                color: PdfColors.grey700,
              ),
            ),
            pw.SizedBox(height: 5),
            pw.Text(
              value,
              style: pw.TextStyle(
                fontSize: 20,
                fontWeight: pw.FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  /// Build a table cell widget for PDF
  static pw.Widget _buildTableCell(String text, {bool isHeader = false}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(8),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontSize: 10,
          fontWeight: isHeader ? pw.FontWeight.bold : pw.FontWeight.normal,
        ),
      ),
    );
  }
  
  /// Preview and print PDF
  static Future<void> printPDF({
    required List<Submission> submissions,
    required Map<String, FormModel> forms,
    required Map<String, List<SubmissionAnswer>> answers,
    required Map<String, int> submissionCounts,
    required Map<String, double> completionRates,
    DateTime? startDate,
    DateTime? endDate,
    String? storeName,
  }) async {
    final file = await generatePDFReport(
      submissions: submissions,
      forms: forms,
      answers: answers,
      submissionCounts: submissionCounts,
      completionRates: completionRates,
      startDate: startDate,
      endDate: endDate,
      storeName: storeName,
    );
    
    await Printing.layoutPdf(
      onLayout: (format) async => await file.readAsBytes(),
    );
  }
}
