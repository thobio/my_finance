import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/notification_service.dart';

final notificationServiceProvider = Provider<NotificationService>((_) {
  throw UnimplementedError('notificationServiceProvider must be overridden in main.dart');
});
