# tencent_cos_dart

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
