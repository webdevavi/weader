import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/widgets.dart';
import '../../../../injector.dart';
import '../bloc/bloc.dart';
import '../widgets/locations_widgets.dart';

class SearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocProvider(
        create: (_) => getIt<LocationsBloc>(),
        child: Scaffold(
          appBar: SearchBar(),
          body: BlocBuilder<LocationsBloc, LocationsState>(
            builder: (context, state) {
              if (state is LocationsEmpty) {
                return Container();
              } else if (state is LocationsLoading) {
                return LinearProgressIndicator();
              } else if (state is LocationsLoaded) {
                return LocationsListDisplay(
                  locationsList: state.locationsList.locationsList,
                );
              } else if (state is LocationsError) {
                return ErrorDisplay(
                  message: state.message,
                );
              }
              return Container();
            },
          ),
        ),
      ),
    );
  }
}
