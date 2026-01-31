# tencent_cos_dart

[English](README.md)

腾讯云 COS (对象存储) 预签名 URL 生成器（纯 Dart 实现）。

## 功能
- 生成 COS 预签名 URL（GET/PUT/DELETE/POST）
- 支持自定义域名（带或不带 scheme）

## 安装

```yaml
dependencies:
  tencent_cos_dart: ^0.1.0
```

### 中国镜像（可选）

参考：`https://docs.flutter.cn/community/china`

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

## 使用方法

```dart
import 'package:tencent_cos_dart/tencent_cos_dart.dart';

final config = CosConfig(
  secretId: '<TENCENT_SECRET_ID>',
  secretKey: '<TENCENT_SECRET_KEY>',
  bucket: '<COS_BUCKET_NAME>',
  region: '<COS_REGION>',
  customDomain: 'https://my-cdn.example.com', // 可选
);

final signer = CosSigner.fromConfig(config);
final url = signer.generatePresignedUrl(
  'PUT',
  'src/public/example/file.png',
  expires: 3600,
);
```

## 权限说明

使用本包时，您的腾讯云 SecretId/SecretKey 需要以下 CAM 权限：

前往 [CAM 控制台](https://console.cloud.tencent.com/cam/policy) 创建自定义策略：

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

请将 `ap-guangzhou`、`1250000000` 和 `examplebucket-1250000000` 替换为您的实际区域、AppId 和 Bucket 名称。

## 参数来源（腾讯云控制台）

### 1) SecretId / SecretKey
- API 密钥管理：`https://console.cloud.tencent.com/cam/capi`

### 2) Bucket
- COS 控制台：`https://console.cloud.tencent.com/cos5`
- 文档：`https://cloud.tencent.com/document/product/436/13309`

### 3) Region
- 文档：`https://cloud.tencent.com/document/product/436/6224`

### 4) customDomain（可选）
- 文档：`https://cloud.tencent.com/document/product/436/18424`

## 注意
- `objectKey` 可写成 `path/to/file` 或 `/path/to/file`
- `customDomain` 可以是 `https://example.com` 或 `example.com`

## 维护
- 版本：SemVer
- 反馈：issue / PR
