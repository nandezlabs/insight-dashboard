"use client";

import { useState, useEffect, useRef } from "react";
import { useRouter, useParams } from "next/navigation";
import { useOne, useUpdate, useCreate, useList } from "@refinedev/core";
import { ArrowLeft, Save, Upload } from "lucide-react";
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

  // Load published form
  const { query: publishedQuery } = useOne({
    resource: "form_templates",
    id: formId,
  });
  const { data: publishedForm, isLoading: isLoadingPublished } = publishedQuery || {};

  // Load draft (if exists)
  const { data: draftData, isLoading: isLoadingDraft } = useList({
    resource: "form_drafts",
    filters: [{ field: "form_id", operator: "eq", value: formId }],
  });

  const { mutate: updateForm } = useUpdate();
  const { mutate: createDraft } = useCreate();
  const { mutate: updateDraft } = useUpdate();

  const [creator, setCreator] = useState<any>(null);
  const [mounted, setMounted] = useState(false);
  const [hasDraft, setHasDraft] = useState(false);
  const [draftId, setDraftId] = useState<string | null>(null);
  const [isSavingDraft, setIsSavingDraft] = useState(false);
  const [isPublishing, setIsPublishing] = useState(false);
  const creatorInitialized = useRef(false);

  useEffect(() => {
    setMounted(true);
  }, []);

  // Initialize creator with draft or published form
  useEffect(() => {
    if (
      (publishedForm?.data || draftData?.data) &&
      typeof window !== "undefined" &&
      !creatorInitialized.current
    ) {
      creatorInitialized.current = true;

      // Check if draft exists
      const draft = draftData?.data?.[0];
      const schemaToLoad = draft?.data || publishedForm?.data.schema;
      
      if (draft) {
        setHasDraft(true);
        setDraftId(draft.id);
      }

      // Import Survey Creator dynamically
      import("survey-creator-core")
        .then(({ SurveyCreatorModel }) => {
          const options = {
            showLogicTab: true,
            showTranslationTab: false,
            showJSONEditorTab: false,
          };
          const creatorInstance = new SurveyCreatorModel(options);

          const existingSchema = schemaToLoad || {
            pages: [{ name: "page1", elements: [] }],
          };

          creatorInstance.JSON = existingSchema;
          setCreator(creatorInstance);
        })
        .catch((error) => {
          console.error("Failed to load Survey Creator:", error);
          creatorInitialized.current = false;
        });
    }
  }, [publishedForm, draftData]);

  // Save draft (doesn't affect published version)
  const handleSaveDraft = () => {
    if (!creator) {
      alert("Form builder is still loading");
      return;
    }

    setIsSavingDraft(true);
    const schema = creator.JSON;

    if (draftId) {
      // Update existing draft
      updateDraft(
        {
          resource: "form_drafts",
          id: draftId,
          values: { data: schema, updated_at: new Date().toISOString() },
        },
        {
          onSuccess: () => {
            setIsSavingDraft(false);
            // Show brief success message
            const msg = document.createElement("div");
            msg.className = "fixed top-4 right-4 bg-green-500 text-white px-4 py-2 rounded-lg shadow-lg z-50";
            msg.textContent = "Draft saved";
            document.body.appendChild(msg);
            setTimeout(() => msg.remove(), 2000);
          },
          onError: (error) => {
            setIsSavingDraft(false);
            console.error("Error saving draft:", error);
            alert("Failed to save draft");
          },
        }
      );
    } else {
      // Create new draft
      createDraft(
        {
          resource: "form_drafts",
          values: {
            form_id: formId,
            data: schema,
            updated_at: new Date().toISOString(),
          },
        },
        {
          onSuccess: (data) => {
            setIsSavingDraft(false);
            setHasDraft(true);
            setDraftId(data?.data?.id || null);
            // Show brief success message
            const msg = document.createElement("div");
            msg.className = "fixed top-4 right-4 bg-green-500 text-white px-4 py-2 rounded-lg shadow-lg z-50";
            msg.textContent = "Draft saved";
            document.body.appendChild(msg);
            setTimeout(() => msg.remove(), 2000);
          },
          onError: (error) => {
            setIsSavingDraft(false);
            console.error("Error creating draft:", error);
            alert("Failed to save draft");
          },
        }
      );
    }
  };

  // Publish (creates new version)
  const handlePublish = () => {
    if (!creator) {
      alert("Form builder is still loading");
      return;
    }

    if (!confirm("Publish this version? This will create a new version and make it live.")) {
      return;
    }

    setIsPublishing(true);
    const schema = creator.JSON;
    const surveyTitle = schema.title?.trim() || "Untitled Form";
    const currentVersion = publishedForm?.data?.version || 1;

    updateForm(
      {
        resource: "form_templates",
        id: formId,
        values: {
          name: surveyTitle,
          schema: schema,
          version: currentVersion + 1,
          status: "active",
        },
      },
      {
        onSuccess: () => {
          // Delete draft after publishing
          if (draftId) {
            updateDraft(
              {
                resource: "form_drafts",
                id: draftId,
                values: { data: {} }, // Clear it
              },
              {
                onSuccess: () => {
                  setIsPublishing(false);
                  router.push("/forms");
                },
                onError: () => {
                  setIsPublishing(false);
                  router.push("/forms");
                },
              }
            );
          } else {
            setIsPublishing(false);
            router.push("/forms");
          }
        },
        onError: (error) => {
          setIsPublishing(false);
          console.error("Error publishing form:", error);
          alert("Failed to publish form. Please try again.");
        },
      }
    );
  };

  if (!mounted || isLoadingPublished || isLoadingDraft) {
    return (
      <div className="min-h-screen bg-gray-50 flex items-center justify-center">
        <div className="text-gray-600">Loading form builder...</div>
      </div>
    );
  }

  const currentVersion = publishedForm?.data?.version || 1;

  return (
    <div className="min-h-screen bg-gray-50">
      {/* Compact Header */}
      <header className="bg-white border-b border-gray-200">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="flex items-center justify-between h-14">
            <div className="flex items-center gap-3">
              <Link
                href="/forms"
                className="p-1.5 hover:bg-gray-100 rounded-lg transition-colors"
              >
                <ArrowLeft className="w-5 h-5 text-gray-600" />
              </Link>
              <div className="flex items-center gap-3">
                <span className="text-sm font-medium text-gray-900">
                  {publishedForm?.data?.name || "Untitled Form"}
                </span>
                <span className="px-2 py-0.5 text-xs font-medium bg-blue-100 text-blue-800 rounded">
                  Published: v{currentVersion}
                </span>
                {hasDraft && (
                  <span className="px-2 py-0.5 text-xs font-medium bg-amber-100 text-amber-800 rounded">
                    Editing Draft
                  </span>
                )}
              </div>
            </div>
            <div className="flex items-center gap-2">
              <button
                onClick={handleSaveDraft}
                disabled={isSavingDraft}
                className="inline-flex items-center px-4 py-2 text-sm bg-white hover:bg-gray-50 border border-gray-300 text-gray-700 rounded-lg transition-colors disabled:opacity-50"
              >
                <Save className="w-4 h-4 mr-1.5" />
                {isSavingDraft ? "Saving..." : "Save Draft"}
              </button>
              <button
                onClick={handlePublish}
                disabled={isPublishing}
                className="inline-flex items-center px-4 py-2 text-sm bg-blue-600 hover:bg-blue-700 disabled:bg-gray-400 text-white rounded-lg transition-colors"
              >
                <Upload className="w-4 h-4 mr-1.5" />
                {isPublishing ? "Publishing..." : `Publish v${currentVersion + 1}`}
              </button>
            </div>
          </div>
        </div>
      </header>

      {/* Main Content - Full height form builder */}
      <main className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-4">
        <div
          className="bg-white rounded-lg shadow overflow-hidden"
          style={{ minHeight: "calc(100vh - 120px)" }}
        >
          {creator && <SurveyCreatorComponent creator={creator} />}
        </div>
      </main>
    </div>
  );
}
