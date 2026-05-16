// Database types for Supabase tables
// This file will be generated from Supabase CLI: npx supabase gen types typescript

export type Json =
  | string
  | number
  | boolean
  | null
  | { [key: string]: Json | undefined }
  | Json[];

export interface Database {
  public: {
    Tables: {
      form_templates: {
        Row: {
          id: string;
          name: string;
          version: number;
          schema: Json;
          status: "draft" | "active" | "archived";
          created_at: string;
          updated_at: string;
        };
        Insert: {
          id?: string;
          name: string;
          version?: number;
          schema: Json;
          status?: "draft" | "active" | "archived";
          created_at?: string;
          updated_at?: string;
        };
        Update: {
          id?: string;
          name?: string;
          version?: number;
          schema?: Json;
          status?: "draft" | "active" | "archived";
          updated_at?: string;
        };
      };
      submissions: {
        Row: {
          id: string;
          form_id: string;
          form_version: number;
          data: Json;
          created_at: string;
          updated_at: string;
        };
        Insert: {
          id?: string;
          form_id: string;
          form_version: number;
          data: Json;
          created_at?: string;
          updated_at?: string;
        };
        Update: {
          id?: string;
          form_id?: string;
          form_version?: number;
          data?: Json;
          updated_at?: string;
        };
      };
      form_drafts: {
        Row: {
          id: string;
          form_id: string;
          data: Json;
          updated_at: string;
        };
        Insert: {
          id?: string;
          form_id: string;
          data: Json;
          updated_at?: string;
        };
        Update: {
          id?: string;
          form_id?: string;
          data?: Json;
          updated_at?: string;
        };
      };
      files: {
        Row: {
          id: string;
          filename: string;
          bucket_path: string;
          size: number;
          mime_type: string;
          submission_id: string | null;
          uploaded_at: string;
        };
        Insert: {
          id?: string;
          filename: string;
          bucket_path: string;
          size: number;
          mime_type: string;
          submission_id?: string | null;
          uploaded_at?: string;
        };
        Update: {
          id?: string;
          filename?: string;
          bucket_path?: string;
          size?: number;
          mime_type?: string;
          submission_id?: string | null;
        };
      };
      analytics_events: {
        Row: {
          id: string;
          form_id: string;
          event_type: "view" | "start" | "complete" | "abandon";
          session_id: string;
          field_name: string | null;
          timestamp: string;
        };
        Insert: {
          id?: string;
          form_id: string;
          event_type: "view" | "start" | "complete" | "abandon";
          session_id: string;
          field_name?: string | null;
          timestamp?: string;
        };
        Update: {
          id?: string;
          form_id?: string;
          event_type?: "view" | "start" | "complete" | "abandon";
          session_id?: string;
          field_name?: string | null;
        };
      };
      alerts: {
        Row: {
          id: string;
          type: "info" | "warning" | "error" | "success";
          title: string;
          message: string;
          priority: "low" | "medium" | "high" | "critical";
          is_read: boolean;
          created_at: string;
          expires_at: string | null;
        };
        Insert: {
          id?: string;
          type: "info" | "warning" | "error" | "success";
          title: string;
          message: string;
          priority?: "low" | "medium" | "high" | "critical";
          is_read?: boolean;
          created_at?: string;
          expires_at?: string | null;
        };
        Update: {
          id?: string;
          type?: "info" | "warning" | "error" | "success";
          title?: string;
          message?: string;
          priority?: "low" | "medium" | "high" | "critical";
          is_read?: boolean;
          expires_at?: string | null;
        };
      };
      error_logs: {
        Row: {
          id: string;
          level: "debug" | "info" | "warning" | "error" | "critical";
          category: string;
          message: string;
          context: Json;
          created_at: string;
        };
        Insert: {
          id?: string;
          level: "debug" | "info" | "warning" | "error" | "critical";
          category: string;
          message: string;
          context?: Json;
          created_at?: string;
        };
        Update: {
          id?: string;
          level?: "debug" | "info" | "warning" | "error" | "critical";
          category?: string;
          message?: string;
          context?: Json;
        };
      };
    };
    Views: {
      [_ in never]: never;
    };
    Functions: {
      [_ in never]: never;
    };
    Enums: {
      [_ in never]: never;
    };
  };
}
