import 'package:flutter/material.dart';

class CustomDrawer extends StatefulWidget {
  final Widget child;

  const CustomDrawer({Key? key, required this.child}) : super(key: key);

  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  bool _isOpen = false;

  void _toggleDrawer() {
    setState(() {
      _isOpen = !_isOpen;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        if (details.delta.dx > 0) {
          // Swiping right to left
          if (!_isOpen && details.globalPosition.dx < 50) {
            _toggleDrawer();
          }
        } else {
          // Swiping left to right
          if (_isOpen && details.globalPosition.dx > screenWidth - 50) {
            _toggleDrawer();
          }
        }
      },
      child: Stack(
        children: [
          widget.child,
          AnimatedContainer(
            duration: Duration(milliseconds: 300),
            transform: Matrix4.translationValues(
              _isOpen ? -screenWidth * 0.7 : 0,
              0,
              0,
            ),
            child: Container(
              width: screenWidth * 0.7,
              height: double.infinity,
              color: Colors.white,
              child: Center(
                child: Text('Custom Drawer'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
