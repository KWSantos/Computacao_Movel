import 'package:flutter/material.dart';
import 'package:nasa_api/views/apod_page.dart';
import 'package:nasa_api/views/earth_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/image.png',
                fit: BoxFit.contain,
                height: 80,
              ),
            ],
          ),
          centerTitle: true
        ),
        backgroundColor: Colors.black,
        body: Padding(
          padding: EdgeInsets.all(10.0),
          child: Column(children: <Widget>[
            GestureDetector(
              child: Row(
                children: <Widget>[
                  Icon(Icons.edit, color: Colors.white, size: 70.0),
                  Text(
                    "Foto Astronômica do dia",
                    style: TextStyle(color: Colors.white, fontSize: 22.0),
                  ),
                ],
              ),
              onTap: () {
                Navigator.push(context,
                MaterialPageRoute(builder: (context) => ApodPage()));
              },
            ),
            GestureDetector(
              child: Row(
                children: <Widget>[
                  Icon(Icons.home, color: Colors.white, size: 70.0),
                  Text(
                    "Foto da Terra do dia",
                    style: TextStyle(color: Colors.white, fontSize: 22.0),
                  )
                ],
              ),
              onTap: () {
                Navigator.push(
                context, MaterialPageRoute(builder: (context) => EarthPage()));
              },
            ),
          ]),
        ),
    );
  }
}