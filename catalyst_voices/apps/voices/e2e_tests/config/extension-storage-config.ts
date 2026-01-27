/**
 * Configuration for remote extension storage (S3).
 *
 * Environment variables:
 * - EXTENSION_S3_BUCKET: The S3 bucket name (required for upload, optional for download)
 * - EXTENSION_S3_REGION: The S3 region (default: eu-central-1)
 * - EXTENSION_S3_PREFIX: The prefix/folder path in the bucket (default: wallet-extensions)
 * - AWS_ACCESS_KEY_ID: AWS access key (required for upload)
 * - AWS_SECRET_ACCESS_KEY: AWS secret key (required for upload)
 *
 * For CI, these should be set in GitHub secrets.
 * For local development, you can use a .env file.
 */

export interface ExtensionStorageConfig {
  bucket: string;
  region: string;
  prefix: string;
  /**
   * Base URL for public read access.
   * If your bucket has public read enabled, extensions can be downloaded via HTTPS.
   * Format: https://{bucket}.s3.{region}.amazonaws.com/{prefix}
   */
  publicBaseUrl?: string;
}

/**
 * Get the extension storage configuration from environment variables.
 */
export const getStorageConfig = (): ExtensionStorageConfig => {
  const bucket = process.env.EXTENSION_S3_BUCKET || "catalyst-e2e-extensions";
  const region = process.env.EXTENSION_S3_REGION || "eu-central-1";
  const prefix = process.env.EXTENSION_S3_PREFIX || "wallet-extensions";

  return {
    bucket,
    region,
    prefix,
    publicBaseUrl: `https://${bucket}.s3.${region}.amazonaws.com/${prefix}`,
  };
};

/**
 * Check if AWS credentials are available for upload operations.
 */
export const hasAwsCredentials = (): boolean => {
  return !!(process.env.AWS_ACCESS_KEY_ID && process.env.AWS_SECRET_ACCESS_KEY);
};
