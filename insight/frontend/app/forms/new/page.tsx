"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";
import { useCreate } from "@refinedev/core";
import { ArrowLeft, Plus, Trash2, Save, X } from "lucide-react";
import Link from "next/link";

interface FormField {
  key: string;
  label: string;
  type:
    | "textfield"
    | "number"
    | "textarea"
    | "select"
    | "checkbox"
    | "date"
    | "file";
  required?: boolean;
  placeholder?: string;
  options?: string[];
  acceptedFileTypes?: string;
}

export default function NewFormPage() {
  const router = useRouter();
  const { mutate: createForm, isLoading } = useCreate();

  const [formName, setFormName] = useState("");
  const [formStatus, setFormStatus] = useState<"draft" | "active">("draft");
  const [fields, setFields] = useState<FormField[]>([]);

  const addField = () => {
    setFields([
      ...fields,
      {
        key: `field_${Date.now()}`,
        label: "",
        type: "textfield",
        required: false,
        placeholder: "",
      },
    ]);
  };

  const updateField = (index: number, updates: Partial<FormField>) => {
    const newFields = [...fields];
    newFields[index] = { ...newFields[index], ...updates };
    setFields(newFields);
  };

  const removeField = (index: number) => {
    setFields(fields.filter((_, i) => i !== index));
  };

  const handleSave = () => {
    if (!formName.trim()) {
      alert("Please enter a form name");
      return;
    }

    if (fields.length === 0) {
      alert("Please add at least one field");
      return;
    }

    // Validate all fields have labels
    const invalidFields = fields.filter((f) => !f.label.trim());
    if (invalidFields.length > 0) {
      alert("All fields must have labels");
      return;
    }

    // Create FormIO.js schema
    const schema = {
      components: fields.map((field) => ({
        key: field.key,
        label: field.label,
        type: field.type,
        input: true,
        validate: {
          required: field.required,
        },
        placeholder: field.placeholder || "",
        ...(field.type === "select" && {
          data: {
            values: (field.options || []).map((opt) => ({
              label: opt,
              value: opt,
            })),
          },
        }),
        ...(field.type === "file" && {
          storage: "base64",
          filePattern: field.acceptedFileTypes || "*",
          fileMaxSize: "10MB",
        }),
      })),
    };

    createForm(
      {
        resource: "form_templates",
        values: {
          name: formName,
          schema,
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
      },
    );
  };

  return (
    <div className="min-h-screen bg-gray-50">
      {/* Header */}
      <header className="bg-white border-b border-gray-200">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-6">
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
                  Build your form by adding fields
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
        <div className="grid grid-cols-1 lg:grid-cols-3 gap-8">
          {/* Form Builder */}
          <div className="lg:col-span-2 space-y-6">
            {/* Form Settings */}
            <div className="bg-white rounded-lg shadow p-6">
              <h2 className="text-lg font-semibold text-gray-900 mb-4">
                Form Settings
              </h2>
              <div className="space-y-4">
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

            {/* Fields */}
            <div className="bg-white rounded-lg shadow p-6">
              <div className="flex justify-between items-center mb-4">
                <h2 className="text-lg font-semibold text-gray-900">
                  Form Fields
                </h2>
                <button
                  onClick={addField}
                  className="inline-flex items-center px-4 py-2 bg-blue-600 hover:bg-blue-700 text-white rounded-lg transition-colors text-sm"
                >
                  <Plus className="w-4 h-4 mr-2" />
                  Add Field
                </button>
              </div>

              {fields.length === 0 ? (
                <div className="text-center py-12 border-2 border-dashed border-gray-300 rounded-lg">
                  <p className="text-gray-500 mb-4">No fields added yet</p>
                  <button
                    onClick={addField}
                    className="inline-flex items-center px-4 py-2 bg-blue-600 hover:bg-blue-700 text-white rounded-lg transition-colors"
                  >
                    <Plus className="w-4 h-4 mr-2" />
                    Add First Field
                  </button>
                </div>
              ) : (
                <div className="space-y-4">
                  {fields.map((field, index) => (
                    <div
                      key={field.key}
                      className="border border-gray-200 rounded-lg p-4 space-y-3"
                    >
                      <div className="flex justify-between items-start">
                        <span className="text-sm font-medium text-gray-500">
                          Field {index + 1}
                        </span>
                        <button
                          onClick={() => removeField(index)}
                          className="text-red-600 hover:text-red-700 p-1"
                        >
                          <Trash2 className="w-4 h-4" />
                        </button>
                      </div>

                      <div className="grid grid-cols-2 gap-3">
                        <div>
                          <label className="block text-xs font-medium text-gray-700 mb-1">
                            Label *
                          </label>
                          <input
                            type="text"
                            value={field.label}
                            onChange={(e) =>
                              updateField(index, { label: e.target.value })
                            }
                            placeholder="e.g., Product Name"
                            className="w-full px-3 py-2 text-sm border border-gray-300 rounded-lg"
                          />
                        </div>
                        <div>
                          <label className="block text-xs font-medium text-gray-700 mb-1">
                            Type
                          </label>
                          <select
                            value={field.type}
                            onChange={(e) =>
                              updateField(index, {
                                type: e.target.value as FormField["type"],
                              })
                            }
                            className="w-full px-3 py-2 text-sm border border-gray-300 rounded-lg"
                          >
                            <option value="textfield">Text</option>
                            <option value="number">Number</option>
                            <option value="textarea">Textarea</option>
                            <option value="select">Select</option>
                            <option value="checkbox">Checkbox</option>
                            <option value="date">Date</option>
                            <option value="file">File Upload</option>
                          </select>
                        </div>
                      </div>

                      <div>
                        <label className="block text-xs font-medium text-gray-700 mb-1">
                          Placeholder
                        </label>
                        <input
                          type="text"
                          value={field.placeholder || ""}
                          onChange={(e) =>
                            updateField(index, { placeholder: e.target.value })
                          }
                          placeholder="Optional placeholder text"
                          className="w-full px-3 py-2 text-sm border border-gray-300 rounded-lg"
                        />
                      </div>

                      {field.type === "file" && (
                        <div>
                          <label className="block text-xs font-medium text-gray-700 mb-1">
                            Accepted File Types
                          </label>
                          <input
                            type="text"
                            value={field.acceptedFileTypes || ""}
                            onChange={(e) =>
                              updateField(index, {
                                acceptedFileTypes: e.target.value,
                              })
                            }
                            placeholder="e.g., .pdf,.doc,.jpg (leave empty for all)"
                            className="w-full px-3 py-2 text-sm border border-gray-300 rounded-lg"
                          />
                        </div>
                      )}

                      {field.type === "select" && (
                        <div>
                          <label className="block text-xs font-medium text-gray-700 mb-2">
                            Options
                          </label>
                          <div className="space-y-2">
                            {(field.options || []).map((option, optIndex) => (
                              <div key={optIndex} className="flex gap-2">
                                <input
                                  type="text"
                                  value={option}
                                  onChange={(e) => {
                                    const newOptions = [...(field.options || [])];
                                    newOptions[optIndex] = e.target.value;
                                    updateField(index, { options: newOptions });
                                  }}
                                  placeholder={`Option ${optIndex + 1}`}
                                  className="flex-1 px-3 py-2 text-sm border border-gray-300 rounded-lg"
                                />
                                <button
                                  onClick={() => {
                                    const newOptions = (field.options || []).filter(
                                      (_, i) => i !== optIndex
                                    );
                                    updateField(index, { options: newOptions });
                                  }}
                                  className="p-2 text-red-600 hover:bg-red-50 rounded"
                                >
                                  <X className="w-4 h-4" />
                                </button>
                              </div>
                            ))}
                            <button
                              onClick={() => {
                                const newOptions = [...(field.options || []), ""];
                                updateField(index, { options: newOptions });
                              }}
                              className="w-full px-3 py-2 text-sm text-blue-600 border border-blue-300 rounded-lg hover:bg-blue-50"
                            >
                              + Add Option
                            </button>
                          </div>
                        </div>
                      )}

                      <div className="flex items-center">
                        <input
                          type="checkbox"
                          id={`required-${field.key}`}
                          checked={field.required}
                          onChange={(e) =>
                            updateField(index, { required: e.target.checked })
                          }
                          className="h-4 w-4 text-blue-600 border-gray-300 rounded"
                        />
                        <label
                          htmlFor={`required-${field.key}`}
                          className="ml-2 text-sm text-gray-700"
                        >
                          Required field
                        </label>
                      </div>
                    </div>
                  ))}
                </div>
              )}
            </div>
          </div>

          {/* Preview */}
          <div className="lg:col-span-1">
            <div className="bg-white rounded-lg shadow p-6 sticky top-6">
              <h2 className="text-lg font-semibold text-gray-900 mb-4">
                Preview
              </h2>
              <div className="space-y-4">
                <div className="text-sm text-gray-500 mb-4">
                  {formName || "Untitled Form"}
                </div>
                {fields.length === 0 ? (
                  <p className="text-sm text-gray-400 italic">
                    Add fields to see preview
                  </p>
                ) : (
                  fields.map((field) => (
                    <div key={field.key}>
                      <label className="block text-sm font-medium text-gray-700 mb-1">
                        {field.label || "Unlabeled Field"}
                        {field.required && (
                          <span className="text-red-500 ml-1">*</span>
                        )}
                      </label>
                      {field.type === "textarea" ? (
                        <textarea
                          placeholder={field.placeholder}
                          className="w-full px-3 py-2 text-sm border border-gray-300 rounded-lg"
                          rows={3}
                          disabled
                        />
                      ) : field.type === "checkbox" ? (
                        <div className="flex items-center">
                          <input
                            type="checkbox"
                            className="h-4 w-4 text-blue-600 border-gray-300 rounded"
                            disabled
                          />
                          <span className="ml-2 text-sm text-gray-600">
                            {field.placeholder || field.label}
                          </span>
                        </div>
                      ) : field.type === "select" ? (
                        <select
                          className="w-full px-3 py-2 text-sm border border-gray-300 rounded-lg"
                          disabled
                        >
                          <option value="">Select...</option>
                          {(field.options || []).map((opt, i) => (
                            <option key={i} value={opt}>
                              {opt || `Option ${i + 1}`}
                            </option>
                          ))}
                        </select>
                      ) : field.type === "file" ? (
                        <div className="border-2 border-dashed border-gray-300 rounded-lg p-3 text-center">
                          <span className="text-xs text-gray-500">
                            📎 Click to upload or drag and drop
                            {field.acceptedFileTypes && (
                              <span className="block mt-1">
                                Accepted: {field.acceptedFileTypes}
                              </span>
                            )}
                          </span>
                        </div>
                      ) : (
                        <input
                          type={
                            field.type === "textfield" ? "text" : field.type
                          }
                          placeholder={field.placeholder}
                          className="w-full px-3 py-2 text-sm border border-gray-300 rounded-lg"
                          disabled
                        />
                      )}
                    </div>
                  ))
                )}
              </div>
            </div>
          </div>
        </div>
      </main>
    </div>
  );
}
