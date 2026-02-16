import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_flutter/core/logger/logger.dart';
import 'package:test_flutter/features/home/domain/nest_repository.dart';
import 'package:test_flutter/features/home/presentation/widgets/nest_card.dart';
import 'package:test_flutter/shared/models/nest.dart';




class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final NestRepository _nestRepo;
  bool _isLoading = false;
  final List<Nest> _nests = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
   _nestRepo = Provider.of<NestRepository>(context, listen: false); // requires Provider<NestService> above
  _loadNests();
    });
  }

  Future<void> _loadNests() async {
  final logger = Provider.of<Logger>(context, listen: false);
  logger.info('HomeScreen: start loading nests');
  setState(() => _isLoading = true);
  try {
    final NestList result = await _nestRepo.listNests();
    logger.info('HomeScreen: repo returned ${result.nests.length} nests');
    if (!mounted) return;
    setState(() {
      _nests
        ..clear()
        ..addAll(result.nests);
    });
    logger.info('HomeScreen: applied ${_nests.length} nests to state');
  } catch (e, st) {
    logger.error('HomeScreen: load failed', e, st);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load nests: $e')),
      );
    }
  } finally {
    if (!mounted) return;
    setState(() => _isLoading = false);
    logger.info('HomeScreen: load finished');
  }
}

  void _addDummy() {
    setState(() {
      final id = DateTime.now().millisecondsSinceEpoch.toString();
      _nests.add(Nest(name: 'New Nest $id', joinCode: id, members: []));
    });
  }



  @override
  Widget build(BuildContext context) {
    Widget body;
    if (_isLoading) {
      body = const Center(child: CircularProgressIndicator());
    } else if (_nests.isEmpty) {
      body = Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.group_work_outlined, size: 72, color: Theme.of(context).hintColor),
            const SizedBox(height: 12),
            Text('No nests yet', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            const Text('Create your first nest to get started.', textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton.icon(onPressed: _addDummy, icon: const Icon(Icons.add), label: const Text('Create')),
          ],
        ),
      );
    } else {
      body = ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        itemCount: _nests.length,
        itemBuilder: (context, i) {
          final n = _nests[i];
          return Padding(
            key: ValueKey(n.joinCode), // stable key
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: NestCard(
              nest: n,
              onPressed: () {
                // open details or navigate
              },
            ),
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: body,
      floatingActionButton: FloatingActionButton(
        onPressed: _addDummy,
        child: const Icon(Icons.add),
      ),
    );
  }
}