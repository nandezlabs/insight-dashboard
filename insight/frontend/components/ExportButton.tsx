"use client";

import { useState } from "react";
import { Download, FileText, File, FileSpreadsheet } from "lucide-react";

interface ExportButtonProps {
  formId?: string;
  startDate?: string;
  endDate?: string;
}

export default function ExportButton({
  formId,
  startDate,
  endDate,
}: ExportButtonProps) {
  const [isExporting, setIsExporting] = useState(false);
  const [showMenu, setShowMenu] = useState(false);

  const apiUrl = process.env.NEXT_PUBLIC_API_URL || "http://localhost:8000";

  const handleExport = async (format: "csv" | "excel" | "pdf") => {
    setIsExporting(true);
    setShowMenu(false);

    try {
      // Build query params
      const params = new URLSearchParams();
      if (formId) params.append("form_id", formId);
      if (startDate) params.append("start_date", startDate);
      if (endDate) params.append("end_date", endDate);

      const queryString = params.toString();
      const url = `${apiUrl}/api/exports/${format}${
        queryString ? `?${queryString}` : ""
      }`;

      // Fetch the file
      const response = await fetch(url);

      if (!response.ok) {
        throw new Error("Export failed");
      }

      // Get filename from headers or use default
      const contentDisposition = response.headers.get("Content-Disposition");
      let filename = `export_${format}_${new Date().getTime()}`;

      if (contentDisposition) {
        const filenameMatch = contentDisposition.match(/filename="?(.+)"?/);
        if (filenameMatch) {
          filename = filenameMatch[1];
        }
      }

      // Create blob and download
      const blob = await response.blob();
      const downloadUrl = window.URL.createObjectURL(blob);
      const link = document.createElement("a");
      link.href = downloadUrl;
      link.download = filename;
      document.body.appendChild(link);
      link.click();
      document.body.removeChild(link);
      window.URL.revokeObjectURL(downloadUrl);
    } catch (error) {
      console.error("Export failed:", error);
      alert("Export failed. Please try again.");
    } finally {
      setIsExporting(false);
    }
  };

  return (
    <div className="relative">
      <button
        onClick={() => setShowMenu(!showMenu)}
        disabled={isExporting}
        className="inline-flex items-center gap-2 px-4 py-2 bg-green-600 text-white rounded-lg hover:bg-green-700 transition-colors disabled:opacity-50 disabled:cursor-not-allowed"
      >
        <Download className="w-4 h-4" />
        {isExporting ? "Exporting..." : "Export"}
      </button>

      {showMenu && (
        <>
          {/* Backdrop */}
          <div
            className="fixed inset-0 z-10"
            onClick={() => setShowMenu(false)}
          />

          {/* Menu */}
          <div className="absolute right-0 mt-2 w-48 bg-white rounded-lg shadow-lg border border-gray-200 z-20">
            <div className="py-1">
              <button
                onClick={() => handleExport("csv")}
                className="w-full px-4 py-2 text-left text-sm text-gray-700 hover:bg-gray-100 flex items-center gap-2"
              >
                <FileText className="w-4 h-4" />
                Export as CSV
              </button>
              <button
                onClick={() => handleExport("excel")}
                className="w-full px-4 py-2 text-left text-sm text-gray-700 hover:bg-gray-100 flex items-center gap-2"
              >
                <FileSpreadsheet className="w-4 h-4" />
                Export as Excel
              </button>
              <button
                onClick={() => handleExport("pdf")}
                className="w-full px-4 py-2 text-left text-sm text-gray-700 hover:bg-gray-100 flex items-center gap-2"
              >
                <File className="w-4 h-4" />
                Export as PDF
              </button>
            </div>
          </div>
        </>
      )}
    </div>
  );
}
