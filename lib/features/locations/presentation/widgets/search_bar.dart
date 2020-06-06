import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/bloc.dart';

class SearchBar extends StatefulWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => Size.fromHeight(120.0);
  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  String query;
  TextEditingController controller = TextEditingController();
  FocusNode focus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 4.0,
      color: Theme.of(context).primaryColor,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(100.0),
          child: Material(
            color: Theme.of(context).primaryColorDark,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: controller,
                    focusNode: focus,
                    textInputAction: TextInputAction.search,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 18.0),
                      border: InputBorder.none,
                      hintText: "Search",
                      hintStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                      ),
                    ),
                    cursorColor: Colors.white,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                    ),
                    onChanged: (value) => setState(() {
                      query = value;
                    }),
                    onSubmitted: (_) => _addGetLocations(query),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.search),
                  color: Colors.white,
                  onPressed: () => _addGetLocations(query),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _addGetLocations(String query) {
    focus.unfocus();
    BlocProvider.of<LocationsBloc>(context).add(GetLocationsListEvent(query));
  }

  void _addGetDeviceLocations() {
    controller.clear();
    focus.unfocus();
    BlocProvider.of<LocationsBloc>(context).add(GetDeviceLocationsListEvent());
  }
}
