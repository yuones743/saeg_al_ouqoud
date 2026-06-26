import 'dart:async';
import 'package:flutter/foundation.dart';

class CacheEntry<T> {
  final T value;
  final DateTime timestamp;
  final Duration ttl;
  CacheEntry({required this.value, required this.timestamp, required this.ttl});

  bool get isExpired => DateTime.now().difference(timestamp) > ttl;
}

class CacheService {
  static final CacheService _instance = CacheService._();
  factory CacheService() => _instance;
  static CacheService get instance => _instance;
  CacheService._();

  final Map<String, CacheEntry<dynamic>> _cache = {};

  void put<T>(String key, T value, {Duration ttl = const Duration(minutes: 5)}) {
    _cache[key] = CacheEntry<T>(value: value, timestamp: DateTime.now(), ttl: ttl);
  }

  T? get<T>(String key) {
    final entry = _cache[key];
    if (entry == null) return null;
    if (entry.isExpired) {
      _cache.remove(key);
      return null;
    }
    return entry.value as T;
  }

  bool contains(String key) {
    final entry = _cache[key];
    if (entry == null) return false;
    if (entry.isExpired) {
      _cache.remove(key);
      return false;
    }
    return true;
  }

  void remove(String key) => _cache.remove(key);

  void clear() => _cache.clear();

  int get size => _cache.length;

  void evictExpired() {
    _cache.removeWhere((_, entry) => entry.isExpired);
  }
}