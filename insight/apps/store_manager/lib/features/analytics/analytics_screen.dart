import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:insight_core/insight_core.dart';
import 'package:insight_ui/insight_ui.dart';
import '../../core/providers/app_providers.dart';
import 'models/completion_stats.dart';
import 'services/export_service.dart';
import 'kpi_trends_tab.dart';

class AnalyticsScreen extends ConsumerStatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  ConsumerState<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends ConsumerState<AnalyticsScreen> {
  DateTime? _startDate;
  DateTime? _endDate;
  String? _selectedFormId;
  bool _isExporting = false;
  
  @override
  void initState() {
    super.initState();
    // Default to current period
    _startDate = DateTime.now().subtract(const Duration(days: 7));
    _endDate = DateTime.now();
  }

  Future<void> _handleExport(String exportType, CompletionStats stats) async {
    setState(() => _isExporting = true);
    
    try {
      final submissionRepo = ref.read(submissionRepositoryProvider);
      final formRepo = ref.read(formRepositoryProvider);
      
      // Fetch all data needed for export
      final allForms = await formRepo.getAllForms();
      final formsMap = {for (var f in allForms) f.id: f};
      
      List<Submission> submissions;
      if (_startDate != null && _endDate != null) {
        submissions = await submissionRepo.getSubmissionsByDateRange(
          _startDate!,
          _endDate!,
        );
      } else {
        // Fetch recent submissions (last 30 days)
        submissions = await submissionRepo.getSubmissionsByDateRange(
          DateTime.now().subtract(const Duration(days: 30)),
          DateTime.now(),
        );
      }
      
      // Filter by selected form if applicable
      if (_selectedFormId != null) {
        submissions = submissions.where((s) => s.formId == _selectedFormId).toList();
      }
      
      // Fetch answers for all submissions
      final answersMap = <String, List<SubmissionAnswer>>{};
      for (final submission in submissions) {
        try {
          final answers = await submissionRepo.getSubmissionAnswers(submission.id);
          answersMap[submission.id] = answers;
        } catch (e) {
          answersMap[submission.id] = [];
        }
      }
      
      // Calculate statistics needed for exports
      final submissionCounts = <String, int>{};
      final completionRates = <String, double>{};
      final avgCompletionTimes = <String, Duration>{};
      
      for (final form in allForms) {
        final formSubmissions = submissions.where((s) => s.formId == form.id).toList();
        submissionCounts[form.id] = formSubmissions.length;
        
        if (formSubmissions.isNotEmpty) {
          final completed = formSubmissions.where((s) => s.status == SubmissionStatus.completed).length;
          completionRates[form.id] = completed / formSubmissions.length;
          
          // TODO: Calculate average completion time when Submission model has completionTime field
          // For now, we'll skip this calculation
        }
      }
      
      // Export based on type
      late final File exportFile;
      switch (exportType) {
        case 'csv_basic':
          exportFile = await ExportService.exportSubmissionsToCSV(
            submissions: submissions,
            forms: formsMap,
            answers: answersMap,
            startDate: _startDate,
            endDate: _endDate,
          );
          break;
          
        case 'csv_detailed':
          // Fetch all fields for all forms
          final formFieldsMap = <String, List<Field>>{};
          for (final form in allForms) {
            try {
              final fields = await formRepo.getFormFields(form.id);
              formFieldsMap[form.id] = fields;
            } catch (e) {
              formFieldsMap[form.id] = [];
            }
          }
          
          exportFile = await ExportService.exportDetailedSubmissionsToCSV(
            submissions: submissions,
            forms: formsMap,
            answers: answersMap,
            formFields: formFieldsMap,
          );
          break;
          
        case 'csv_stats':
          exportFile = await ExportService.exportStatisticsToCSV(
            forms: formsMap,
            submissionCounts: submissionCounts,
            completionRates: completionRates,
            avgCompletionTimes: avgCompletionTimes,
          );
          break;
          
        case 'pdf_report':
          // Generate PDF report
          exportFile = await ExportService.generatePDFReport(
            submissions: submissions,
            forms: formsMap,
            answers: answersMap,
            submissionCounts: submissionCounts,
            completionRates: completionRates,
            startDate: _startDate,
            endDate: _endDate,
            storeName: 'My Store', // TODO: Get actual store name
          );
          break;
          
        case 'pdf_print':
          // Print PDF directly
          await ExportService.printPDF(
            submissions: submissions,
            forms: formsMap,
            answers: answersMap,
            submissionCounts: submissionCounts,
            completionRates: completionRates,
            startDate: _startDate,
            endDate: _endDate,
            storeName: 'My Store', // TODO: Get actual store name
          );
          
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('PDF ready for printing'),
                backgroundColor: AppColors.success,
              ),
            );
            setState(() => _isExporting = false);
          }
          return; // Exit early for print
          
        default:
          throw Exception('Unknown export type: $exportType');
      }
      
      // Share the file (skip for print option)
      await ExportService.shareFile(exportFile);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Export completed successfully'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Export failed: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isExporting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final completionStats = ref.watch(completionStatsProvider);
    final forms = ref.watch(formsProvider);
    
    return Scaffold(
      backgroundColor: AppColors.background,
      body: completionStats.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: EmptyState(
            icon: Icons.error_outline,
            title: 'Error Loading Analytics',
            message: error.toString(),
          ),
        ),
        data: (stats) => CustomScrollView(
          slivers: [
            // Header with filters
            SliverToBoxAdapter(
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Analytics',
                                style: AppTextStyles.headlineMedium.copyWith(
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Form completion insights and trends',
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        PopupMenuButton<String>(
                          icon: const Icon(Icons.file_download_outlined),
                          tooltip: 'Export Report',
                          onSelected: (value) => _handleExport(value, stats),
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                              value: 'csv_basic',
                              child: Row(
                                children: [
                                  Icon(Icons.table_chart),
                                  SizedBox(width: 12),
                                  Text('Export Submissions (Basic)'),
                                ],
                              ),
                            ),
                            const PopupMenuItem(
                              value: 'csv_detailed',
                              child: Row(
                                children: [
                                  Icon(Icons.table_rows),
                                  SizedBox(width: 12),
                                  Text('Export Submissions (Detailed)'),
                                ],
                              ),
                            ),
                            const PopupMenuItem(
                              value: 'csv_stats',
                              child: Row(
                                children: [
                                  Icon(Icons.analytics),
                                  SizedBox(width: 12),
                                  Text('Export Statistics'),
                                ],
                              ),
                            ),
                            const PopupMenuDivider(),
                            const PopupMenuItem(
                              value: 'pdf_report',
                              child: Row(
                                children: [
                                  Icon(Icons.picture_as_pdf),
                                  SizedBox(width: 12),
                                  Text('Generate PDF Report'),
                                ],
                              ),
                            ),
                            const PopupMenuItem(
                              value: 'pdf_print',
                              child: Row(
                                children: [
                                  Icon(Icons.print),
                                  SizedBox(width: 12),
                                  Text('Print PDF Report'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Filters
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        _FilterChip(
                          label: _startDate != null && _endDate != null
                              ? '${_formatDate(_startDate!)} - ${_formatDate(_endDate!)}'
                              : 'Select Date Range',
                          icon: Icons.calendar_today,
                          onTap: () => _selectDateRange(context),
                        ),
                        forms.when(
                          data: (formsList) => _FilterChip(
                            label: _selectedFormId != null
                                ? formsList.firstWhere((f) => f.id == _selectedFormId).title
                                : 'All Forms',
                            icon: Icons.description_outlined,
                            onTap: () => _selectForm(context, formsList),
                          ),
                          loading: () => const SizedBox(),
                          error: (_, __) => const SizedBox(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            // Summary Cards
            SliverPadding(
              padding: const EdgeInsets.all(24),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 1.5,
                ),
                delegate: SliverChildListDelegate([
                  _SummaryCard(
                    title: 'Total Submissions',
                    value: stats.totalSubmissions.toString(),
                    icon: Icons.check_circle_outline,
                    color: AppColors.success,
                  ),
                  _SummaryCard(
                    title: 'Completion Rate',
                    value: '${stats.completionRate.toStringAsFixed(1)}%',
                    icon: Icons.trending_up,
                    color: AppColors.primary,
                  ),
                  _SummaryCard(
                    title: 'Avg Time',
                    value: '${stats.averageCompletionTime.toStringAsFixed(0)}m',
                    icon: Icons.timer_outlined,
                    color: AppColors.warning,
                  ),
                  _SummaryCard(
                    title: 'Active Forms',
                    value: stats.activeForms.toString(),
                    icon: Icons.description,
                    color: AppColors.info,
                  ),
                ]),
              ),
            ),
            
            // Charts
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: _CompletionTrendChart(stats: stats),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _FormCompletionChart(stats: stats),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _SubmissionsTable(stats: stats),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  String _formatDate(DateTime date) {
    return '${date.month}/${date.day}';
  }
  
  Future<void> _selectDateRange(BuildContext context) async {
    final result = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now(),
      initialDateRange: _startDate != null && _endDate != null
          ? DateTimeRange(start: _startDate!, end: _endDate!)
          : null,
    );
    
    if (result != null) {
      setState(() {
        _startDate = result.start;
        _endDate = result.end;
      });
    }
  }
  
  Future<void> _selectForm(BuildContext context, List<FormModel> forms) async {
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Form'),
        content: SizedBox(
          width: 300,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('All Forms'),
                onTap: () => Navigator.pop(context, null),
                selected: _selectedFormId == null,
              ),
              ...forms.map((form) => ListTile(
                title: Text(form.title),
                onTap: () => Navigator.pop(context, form.id),
                selected: _selectedFormId == form.id,
              )),
            ],
          ),
        ),
      ),
    );
    
    if (result != null || result == null) {
      setState(() {
        _selectedFormId = result;
      });
    }
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: AppColors.textSecondary),
            const SizedBox(width: 8),
            Text(
              label,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _SummaryCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              Icon(icon, color: color, size: 20),
            ],
          ),
          Text(
            value,
            style: AppTextStyles.headlineMedium.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _CompletionTrendChart extends StatelessWidget {
  final CompletionStats stats;

  const _CompletionTrendChart({required this.stats});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Completion Trend',
            style: AppTextStyles.titleMedium.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 250,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 20,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: AppColors.border,
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                        if (value.toInt() >= 0 && value.toInt() < days.length) {
                          return Text(
                            days[value.toInt()],
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 20,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          '${value.toInt()}%',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                minX: 0,
                maxX: 6,
                minY: 0,
                maxY: 100,
                lineBarsData: [
                  LineChartBarData(
                    spots: _generateMockData(),
                    isCurved: true,
                    color: AppColors.primary,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: 4,
                          color: Colors.white,
                          strokeWidth: 2,
                          strokeColor: AppColors.primary,
                        );
                      },
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      color: AppColors.primary.withValues(alpha: 0.1),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  List<FlSpot> _generateMockData() {
    // Mock data - in production, use actual submission data
    return const [
      FlSpot(0, 65),
      FlSpot(1, 72),
      FlSpot(2, 78),
      FlSpot(3, 85),
      FlSpot(4, 80),
      FlSpot(5, 88),
      FlSpot(6, 92),
    ];
  }
}

class _FormCompletionChart extends StatelessWidget {
  final CompletionStats stats;

  const _FormCompletionChart({required this.stats});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'By Form Type',
            style: AppTextStyles.titleMedium.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 250,
            child: PieChart(
              PieChartData(
                sectionsSpace: 2,
                centerSpaceRadius: 60,
                sections: _generatePieData(),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  List<PieChartSectionData> _generatePieData() {
    // Mock data - in production, use actual form completion data
    return [
      PieChartSectionData(
        color: AppColors.primary,
        value: 40,
        title: '40%',
        radius: 50,
        titleStyle: AppTextStyles.bodySmall.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      PieChartSectionData(
        color: AppColors.success,
        value: 30,
        title: '30%',
        radius: 50,
        titleStyle: AppTextStyles.bodySmall.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      PieChartSectionData(
        color: AppColors.warning,
        value: 20,
        title: '20%',
        radius: 50,
        titleStyle: AppTextStyles.bodySmall.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      PieChartSectionData(
        color: AppColors.info,
        value: 10,
        title: '10%',
        radius: 50,
        titleStyle: AppTextStyles.bodySmall.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    ];
  }
}

class _SubmissionsTable extends StatelessWidget {
  final CompletionStats stats;

  const _SubmissionsTable({required this.stats});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recent Submissions',
            style: AppTextStyles.titleMedium.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          Table(
            columnWidths: const {
              0: FlexColumnWidth(2),
              1: FlexColumnWidth(2),
              2: FlexColumnWidth(1),
              3: FlexColumnWidth(1),
            },
            children: [
              TableRow(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: AppColors.border),
                  ),
                ),
                children: [
                  _buildTableHeader('Form'),
                  _buildTableHeader('Submitted By'),
                  _buildTableHeader('Status'),
                  _buildTableHeader('Time'),
                ],
              ),
              ..._generateMockRows(),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildTableHeader(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      child: Text(
        text,
        style: AppTextStyles.bodySmall.copyWith(
          color: AppColors.textSecondary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
  
  List<TableRow> _generateMockRows() {
    // Mock data - in production, use actual submissions
    final mockData = [
      ('Daily Operations', 'John Doe', 'Completed', '2m ago'),
      ('Weekly Inventory', 'Jane Smith', 'Completed', '15m ago'),
      ('Period Review', 'Bob Johnson', 'In Progress', '1h ago'),
      ('Main Checklist', 'Alice Brown', 'Completed', '2h ago'),
    ];
    
    return mockData.map((data) {
      return TableRow(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: AppColors.border.withValues(alpha: 0.5)),
          ),
        ),
        children: [
          _buildTableCell(data.$1),
          _buildTableCell(data.$2),
          _buildStatusCell(data.$3),
          _buildTableCell(data.$4),
        ],
      );
    }).toList();
  }
  
  Widget _buildTableCell(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      child: Text(
        text,
        style: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.textPrimary,
        ),
      ),
    );
  }
  
  Widget _buildStatusCell(String status) {
    final color = status == 'Completed' ? AppColors.success : AppColors.warning;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          status,
          style: AppTextStyles.bodySmall.copyWith(
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
