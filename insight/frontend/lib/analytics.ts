/**
 * Analytics tracking hook for form events
 */

import { useEffect, useRef, useCallback } from "react";

interface TrackEventParams {
  eventType: "view" | "start" | "complete" | "abandon";
  formId: string;
  sessionId?: string;
  userId?: string;
  metadata?: Record<string, any>;
}

const API_URL = process.env.NEXT_PUBLIC_API_URL || "http://localhost:8000";

// Generate a session ID that persists across page reloads for the same form
const getSessionId = (formId: string): string => {
  const key = `insight_session_${formId}`;
  let sessionId = sessionStorage.getItem(key);

  if (!sessionId) {
    sessionId = `session_${Date.now()}_${Math.random()
      .toString(36)
      .substr(2, 9)}`;
    sessionStorage.setItem(key, sessionId);
  }

  return sessionId;
};

// Track an analytics event
export const trackEvent = async (params: TrackEventParams): Promise<void> => {
  try {
    const sessionId = params.sessionId || getSessionId(params.formId);

    await fetch(`${API_URL}/api/analytics/track`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        event_type: params.eventType,
        form_id: params.formId,
        session_id: sessionId,
        user_id: params.userId,
        metadata: params.metadata,
      }),
    });
  } catch (error) {
    console.error("Analytics tracking failed:", error);
    // Don't throw - analytics should never break the app
  }
};

// Hook to track form view
export const useTrackFormView = (formId: string | undefined) => {
  const hasTracked = useRef(false);

  useEffect(() => {
    if (formId && !hasTracked.current) {
      trackEvent({
        eventType: "view",
        formId,
      });
      hasTracked.current = true;
    }
  }, [formId]);
};

// Hook to track form start (first interaction)
export const useTrackFormStart = (formId: string | undefined) => {
  const hasTracked = useRef(false);

  const trackStart = useCallback(() => {
    if (formId && !hasTracked.current) {
      trackEvent({
        eventType: "start",
        formId,
      });
      hasTracked.current = true;
    }
  }, [formId]);

  return trackStart;
};

// Function to track form completion
export const trackFormComplete = (
  formId: string,
  metadata?: Record<string, any>,
) => {
  trackEvent({
    eventType: "complete",
    formId,
    metadata,
  });
};

// Hook to track form abandonment on unmount
export const useTrackFormAbandon = (
  formId: string | undefined,
  hasStarted: boolean,
  hasCompleted: boolean,
) => {
  useEffect(() => {
    return () => {
      // Track abandon if user started but didn't complete
      if (formId && hasStarted && !hasCompleted) {
        trackEvent({
          eventType: "abandon",
          formId,
        });
      }
    };
  }, [formId, hasStarted, hasCompleted]);
};

// Get analytics stats for a form
export const getFormStats = async (formId: string) => {
  try {
    const response = await fetch(
      `${API_URL}/api/analytics/forms/${formId}/stats`,
    );

    if (!response.ok) {
      throw new Error("Failed to fetch stats");
    }

    return await response.json();
  } catch (error) {
    console.error("Failed to get form stats:", error);
    return null;
  }
};
