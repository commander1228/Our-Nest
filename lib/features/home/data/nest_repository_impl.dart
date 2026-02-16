
import 'package:test_flutter/features/home/domain/nest_repository.dart';
import 'package:test_flutter/shared/models/nest.dart';
import './nest_service.dart';

class NestRepositoryImpl implements NestRepository {
  final NestService service;

  NestRepositoryImpl(this.service);

  @override
  Future<Nest> createNest(String name) async {
    final res = await service.createNest(name);
    if(name.trim().isEmpty){
    throw Exception('creating a new nest requires a name');
    }
    return res;
  }

  @override
  Future<NestList> listNests() async {
    final res = await service.listNests();
    return res;
  }
}