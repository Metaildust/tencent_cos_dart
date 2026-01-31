import 'dart:convert';

import 'package:crypto/crypto.dart';

import 'cos_config.dart';

class CosSigner {
  final String secretId;
  final String secretKey;
  final String bucket;
  final String region;
  final String? customDomain;

  CosSigner({
    required this.secretId,
    required this.secretKey,
    required this.bucket,
    required this.region,
    this.customDomain,
  });

  factory CosSigner.fromConfig(CosConfig config) {
    return CosSigner(
      secretId: config.secretId,
      secretKey: config.secretKey,
      bucket: config.bucket,
      region: config.region,
      customDomain: config.customDomain,
    );
  }

  /// 生成预签名 URL
  /// [httpMethod]: 请求方法，如 'get', 'put'
  /// [objectKey]: 对象路径，如 'exampleobject' 或 '/folder/file.txt'
  /// [expires]: 过期时间（秒），默认 1800 秒
  String generatePresignedUrl(
    String httpMethod,
    String objectKey, {
    int expires = 1800,
    Map<String, String>? queryParams,
    Map<String, String>? headers,
  }) {
    // 1. 处理路径，确保以 '/' 开头
    if (!objectKey.startsWith('/')) {
      objectKey = '/$objectKey';
    }

    // 2. 生成 KeyTime (StartTimestamp;EndTimestamp)
    final now = DateTime.now();
    final startTime = now.millisecondsSinceEpoch ~/ 1000;
    final endTime = startTime + expires;
    final keyTime = '$startTime;$endTime';

    // 3. 生成 SignKey
    // SignKey = HMAC-SHA1([SecretKey], KeyTime)
    final signKey = _hmacSha1(secretKey, keyTime);

    // 4. 处理 URL 参数 (UrlParamList & HttpParameters)
    final params = queryParams ?? {};
    final sortedParamsKeys = params.keys.map((k) => k.toLowerCase()).toList()
      ..sort();

    final urlParamList = sortedParamsKeys.map((k) => _uriEncode(k)).join(';');
    final httpParameters = sortedParamsKeys
        .map((k) {
          final key = _uriEncode(k);
          final value = _uriEncode(params[k] ?? '');
          return '$key=$value';
        })
        .join('&');

    // 5. 处理 Header (HeaderList & HttpHeaders)
    // 注意：预签名 URL 通常不需要签名 Header，除非你有特定的 Header 必须校验
    final headerMap = headers ?? {};
    final sortedHeaderKeys = headerMap.keys.map((k) => k.toLowerCase()).toList()
      ..sort();

    final headerList = sortedHeaderKeys.map((k) => _uriEncode(k)).join(';');
    final httpHeaders = sortedHeaderKeys
        .map((k) {
          final key = _uriEncode(k);
          final value = _uriEncode(headerMap[k] ?? '');
          return '$key=$value';
        })
        .join('&');

    // 6. 生成 HttpString
    // Format: [HttpMethod]\n[HttpURI]\n[HttpParameters]\n[HttpHeaders]\n
    final httpString =
        '${httpMethod.toLowerCase()}\n'
        '$objectKey\n'
        '$httpParameters\n'
        '$httpHeaders\n';

    // 7. 生成 StringToSign
    // Format: sha1\nKeyTime\nSHA1(HttpString)\n
    final sha1HttpString = sha1.convert(utf8.encode(httpString)).toString();
    final stringToSign = 'sha1\n$keyTime\n$sha1HttpString\n';

    // 8. 计算 Signature
    // Signature = HMAC-SHA1(SignKey, StringToSign)
    final signature = _hmacSha1(signKey, stringToSign);

    // 9. 构造最终的参数 Map
    final signatureParams = {
      'q-sign-algorithm': 'sha1',
      'q-ak': secretId,
      'q-sign-time': keyTime,
      'q-key-time': keyTime,
      'q-header-list': headerList,
      'q-url-param-list': urlParamList,
      'q-signature': signature,
    };

    // 合并用户参数和签名参数
    final allParams = {...params, ...signatureParams};

    // 10. 拼接完整 URL - 使用自定义域名或默认域名
    final queryString = allParams.entries
        .map((e) {
          return '${e.key}=${_uriEncode(e.value)}';
        })
        .join('&');

    final host =
        _normalizeHost(customDomain) ?? '$bucket.cos.$region.myqcloud.com';
    return 'https://$host$objectKey?$queryString';
  }

  /// 辅助函数：HMAC-SHA1 计算
  String _hmacSha1(String key, String msg) {
    final hmac = Hmac(sha1, utf8.encode(key));
    final digest = hmac.convert(utf8.encode(msg));
    return digest.toString();
  }

  /// 辅助函数：自定义 UriEncode
  /// 腾讯云 COS 要求对所有字符进行编码，除了部分特殊字符，且空格转为 %20 而非 +
  String _uriEncode(String input) {
    // 使用 Uri.encodeComponent 会把空格转为 %20，符合要求
    // 但需要注意部分符号在 COS 标准中是否需要二次处理，
    // 通常 Dart 的 encodeComponent 对大部分 ASCII 符号处理已足够兼容 COS。
    // 严格来说，COS 文档要求：
    // 字符范围：0-9, a-z, A-Z, ! $ & ' ( ) * + , - . / : ; = ? @ _ ~ 不被编码
    // 但为了安全，通常全量编码（除了 /）也是可行的，或者直接使用标准库。
    return Uri.encodeComponent(input).replaceAll('+', '%20');
  }

  String? _normalizeHost(String? raw) {
    if (raw == null || raw.isEmpty) {
      return null;
    }
    final trimmed = raw.trim();
    if (trimmed.startsWith('http://') || trimmed.startsWith('https://')) {
      final uri = Uri.tryParse(trimmed);
      return uri?.host;
    }
    return trimmed;
  }
}
