import 'package:flutter/material.dart';
import 'package:weader/features/weather/presentation/pages/weather_pages.dart';

class LocationsListDisplay extends StatelessWidget {
  final List locationsList;

  const LocationsListDisplay({Key key, this.locationsList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: locationsList.length,
        itemBuilder: (context, index) {
          return ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WeatherPage(
                    location: locationsList[index],
                  ),
                ),
              );
            },
            leading: Icon(
              Icons.search,
            ),
            title: Text(
              locationsList[index].displayName,
              style: TextStyle(color: Colors.grey),
            ),
            subtitle: Text(
              locationsList[index].address,
            ),
            trailing: Icon(Icons.arrow_forward),
          );
        });
  }
}
