import 'package:bldapp/Colors.dart';
import 'package:bldapp/model/donar_model.dart';
import 'package:flutter/material.dart';

class DonarDetailsInfo extends StatefulWidget {
  final Donar donar; // Declare a Donar variable

  DonarDetailsInfo({required this.donar}); // Receive Donar data via constructor

  @override
  _DonarDetailsInfoState createState() => _DonarDetailsInfoState();
}

class _DonarDetailsInfoState extends State<DonarDetailsInfo>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          setState(() {
            _isLoading = false;
          });
        }
      });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     
      appBar: AppBar(
        title: Text('Donar information'),
      ),
      body: _isLoading
          ? Center(
              child: FadeTransition(
                opacity: _animation,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 20.0),
                    Text(
                      'Loading...',
                      style: TextStyle(
                        fontSize: 18.0,
                      ),
                    ),
                  ],
                ),
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    padding: EdgeInsets.all(8.0),
                    child: Card(
                      elevation: 5.0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          _buildDetailRow(
                              'Name', Icons.person, widget.donar.donarName),
                          Divider(),
                          _buildDetailRow('National ID', Icons.credit_card,
                              widget.donar.donarId.toString()),
                          Divider(),
                          _buildDetailRow('Blood Type', Icons.favorite,
                              widget.donar.bloodType),
                          Divider(),
                          _buildDetailRow('Blood Type Date',
                              Icons.calendar_today, widget.donar.createdDate),
                          Divider(),
                          _buildDetailRow('Blood Type Expiry Date', Icons.timer,
                              widget.donar.expiredDate),
                          Divider(),
                          _buildDetailRow('More Details', Icons.info,
                              widget.donar.moreDetails),
                          Divider(),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            color: Colors.amber,
                            borderRadius: BorderRadius.circular(50)),
                        child: IconButton(
                            onPressed: () {
                              Navigator.pop(context); // Navigate back
                            },
                            icon: Icon(
                              Icons.arrow_back,
                              color: background,
                            ))),
                  )
                ],
              ),
            ),
    );
  }

  Widget _buildDetailRow(String label, IconData icon, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        child: Row(
          children: <Widget>[
            Icon(
              icon,
              size: 30.0,
              color: Colors.blue,
            ),
            SizedBox(width: 10.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
