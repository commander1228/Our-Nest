import '../../../core/api/api_client.dart';
import 'package:test_flutter/shared/models/nest.dart';

class NestService {
  final ApiClient api;
  NestService(this.api);

  Future<Nest> createNest(String name) async {
    final r = await api.dio.post('/nest/create', data: {'name': name});
    final data = r.data as Map<String, dynamic>;
    return Nest.fromJson(data);
  }

  Future<NestList> listNests() async {
    final r = await api.dio.get('/nest/list');
    final data = r.data as Map<String, dynamic>;
    return NestList.fromJson(data);
  }
}
