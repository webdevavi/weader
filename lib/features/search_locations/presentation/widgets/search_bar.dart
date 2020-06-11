import 'package:flutter/material.dart';

import '../../../../core/widgets/small_icon_button.dart';
import '../bloc/bloc.dart';

class SearchBar extends StatefulWidget implements PreferredSizeWidget {
  final SearchLocationsBloc bloc;

  const SearchBar({Key key, @required this.bloc}) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(55.0);

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  TextEditingController controller;
  FocusNode focus;
  String query;

  @override
  void initState() {
    super.initState();
    focus = FocusNode();
    controller = TextEditingController();
  }

  @override
  AppBar build(BuildContext context) {
    return AppBar(
      leading: SmallIconButton(
        onPressed: () => Navigator.of(context).pop(),
        icon: Icon(Icons.arrow_back),
      ),
      titleSpacing: 0.0,
      title: Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(100.0),
          child: Material(
            color: Theme.of(context).primaryColorDark,
            child: Row(
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
                        color: Colors.white70,
                        fontSize: 18.0,
                      ),
                    ),
                    cursorColor: Colors.white,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                    ),
                    onChanged: (value) {
                      setState(() {
                        query = value;
                      });
                    },
                    onSubmitted: (_) => _addGetLocations(query),
                  ),
                ),
                SmallIconButton(
                  onPressed: () => _addGetLocations(query),
                  icon: Icon(Icons.search, color: Colors.white),
                ),
                SmallIconButton(
                  onPressed: () {
                    controller.clear();
                  },
                  icon: Icon(Icons.clear, color: Colors.white),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _addGetLocations(String query) {
    focus.unfocus();
    widget.bloc.add(GetLocationsListEvent(query));
  }

  @override
  void dispose() {
    super.dispose();
    focus.dispose();
    controller.dispose();
  }
}
