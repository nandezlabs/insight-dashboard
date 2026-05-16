"use client";

import { useList } from "@refinedev/core";
import Link from "next/link";
import {
  FileText,
  CheckCircle,
  TrendingUp,
  Activity,
  ArrowRight,
} from "lucide-react";
import ExportButton from "@/components/ExportButton";
import {
  PieChart,
  Pie,
  Cell,
  LineChart,
  Line,
  XAxis,
  YAxis,
  CartesianGrid,
  Tooltip,
  Legend,
  ResponsiveContainer,
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
  created_at: string;
  data: Record<string, any>;
}

export default function DashboardPage() {
  // Fetch forms
  const { query: formsQuery } = useList<FormTemplate>({
    resource: "form_templates",
    pagination: { pageSize: 100 },
  });

  // Fetch submissions
  const { query: submissionsQuery } = useList<Submission>({
    resource: "submissions",
    pagination: { pageSize: 1000 },
    sorters: [{ field: "created_at", order: "desc" }],
  });

  const forms = formsQuery.data?.data || [];
  const submissions = submissionsQuery.data?.data || [];

  // Calculate stats
  const stats = useMemo(() => {
    const activeFormCount = forms.filter((f) => f.status === "active").length;
    const totalSubmissions = submissions.length;

    // Get submissions from last 7 days
    const sevenDaysAgo = new Date();
    sevenDaysAgo.setDate(sevenDaysAgo.getDate() - 7);
    const recentSubmissions = submissions.filter(
      (s) => new Date(s.created_at) >= sevenDaysAgo
    );

    return {
      totalForms: forms.length,
      activeForms: activeFormCount,
      totalSubmissions,
      recentSubmissions: recentSubmissions.length,
    };
  }, [forms, submissions]);

  // Prepare forms by status data for pie chart
  const formsByStatus = useMemo(() => {
    const statusCounts = forms.reduce((acc, form) => {
      const status = form.status || "draft";
      acc[status] = (acc[status] || 0) + 1;
      return acc;
    }, {} as Record<string, number>);

    return Object.entries(statusCounts).map(([status, count]) => ({
      name: status.charAt(0).toUpperCase() + status.slice(1),
      value: count,
    }));
  }, [forms]);

  // Prepare submissions over time data for line chart
  const submissionsOverTime = useMemo(() => {
    const last30Days = Array.from({ length: 30 }, (_, i) => {
      const date = new Date();
      date.setDate(date.getDate() - (29 - i));
      return date.toISOString().split("T")[0];
    });

    const submissionsByDate = submissions.reduce((acc, submission) => {
      const date = submission.created_at.split("T")[0];
      acc[date] = (acc[date] || 0) + 1;
      return acc;
    }, {} as Record<string, number>);

    return last30Days.map((date) => ({
      date: new Date(date).toLocaleDateString("en-US", {
        month: "short",
        day: "numeric",
      }),
      submissions: submissionsByDate[date] || 0,
    }));
  }, [submissions]);

  // Recent submissions for table
  const recentSubmissions = submissions.slice(0, 5);

  const COLORS = ["#3b82f6", "#10b981", "#f59e0b", "#ef4444"];

  if (formsQuery.isLoading || submissionsQuery.isLoading) {
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
          <div>
            <h1 className="text-3xl font-bold text-gray-900">Dashboard</h1>
            <p className="text-gray-600 mt-1">
              Overview of your forms and submissions
            </p>
          <div className="flex gap-3">
            {submissions.length > 0 && <ExportButton />}
            <Link
              href="/forms/new"
              className="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors"
            >
              Create Form
            </Link>
          </divte Form
          </Link>
        </div>

        {/* Stats Cards */}
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
          <div className="bg-white p-6 rounded-lg shadow-sm border border-gray-200">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-sm text-gray-600 mb-1">Total Forms</p>
                <p className="text-3xl font-bold text-gray-900">
                  {stats.totalForms}
                </p>
              </div>
              <FileText className="w-12 h-12 text-blue-600 opacity-80" />
            </div>
            <p className="text-sm text-gray-500 mt-2">
              {stats.activeForms} active
            </p>
          </div>

          <div className="bg-white p-6 rounded-lg shadow-sm border border-gray-200">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-sm text-gray-600 mb-1">Total Submissions</p>
                <p className="text-3xl font-bold text-gray-900">
                  {stats.totalSubmissions}
                </p>
              </div>
              <CheckCircle className="w-12 h-12 text-green-600 opacity-80" />
            </div>
            <p className="text-sm text-gray-500 mt-2">All time</p>
          </div>

          <div className="bg-white p-6 rounded-lg shadow-sm border border-gray-200">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-sm text-gray-600 mb-1">Recent Activity</p>
                <p className="text-3xl font-bold text-gray-900">
                  {stats.recentSubmissions}
                </p>
              </div>
              <TrendingUp className="w-12 h-12 text-orange-600 opacity-80" />
            </div>
            <p className="text-sm text-gray-500 mt-2">Last 7 days</p>
          </div>

          <div className="bg-white p-6 rounded-lg shadow-sm border border-gray-200">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-sm text-gray-600 mb-1">Active Forms</p>
                <p className="text-3xl font-bold text-gray-900">
                  {stats.activeForms}
                </p>
              </div>
              <Activity className="w-12 h-12 text-purple-600 opacity-80" />
            </div>
            <p className="text-sm text-gray-500 mt-2">Ready to use</p>
          </div>
        </div>

        {/* Charts */}
        <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
          {/* Forms by Status Pie Chart */}
          <div className="bg-white p-6 rounded-lg shadow-sm border border-gray-200">
            <h2 className="text-lg font-semibold text-gray-900 mb-4">
              Forms by Status
            </h2>
            {formsByStatus.length > 0 ? (
              <ResponsiveContainer width="100%" height={300}>
                <PieChart>
                  <Pie
                    data={formsByStatus}
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
                    {formsByStatus.map((entry, index) => (
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

          {/* Submissions Over Time Line Chart */}
          <div className="bg-white p-6 rounded-lg shadow-sm border border-gray-200">
            <h2 className="text-lg font-semibold text-gray-900 mb-4">
              Submissions (Last 30 Days)
            </h2>
            {submissions.length > 0 ? (
              <ResponsiveContainer width="100%" height={300}>
                <LineChart data={submissionsOverTime}>
                  <CartesianGrid strokeDasharray="3 3" />
                  <XAxis
                    dataKey="date"
                    tick={{ fontSize: 12 }}
                    interval="preserveStartEnd"
                  />
                  <YAxis />
                  <Tooltip />
                  <Legend />
                  <Line
                    type="monotone"
                    dataKey="submissions"
                    stroke="#3b82f6"
                    strokeWidth={2}
                    dot={{ r: 4 }}
                    activeDot={{ r: 6 }}
                  />
                </LineChart>
              </ResponsiveContainer>
            ) : (
              <div className="h-75 flex items-center justify-center text-gray-500">
                No submissions yet
              </div>
            )}
          </div>
        </div>

        {/* Recent Submissions Table */}
        <div className="bg-white rounded-lg shadow-sm border border-gray-200">
          <div className="p-6 border-b border-gray-200">
            <div className="flex items-center justify-between">
              <h2 className="text-lg font-semibold text-gray-900">
                Recent Submissions
              </h2>
              <Link
                href="/submissions"
                className="text-blue-600 hover:text-blue-700 text-sm font-medium flex items-center gap-1"
              >
                View all
                <ArrowRight className="w-4 h-4" />
              </Link>
            </div>
          </div>

          {recentSubmissions.length > 0 ? (
            <div className="overflow-x-auto">
              <table className="w-full">
                <thead className="bg-gray-50 border-b border-gray-200">
                  <tr>
                    <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                      ID
                    </th>
                    <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                      Form
                    </th>
                    <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                      Submitted
                    </th>
                    <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                      Actions
                    </th>
                  </tr>
                </thead>
                <tbody className="bg-white divide-y divide-gray-200">
                  {recentSubmissions.map((submission) => {
                    const form = forms.find((f) => f.id === submission.form_id);
                    return (
                      <tr key={submission.id} className="hover:bg-gray-50">
                        <td className="px-6 py-4 whitespace-nowrap text-sm font-mono text-gray-900">
                          {submission.id.slice(0, 8)}...
                        </td>
                        <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                          {form?.name || "Unknown Form"}
                        </td>
                        <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                          {new Date(submission.created_at).toLocaleDateString(
                            "en-US",
                            {
                              year: "numeric",
                              month: "short",
                              day: "numeric",
                              hour: "2-digit",
                              minute: "2-digit",
                            }
                          )}
                        </td>
                        <td className="px-6 py-4 whitespace-nowrap text-sm">
                          <Link
                            href={`/submissions/${submission.id}`}
                            className="text-blue-600 hover:text-blue-700 font-medium"
                          >
                            View
                          </Link>
                        </td>
                      </tr>
                    );
                  })}
                </tbody>
              </table>
            </div>
          ) : (
            <div className="p-12 text-center text-gray-500">
              <CheckCircle className="w-12 h-12 mx-auto mb-4 opacity-50" />
              <p>No submissions yet</p>
              <p className="text-sm mt-2">
                Start collecting data by creating and sharing forms
              </p>
            </div>
          )}
        </div>
      </div>
    </div>
  );
}
