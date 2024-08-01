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
      {'image': 'assets/images/t5.jpg', 'date': '12 July 2024'},
      {'image': 'assets/images/t6.jpg', 'date': '12 July 2024'},
      {'image': 'assets/images/t1.jpg', 'date': '1 July 2024'},
      {'image': 'assets/images/t2.jpg', 'date': '12 July 2024'},
      {'image': 'assets/images/t3.jpg', 'date': '12 July 2024'},
    ];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('History'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
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
            Container(
              width: double.infinity,
              color: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Text(
                'History',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
