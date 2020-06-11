import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/entities/entities.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repository/settings_repository.dart';

class SwitchTimeFormat extends UseCase<Settings, SwitchTimeFormatParams> {
  final SettingsRepository repository;

  SwitchTimeFormat(this.repository);

  @override
  Future<Either<Failure, Settings>> call(SwitchTimeFormatParams params) async {
    return await repository.switchTimeFormat(params.timeFormat);
  }
}

class SwitchTimeFormatParams extends Equatable {
  final TimeFormat timeFormat;

  SwitchTimeFormatParams(this.timeFormat);
  @override
  List<Object> get props => [timeFormat];
}
