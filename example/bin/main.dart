import 'package:tencent_cos_dart/tencent_cos_dart.dart';

void main() {
  final config = CosConfig(
    secretId: '<TENCENT_SECRET_ID>',
    secretKey: '<TENCENT_SECRET_KEY>',
    bucket: 'example-1250000000',
    region: 'ap-guangzhou',
    customDomain: 'https://static.example.com',
  );

  final signer = CosSigner.fromConfig(config);
  final url = signer.generatePresignedUrl(
    'PUT',
    'demo/example.png',
    expires: 600,
  );

  // ignore: avoid_print
  print(url);
}
