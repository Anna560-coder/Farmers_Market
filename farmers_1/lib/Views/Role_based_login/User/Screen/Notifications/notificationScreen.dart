import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:intl/intl.dart';
import 'notification_detail_screen.dart';

class Notificationscreen extends StatefulWidget {
  const Notificationscreen({super.key});

  @override
  State<Notificationscreen> createState() => _NotificationscreenState();
}

class _NotificationscreenState extends State<Notificationscreen> {
  final user = FirebaseAuth.instance.currentUser;
  bool _markedOpened = false;

  @override
  void initState() {
    super.initState();
    subscribeUserToTopic();
    listenToNotifications();
  }

  /// Subscribe user to FCM topic
  Future<void> subscribeUserToTopic() async {
    if (user == null) return;
    await FirebaseMessaging.instance.subscribeToTopic("allUsers");
    String? token = await FirebaseMessaging.instance.getToken();
    if (token != null) {
      await FirebaseFirestore.instance.collection("users").doc(user!.uid).set({
        "fcmToken": token,
      }, SetOptions(merge: true));
    }
  }

  /// Listen for foreground and background messages
  void listenToNotifications() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _handleNotification(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _handleNotification(message, openDetail: true);
    });

    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        _handleNotification(message, openDetail: true);
      }
    });
  }

  /// Save notification and optionally navigate to detail
  Future<void> _handleNotification(
    RemoteMessage message, {
    bool openDetail = false,
  }) async {
    final title = message.notification?.title ?? "Notification";
    final body = message.notification?.body ?? "You have a new message.";

    if (user != null) {
      await FirebaseFirestore.instance
          .collection("user_notifications")
          .doc(user!.uid)
          .collection("notifications")
          .add({
            "title": title,
            "body": body,
            "timestamp": FieldValue.serverTimestamp(),
          });
    }

    if (!openDetail) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(title),
          content: Text(body),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        NotificationDetailScreen(title: title, body: body),
                  ),
                );
              },
              child: const Text("View"),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Close"),
            ),
          ],
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => NotificationDetailScreen(title: title, body: body),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return const Scaffold(
        body: Center(
          child: Text(
            "User not logged in",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ),
      );
    }

    if (!_markedOpened) {
      _markedOpened = true;
      FirebaseFirestore.instance.collection("users").doc(user!.uid).set({
        "notificationsLastOpened": FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    }

    final userStream = FirebaseFirestore.instance
        .collection("user_notifications")
        .doc(user!.uid)
        .collection("notifications")
        .snapshots();

    final broadcastStream = FirebaseFirestore.instance
        .collection("broadcast_notifications")
        .snapshots();

    final hiddenBroadcastsStream = FirebaseFirestore.instance
        .collection("user_notifications")
        .doc(user!.uid)
        .collection("hidden_broadcasts")
        .snapshots();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Notifications",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.green.shade600,
        foregroundColor: Colors.white,
        elevation: 4,
        shadowColor: Colors.black26,
      ),
      backgroundColor: Colors.grey.shade100,
      body: StreamBuilder<QuerySnapshot>(
        stream: userStream,
        builder: (context, userSnap) {
          return StreamBuilder<QuerySnapshot>(
            stream: broadcastStream,
            builder: (context, broadSnap) {
              return StreamBuilder<QuerySnapshot>(
                stream: hiddenBroadcastsStream,
                builder: (context, hiddenSnap) {
                  if (!userSnap.hasData ||
                      !broadSnap.hasData ||
                      !hiddenSnap.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final hiddenIds = hiddenSnap.data!.docs
                      .map((d) => d.id)
                      .toSet();
                  final List<Map<String, dynamic>> merged = [];

                  for (final d in userSnap.data!.docs) {
                    final data = d.data() as Map<String, dynamic>;
                    merged.add({
                      'title': data['title'],
                      'body': data['body'],
                      'timestamp': (data['timestamp'] as Timestamp?)?.toDate(),
                      'type': 'user',
                      'docId': d.id,
                    });
                  }

                  for (final d in broadSnap.data!.docs) {
                    if (hiddenIds.contains(d.id)) continue;
                    final data = d.data() as Map<String, dynamic>;
                    merged.add({
                      'title': data['title'],
                      'body': data['body'],
                      'timestamp': (data['createdAt'] as Timestamp?)?.toDate(),
                      'type': 'broadcast',
                      'docId': d.id,
                    });
                  }

                  merged.sort((a, b) {
                    final at = a['timestamp'] as DateTime?;
                    final bt = b['timestamp'] as DateTime?;
                    if (at == null && bt == null) return 0;
                    if (at == null) return 1;
                    if (bt == null) return -1;
                    return bt.compareTo(at);
                  });

                  if (merged.isEmpty) {
                    return const Center(
                      child: Text(
                        "No notifications yet",
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 10,
                    ),
                    itemCount: merged.length,
                    itemBuilder: (context, index) {
                      final item = merged[index];
                      final dateStr = item['timestamp'] is DateTime
                          ? DateFormat(
                              'dd MMM yyyy • hh:mm a',
                            ).format(item['timestamp'] as DateTime)
                          : "";

                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        child: Card(
                          elevation: 4,
                          shadowColor: Colors.black26,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(16),
                            leading: CircleAvatar(
                              radius: 26,
                              backgroundColor: Colors.green.shade100,
                              child: Icon(
                                item['type'] == 'broadcast'
                                    ? Icons.campaign_outlined
                                    : Icons.notifications_active_outlined,
                                color: Colors.green.shade800,
                                size: 26,
                              ),
                            ),
                            title: Text(
                              item['title'] ?? 'N/A',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item['body'] ?? 'N/A',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    dateStr,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            trailing: PopupMenuButton<String>(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              onSelected: (value) async {
                                if (value == 'view') {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => NotificationDetailScreen(
                                        title: item['title'] ?? 'N/A',
                                        body: item['body'] ?? 'N/A',
                                      ),
                                    ),
                                  );
                                } else if (value == 'edit') {
                                  // Open edit page or dialog
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Edit feature coming soon'),
                                    ),
                                  );
                                } else if (value == 'delete') {
                                  if (item['type'] == 'user') {
                                    await FirebaseFirestore.instance
                                        .collection('user_notifications')
                                        .doc(user!.uid)
                                        .collection('notifications')
                                        .doc(item['docId'] as String)
                                        .delete();
                                  } else {
                                    await FirebaseFirestore.instance
                                        .collection('user_notifications')
                                        .doc(user!.uid)
                                        .collection('hidden_broadcasts')
                                        .doc(item['docId'] as String)
                                        .set({'hidden': true});
                                  }
                                }
                              },
                              itemBuilder: (context) => const [
                                PopupMenuItem(
                                  value: 'delete',
                                  child: Row(
                                    children: [
                                      Icon(Icons.delete, color: Colors.red),
                                      SizedBox(width: 8),
                                      Text("Delete Message"),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => NotificationDetailScreen(
                                    title: item['title'] ?? 'N/A',
                                    body: item['body'] ?? 'N/A',
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
