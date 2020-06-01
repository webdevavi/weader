import 'package:flutter/material.dart';

class LocationsListDisplay extends StatelessWidget {
  final List locationsList;

  const LocationsListDisplay({Key key, this.locationsList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: locationsList.length,
        itemBuilder: (context, index) {
          return ListTile(
            isThreeLine: true,
            onTap: () {},
            leading: Icon(
              Icons.search,
            ),
            title: Text(
              locationsList[index].displayName,
            ),
            subtitle: Text(
              locationsList[index].address,
            ),
            trailing: Icon(Icons.arrow_forward),
          );
        });
  }
}
