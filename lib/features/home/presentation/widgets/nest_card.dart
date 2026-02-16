import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../shared/models/nest.dart';

class NestCard extends StatelessWidget {
  final Nest nest;
  final bool isLoading;
  final VoidCallback? onOpen;
  final VoidCallback? onEdit;

  const NestCard({
    super.key,
    required this.nest,
    this.onOpen,
    this.onEdit,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ExpansionTile(
        title: Text(nest.name),
        subtitle: Text('${nest.members.length} members'),
        childrenPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text('Join code: ${nest.joinCode}'),
          ),
          const SizedBox(height: 8),
          // Optional: list a few members (adjust depending on your model)
          if (nest.members.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: nest.members
                  .take(5)
                  .map((m) => Text('- ${m.toString()}'))
                  .toList(),
            ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: nest.joinCode));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Join code copied')),
                  );
                },
                child: const Text('Copy Code'),
              ),
              const SizedBox(width: 8),
              TextButton(
                onPressed: isLoading ? null : onEdit,
                child: const Text('Edit'),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: isLoading ? null : onOpen,
                child: const Text('Open'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}