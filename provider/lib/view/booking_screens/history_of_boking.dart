import 'package:flutter/material.dart';
import 'package:worker/controller/history_of_booking_controller.dart';
import 'package:worker/models/booking_model.dart';

class HistoryBookingScreen extends StatefulWidget {
  @override
  _HistoryBookingScreenState createState() => _HistoryBookingScreenState();
}

class _HistoryBookingScreenState extends State<HistoryBookingScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late HistoryBookingController _historyBookingController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _historyBookingController = HistoryBookingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('سجل تعاملاتي'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'مؤكد'),
            Tab(text: 'معلق'),
            Tab(text: 'ملغا'),
            Tab(text: 'مكتمل'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          HistoryBookingList(
              status: 'accepted',
              historyBookingController: _historyBookingController),
          HistoryBookingList(
              status: 'pending',
              historyBookingController: _historyBookingController),
          HistoryBookingList(
              status: 'canceled',
              historyBookingController: _historyBookingController),
          HistoryBookingList(
              status: 'completed',
              historyBookingController: _historyBookingController),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}

class HistoryBookingList extends StatelessWidget {
  final String status;
  final HistoryBookingController historyBookingController;

  const HistoryBookingList({
    required this.status,
    required this.historyBookingController,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Booking>>(
      future: historyBookingController.getBookingsByStatus(status),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          final List<Booking> bookings = snapshot.data ?? [];
          return ListView.builder(
            itemCount: bookings.length,
            itemBuilder: (context, index) {
              final booking = bookings[index];
              return ListTile(
                title: Container(
                  padding: EdgeInsets.all(
                      8.0), // Add padding for better visual separation
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey), // Add border
                    borderRadius:
                        BorderRadius.circular(8.0), // Add border radius
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "  اسم طالب الخدمه: ${booking.user.name} ",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                          // Add your desired text style here
                        ),
                      ),
                      SizedBox(height: 4.0), // Add spacing between text
                      Text(
                        " وصف الخدمه: ${booking.description}",
                        style: TextStyle(
                            // Add your desired text style here
                            ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }
}
