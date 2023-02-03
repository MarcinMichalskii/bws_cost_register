import 'package:flutter/foundation.dart';

extension AsUint8List on List<int> {
  Uint8List asUint8List() {
    final self = this;
    return (self is Uint8List) ? self : Uint8List.fromList(this);
  }
}

extension AsPLN on int {
  String asPLN() {
    final double value = this.toDouble();
    return '${(value / 100).toStringAsFixed(2)}'.replaceAll('.', ',');
  }
}
