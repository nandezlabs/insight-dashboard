// Supabase client configuration
import { createClient } from "@supabase/supabase-js";
import { Database } from "./database.types";

// Environment variables
const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL!;
const supabaseAnonKey = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!;

if (!supabaseUrl || !supabaseAnonKey) {
  throw new Error("Missing Supabase environment variables");
}

// Create Supabase client
export const supabase = createClient<Database>(supabaseUrl, supabaseAnonKey, {
  auth: {
    persistSession: true,
    autoRefreshToken: true,
    detectSessionInUrl: false,
  },
  global: {
    headers: {
      "x-application": "insight-dashboard",
    },
  },
});

// Helper to check if Supabase is connected
export async function checkSupabaseConnection(): Promise<boolean> {
  try {
    const { error } = await supabase
      .from("form_templates")
      .select("id")
      .limit(1);
    return !error;
  } catch {
    return false;
  }
}

// Helper to get signed URL for file
export async function getFileUrl(path: string): Promise<string | null> {
  const { data } = await supabase.storage
    .from("uploads")
    .createSignedUrl(path, 3600);
  return data?.signedUrl || null;
}

// Helper to upload file
export async function uploadFile(
  file: File,
  path?: string,
): Promise<{ path: string; url: string } | null> {
  const fileName = path || `${Date.now()}-${file.name}`;
  const filePath = `uploads/${new Date().getFullYear()}/${String(
    new Date().getMonth() + 1,
  ).padStart(2, "0")}/${fileName}`;

  const { data, error } = await supabase.storage
    .from("uploads")
    .upload(filePath, file, {
      cacheControl: "3600",
      upsert: false,
    });

  if (error || !data) {
    console.error("Upload error:", error);
    return null;
  }

  const url = await getFileUrl(data.path);
  return url ? { path: data.path, url } : null;
}
