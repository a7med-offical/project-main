import 'package:bldapp/Colors.dart';
import 'package:bldapp/Provider/theme_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomCardNotification extends StatelessWidget {
  const CustomCardNotification({super.key, required this.snap});
  final QueryDocumentSnapshot snap;

  @override
  Widget build(BuildContext context) {
    var _theme = Provider.of<ThemeProvider>(context);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: _theme.isDarkMode ? Colors.white : kSecondary,
      ),
      width: double.infinity,
      // height: 110,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
         SizedBox(width : 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                CustomListTile(
                  text: snap['bloodType'],
                  icon: Icons.bloodtype,
                  fontSize: 20,
                  date:''
                ),
                CustomListTile(
                  text: snap['userName'],
                  icon: Icons.person,
                  date :''
                ),
                CustomListTile(
                  text: snap['place'],
                  icon: Icons.location_on,
                  date :''
                ),
                CustomListTile(
                  text: snap['phoneNumber'],
                  icon: Icons.phone,
                  date: snap['date'],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class CustomListTile extends StatelessWidget {
   CustomListTile({
    super.key,
    this.fontSize = 14,
    required this.text,
    required this.icon, this.date,
  });
  final String text;
  final double fontSize;
  String ?date;
  final IconData  icon;
  @override
  Widget build(BuildContext context) {
    return Row(
   crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        Icon(
          icon,
          color: kPrimary,
          size: 20,
        ),
        const SizedBox(
          width: 5,
        ),
        Container(
          width: 180,
          child: Text(
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            text,
            style: TextStyle(
                color: kPrimary,
                fontWeight: FontWeight.bold,
                fontSize: fontSize,
                fontStyle: FontStyle.italic),
          ),
        ),
        const SizedBox(
          height: 6,
        ),
        Text(date!,style: TextStyle(color:kPrimary,fontSize: 16,fontWeight:FontWeight.bold ),)

      ],
    );
  }
}
