class CompletionStats {
  final int totalSubmissions;
  final double completionRate;
  final double averageCompletionTime; // in minutes
  final int activeForms;
  final Map<String, int> submissionsByForm;
  final List<DailySubmission> dailySubmissions;

  const CompletionStats({
    required this.totalSubmissions,
    required this.completionRate,
    required this.averageCompletionTime,
    required this.activeForms,
    required this.submissionsByForm,
    required this.dailySubmissions,
  });

  factory CompletionStats.empty() {
    return const CompletionStats(
      totalSubmissions: 0,
      completionRate: 0.0,
      averageCompletionTime: 0.0,
      activeForms: 0,
      submissionsByForm: {},
      dailySubmissions: [],
    );
  }
}

class DailySubmission {
  final DateTime date;
  final int count;
  final double completionRate;

  const DailySubmission({
    required this.date,
    required this.count,
    required this.completionRate,
  });
}
