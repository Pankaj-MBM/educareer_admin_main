import 'package:flutter/material.dart';

import 'DB_config_pages/count_users.dart';

class LiveDataPage extends StatelessWidget {
  final DataService dataService = DataService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Live User Counts'),
      ),
      body: StreamBuilder<Map<String, int>>(
        stream: dataService.getCounts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text('No data available'));
          }

          final data = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Text('Total Users: ${data['total_users']}'),
                Text('Students: ${data['students']}'),
                Text('Job Seekers: ${data['job_seekers']}'),
                Text('Job Providers: ${data['job_providers']}'),
              ],
            ),
          );
        },
      ),
    );
  }
}
