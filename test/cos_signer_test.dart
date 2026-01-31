import 'package:tencent_cos_dart/tencent_cos_dart.dart';
import 'package:test/test.dart';

void main() {
  test('generates URL with required signature params', () {
    final signer = CosSigner.fromConfig(
      const CosConfig(
        secretId: 'AKIDTEST',
        secretKey: 'TESTSECRET',
        bucket: 'example-1250000000',
        region: 'ap-guangzhou',
      ),
    );

    final url = signer.generatePresignedUrl(
      'GET',
      'demo/file.png',
      expires: 60,
    );

    final uri = Uri.parse(url);
    expect(uri.scheme, 'https');
    expect(uri.host, 'example-1250000000.cos.ap-guangzhou.myqcloud.com');
    expect(uri.queryParameters['q-ak'], 'AKIDTEST');
    expect(uri.queryParameters['q-sign-algorithm'], 'sha1');
    expect(uri.queryParameters.containsKey('q-signature'), isTrue);
  });

  test('uses custom domain and normalizes object key', () {
    final signer = CosSigner.fromConfig(
      const CosConfig(
        secretId: 'AKIDTEST',
        secretKey: 'TESTSECRET',
        bucket: 'unused',
        region: 'ap-guangzhou',
        customDomain: 'https://static.example.com',
      ),
    );

    final url = signer.generatePresignedUrl(
      'PUT',
      '/path/to/file.txt',
      expires: 60,
    );

    final uri = Uri.parse(url);
    expect(uri.host, 'static.example.com');
    expect(uri.path, '/path/to/file.txt');
  });
}
