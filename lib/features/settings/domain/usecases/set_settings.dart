import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/entities/settings.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import 'package:meta/meta.dart';
import 'package:weader/features/settings/domain/repository/settings_repository.dart';

class SetSettings extends UseCase<Settings, Params> {
  final SettingsRepository repository;

  SetSettings(this.repository);

  @override
  Future<Either<Failure, Settings>> call(Params params) async {
    return await repository.setSettings(params.settings);
  }
}

class Params extends Equatable {
  final Settings settings;

  Params({@required this.settings});

  @override
  List<Object> get props => [settings];
}
