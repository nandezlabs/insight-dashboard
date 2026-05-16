"use client";

import { useEffect, useState, useCallback } from "react";
import { useParams, useRouter } from "next/navigation";
import { useOne, useCreate } from "@refinedev/core";
import { Form } from "@formio/react";
import { ArrowLeft, Save, CheckCircle } from "lucide-react";
import Link from "next/link";
import {
  useTrackFormView,
  useTrackFormStart,
  useTrackFormAbandon,
  trackFormComplete,
} from "@/lib/analytics";

interface FormTemplate {
  id: string;
  name: string;
  version: number;
  schema: any;
  status: string;
}

export default function FillFormPage() {
  const params = useParams();
  const router = useRouter();
  const [hasStarted, setHasStarted] = useState(false);
  const [hasCompleted, setHasCompleted] = useState(false);

  // Analytics tracking
  useTrackFormView(formId);
  const trackStart = useTrackFormStart(formId);
  useTrackFormAbandon(formId, hasStarted, hasCompleted);
  const formId = params.id as string;

  const [formData, setFormData] = useState<any>({});
  const [isDirty, setIsDirty] = useState(false);
  const [lastSaved, setLastSaved] = useState<Date | null>(null);
  const [isSubmitting, setIsSubmitting] = useState(false);

  // Fetch form template
  const { query: formQuery } = useOne<FormTemplate>({
    resource: "form_templates",
    id: formId,
  });

  // Fetch existing draft
  const { query: draftQuery } = useOne({
    resource: "form_drafts",
    id: formId,
  });

  const { mutate: saveDraft } = useCreate();
  const { mutate: createSubmission } = useCreate();

  const form = formQuery.data?.data;
  const draft = draftQuery.data?.data;

  // Load draft data when available
  useEffect(() => {
    if (draft?.data && Object.keys(formData).length === 0) {
      setFormData(draft.data);
    }
  }, [draft, formData]);

  // Auto-save draft every 2 seconds when dirty
  useEffect(() => {
    if (!isDirty) return;

    const timer = setTimeout(() => {
      saveDraft(
        {
          resource: "form_drafts",
          values: {
            form_id: formId,
            data: formData,
          },
        },
        {
          onSuccess: () => {
            setIsDirty(false);
            setLastSaved(new Date());
          },
        },
      );
    }, 2000);
  
    // Track form start on first interaction
    if (!hasStarted) {
      setHasStarted(true);
      trackStart();
    }setHasCompleted(true);
      
      // Track completion
      trackFormComplete(formId, {
        field_count: Object.keys(submission.data).length,
      });
      
      createSubmission(
        {
          resource: "submissions",
          values: {
            form_id: formId,
            data: submission.data,
          },
        },
        {
          onSuccess: () => {
            router.push("/forms?submitted=true");
          },
          onError: (error) => {
            console.error("Submission error:", error);
            alert("Failed to submit form. Please try again.");
            setIsSubmitting(false);
            setHasCompletedsions",
          values: {
            form_id: formId,
            data: submission.data,
          },
        },
        {
          onSuccess: () => {
            router.push("/forms?submitted=true");
          },
          onError: (error) => {
            console.error("Submission error:", error);
            alert("Failed to submit form. Please try again.");
            setIsSubmitting(false);
          },
        },
      );
    },
    [formId, createSubmission, router],
  );

  if (formQuery.isLoading || draftQuery.isLoading) {
    return (
      <div className="min-h-screen bg-gray-50 flex items-center justify-center">
        <div className="text-center">
          <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-600 mx-auto"></div>
          <p className="mt-4 text-gray-600">Loading form...</p>
        </div>
      </div>
    );
  }

  if (formQuery.isError || !form) {
    return (
      <div className="min-h-screen bg-gray-50 p-6">
        <div className="max-w-3xl mx-auto">
          <div className="bg-red-50 border border-red-200 rounded-lg p-6">
            <h2 className="text-lg font-semibold text-red-800 mb-2">
              Form Not Found
            </h2>
            <p className="text-red-600 mb-4">
              The form you're looking for doesn't exist or has been archived.
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

  if (form.status !== "active") {
    return (
      <div className="min-h-screen bg-gray-50 p-6">
        <div className="max-w-3xl mx-auto">
          <div className="bg-yellow-50 border border-yellow-200 rounded-lg p-6">
            <h2 className="text-lg font-semibold text-yellow-800 mb-2">
              Form Not Active
            </h2>
            <p className="text-yellow-600 mb-4">
              This form is currently {form.status} and cannot be filled out.
            </p>
            <Link
              href="/forms"
              className="inline-flex items-center text-yellow-700 hover:text-yellow-900"
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
      <header className="bg-white border-b border-gray-200 sticky top-0 z-10">
        <div className="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 py-4">
          <div className="flex items-center justify-between">
            <div className="flex items-center gap-4">
              <Link
                href="/forms"
                className="p-2 hover:bg-gray-100 rounded-lg transition-colors"
              >
                <ArrowLeft className="w-5 h-5 text-gray-600" />
              </Link>
              <div>
                <h1 className="text-xl font-bold text-gray-900">{form.name}</h1>
                <div className="flex items-center gap-3 mt-1">
                  <span className="text-xs text-gray-500">
                    Version {form.version}
                  </span>
                  {lastSaved && (
                    <span className="flex items-center text-xs text-green-600">
                      <CheckCircle className="w-3 h-3 mr-1" />
                      Saved {lastSaved.toLocaleTimeString()}
                    </span>
                  )}
                  {isDirty && (
                    <span className="flex items-center text-xs text-gray-500">
                      <Save className="w-3 h-3 mr-1 animate-pulse" />
                      Saving...
                    </span>
                  )}
                </div>
              </div>
            </div>
          </div>
        </div>
      </header>

      {/* Main Content */}
      <main className="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <div className="bg-white rounded-lg shadow-sm p-6">
          <Form
            form={form.schema}
            submission={{ data: formData }}
            onChange={handleChange}
            onSubmit={handleSubmit}
            options={{
              readOnly: isSubmitting,
              buttonSettings: {
                showCancel: false,
              },
            }}
          />
          {isSubmitting && (
            <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
              <div className="bg-white rounded-lg p-8 text-center">
                <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-600 mx-auto"></div>
                <p className="mt-4 text-gray-600">Submitting form...</p>
              </div>
            </div>
          )}
        </div>
      </main>
    </div>
  );
}
