import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../domain/entities/field_config.dart';
import '../../../bloc/field/field_bloc.dart';
import '../../../bloc/field/field_event.dart';
import '../../../bloc/field/field_state.dart';
import 'field_list_item.dart';
import 'add_edit_field_dialog.dart';

class FieldsSection extends StatelessWidget {
  const FieldsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<FieldBloc, FieldState>(
        builder: (context, state) {
          if (state is FieldLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is FieldsLoaded) {
            return ReorderableListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.fields.length,
              onReorder: (oldIndex, newIndex) {
                // Implement reorder logic
              },
              itemBuilder: (context, index) {
                final field = state.fields[index];
                return FieldListItem(
                  key: Key(field.id.toString()),
                  field: field,
                  onEdit: () => _showEditDialog(context, field),
                  onDelete: () {
                    context.read<FieldBloc>().add(DeleteFieldEvent(field.id!));
                  },
                );
              },
            );
          }
          return const Center(child: Text('No custom fields configured'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AddEditFieldDialog(
        onSave: (field) {
          context.read<FieldBloc>().add(SaveFieldEvent(field));
          context.read<FieldBloc>().add(LoadFields());
        },
      ),
    );
  }

  void _showEditDialog(BuildContext context, FieldConfig field) {
    showDialog(
      context: context,
      builder: (context) => AddEditFieldDialog(
        field: field,
        onSave: (field) {
          context.read<FieldBloc>().add(SaveFieldEvent(field));
          context.read<FieldBloc>().add(LoadFields());
        },
      ),
    );
  }
}
