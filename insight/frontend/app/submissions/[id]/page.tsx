"use client";

import { useParams } from "next/navigation";
import { useOne } from "@refinedev/core";
import { ArrowLeft, Calendar, FileText, Hash } from "lucide-react";
import Link from "next/link";

interface Submission {
  id: string;
  form_id: string;
  form_version: number;
  data: Record<string, any>;
  created_at: string;
}

interface FormTemplate {
  id: string;
  name: string;
  schema: any;
}

export default function SubmissionViewPage() {
  const params = useParams();
  const submissionId = params.id as string;

  const { query: submissionQuery } = useOne<Submission>({
    resource: "submissions",
    id: submissionId,
  });

  const submission = submissionQuery.data?.data;

  // Fetch form template details
  const { query: formQuery } = useOne<FormTemplate>({
    resource: "form_templates",
    id: submission?.form_id || "",
    queryOptions: {
      enabled: !!submission?.form_id,
    },
  });

  const form = formQuery.data?.data;

  if (submissionQuery.isLoading) {
    return (
      <div className="min-h-screen bg-gray-50 flex items-center justify-center">
        <div className="text-center">
          <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-600 mx-auto"></div>
          <p className="mt-4 text-gray-600">Loading submission...</p>
        </div>
      </div>
    );
  }

  if (submissionQuery.isError || !submission) {
    return (
      <div className="min-h-screen bg-gray-50 p-6">
        <div className="max-w-3xl mx-auto">
          <div className="bg-red-50 border border-red-200 rounded-lg p-6">
            <h2 className="text-lg font-semibold text-red-800 mb-2">
              Submission Not Found
            </h2>
            <p className="text-red-600 mb-4">
              The submission you're looking for doesn't exist.
            </p>
            <Link
              href="/forms"
              className="inline-flex items-center text-red-700 hover:text-red-900"
            >
              <ArrowLeft className="w-4 h-4 mr-2" />
              Back to Forms
            </Link>
          </div>
        </div>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-gray-50">
      {/* Header */}
      <header className="bg-white border-b border-gray-200">
        <div className="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 py-6">
          <div className="flex items-center gap-4">
            <Link
              href="/forms"
              className="p-2 hover:bg-gray-100 rounded-lg transition-colors"
            >
              <ArrowLeft className="w-5 h-5 text-gray-600" />
            </Link>
            <div>
              <h1 className="text-2xl font-bold text-gray-900">
                {form?.name || "Form Submission"}
              </h1>
              <p className="mt-1 text-sm text-gray-500">Submission Details</p>
            </div>
          </div>
        </div>
      </header>

      {/* Main Content */}
      <main className="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        {/* Metadata Card */}
        <div className="bg-white rounded-lg shadow-sm p-6 mb-6">
          <h2 className="text-lg font-semibold text-gray-900 mb-4">
            Submission Info
          </h2>
          <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
            <div className="flex items-start gap-3">
              <Hash className="w-5 h-5 text-gray-400 mt-0.5" />
              <div>
                <p className="text-xs font-medium text-gray-500">ID</p>
                <p className="text-sm text-gray-900 font-mono">
                  {submission.id.slice(0, 8)}...
                </p>
              </div>
            </div>
            <div className="flex items-start gap-3">
              <Calendar className="w-5 h-5 text-gray-400 mt-0.5" />
              <div>
                <p className="text-xs font-medium text-gray-500">Submitted</p>
                <p className="text-sm text-gray-900">
                  {new Date(submission.created_at).toLocaleString()}
                </p>
              </div>
            </div>
            <div className="flex items-start gap-3">
              <FileText className="w-5 h-5 text-gray-400 mt-0.5" />
              <div>
                <p className="text-xs font-medium text-gray-500">
                  Form Version
                </p>
                <p className="text-sm text-gray-900">
                  v{submission.form_version}
                </p>
              </div>
            </div>
          </div>
        </div>

        {/* Submission Data */}
        <div className="bg-white rounded-lg shadow-sm p-6">
          <h2 className="text-lg font-semibold text-gray-900 mb-4">
            Submitted Data
          </h2>

          {form?.schema?.components ? (
            <div className="space-y-6">
              {form.schema.components.map((component: any) => {
                const value = submission.data[component.key];
                return (
                  <div
                    key={component.key}
                    className="border-b border-gray-200 pb-4 last:border-0"
                  >
                    <label className="block text-sm font-medium text-gray-700 mb-2">
                      {component.label}
                      {component.validate?.required && (
                        <span className="text-red-500 ml-1">*</span>
                      )}
                    </label>
                    <div className="text-gray-900">
                      {component.type === "checkbox" ? (
                        <span
                          className={value ? "text-green-600" : "text-gray-400"}
                        >
                          {value ? "✓ Yes" : "✗ No"}
                        </span>
                      ) : component.type === "file" ? (
                        <div className="bg-gray-50 p-3 rounded-lg">
                          {value && Array.isArray(value) && value.length > 0 ? (
                            <div className="space-y-2">
                              {value.map((file: any, idx: number) => (
                                <div
                                  key={idx}
                                  className="flex items-center gap-2 p-2 bg-white rounded border border-gray-200"
                                >
                                  <FileText className="w-4 h-4 text-blue-600" />
                                  <div className="flex-1 min-w-0">
                                    <p className="text-sm font-medium text-gray-900 truncate">
                                      {file.originalName || file.name || `File ${idx + 1}`}
                                    </p>
                                    {file.size && (
                                      <p className="text-xs text-gray-500">
                                        {(file.size / 1024).toFixed(2)} KB
                                      </p>
                                    )}
                                  </div>
                                  {file.url && (
                                    <a
                                      href={file.url}
                                      download={file.originalName || file.name}
                                      className="px-3 py-1 text-xs bg-blue-600 text-white rounded hover:bg-blue-700"
                                    >
                                      Download
                                    </a>
                                  )}
                                </div>
                              ))}
                            </div>
                          ) : (
                            <span className="text-gray-400 italic">
                              No file uploaded
                            </span>
                          )}
                        </div>
                      ) : component.type === "textarea" ? (
                        <p className="whitespace-pre-wrap bg-gray-50 p-3 rounded-lg">
                          {value || (
                            <span className="text-gray-400 italic">
                              No response
                            </span>
                          )}
                        </p>
                      ) : (
                        <p className="bg-gray-50 p-3 rounded-lg">
                          {value || (
                            <span className="text-gray-400 italic">
                              No response
                            </span>
                          )}
                        </p>
                      )}
                    </div>
                  </div>
                );
              })}
            </div>
          ) : (
            <div className="space-y-4">
              {Object.entries(submission.data).map(([key, value]) => (
                <div
                  key={key}
                  className="border-b border-gray-200 pb-4 last:border-0"
                >
                  <label className="block text-sm font-medium text-gray-700 mb-2">
                    {key}
                  </label>
                  <p className="text-gray-900 bg-gray-50 p-3 rounded-lg">
                    {String(value)}
                  </p>
                </div>
              ))}
            </div>
          )}
        </div>

        {/* Actions */}
        <div className="mt-6 flex justify-end gap-3">
          <Link
            href={`/forms/${submission.form_id}`}
            className="px-4 py-2 text-sm text-gray-700 hover:bg-gray-100 rounded-lg transition-colors"
          >
            View Form
          </Link>
          <button
            onClick={() => window.print()}
            className="px-4 py-2 text-sm bg-blue-600 hover:bg-blue-700 text-white rounded-lg transition-colors"
          >
            Print
          </button>
        </div>
      </main>
    </div>
  );
}
