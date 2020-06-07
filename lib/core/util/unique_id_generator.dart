import 'package:uuid/uuid.dart';

class UniqueIdGenerator {
  final Uuid uuid;

  UniqueIdGenerator(this.uuid);

  String get getId => uuid.v1();
}
