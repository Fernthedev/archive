import 'dart:typed_data';

import '../util/input_stream.dart';
import '../util/output_stream.dart';
import 'zlib/_gzip_encoder.dart';

class GZipEncoder {
  Uint8List encode(List<int> bytes, {int level = 6}) =>
      platformGZipEncoder.encode(bytes, level: level);

  void encodeStream(InputStream input, OutputStream output, {int level = 6}) =>
      platformGZipEncoder.encodeStream(input, output, level: level);
}
