"use client";

import { useState, useEffect } from "react";
import { useRouter } from "next/navigation";
import { useCreate } from "@refinedev/core";
import { ArrowLeft, Save } from "lucide-react";
import Link from "next/link";
import dynamic from "next/dynamic";

const FormBuilder = dynamic(
  () => import("@formio/react").then((mod) => mod.FormBuilder),
  {
    ssr: false,
    loading: () => (
      <div className="flex items-center justify-center p-12">
        <div className="text-gray-600">Loading form builder...</div>
      </div>
    ),
  }
);

export default function NewFormPage() {
  const router = useRouter();
  const { mutate: createForm, isLoading } = useCreate();
  const [formName, setFormName] = useState("");
  const [formStatus, setFormStatus] = useState<"draft" | "active">("draft");
  const [schema, setSchema] = useState<any>({ components: [] });
  const [mounted, setMounted] = useState(false);

  useEffect(() => {
    setMounted(true);
  }, []);

  const handleSave = () => {
    if (!formName.trim()) {
      alert("Please enter a form name");
      return;
    }

    createForm(
      {
        resource: "form_templates",
        values: {
          name: formName,
          schema: schema,
          status: formStatus,
        },
      },
      {
        onSuccess: () => {
          router.push("/forms");
        },
        onError: (error) => {
          console.error("Error creating form:", error);
          alert("Failed to create form. Please try again.");
        },
      }
    );
  };

  const handleSchemaChange = (newSchema: any) => {
    setSchema(newSchema);
  };

  if (!mounted) {
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
                <h1 className="text-3xl font-bold text-gray-900">
                  Create New Form
                </h1>
                <p className="mt-1 text-sm text-gray-500">
                  Drag and drop components to build your form
                </p>
              </div>
            </div>
            <button
              onClick={handleSave}
              disabled={isLoading}
              className="inline-flex items-center px-6 py-3 bg-blue-600 hover:bg-blue-700 disabled:bg-gray-400 text-white rounded-lg transition-colors"
            >
              <Save className="w-5 h-5 mr-2" />
              {isLoading ? "Saving..." : "Save Form"}
            </button>
          </div>
        </div>
      </header>

      {/* Main Content */}
      <main className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        {/* Form Settings */}
        <div className="bg-white rounded-lg shadow p-6 mb-6">
          <h2 className="text-lg font-semibold text-gray-900 mb-4">
            Form Settings
          </h2>
          <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-2">
                Form Name *
              </label>
              <input
                type="text"
                value={formName}
                onChange={(e) => setFormName(e.target.value)}
                placeholder="e.g., Inventory Check Form"
                className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
              />
            </div>
            <div>
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

        {/* FormIO Form Builder */}
        <div className="bg-white rounded-lg shadow overflow-hidden">
          <FormBuilder
            form={schema}
            onChange={handleSchemaChange}
            options={{
              builder: {
                basic: true,
                advanced: true,
                data: true,
                layout: true,
                premium: false,
              },
              editForm: {
                textfield: [
                  {
                    key: "display",
                    components: [
                      { key: "placeholder", ignore: false },
                      { key: "description", ignore: false },
                      { key: "tooltip", ignore: false },
                      { key: "customClass", ignore: false },
                    ],
                  },
                  {
                    key: "validation",
                    components: [
                      { key: "required", ignore: false },
                      { key: "minLength", ignore: false },
                      { key: "maxLength", ignore: false },
                      { key: "pattern", ignore: false },
                    ],
                  },
                ],
              },
            }}
          />
        </div>
      </main>
    </div>
  );
}
