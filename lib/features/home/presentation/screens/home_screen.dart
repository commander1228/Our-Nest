import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_flutter/core/logger/logger.dart';
import 'package:test_flutter/core/widgets/app_text_input_modal.dart';
import 'package:test_flutter/core/widgets/primary_button.dart';
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
  RouteObserver<ModalRoute<void>>? _routeObserver;

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

Future<void> _addNest(String name) async {
  setState(() => _isLoading = true);
  try {
    await _nestRepo.createNest(name);
    await _loadNests();

}catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('login failed: $e')));
    }
}



  @override
  Widget build(BuildContext context) {
    Widget body;
    if (_isLoading) {
      body = const Center(child: CircularProgressIndicator());
    }  else {
      body = ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        itemCount: _nests.length,
        itemBuilder: (context, i) {
          final n = _nests[i];
          return Padding(
            key: ValueKey(n.joinCode), // stable key
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: NestCard(
              nest: n
            ),
          );
        },
      );
    }

    return Scaffold(
      body: body,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final nameController = TextEditingController();
          AppTextInputModal.show(
            context: context,
            title: 'Create Nest',
            content: TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Nest name'),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  final name = nameController.text;
                  if (name.isNotEmpty) {
                    _addNest(name);
                  }
                  Navigator.pop(context);
                },
                child: const Text('Create'),
              ),
            ],
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}