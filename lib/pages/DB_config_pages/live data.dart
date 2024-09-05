import 'package:flutter/material.dart';

class LiveData extends ChangeNotifier {
  int totalUsers = 0;
  int jobSeekers = 0;
  int jobProviders = 0;
  int students = 0;

  void updateData(int users, int seekers, int providers, int studentsCount) {
    totalUsers = users;
    jobSeekers = seekers;
    jobProviders = providers;
    students = studentsCount;
    notifyListeners();
  }
}
