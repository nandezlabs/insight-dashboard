import type { NextConfig } from "next";

const nextConfig: NextConfig = {
  reactStrictMode: true,

  // Enable SWC minification
  swcMinify: true,

  // Image optimization
  images: {
    domains: ["supabase.co", "localhost"],
    remotePatterns: [
      {
        protocol: "https",
        hostname: "**.supabase.co",
        port: "",
        pathname: "/storage/v1/object/public/**",
      },
    ],
  },

  // Environment variables available to browser
  env: {
    NEXT_PUBLIC_APP_NAME: process.env.APP_NAME || "Insight",
    NEXT_PUBLIC_APP_URL: process.env.APP_URL || "http://localhost:3000",
  },

  // Experimental features
  experimental: {
    optimizePackageImports: ["lucide-react", "recharts"],
  },

  // Headers for security
  async headers() {
    return [
      {
        source: "/:path*",
        headers: [
          {
            key: "X-DNS-Prefetch-Control",
            value: "on",
          },
          {
            key: "X-Frame-Options",
            value: "SAMEORIGIN",
          },
          {
            key: "X-Content-Type-Options",
            value: "nosniff",
          },
          {
            key: "Referrer-Policy",
            value: "origin-when-cross-origin",
          },
        ],
      },
    ];
  },
};

export default nextConfig;
