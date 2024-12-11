import 'package:flutter/material.dart';
import 'package:nasa_api/services/nasa_service.dart';
import 'package:url_launcher/url_launcher.dart';

class ApodPage extends StatefulWidget {
  const ApodPage({super.key});

  @override
  State<ApodPage> createState() => _ApodPageState();
}

class _ApodPageState extends State<ApodPage> {


  String? date;

  Widget displayResult(BuildContext context, AsyncSnapshot snapshot) {
    final data = snapshot.data;
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        children: [
          if (data['media_type'] == 'image') ...[
            Image.network(data['url']),
          ] else if (data['media_type'] == 'video') ...[
            Text(
              'A mídia do dia é um vídeo. Visualize no link abaixo:',
              style: TextStyle(color: Colors.white),
            ),
            InkWell(
              child: Text(
                data['url'],
                style: TextStyle(
                    color: Colors.blue, decoration: TextDecoration.underline),
              ),
              onTap: () => launchURL(data['url']),
            ),
          ],
          SizedBox(height: 20),
          Text(
            data['title'] ?? 'Sem título',
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
          ),
          SizedBox(height: 10),
          Text(
            data['explanation'] ?? 'Sem descrição disponível.',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ],
      ),
    );
  }

  void launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Não foi possível abrir a URL: $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'NASA APOD',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            TextField(
              decoration: InputDecoration(
                labelText: "Digite uma Data (YYYY-MM-DD)",
                labelStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.datetime,
              style: TextStyle(color: Colors.white, fontSize: 18),
              onSubmitted: (value) {
                setState(() {
                  date = value;
                });
              },
            ),
            Expanded(
              child: FutureBuilder(
                future: astronomicPicturyOfTheDay(date),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                    case ConnectionState.none:
                      return Container(
                        width: 200.0,
                        height: 200.0,
                        alignment: Alignment.center,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          strokeWidth: 5.0,
                        ),
                      );
                    default:
                      if (snapshot.hasError) {
                        return Center(
                          child: Text(
                            'Erro ao carregar dados.',
                            style: TextStyle(color: Colors.white),
                          ),
                        );
                      } else {
                        return displayResult(context, snapshot);
                      }
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}