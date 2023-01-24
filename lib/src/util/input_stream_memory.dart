//import 'dart:async';
import 'dart:typed_data';

import 'byte_order.dart';
import 'input_stream.dart';

/// A buffer that can be read as a stream of bytes
class InputStreamMemory extends InputStream {
  late Uint8List buffer;
  // The read offset into the buffer.
  int _position;
  late int _length;

  /// Create a [InputStream] for reading from a Uint8List
  InputStreamMemory(Uint8List bytes,
      {super.byteOrder = ByteOrder.littleEndian, int? offset, int? length})
      : _position = 0 {
    offset ??= 0;
    length ??= bytes.buffer.lengthInBytes - offset;
    final requestedLength = bytes.offsetInBytes + offset + length;
    if (requestedLength > bytes.buffer.lengthInBytes) {
      length = bytes.buffer.lengthInBytes - (bytes.offsetInBytes + offset);
    }
    buffer = Uint8List.view(bytes.buffer, bytes.offsetInBytes + offset, length);
    _length = buffer.length;
  }

  InputStreamMemory.empty()
      : buffer = Uint8List(0),
        _position = 0,
        _length = 0,
        super(byteOrder: ByteOrder.littleEndian);

  InputStreamMemory.fromList(List<int> bytes,
      {super.byteOrder = ByteOrder.littleEndian})
      : buffer = Uint8List.fromList(bytes),
        _position = 0,
        _length = bytes.length;

  /// Create a copy of [other].
  InputStreamMemory.from(InputStreamMemory other)
      : buffer = other.buffer,
        _position = other._position,
        _length = other._length,
        super(byteOrder: other.byteOrder);

  ///  The current read position relative to the start of the buffer.
  @override
  int get position => _position;

  /// How many bytes are left in the stream.
  @override
  int get length => buffer.length - _position;

  /// Is the current position at the end of the stream?
  @override
  bool get isEOS => _position >= _length;

  @override
  void setPosition(int v) {
    _position = v;
  }

  /// Reset to the beginning of the stream.
  @override
  void reset() {
    _position = 0;
  }

  @override
  bool open() => true;

  @override
  void close() {
    _position = 0;
  }

  /// Rewind the read head of the stream by the given number of bytes.
  @override
  void rewind([int length = 1]) {
    _position -= length;
    _position = _position.clamp(0, _length);
  }

  /// Move the read position by [count] bytes.
  @override
  void skip(int count) {
    _position += count;
    _position = _position.clamp(0, _length);
  }

  /// Access the buffer relative from the current position.
  int operator [](int index) => buffer[_position + index];

  /// Return an [InputStream] to read a subset of this stream. It does not
  /// move the read position of this stream. [position] is specified relative
  /// to the start of the buffer. If [position] is not specified, the current
  /// read position is used. If [length] is not specified, the remainder of this
  /// stream is used.
  @override
  InputStream subset({int? position, int? length}) {
    position ??= _position;
    length ??= _length - position;
    return InputStreamMemory(buffer,
        byteOrder: byteOrder, offset: position, length: length);
  }

  /// Read a single byte.
  @override
  int readByte() {
    final b = buffer[_position++];
    return b;
  }

  @override
  Uint8List toUint8List() {
    var len = length;
    if ((_position + len) > buffer.length) {
      len = buffer.length - _position;
    }

    final bytes =
        Uint8List.view(buffer.buffer, buffer.offsetInBytes + _position, len);

    return bytes;
  }
}
