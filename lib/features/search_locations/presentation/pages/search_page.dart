import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/bloc.dart';
import '../widgets/search_bar.dart';
import '../widgets/search_page_body.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  SearchLocationsBloc bloc;
  GlobalKey globalKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    bloc = BlocProvider.of<SearchLocationsBloc>(context);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    bloc.add(
      GetRecentlySearchedLocationsListEvent(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SearchBar(bloc: bloc),
      body: SearchPageBody(
        bloc: bloc,
        globalKey: globalKey,
        mainContext: context,
      ),
      key: globalKey,
    );
  }

  @override
  void dispose() {
    super.dispose();
    bloc.add(
      GetRecentlySearchedLocationsListEvent(),
    );
  }
}
