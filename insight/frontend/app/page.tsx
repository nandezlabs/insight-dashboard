import Link from "next/link";
import { CheckCircle } from "lucide-react";

export default function Home() {
  return (
    <div className="min-h-screen flex items-center justify-center p-8">
      <div className="max-w-2xl w-full space-y-8 text-center">
        <div className="space-y-4">
          <div className="flex justify-center">
            <CheckCircle className="w-16 h-16 text-blue-600" />
          </div>
          <h1 className="text-4xl font-bold tracking-tight text-gray-900">
            Welcome to Insight Dashboard
          </h1>
          <p className="text-lg text-gray-600">
            Your inventory management solution with offline capability
          </p>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4 mt-8">
          <Link
            href="/forms"
            className="p-6 bg-white border border-gray-200 rounded-lg hover:border-blue-500 hover:shadow-md transition-all"
          >
            <h2 className="text-xl font-semibold mb-2">Forms</h2>
            <p className="text-gray-600 text-sm">
              Create and manage dynamic forms with auto-save
            </p>
          </Link>

          <Link
            href="/submissions"
            className="p-6 bg-white border border-gray-200 rounded-lg hover:border-blue-500 hover:shadow-md transition-all"
          >
            <h2 className="text-xl font-semibold mb-2">Submissions</h2>
            <p className="text-gray-600 text-sm">
              View and manage all form submissions
            </p>
          </Link>

          <Link
            href="/dashboard"
            className="p-6 bg-white border border-gray-200 rounded-lg hover:border-blue-500 hover:shadow-md transition-all"
          >
            <h2 className="text-xl font-semibold mb-2">Dashboard</h2>
            <p className="text-gray-600 text-sm">
              Visualize data with interactive charts
            </p>
          </Link>

          <Link
            href="/analytics"
            className="p-6 bg-white border border-gray-200 rounded-lg hover:border-blue-500 hover:shadow-md transition-all"
          >
            <h2 className="text-xl font-semibold mb-2">Analytics</h2>
            <p className="text-gray-600 text-sm">
              Track form completion and performance metrics
            </p>
          </Link>
        </div>

        <div className="mt-12 p-6 bg-blue-50 rounded-lg border border-blue-200">
          <h3 className="text-lg font-semibold mb-2 text-blue-900">
            🚀 Setup Required
          </h3>
          <p className="text-blue-800 text-sm mb-4">
            To get started, configure your environment variables and Supabase
            project.
          </p>
          <div className="text-left text-sm text-blue-900 space-y-2">
            <p>
              1. Copy{" "}
              <code className="bg-blue-100 px-2 py-1 rounded">
                .env.example
              </code>{" "}
              to{" "}
              <code className="bg-blue-100 px-2 py-1 rounded">.env.local</code>
            </p>
            <p>2. Add your Supabase credentials</p>
            <p>
              3. Run the database schema from{" "}
              <code className="bg-blue-100 px-2 py-1 rounded">
                backend/database/schema.sql
              </code>
            </p>
            <p>4. Restart the development server</p>
          </div>
        </div>

        <div className="text-sm text-gray-500 mt-8">
          <p>
            Read the full setup guide in <code>docs/SETUP.md</code>
          </p>
        </div>
      </div>
    </div>
  );
}
