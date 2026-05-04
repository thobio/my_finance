import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';

import '../../features/bills/domain/models/recurrence.dart';

@pragma('vm:entry-point')
Future<void> _fcmBackgroundHandler(RemoteMessage _) async {}

class NotificationService {
  static const _channelId = 'bill_reminders';
  static const _channelName = 'Bill Reminders';
  static const _channelDesc = 'Reminders for upcoming bills and EMIs';

  final _local = FlutterLocalNotificationsPlugin();
  bool _initialised = false;
  bool _sessionChecked = false;

  Future<void> init() async {
    if (_initialised) return;
    _initialised = true;

    if (kIsWeb) return;

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const darwinSettings = DarwinInitializationSettings();
    await _local.initialize(
      const InitializationSettings(android: androidSettings, iOS: darwinSettings),
    );

    if (Platform.isAndroid) {
      await _local
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(
            const AndroidNotificationChannel(
              _channelId,
              _channelName,
              description: _channelDesc,
              importance: Importance.high,
            ),
          );
    }

    FirebaseMessaging.onBackgroundMessage(_fcmBackgroundHandler);
    await FirebaseMessaging.instance.requestPermission();
    FirebaseMessaging.onMessage.listen(_onForegroundMessage);
  }

  void _onForegroundMessage(RemoteMessage message) {
    final n = message.notification;
    if (n == null) return;
    _local.show(
      message.hashCode,
      n.title,
      n.body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          _channelName,
          channelDescription: _channelDesc,
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
    );
  }

  /// Called once per session when recurrences load.
  /// Shows a local notification for each active recurrence whose next due
  /// date falls within its configured reminder window.
  Future<void> checkUpcomingBills(List<Recurrence> recurrences) async {
    if (kIsWeb || _sessionChecked) return;
    _sessionChecked = true;

    final today = DateTime.now();
    var id = 1000;
    final fmt = DateFormat('d MMM');
    final amtFmt = NumberFormat.currency(symbol: '₹', decimalDigits: 0);

    for (final r in recurrences) {
      if (!r.isActive || r.reminderOffsetDays <= 0) continue;
      final diff = r.nextDueDate.difference(DateTime(today.year, today.month, today.day)).inDays;
      if (diff < 0 || diff > r.reminderOffsetDays) continue;

      final whenLabel = switch (diff) {
        0 => 'today',
        1 => 'tomorrow',
        _ => 'in $diff days',
      };
      final amount = amtFmt.format(r.amount);

      await _local.show(
        id++,
        '${r.label} due $whenLabel',
        '$amount due on ${fmt.format(r.nextDueDate)}',
        const NotificationDetails(
          android: AndroidNotificationDetails(
            _channelId,
            _channelName,
            channelDescription: _channelDesc,
            importance: Importance.high,
            priority: Priority.high,
          ),
        ),
      );
    }
  }
}
