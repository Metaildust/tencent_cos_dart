# tencent_cos_dart

Tencent Cloud COS presigned URL signer (pure Dart).
Tencent Cloud COS 预签名 URL 生成器（纯 Dart）。

## Features / 功能
- Generate COS presigned URLs (GET/PUT/DELETE/POST)
- Custom domain support (with or without scheme)
- 生成 COS 预签名 URL（GET/PUT/DELETE/POST）
- 支持自定义域名（支持带协议或仅 Host）

## Install / 安装

```yaml
dependencies:
  tencent_cos_dart: ^0.1.0
```

### China mirror (optional) / 中国镜像（可选）

Ref / 参考：`https://docs.flutter.cn/community/china`

macOS / Linux:

```bash
export PUB_HOSTED_URL="https://pub.flutter-io.cn"
export FLUTTER_STORAGE_BASE_URL="https://storage.flutter-io.cn"
```

Windows PowerShell:

```powershell
$env:PUB_HOSTED_URL="https://pub.flutter-io.cn"
$env:FLUTTER_STORAGE_BASE_URL="https://storage.flutter-io.cn"
```

## Usage / 使用

```dart
import 'package:tencent_cos_dart/tencent_cos_dart.dart';

final config = CosConfig(
  secretId: '<TENCENT_SECRET_ID>',
  secretKey: '<TENCENT_SECRET_KEY>',
  bucket: '<COS_BUCKET_NAME>',
  region: '<COS_REGION>',
  customDomain: 'https://my-cdn.example.com', // optional / 可选
);

final signer = CosSigner.fromConfig(config);
final url = signer.generatePresignedUrl(
  'PUT',
  'src/public/example/file.png',
  expires: 3600,
);
```

## Where to find COS settings / 参数来源（腾讯云控制台）

### 1) SecretId / SecretKey
- API Key Management / API 密钥管理：`https://console.cloud.tencent.com/cam/capi`

### 2) Bucket
- COS Console / COS 控制台：`https://console.cloud.tencent.com/cos5`
- Doc / 文档：`https://cloud.tencent.com/document/product/436/13309`

### 3) Region
- Doc / 文档：`https://cloud.tencent.com/document/product/436/6224`

### 4) customDomain (optional)
- Doc / 文档：`https://cloud.tencent.com/document/product/436/18424`

## Notes / 注意
- `objectKey` can be `path/to/file` or `/path/to/file`.
- `customDomain` can be `https://example.com` or `example.com`.
- `objectKey` 可写成 `path/to/file` 或 `/path/to/file`。
- `customDomain` 可以是 `https://example.com` 或 `example.com`。

## Maintenance / 维护
- Versioning: SemVer
- Feedback: issue / PR
