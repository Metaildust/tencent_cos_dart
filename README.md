# tencent_cos_dart

[中文文档](README.zh.md)

Tencent Cloud COS presigned URL signer (pure Dart).

## Features
- Generate COS presigned URLs (GET/PUT/DELETE/POST)
- Custom domain support (with or without scheme)

## Install

```yaml
dependencies:
  tencent_cos_dart: ^0.1.0
```

## Usage

```dart
import 'package:tencent_cos_dart/tencent_cos_dart.dart';

final config = CosConfig(
  secretId: '<TENCENT_SECRET_ID>',
  secretKey: '<TENCENT_SECRET_KEY>',
  bucket: '<COS_BUCKET_NAME>',
  region: '<COS_REGION>',
  customDomain: 'https://my-cdn.example.com', // optional
);

final signer = CosSigner.fromConfig(config);
final url = signer.generatePresignedUrl(
  'PUT',
  'src/public/example/file.png',
  expires: 3600,
);
```

## Required Permissions

Your Tencent Cloud SecretId/SecretKey needs the following CAM permissions:

```json
{
    "version": "2.0",
    "statement": [
        {
            "effect": "allow",
            "action": [
                "name/cos:PutObject",
                "name/cos:PostObject",
                "name/cos:GetObject",
                "name/cos:DeleteObject",
                "name/cos:HeadObject"
            ],
            "resource": [
                "qcs::cos:ap-guangzhou:uid/1250000000:examplebucket-1250000000/*"
            ]
        }
    ]
}
```

Replace `ap-guangzhou`, `1250000000`, and `examplebucket-1250000000` with your actual region, AppId, and Bucket name.

## Where to find COS settings (Tencent Console)

### 1) SecretId / SecretKey
- API Key Management: `https://console.cloud.tencent.com/cam/capi`

### 2) Bucket
- COS Console: `https://console.cloud.tencent.com/cos5`
- Doc: `https://cloud.tencent.com/document/product/436/13309`

### 3) Region
- Doc: `https://cloud.tencent.com/document/product/436/6224`

### 4) customDomain (optional)
- Doc: `https://cloud.tencent.com/document/product/436/18424`

## Notes
- `objectKey` can be `path/to/file` or `/path/to/file`.
- `customDomain` can be `https://example.com` or `example.com`.

## Maintenance
- Versioning: SemVer
- Feedback: issue / PR
