import 'package:flutter/material.dart';

import 'Approved-Queries.dart';
import 'Job_student_search.dart';
import 'Reject_Queries.dart';

class StudentRequestManage extends StatelessWidget {
  const StudentRequestManage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Student Request Management'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'All Request Requests'),
              Tab(text: 'Approved Requests'),
              Tab(text: 'Rejected Requests'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            JobSearchStudentView(),
            const JobApproveSeekerStudentView(),
            const RejectQueries(),
          ],
        ),
      ),
    );
  }
}


