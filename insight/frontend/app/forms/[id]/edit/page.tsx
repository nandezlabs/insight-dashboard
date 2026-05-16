"use client";

import { useState, useEffect, useRef } from "react";
import { useRouter, useParams } from "next/navigation";
import { useOne, useUpdate } from "@refinedev/core";
import { ArrowLeft, Save } from "lucide-react";
import Link from "next/link";
import dynamic from "next/dynamic";

const SurveyCreatorComponent = dynamic(
  () => import("survey-creator-react").then((mod) => mod.SurveyCreatorComponent),
  {
    ssr: false,
    loading: () => (
      <div className="flex items-center justify-center p-12 bg-white rounded-lg">
        <div className="text-gray-600">Loading form builder...</div>
      </div>
    ),
  }
);

export default function EditFormPage() {
  const router = useRouter();
  const params = useParams();
  const formId = params?.id as string;

  const { query } = useOne({
    resource: "form_templates",
    id: formId,
  });

  const { data: formData, isLoading: isLoadingForm } = query || {};

  const { mutate: updateForm, isLoading: isUpdating } = useUpdate();

  const [formStatus, setFormStatus] = useState<"draft" | "active">("draft");
  const [creator, setCreator] = useState<any>(null);
  const [mounted, setMounted] = useState(false);
  const creatorInitialized = useRef(false);

  useEffect(() => {
    setMounted(true);
  }, []);

  useEffect(() => {
    if (formData?.data && typeof window !== "undefined" && !creatorInitialized.current) {
      creatorInitialized.current = true;
      
      setFormStatus(formData.data.status || "draft");

      // Import Survey Creator dynamically on client side
      import("survey-creator-core").then(({ SurveyCreatorModel }) => {
        const options = {
          showLogicTab: true,
          showTranslationTab: false,
          showJSONEditorTab: false,
        };
        const creatorInstance = new SurveyCreatorModel(options);
        
        // Load existing schema or create default
        const existingSchema = formData.data.schema || {
          pages: [
            {
              name: "page1",
              elements: [],
            },
          ],
        };
        
        creatorInstance.JSON = existingSchema;
        setCreator(creatorInstance);
      }).catch((error) => {
        console.error("Failed to load Survey Creator:", error);
        creatorInitialized.current = false; // Allow retry on error
      });
    }
  }, [formData]);

  const handleSave = () => {
    if (!creator) {
      alert("Form builder is still loading");
      return;
    }

    const schema = creator.JSON;
    // Get the survey title from Survey.js schema, fallback to "Untitled Form"
    const surveyTitle = schema.title?.trim() || "Untitled Form";

    updateForm(
      {
        resource: "form_templates",
        id: formId,
        values: {
          name: surveyTitle,
          schema: schema,
          status: formStatus,
        },
      },
      {
        onSuccess: () => {
          router.push("/forms");
        },
        onError: (error) => {
          console.error("Error updating form:", error);
          alert("Failed to update form. Please try again.");
        },
      }
    );
  };

  if (!mounted || isLoadingForm) {
    return (
      <div className="min-h-screen bg-gray-50 flex items-center justify-center">
        <div className="text-gray-600">Loading form builder...</div>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-gray-50">
      {/* Header */}
      <header className="bg-white shadow-sm border-b border-gray-200">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-4">
          <div className="flex items-center justify-between">
            <div className="flex items-center gap-4">
              <Link
                href="/forms"
                className="p-2 hover:bg-gray-100 rounded-lg transition-colors"
              >
                <ArrowLeft className="w-5 h-5 text-gray-600" />
              </Link>
              <div>
                <h1 className="text-3xl font-bold text-gray-900">Edit Form</h1>
                <p className="mt-1 text-sm text-gray-500">
                  Drag and drop components to build your form
                </p>
              </div>
            </div>
            <button
              onClick={handleSave}
              disabled={isUpdating}
              className="inline-flex items-center px-6 py-3 bg-blue-600 hover:bg-blue-700 disabled:bg-gray-400 text-white rounded-lg transition-colors"
            >
              <Save className="w-5 h-5 mr-2" />
              {isUpdating ? "Saving..." : "Save Changes"}
            </button>
          </div>
        </div>
      </header>

      {/* Main Content */}
      <main className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        {/* Form Settings */}
        <div className="bg-white rounded-lg shadow p-6 mb-6">
          <div className="flex items-center justify-between">
            <div>
              <h2 className="text-lg font-semibold text-gray-900">
                Publish Settings
              </h2>
              <p className="text-sm text-gray-500 mt-1">
                Set the survey title in the builder below. Use this to control publishing.
              </p>
            </div>
            <div className="w-48">
              <label className="block text-sm font-medium text-gray-700 mb-2">
                Status
              </label>
              <select
                value={formStatus}
                onChange={(e) =>
                  setFormStatus(e.target.value as "draft" | "active")
                }
                className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
              >
                <option value="draft">Draft</option>
                <option value="active">Active</option>
              </select>
            </div>
          </div>
        </div>

        {/* Survey.js Form Builder */}
        <div className="bg-white rounded-lg shadow overflow-hidden" style={{ minHeight: "600px" }}>
          {creator && <SurveyCreatorComponent creator={creator} />}
        </div>
      </main>
    </div>
  );
}
