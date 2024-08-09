import 'package:flutter/material.dart';
import 'Companies.dart';
import 'DB_config_pages/logout.dart';
import 'Student list.dart';
import 'UnderWorking.dart';
import 'add_new_job.dart';
import 'candidate.dart';
import 'contactpage.dart';
import 'home.dart';
import 'jobs.dart';
import 'panelists.dart';
import 'profile-Setting.dart';
import 'profile.dart';

class IndexPage extends StatefulWidget {
  final Map<String, dynamic> userData;
  const IndexPage({super.key, required this.userData});

  @override
  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  bool _isDrawerOpen = true;
  Widget _currentPage = const HomePage();

  Future<void> _toggleDrawer() async {
    setState(() {
      _isDrawerOpen = !_isDrawerOpen;
    });
  }

  void _updatePage(Widget page, {Map<String, dynamic>? userData}) {
    setState(() {
      if (page is ProfilePage && userData != null) {
        _currentPage = ProfilePage(userData: userData);
      } else {
        _currentPage = page;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final String userName = widget.userData['name'] ?? 'User'; // Default to 'User' if name is not available

    return Scaffold(
      appBar: AppBar(
        title: RichText(
          text: const TextSpan(
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
        actions: [
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
          Center(
            child: Container(
              color: Colors.orange,
              child: Padding(
                padding: const EdgeInsets.only(left: 8, right: 15),
                child: Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: CircleAvatar(
                        radius: 20, // Set the size of the avatar
                        backgroundImage: AssetImage('assets/images/new1.JPG'),
                        backgroundColor: Colors.transparent,
                      ),
                    ),
                    Text(
                      userName, // Display dynamic user name
                      style: TextStyle(
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
                            _updatePage(ProfilePage(userData: widget.userData)); // Pass userData here
                            break;
                          case 2:
                            _updatePage(ProfileSetting());
                            break;
                          case 3:
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
                        const PopupMenuItem(
                          value: 2,
                          child: Text("Settings"),
                        ),
                        const PopupMenuItem(
                          value: 3,
                          child: Text("Logout"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      body: Row(
        children: [
          CustomDrawer(
            isOpen: _isDrawerOpen,
            toggleDrawer: _toggleDrawer,
            onPageSelected: _updatePage,
            userName: userName, // Pass the dynamic user name to the drawer
          ),
          Expanded(
            child: _currentPage,
          ),
        ],
      ),
    );
  }
}

class CustomDrawer extends StatelessWidget {
  final bool isOpen;
  final VoidCallback toggleDrawer;
  final void Function(Widget) onPageSelected; // Callback for page selection
  final String userName; // Add a field for user name

  const CustomDrawer({
    super.key,
    required this.isOpen,
    required this.toggleDrawer,
    required this.onPageSelected, // Initialize the callback
    required this.userName, // Initialize the user name
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: isOpen ? 225 : 80, // Expanded and collapsed widths
      color: const Color(0xFF263238),
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 100,
            // Set the height of the DrawerHeader
            child: DrawerHeader(
              child: Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      radius: 30, // Set the size of the avatar
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
                        Text(
                          userName, // Display dynamic user name
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                          ),
                        ),
                        const Text(
                          'Online',
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
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
              margin: EdgeInsets.zero,
              padding: EdgeInsets.zero,
            ),
          ),
          const SizedBox(height: 15),
          _buildListTile(Icons.dashboard, 'Dashboard', context, Colors.purple,
              const HomePage()),
          _buildJobsExpansionTile(context),
          _buildListTile(Icons.apps_outage_sharp, 'Companies', context, Colors.cyan,
              const CompaniePage()),
          _buildListTile(Icons.apps_outage_sharp, 'Students', context, Colors.cyan,
              const StudentList()),
          _buildListTile(Icons.diamond_outlined, 'Candidates', context, Colors.purpleAccent,
              const Candidates()),
          _buildListTile(Icons.map_sharp, 'Panelists', context, Colors.red,
              const PanelistsPage()),
          _buildListTile(Icons.contact_mail_rounded, 'Contact', context, Colors.blue,
              const ContactPage()),
          _buildListTile(Icons.settings, 'Settings', context, Colors.green,
              const UnderWorking()),
        ],
      ),
    );
  }

  Widget _buildListTile(IconData icon, String text, BuildContext context, Color color,
      Widget page) {
    return ListTile(
      leading: Icon(
        icon,
        color: color,
      ),
      title: isOpen ? Text(text, style: const TextStyle(color: Colors.white)) : null,
      onTap: () {
        onPageSelected(page);
      },
    );
  }

  Widget _buildJobsExpansionTile(BuildContext context) {
    return ExpansionTile(
      leading: Icon(Icons.widgets_outlined, color: Colors.greenAccent),
      title: isOpen
          ? const Text('Jobs', style: TextStyle(color: Colors.white))
          : const SizedBox.shrink(), // Use SizedBox.shrink() for a hidden title
      children: <Widget>[
        ListTile(
          title: const Text('Add New Job', style: TextStyle(color: Colors.white)),
          onTap: () {
            onPageSelected(AddNewJobPortal()); // Assuming JobsPage handles New Job
          },
        ),
        ListTile(
          title: const Text('All Jobs', style: TextStyle(color: Colors.white)),
          onTap: () {
            onPageSelected(const JobsPage()); // Adjust if All Jobs has a different page
          },
        ),
      ],
    );
  }
}
