import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/entities/entities.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repository/settings_repository.dart';

class SwitchCurrentTheme extends UseCase<Settings, SwitchCurrentThemeParams> {
  final SettingsRepository repository;

  SwitchCurrentTheme(this.repository);

  @override
  Future<Either<Failure, Settings>> call(
      SwitchCurrentThemeParams params) async {
    return await repository.switchCurrentTheme(params.currentTheme);
  }
}

class SwitchCurrentThemeParams extends Equatable {
  final CurrentTheme currentTheme;

  SwitchCurrentThemeParams(this.currentTheme);
  @override
  List<Object> get props => [currentTheme];
}
