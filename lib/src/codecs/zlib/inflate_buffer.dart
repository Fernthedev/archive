import 'dart:async';
import 'dart:typed_data';

import '_inflate_buffer_stub.dart'
    if (dart.library.io) '_inflate_buffer_io.dart'
    if (dart.library.js) '_inflate_buffer_web.dart';

FutureOr<Uint8List>? inflateBuffer(Uint8List data) => inflateBuffer_(data);
