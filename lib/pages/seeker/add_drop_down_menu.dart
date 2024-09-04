import 'package:flutter/material.dart';

import 'add_job_category.dart';

class DropMenuIndexPage extends StatelessWidget {
  const DropMenuIndexPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Drop Menu Index'),
        bottom: TabBar(
          tabs: [
            Tab(text: 'Category'),
            Tab(text: 'Organization'),
            Tab(text: 'Courses'),
            Tab(text: 'Subjects'),
          ],
        ),
      ),
      body: const TabBarView(
        children: [
          AddJobCategory(),
          AddJobCategory(),
          AddJobCategory(),
          AddJobCategory(),
        ],
      ),
    );
  }
}

