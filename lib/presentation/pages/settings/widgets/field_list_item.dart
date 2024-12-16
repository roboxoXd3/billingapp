import 'package:flutter/material.dart';
import '../../../../domain/entities/field_config.dart';

class FieldListItem extends StatelessWidget {
  final FieldConfig field;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const FieldListItem({
    super.key,
    required this.field,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        title: Text(field.label),
        subtitle: Text(
          '${field.type.toUpperCase()}${field.required ? ' • Required' : ''}${field.isCalculated ? ' • Calculated' : ''}',
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: onEdit,
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => _confirmDelete(context),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Field'),
        content: Text('Are you sure you want to delete "${field.label}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onDelete();
            },
            child: const Text('DELETE'),
          ),
        ],
      ),
    );
  }
}
