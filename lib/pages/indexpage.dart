import 'package:flutter/material.dart';
import 'package:flutteradmin/pages/provider/add_job_Provider.dart';
import 'package:flutteradmin/pages/provider/job_Provider_list.dart';
import 'package:flutteradmin/pages/provider/test.dart';
import 'package:flutteradmin/pages/seeker/add_job_seeker.dart';
import 'package:flutteradmin/pages/seeker/add_new_job.dart';
import 'package:flutteradmin/pages/seeker/job_seeker_list.dart';
import 'package:flutteradmin/pages/seeker/jobs.dart';
import 'package:flutteradmin/pages/student/add_student.dart';
import 'package:flutteradmin/pages/student/students_list.dart';
import 'package:flutteradmin/pages/test.dart';
import 'package:flutteradmin/pages/website_layout/feature_job.dart';
import 'package:flutteradmin/pages/StatusCheckPage.dart';
import 'package:flutteradmin/pages/ProviderSearchPage.dart';
import 'package:flutteradmin/pages/Job_student_search.dart';
import 'Companies.dart';
import 'DB_config_pages/logout.dart';
import 'Help_Support.dart';
import 'Reject_Queries.dart';
import 'Student_Query_Manager.dart';
import 'UnderWorking.dart';
import 'candidate.dart';
import 'contactpage.dart';
import 'dropdowns/indexdropdown.dart';
import 'home.dart';
import 'profile-Setting.dart';
import 'profile.dart';

class IndexPage extends StatefulWidget {
  final Map<String, dynamic> userData;
  const IndexPage({super.key, required this.userData});

  @override
  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  bool _isDrawerOpen = false; // Set the drawer to closed by default
  Widget _currentPage =  HomePage();
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _isDrawerOpen = !_isMobileView(); // Auto open drawer for desktop/laptop
      setState(() {});
    });
  }

  void _toggleDrawer() {
    setState(() {
      _isDrawerOpen = !_isDrawerOpen;
    });
  }

  void _updatePage(int index, Widget page, {Map<String, dynamic>? userData}) {
    setState(() {
      _selectedIndex = index;
      if (page is ProfilePage && userData != null) {
        _currentPage = ProfilePage(userData: userData);
      } else {
        _currentPage = page;
      }
      if (_isMobileView()) {
        _isDrawerOpen = false; // Close the drawer after selecting a page on mobile
      }
    });
  }

  bool _isMobileView() {
    return MediaQuery.of(context).size.width < 768; // Adjust the width threshold as needed
  }

  @override
  Widget build(BuildContext context) {
    final String userName = widget.userData['name'] ?? 'User';

    return Scaffold(
      appBar: AppBar(
        title: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'EDU',
                style: TextStyle(
                  fontSize: 22,
                  color: Colors.deepOrange, // Color for EDU
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(
                text: 'Career',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.blue, // Color for Career
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        backgroundColor: const Color(0xFF263238),
        leading: IconButton(
          icon: Icon(_isDrawerOpen ? Icons.arrow_back : Icons.menu),
          color: Colors.white,
          onPressed: _toggleDrawer,
        ),
        actions: _isMobileView()
            ? [_buildUserProfileDropdown(userName)] // Show dropdown only on mobile
            : _buildAppBarActions(userName), // Show full actions on larger screens
      ),
      body: Row(
        children: [
          if (!_isMobileView() || _isDrawerOpen)
            CustomDrawer(
              isOpen: _isDrawerOpen,
              toggleDrawer: _toggleDrawer,
              onPageSelected: (index, page) => _updatePage(index, page, userData: widget.userData),
              selectedIndex: _selectedIndex,
              userName: userName,
            ),
          Expanded(
            child: _currentPage,
          ),
        ],
      ),
    );
  }

  List<Widget> _buildAppBarActions(String userName) {
    return [
      IconButton(
        icon: const Icon(Icons.light_mode_outlined),
        color: Colors.white,
        onPressed: () {
          // Handle theme toggle
        },
      ),
      IconButton(
        icon: const Icon(Icons.notifications_none),
        color: Colors.white,
        onPressed: () {
          // Handle notifications
        },
      ),
      IconButton(
        icon: const Icon(Icons.mail_outline_outlined),
        color: Colors.white,
        onPressed: () {
          // Handle mail options
        },
      ),
      IconButton(
        icon: const Icon(Icons.verified_user_outlined),
        color: Colors.green,
        onPressed: () {
          // Handle user verification
        },
      ),
      _buildUserProfileDropdown(userName),
    ];
  }

  Widget _buildUserProfileDropdown(String userName) {
    return Center(
      child: Container(
      // color: Colors.orange,
        child: Padding(
          padding: const EdgeInsets.only(left: 8, right: 15),
          child: Row(
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: CircleAvatar(
                  radius: 20,
                  backgroundImage: AssetImage('assets/images/new1.JPG'),
                  backgroundColor: Colors.transparent,
                ),
              ),
              if (!_isMobileView())
                Text(
                  userName,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 18,
                  ),
                ),
              PopupMenuButton<int>(
                icon: const Icon(
                  Icons.keyboard_arrow_down_outlined,
                  color: Colors.white70,
                ),
                onSelected: (value) {
                  switch (value) {
                    case 1:
                      _updatePage(_selectedIndex, ProfilePage(userData: widget.userData));
                      break;
                    // case 2:
                    //   _updatePage(_selectedIndex, ProfileSetting());
                    //   break;

                    case 2:
                      setState(() {
                        logout(context);
                      });
                      break;
                  }
                },
                itemBuilder: (BuildContext context) => [
                  const PopupMenuItem(
                    value: 1,
                    child: Text("Profile"),
                  ),
                  // const PopupMenuItem(
                  //   value: 2,
                  //   child: Text("Settings"),
                  // ),
                  const PopupMenuItem(
                    value: 2,
                    child: Text("Logout"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomDrawer extends StatelessWidget {
  final bool isOpen;
  final VoidCallback toggleDrawer;
  final void Function(int, Widget) onPageSelected;
  final int selectedIndex;
  final String userName;

  const CustomDrawer({
    super.key,
    required this.isOpen,
    required this.toggleDrawer,
    required this.onPageSelected,
    required this.selectedIndex,
    required this.userName,
  });

  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.of(context).size.width < 768;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: isOpen ? (isMobile ? MediaQuery.of(context).size.width : 225) : 0,
      color: const Color(0xFF263238),
      child: Column(
        children: <Widget>[
          if (isOpen)
            DrawerHeader(
              child: Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      radius: 30,
                      backgroundImage: AssetImage('assets/images/new1.JPG'),
                      backgroundColor: Colors.transparent,
                    ),
                  ),
                  if (isOpen) ...[
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: Text(
                            userName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                            ),
                          ),
                        ),
                        Center(
                          child: const Text(
                            'Online',
                            style: TextStyle(
                              color: Colors.green,
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
              decoration: const BoxDecoration(
                color: Color(0xFF263238),
              ),
            ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildListTile(0, Icons.dashboard, 'Dashboard', context, Colors.purple,  HomePage()),
                  _buildJobsExpansionTile(context),
                  _buildProviderExpansionTile(context),
                  _buildStudentExpansionTile(context),
                  _buildListTile(1, Icons.supervised_user_circle, 'Job seeker Search', context, Colors.cyan,const SeekerJobSearchView()),
                  _buildListTile(2, Icons.app_registration_sharp, 'Job Provider Search', context, Colors.green,const ProviderJobSearchView()),
                   // _buildListTile(3, Icons.apps_outage_sharp, 'Test', context, Colors.cyan,LiveDataPage()),
                  _buildListTile(4, Icons.apps_outage_sharp, 'StudentRequestManage', context, Colors.cyan,StudentRequestManage()),
                  // _buildListTile(5, Icons.apps_outage_sharp, 'Companies', context, Colors.cyan, const CompaniePage()),
                  // _buildListTile(6, Icons.diamond_outlined, 'Candidates', context, Colors.purpleAccent, const Candidates()),
                  _buildListTile(7, Icons.map_sharp, 'Hepls Queries', context, Colors.red, const HelpAndSupportPage()),
                  _buildListTile(8, Icons.water_drop, 'Drop Down Menus', context, Colors.yellow, const IndexdropdownPage()),
                  _buildListTile(9, Icons.home_repair_service, 'Add featured Jobs', context, Colors.greenAccent, const FeatureJobPage()),
                  _buildListTile(10, Icons.contact_mail_rounded, 'Contact', context, Colors.blue, const ContactPage()),
                  // _buildListTile(11, Icons.settings, 'Settings', context, Colors.green, const UnderWorking()),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListTile(int index, IconData icon, String text, BuildContext context, Color color, Widget page) {
    final bool isSelected = index == selectedIndex;
    return ListTile(
      leading: Icon(
        icon,
        color: color,
      ),
      title: isOpen
          ? Text(
        text,
        style: TextStyle(
          color: isSelected ? Colors.orange : Colors.white,
        ),
      )
          : null,
      tileColor: isSelected ? Colors.orange.withOpacity(0.2) : Colors.transparent,
      onTap: () {
        onPageSelected(index, page);
      },
    );
  }
   //job Seeker
  Widget _buildJobsExpansionTile(BuildContext context) {
    return ExpansionTile(
      leading: Icon(Icons.widgets_outlined, color: Colors.orange),
      title: isOpen
          ? const Text('Job Seekers', style: TextStyle(color: Colors.white))
          : const SizedBox.shrink(),
      children: <Widget>[
        ListTile(
          title: const Text('All Jobs', style: TextStyle(color: Colors.white)),
          onTap: () {
            onPageSelected(2, const JobsPage());
          },
        ),
        ListTile(
          title: const Text('Add New Job', style: TextStyle(color: Colors.white)),
          onTap: () {
            onPageSelected(2, const AddNewJobPortal());
          },
        ),
        ListTile(
          title: const Text('All Job Seekers', style: TextStyle(color: Colors.white)),
          onTap: () {
            onPageSelected(2,  JobSeekerList());
          },
        ),
        ListTile(
          title: const Text('Add Job Seeker', style: TextStyle(color: Colors.white)),
          onTap: () {
            onPageSelected(2,AddNewJobSeeker());
          },
        ),
        // ListTile(
        //   title: const Text('Items', style: TextStyle(color: Colors.white)),
        //   onTap: () {
        //     onPageSelected(2,DropMenuIndexPage());
        //   },
        // ),
      ],
    );
  }
    // job Provider
  Widget _buildProviderExpansionTile(BuildContext context) {
    return ExpansionTile(
      leading: Icon(Icons.groups_outlined, color: Colors.red),
      title: isOpen
          ? const Text('Job Providers', style: TextStyle(color: Colors.white))
          : const SizedBox.shrink(),
      children: <Widget>[
        ListTile(
          title: const Text('All Providers', style: TextStyle(color: Colors.white)),
          onTap: () {
            onPageSelected(2, JobProviderList());
          },
        ),
        ListTile(
          title: const Text('Add New Provider', style: TextStyle(color: Colors.white)),
          onTap: () {
            onPageSelected(2, AddJobProvider());
          },
        ),

      ],
    );
  }
    // student
  Widget _buildStudentExpansionTile(BuildContext context) {
    return ExpansionTile(
      leading: Icon(Icons.school_outlined, color: Colors.blue),
      title: isOpen
          ? const Text('Students', style: TextStyle(color: Colors.white))
          : const SizedBox.shrink(),
      children: <Widget>[
        ListTile(
          title: const Text('All Students', style: TextStyle(color: Colors.white)),
          onTap: () {
            onPageSelected(2, StudentList());
          },
        ),
        ListTile(
          title: const Text('Add Student', style: TextStyle(color: Colors.white)),
          onTap: () {
            onPageSelected(2, AddNewStudent());
          },
        ),
      ],
    );
  }
}
