import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/entities/entities.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repository/settings_repository.dart';

class SwitchUnitSystem extends UseCase<Settings, SwitchUnitSystemParams> {
  final SettingsRepository repository;

  SwitchUnitSystem(this.repository);

  @override
  Future<Either<Failure, Settings>> call(SwitchUnitSystemParams params) async {
    return await repository.switchUnitSystem(params.unitSystem);
  }
}

class SwitchUnitSystemParams extends Equatable {
  final UnitSystem unitSystem;

  SwitchUnitSystemParams(this.unitSystem);
  @override
  List<Object> get props => [unitSystem];
}
