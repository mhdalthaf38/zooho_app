import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';



class ScheduleScreen extends StatefulWidget {
  @override
  _ScheduleScreenState createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.black,
        title: Text(
          "Schedule",
          style: GoogleFonts.poppins(
              fontSize: 22, color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: TabBar(
            controller: _tabController,
            labelStyle: GoogleFonts.poppins(fontSize: 16),
            indicator: BoxDecoration(
              color: Color(0xFFFFD4E5), // Light pink for the active tab
              borderRadius: BorderRadius.circular(20),
            ),
            unselectedLabelColor: Colors.white,
            labelColor: Colors.black,
            indicatorPadding: EdgeInsets.symmetric(horizontal: 10),
            tabs: [
              Tab(text: "Upcoming"),
              Tab(text: "Complete"),
              Tab(text: "Cancel"),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          ScheduleListView(),
          Center(child: Text("Complete Tab", style: TextStyle(color: Colors.white))),
          Center(child: Text("Cancel Tab", style: TextStyle(color: Colors.white))),
        ],
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}

class ScheduleListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(10),
      children: [
        ScheduleCard(
          doctorName: "Dr. Vega Punk",
          specialization: "Heart Specialist",
          date: "Monday, Jan 8",
          time: "9.00 - 11.00",
          status: "Confirmed",
          doctorImage: "https://via.placeholder.com/50",
        ),
        ScheduleCard(
          doctorName: "Dr. Brooklyn Simmons",
          specialization: "Specialist Pulmonologist",
          date: "Monday, Jan 8",
          time: "9.00 - 11.00",
          status: "Confirmed",
          doctorImage: "https://via.placeholder.com/50",
        ),
        ScheduleCard(
          doctorName: "Dr. Darlene Robertson",
          specialization: "Specialist Pulmonologist",
          date: "Monday, Jan 8",
          time: "9.00 - 11.00",
          status: "Pending",
          doctorImage: "https://via.placeholder.com/50",
        ),
      ],
    );
  }
}

class ScheduleCard extends StatelessWidget {
  final String doctorName;
  final String specialization;
  final String date;
  final String time;
  final String status;
  final String doctorImage;

  const ScheduleCard({
    Key? key,
    required this.doctorName,
    required this.specialization,
    required this.date,
    required this.time,
    required this.status,
    required this.doctorImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[900],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: EdgeInsets.only(bottom: 15),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(doctorImage),
              radius: 30,
            ),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    doctorName,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    specialization,
                    style: GoogleFonts.poppins(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.calendar_today, color: Colors.white, size: 14),
                      SizedBox(width: 5),
                      Text(
                        date,
                        style: GoogleFonts.poppins(color: Colors.white, fontSize: 13),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.access_time, color: Colors.white, size: 14),
                      SizedBox(width: 5),
                      Text(
                        time,
                        style: GoogleFonts.poppins(color: Colors.white, fontSize: 13),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.circle,
                          color: status == "Confirmed"
                              ? Colors.green
                              : Colors.orange,
                          size: 12),
                      SizedBox(width: 5),
                      Text(
                        status,
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              children: [
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[700],
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20))),
                  child: Text("Cancel",
                      style: GoogleFonts.poppins(color: Colors.white)),
                ),
                SizedBox(height: 5),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pinkAccent,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20))),
                  child: Text("Reschedule",
                      style: GoogleFonts.poppins(color: Colors.white)),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class BottomNavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.black,
      selectedItemColor: Colors.pinkAccent,
      unselectedItemColor: Colors.white,
      currentIndex: 1, // Calendar Tab Selected
      items: [
        BottomNavigationBarItem(
            icon: Icon(Icons.home), label: "Home"),
        BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today), label: "Calendar"),
        BottomNavigationBarItem(
            icon: Icon(Icons.message), label: "Messages"),
        BottomNavigationBarItem(
            icon: Icon(Icons.person), label: "Profile"),
      ],
    );
  }
}
