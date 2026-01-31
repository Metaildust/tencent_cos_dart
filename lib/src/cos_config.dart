class CosConfig {
  final String secretId;
  final String secretKey;
  final String bucket;
  final String region;
  final String? customDomain;

  const CosConfig({
    required this.secretId,
    required this.secretKey,
    required this.bucket,
    required this.region,
    this.customDomain,
  });
}
