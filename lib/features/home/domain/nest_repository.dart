import 'package:test_flutter/shared/models/nest.dart';

abstract class NestRepository {
  Future<Nest> createNest(String name);
  Future<NestList> listNests();
}