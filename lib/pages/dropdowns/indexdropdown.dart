import 'package:flutter/material.dart';

import 'AddDesignationPage.dart';
import 'AddHighestEducationPage.dart';
import 'AddOrganizationPage.dart';
import 'AddSkillsLevel.dart';
import 'AddSubjects.dart';
import 'Add_Teacher_types.dart';

class IndexdropdownPage extends StatelessWidget {
  const IndexdropdownPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 6, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          title: Text('Add Dynamic value'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Designation'),
              Tab(text: 'Organization'),
              Tab(text: 'Highest Education'),
              Tab(text: 'Skilles Level'),
              Tab(text: 'Subject'),
              Tab(text: 'Teacher'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Adddesignationpage(), // Replace with your actual page widget
            AddOrganizationPage(), // Replace with your actual page widget
            AddHighestEducationPage(), // Replace with your actual page widget
            AddSkillsLevel(),
            AddSubjectsPage(),
            AddTeacherTypePage()
            // Replace with your actual page widget
          ],
        ),
      ),
    );
  }
}

// Example Page A
class APage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('This is Page A'),
    );
  }
}

// Example Page B
class BPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('This is Page B'),
    );
  }
}

// Example Page C
class CPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('This is Page C'),
    );
  }
}

// Example Page D
class DPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('This is Page D'),
    );
  }
}
