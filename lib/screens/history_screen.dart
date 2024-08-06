import 'package:flutter/material.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  Widget build(BuildContext context) {
    // Dummy data for the grid
    final List<Map<String, String>> historyItems = [
      {'image': 'assets/images/t1.jpg', 'date': '1 July 2024'},
      {'image': 'assets/images/t2.jpg', 'date': '12 July 2024'},
      {'image': 'assets/images/t3.jpg', 'date': '12 July 2024'},
      {'image': 'assets/images/t4.jpg', 'date': '1 July 2024'},
      {'image': 'assets/images/t6.jpg', 'date': '12 July 2024'},
      {'image': 'assets/images/t6.jpg', 'date': '12 July 2024'},
      {'image': 'assets/images/t1.jpg', 'date': '1 July 2024'},
      {'image': 'assets/images/t2.jpg', 'date': '12 July 2024'},
      {'image': 'assets/images/t3.jpg', 'date': '12 July 2024'},
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pushReplacementNamed('/start');
          },
        ),
        title: const Text(
          'History',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, // 3 items per row
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 0.75, // Aspect ratio for the grid items
                ),
                itemCount: historyItems.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.asset(
                            historyItems[index]['image']!,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        historyItems[index]['date']!,
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
