import 'package:flutter/material.dart';
import 'package:flutter_application/src/screens/list-securisation.dart';
import 'package:flutter_application/src/screens/form-example.dart';
import 'package:flutter_application/src/screens/list-observations.dart';
import 'package:flutter_application/src/screens/testSecurisation.dart';

class TestPage extends StatefulWidget {
  const TestPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Scaffold(
        body: TabBarView(
          physics: const NeverScrollableScrollPhysics(),
          controller: _tabController,
          children: [
            Navigator(
              onGenerateRoute: (settings) => MaterialPageRoute(
                builder: (context) => ListSecurisation(),
                settings: settings,
              ),
            ),
            Navigator(
              onGenerateRoute: (settings) => MaterialPageRoute(
                builder: (context) => ListObservations(),
                settings: settings,
              ),
            ),
            Navigator(
              onGenerateRoute: (settings) => MaterialPageRoute(
                builder: (context) => FormExample(),
                settings: settings,
              ),
            ),
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          color: Colors.green,
          child: TabBar(
            isScrollable: false,
            controller: _tabController,
            tabs: [
              Tab(
                text: "Sécurisations",
              ),
              Tab(
                text: "Observations",
              ),
              Tab(
                text: "Formulaires",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
