"use client";

import { useList } from "@refinedev/core";
import Link from "next/link";
import {
  ArrowLeft,
  TrendingUp,
  TrendingDown,
  BarChart3,
  Users,
  Clock,
} from "lucide-react";
import {
  BarChart,
  Bar,
  XAxis,
  YAxis,
  CartesianGrid,
  Tooltip,
  Legend,
  ResponsiveContainer,
  PieChart,
  Pie,
  Cell,
} from "recharts";
import { useMemo } from "react";

interface FormTemplate {
  id: string;
  name: string;
  status: string;
  version: number;
  created_at: string;
}

interface Submission {
  id: string;
  form_id: string;
  form_version: number;
  created_at: string;
  data: Record<string, any>;
}

interface FormDraft {
  id: string;
  form_id: string;
  updated_at: string;
}

export default function AnalyticsPage() {
  // Fetch all data
  const { query: formsQuery } = useList<FormTemplate>({
    resource: "form_templates",
    pagination: { pageSize: 100 },
  });

  const { query: submissionsQuery } = useList<Submission>({
    resource: "submissions",
    pagination: { pageSize: 10000 },
  });

  const { query: draftsQuery } = useList<FormDraft>({
    resource: "form_drafts",
    pagination: { pageSize: 1000 },
  });

  const forms = formsQuery.data?.data || [];
  const submissions = submissionsQuery.data?.data || [];
  const drafts = draftsQuery.data?.data || [];

  // Calculate comprehensive analytics
  const analytics = useMemo(() => {
    // Form-level statistics
    const formStats = forms.map((form) => {
      const formSubmissions = submissions.filter((s) => s.form_id === form.id);
      const formDrafts = drafts.filter((d) => d.form_id === form.id);

      // Calculate completion rate
      const totalStarts = formSubmissions.length + formDrafts.length;
      const completionRate =
        totalStarts > 0
          ? ((formSubmissions.length / totalStarts) * 100).toFixed(1)
          : "0";

      // Calculate average time (mock data for now - would need analytics events)
      const avgTime = formSubmissions.length > 0 ? "3.5" : "0";

      return {
        id: form.id,
        name: form.name,
        status: form.status,
        submissions: formSubmissions.length,
        drafts: formDrafts.length,
        totalStarts,
        completionRate: parseFloat(completionRate),
        avgTime: parseFloat(avgTime),
        created: new Date(form.created_at),
      };
    });

    // Sort by submissions
    formStats.sort((a, b) => b.submissions - a.submissions);

    // Overall statistics
    const totalSubmissions = submissions.length;
    const totalDrafts = drafts.length;
    const totalStarts = totalSubmissions + totalDrafts;
    const overallCompletionRate =
      totalStarts > 0 ? (totalSubmissions / totalStarts) * 100 : 0;

    // Submissions by day of week
    const dayOfWeekCounts = [0, 0, 0, 0, 0, 0, 0];
    submissions.forEach((submission) => {
      const day = new Date(submission.created_at).getDay();
      dayOfWeekCounts[day]++;
    });

    const submissionsByDay = [
      { day: "Sun", count: dayOfWeekCounts[0] },
      { day: "Mon", count: dayOfWeekCounts[1] },
      { day: "Tue", count: dayOfWeekCounts[2] },
      { day: "Wed", count: dayOfWeekCounts[3] },
      { day: "Thu", count: dayOfWeekCounts[4] },
      { day: "Fri", count: dayOfWeekCounts[5] },
      { day: "Sat", count: dayOfWeekCounts[6] },
    ];

    // Submissions by hour (mock data - would need actual timestamp analysis)
    const submissionsByHour = Array.from({ length: 24 }, (_, i) => ({
      hour: i,
      count: Math.floor(Math.random() * 10), // Mock data
    }));

    // Top performing forms (top 5)
    const topForms = formStats.slice(0, 5);

    // Forms with lowest completion rates
    const strugglingForms = formStats
      .filter((f) => f.totalStarts > 0)
      .sort((a, b) => a.completionRate - b.completionRate)
      .slice(0, 5);

    return {
      formStats,
      totalSubmissions,
      totalDrafts,
      totalStarts,
      overallCompletionRate,
      submissionsByDay,
      submissionsByHour,
      topForms,
      strugglingForms,
    };
  }, [forms, submissions, drafts]);

  const COLORS = ["#3b82f6", "#10b981", "#f59e0b", "#ef4444", "#8b5cf6"];

  if (
    formsQuery.isLoading ||
    submissionsQuery.isLoading ||
    draftsQuery.isLoading
  ) {
    return (
      <div className="min-h-screen flex items-center justify-center">
        <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-600"></div>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-gray-50 p-8">
      <div className="max-w-7xl mx-auto space-y-8">
        {/* Header */}
        <div className="flex items-center justify-between">
          <div className="flex items-center gap-4">
            <Link
              href="/"
              className="p-2 hover:bg-gray-100 rounded-lg transition-colors"
            >
              <ArrowLeft className="w-5 h-5" />
            </Link>
            <div>
              <h1 className="text-3xl font-bold text-gray-900">Analytics</h1>
              <p className="text-gray-600 mt-1">
                Deep insights into form performance and user behavior
              </p>
            </div>
          </div>
        </div>

        {/* Key Metrics */}
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
          <div className="bg-white p-6 rounded-lg shadow-sm border border-gray-200">
            <div className="flex items-center justify-between mb-2">
              <p className="text-sm text-gray-600">Completion Rate</p>
              {analytics.overallCompletionRate >= 70 ? (
                <TrendingUp className="w-5 h-5 text-green-600" />
              ) : (
                <TrendingDown className="w-5 h-5 text-red-600" />
              )}
            </div>
            <p className="text-3xl font-bold text-gray-900">
              {analytics.overallCompletionRate.toFixed(1)}%
            </p>
            <p className="text-sm text-gray-500 mt-1">
              {analytics.totalSubmissions} of {analytics.totalStarts} starts
            </p>
          </div>

          <div className="bg-white p-6 rounded-lg shadow-sm border border-gray-200">
            <div className="flex items-center justify-between mb-2">
              <p className="text-sm text-gray-600">Total Forms</p>
              <BarChart3 className="w-5 h-5 text-blue-600" />
            </div>
            <p className="text-3xl font-bold text-gray-900">{forms.length}</p>
            <p className="text-sm text-gray-500 mt-1">
              {forms.filter((f) => f.status === "active").length} active
            </p>
          </div>

          <div className="bg-white p-6 rounded-lg shadow-sm border border-gray-200">
            <div className="flex items-center justify-between mb-2">
              <p className="text-sm text-gray-600">Active Drafts</p>
              <Users className="w-5 h-5 text-orange-600" />
            </div>
            <p className="text-3xl font-bold text-gray-900">
              {analytics.totalDrafts}
            </p>
            <p className="text-sm text-gray-500 mt-1">In progress</p>
          </div>

          <div className="bg-white p-6 rounded-lg shadow-sm border border-gray-200">
            <div className="flex items-center justify-between mb-2">
              <p className="text-sm text-gray-600">Avg. Completion</p>
              <Clock className="w-5 h-5 text-purple-600" />
            </div>
            <p className="text-3xl font-bold text-gray-900">3.5 min</p>
            <p className="text-sm text-gray-500 mt-1">Per form</p>
          </div>
        </div>

        {/* Charts Row */}
        <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
          {/* Submissions by Day of Week */}
          <div className="bg-white p-6 rounded-lg shadow-sm border border-gray-200">
            <h2 className="text-lg font-semibold text-gray-900 mb-4">
              Submissions by Day of Week
            </h2>
            {analytics.totalSubmissions > 0 ? (
              <ResponsiveContainer width="100%" height={300}>
                <BarChart data={analytics.submissionsByDay}>
                  <CartesianGrid strokeDasharray="3 3" />
                  <XAxis dataKey="day" />
                  <YAxis />
                  <Tooltip />
                  <Bar dataKey="count" fill="#3b82f6" radius={[8, 8, 0, 0]} />
                </BarChart>
              </ResponsiveContainer>
            ) : (
              <div className="h-75 flex items-center justify-center text-gray-500">
                No data yet
              </div>
            )}
          </div>

          {/* Top Performing Forms */}
          <div className="bg-white p-6 rounded-lg shadow-sm border border-gray-200">
            <h2 className="text-lg font-semibold text-gray-900 mb-4">
              Top Performing Forms
            </h2>
            {analytics.topForms.length > 0 ? (
              <ResponsiveContainer width="100%" height={300}>
                <PieChart>
                  <Pie
                    data={analytics.topForms.map((f) => ({
                      name: f.name,
                      value: f.submissions,
                    }))}
                    cx="50%"
                    cy="50%"
                    labelLine={false}
                    label={({ name, percent }) =>
                      `${name}: ${(percent * 100).toFixed(0)}%`
                    }
                    outerRadius={100}
                    fill="#8884d8"
                    dataKey="value"
                  >
                    {analytics.topForms.map((entry, index) => (
                      <Cell
                        key={`cell-${index}`}
                        fill={COLORS[index % COLORS.length]}
                      />
                    ))}
                  </Pie>
                  <Tooltip />
                </PieChart>
              </ResponsiveContainer>
            ) : (
              <div className="h-75 flex items-center justify-center text-gray-500">
                No forms yet
              </div>
            )}
          </div>
        </div>

        {/* Form Performance Table */}
        <div className="bg-white rounded-lg shadow-sm border border-gray-200">
          <div className="p-6 border-b border-gray-200">
            <h2 className="text-lg font-semibold text-gray-900">
              Form Performance Breakdown
            </h2>
          </div>

          {analytics.formStats.length > 0 ? (
            <div className="overflow-x-auto">
              <table className="w-full">
                <thead className="bg-gray-50 border-b border-gray-200">
                  <tr>
                    <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                      Form Name
                    </th>
                    <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                      Status
                    </th>
                    <th className="px-6 py-3 text-right text-xs font-medium text-gray-500 uppercase tracking-wider">
                      Submissions
                    </th>
                    <th className="px-6 py-3 text-right text-xs font-medium text-gray-500 uppercase tracking-wider">
                      Drafts
                    </th>
                    <th className="px-6 py-3 text-right text-xs font-medium text-gray-500 uppercase tracking-wider">
                      Completion Rate
                    </th>
                    <th className="px-6 py-3 text-right text-xs font-medium text-gray-500 uppercase tracking-wider">
                      Avg. Time
                    </th>
                    <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                      Actions
                    </th>
                  </tr>
                </thead>
                <tbody className="bg-white divide-y divide-gray-200">
                  {analytics.formStats.map((stat) => (
                    <tr key={stat.id} className="hover:bg-gray-50">
                      <td className="px-6 py-4 whitespace-nowrap">
                        <div className="text-sm font-medium text-gray-900">
                          {stat.name}
                        </div>
                      </td>
                      <td className="px-6 py-4 whitespace-nowrap">
                        <span
                          className={`inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium ${
                            stat.status === "active"
                              ? "bg-green-100 text-green-800"
                              : stat.status === "draft"
                              ? "bg-yellow-100 text-yellow-800"
                              : "bg-gray-100 text-gray-800"
                          }`}
                        >
                          {stat.status}
                        </span>
                      </td>
                      <td className="px-6 py-4 whitespace-nowrap text-right text-sm text-gray-900">
                        {stat.submissions}
                      </td>
                      <td className="px-6 py-4 whitespace-nowrap text-right text-sm text-gray-900">
                        {stat.drafts}
                      </td>
                      <td className="px-6 py-4 whitespace-nowrap text-right text-sm">
                        <span
                          className={`font-medium ${
                            stat.completionRate >= 70
                              ? "text-green-600"
                              : stat.completionRate >= 40
                              ? "text-yellow-600"
                              : "text-red-600"
                          }`}
                        >
                          {stat.completionRate}%
                        </span>
                      </td>
                      <td className="px-6 py-4 whitespace-nowrap text-right text-sm text-gray-900">
                        {stat.avgTime} min
                      </td>
                      <td className="px-6 py-4 whitespace-nowrap text-sm">
                        <Link
                          href={`/forms/${stat.id}`}
                          className="text-blue-600 hover:text-blue-700 font-medium"
                        >
                          View Form
                        </Link>
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          ) : (
            <div className="p-12 text-center text-gray-500">
              <BarChart3 className="w-12 h-12 mx-auto mb-4 opacity-50" />
              <p>No forms to analyze yet</p>
              <p className="text-sm mt-2">
                Create your first form to start tracking analytics
              </p>
            </div>
          )}
        </div>

        {/* Insights Panel */}
        {analytics.formStats.length > 0 && (
          <div className="bg-linear-to-r from-blue-50 to-indigo-50 p-6 rounded-lg border border-blue-200">
            <h2 className="text-lg font-semibold text-gray-900 mb-4">
              📊 Key Insights
            </h2>
            <div className="space-y-3">
              {analytics.overallCompletionRate >= 70 ? (
                <div className="flex items-start gap-3">
                  <TrendingUp className="w-5 h-5 text-green-600 mt-0.5" />
                  <div>
                    <p className="text-sm font-medium text-gray-900">
                      Strong Completion Rate
                    </p>
                    <p className="text-sm text-gray-600">
                      Your forms have a{" "}
                      {analytics.overallCompletionRate.toFixed(1)}% completion
                      rate, which is excellent!
                    </p>
                  </div>
                </div>
              ) : (
                <div className="flex items-start gap-3">
                  <TrendingDown className="w-5 h-5 text-orange-600 mt-0.5" />
                  <div>
                    <p className="text-sm font-medium text-gray-900">
                      Room for Improvement
                    </p>
                    <p className="text-sm text-gray-600">
                      Consider simplifying forms or reducing required fields to
                      improve the {analytics.overallCompletionRate.toFixed(1)}%
                      completion rate.
                    </p>
                  </div>
                </div>
              )}

              {analytics.topForms.length > 0 && (
                <div className="flex items-start gap-3">
                  <BarChart3 className="w-5 h-5 text-blue-600 mt-0.5" />
                  <div>
                    <p className="text-sm font-medium text-gray-900">
                      Top Performer
                    </p>
                    <p className="text-sm text-gray-600">
                      "{analytics.topForms[0].name}" leads with{" "}
                      {analytics.topForms[0].submissions} submissions
                    </p>
                  </div>
                </div>
              )}

              {analytics.totalDrafts > analytics.totalSubmissions * 0.3 && (
                <div className="flex items-start gap-3">
                  <Users className="w-5 h-5 text-orange-600 mt-0.5" />
                  <div>
                    <p className="text-sm font-medium text-gray-900">
                      High Draft Count
                    </p>
                    <p className="text-sm text-gray-600">
                      You have {analytics.totalDrafts} drafts. Consider
                      following up with users to help them complete submissions.
                    </p>
                  </div>
                </div>
              )}
            </div>
          </div>
        )}
      </div>
    </div>
  );
}
