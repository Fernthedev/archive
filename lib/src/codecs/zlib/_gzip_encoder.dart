export '_gzip_encoder_stub.dart'
    if (dart.library.io) '_gzip_encoder_io.dart'
    if (dart.library.js) '_gzip_encoder_web.dart';
