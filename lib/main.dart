import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const HaritiiDeliveryApp());
}

class HaritiiDeliveryApp extends StatelessWidget {
  const HaritiiDeliveryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Haritii Delivery',
      theme: ThemeData(primarySwatch: Colors.green),
      home: const DeliveryOrdersScreen(),
    );
  }
}

class DeliveryOrdersScreen extends StatelessWidget {
  const DeliveryOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('የቀረቡ ትእዛዞች (Orders)'),
        backgroundColor: Colors.green,
      ),
      body: StreamBuilder<QuerySnapshot>(
        // 1. በቅጽበት 'pending' የሆኑ ትእዛዞችን ማዳመጥ
        stream: FirebaseFirestore.instance
            .collection('orders')
            .where('status', isEqualTo: 'pending')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                'አሁን ላይ ምንም አዲስ ትእዛዝ የለም',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }

          final orders = snapshot.data!.docs;

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              var orderData = orders[index].data() as Map<String, dynamic>;
              String orderId = orders[index].id;

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: ListTile(
                  title: Text(
                    'ትእዛዝ: ${orderData['customerName'] ?? 'ደንበኛ'}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'አድራሻ: ${orderData['deliveryAddress'] ?? 'ያልተጠቀሰ'}\nዋጋ: ${orderData['totalPrice'] ?? '0'} ETB',
                  ),
                  trailing: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () async {
                      // 2. ትእዛዙን ስትቀበል ዳታቤዝ ላይ Update ያደርጋል
                      await FirebaseFirestore.instance
                          .collection('orders')
                          .doc(orderId)
                          .update({
                        'status': 'accepted',
                        'acceptedAt': FieldValue.serverTimestamp(),
                      });

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('ትእዛዙን በትክክል ተቀብለዋል!')),
                      );
                    },
                    child: const Text('ተቀበል (Accept)'),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}