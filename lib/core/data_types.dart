import 'dart:io';

import 'package:flutter/foundation.dart';

class IntVs extends ValueNotifier<int> {
  IntVs(int value) : super(value);
}

class DoubleVs extends ValueNotifier<double> {
  DoubleVs(double value) : super(value);
}

class StringVs extends ValueNotifier<String> {
  StringVs([String value = '']) : super(value);
}

class BoolVs extends ValueNotifier<bool> {
  BoolVs(bool value) : super(value);
}

class ListVs<E> extends ValueNotifier<List<E>> {
  ListVs(List<E> value) : super(value);

  addAll(List<File> imageFile) {}
}
