import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/entities/entities.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repository/settings_repository.dart';

class SwitchDataPreference
    extends UseCase<Settings, SwitchDataPreferenceParams> {
  final SettingsRepository repository;

  SwitchDataPreference(this.repository);

  @override
  Future<Either<Failure, Settings>> call(
      SwitchDataPreferenceParams params) async {
    return await repository.switchDataPreference(params.dataPreference);
  }
}

class SwitchDataPreferenceParams extends Equatable {
  final DataPreference dataPreference;

  SwitchDataPreferenceParams(this.dataPreference);
  @override
  List<Object> get props => [dataPreference];
}
