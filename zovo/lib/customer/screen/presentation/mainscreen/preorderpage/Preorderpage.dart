import 'package:flutter/material.dart';
import 'package:zovo/Customer/screen/presentation/mainscreen/mainscreen.dart';


class MyOrdersScreen extends StatelessWidget {
  final List<Order> orders = [
    Order(id: '17061585', status: 'Order Placed', time: 'Just now', date: '', delivered: false, cancelled: false),
    Order(id: '17061545', status: 'In the way', time: '5 hours ago', date: '', delivered: false, cancelled: false),
    Order(id: '17061170', status: 'Delivered', time: '11 June, 2017', date: '', delivered: true, cancelled: false),
    Order(id: '17061170', status: 'Cancelled', time: '15 June, 2017', date: '', delivered: false, cancelled: true),
    Order(id: '17061170', status: 'Delivered', time: '11 June, 2017', date: '', delivered: true, cancelled: false),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
             Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const MainPage()),
        (Route<dynamic> route) => false, // Clears all previous routes
      );
          },
        ),
        backgroundColor: Colors.orangeAccent,
        title: Text("My Order's", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        elevation: 0,
      ),
      body: ListView.builder(
        itemCount: orders.length,
        itemBuilder: (context, index) {
          return OrderCard(order: orders[index]);
        },
      ),
      backgroundColor: Colors.grey.shade100,
    );
  }
}

class Order {
  final String id, status, time, date;
  final bool delivered, cancelled;

  Order({
    required this.id,
    required this.status,
    required this.time,
    required this.date,
    required this.delivered,
    required this.cancelled,
  });
}

class OrderCard extends StatelessWidget {
  final Order order;

  OrderCard({required this.order});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Order id -${order.id}',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                if (order.cancelled)
                  Text('(Cancelled)', style: TextStyle(color: Colors.red)),
                if (order.delivered)
                  Text('(Delivered)', style: TextStyle(color: Colors.green)),
                if (!order.delivered && !order.cancelled)
                  Text('(${order.status})', style: TextStyle(color: Colors.orange)),
              ],
            ),
            SizedBox(height: 8),
            Text('Order title - 19.75\$'),
            SizedBox(height: 4),
            Text(order.time.isEmpty ? order.date : order.time),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (!order.cancelled && !order.delivered)
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                    ),
                    child: Text('Track Order'),
                  ),
                if (order.delivered)
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                    ),
                    child: Text('Review Order'),
                  ),
                if (order.cancelled)
                  SizedBox(), // No action for cancelled orders
                SizedBox(width: 8),
                OutlinedButton(
                  onPressed: () {},
                  child: Text('Repeat Order'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
