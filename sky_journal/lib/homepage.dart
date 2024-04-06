import 'package:sky_journal/imports/home_page_imports/home_page_imports.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 1;
  String userName = ''; // Default value for user name

  @override
  void initState() {
    super.initState();
    loadUserName();
  }

  void loadUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('userName') ??
          ''; // Get user name from shared preferences
    });
  }

  void _navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = [
      Wallet(),
      Flights(userName: userName), // Pass the user name to the Flights page
      Stats(),
      Settings(),
    ];
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        color: Surface,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
          child: GNav(
            backgroundColor: Surface,
            activeColor: Yellow,
            gap: 8,
            selectedIndex: _selectedIndex,
            onTabChange: _navigateBottomBar,
            padding: EdgeInsets.all(16),
            tabs: [
              GButton(
                icon: Icons.wallet,
                text: 'Cards',
                iconColor: Colors.white,
              ),
              GButton(
                icon: Icons.home,
                text: 'Flights',
                iconColor: Colors.white,
              ),
              GButton(
                icon: Icons.stacked_bar_chart,
                text: 'Stats',
                iconColor: Colors.white,
              ),
              GButton(
                icon: Icons.settings,
                text: 'Settings',
                iconColor: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
