class Nest {
  final String name;
  final String joinCode;
  final List<String> members;

  Nest({required this.name, required this.members, required this.joinCode});

  factory Nest.fromJson(Map<String, dynamic> json) {
    final name = (json['name'] ?? '').toString();
    final joinCode = (json['joinCode'] ?? json['join_code'] ?? '').toString();

    final membersRaw = json['members'];
    final members = (membersRaw is Iterable)
        ? membersRaw.map((e) => e?.toString() ?? '').toList()
        : <String>[];

    return Nest(name: name, joinCode: joinCode, members: members);
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'join_code': joinCode,
        'members': members,
      };
}

class NestList {
  final List<Nest> nests;

  NestList({required this.nests});

  factory NestList.fromJson(Map<String, dynamic> json) {
    final list = (json['nests'] as List<dynamic>?) ?? <dynamic>[];
    return NestList(
      nests: list
          .map((e) => Nest.fromJson(e as Map<String, dynamic>))
          .toList(growable: false),
    );
  }
}