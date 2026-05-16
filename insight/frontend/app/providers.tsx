"use client";

import { Refine } from "@refinedev/core";
import { dataProvider } from "@refinedev/supabase";
import routerProvider from "@refinedev/nextjs-router";
import { ReactNode } from "react";
import { supabase } from "@/lib/supabase";

export function RefineProvider({ children }: { children: ReactNode }) {
  return (
    <Refine
      dataProvider={dataProvider(supabase)}
      routerProvider={routerProvider}
      resources={[
        {
          name: "form_templates",
          list: "/forms",
          create: "/forms/new",
          edit: "/forms/:id/edit",
          show: "/forms/:id",
          meta: {
            label: "Forms",
          },
        },
        {
          name: "submissions",
          list: "/submissions",
          show: "/submissions/:id",
          meta: {
            label: "Submissions",
          },
        },
        {
          name: "form_drafts",
          meta: {
            label: "Drafts",
          },
        },
      ]}
      options={{
        syncWithLocation: true,
        warnWhenUnsavedChanges: true,
        projectId: "insight-dashboard",
      }}
    >
      {children}
    </Refine>
  );
}
