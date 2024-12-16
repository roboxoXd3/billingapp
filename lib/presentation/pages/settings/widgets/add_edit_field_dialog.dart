import 'package:flutter/material.dart';
import '../../../../domain/entities/field_config.dart';

class AddEditFieldDialog extends StatefulWidget {
  final FieldConfig? field;
  final Function(FieldConfig) onSave;

  const AddEditFieldDialog({
    super.key,
    this.field,
    required this.onSave,
  });

  @override
  State<AddEditFieldDialog> createState() => _AddEditFieldDialogState();
}

class _AddEditFieldDialogState extends State<AddEditFieldDialog> {
  final _formKey = GlobalKey<FormState>();
  final _labelController = TextEditingController();
  final _defaultValueController = TextEditingController();
  final _formulaController = TextEditingController();
  late String _fieldId;
  late String _type;
  late bool _required;
  late bool _isCalculated;

  @override
  void initState() {
    super.initState();
    if (widget.field != null) {
      _fieldId = widget.field!.fieldId;
      _labelController.text = widget.field!.label;
      _type = widget.field!.type;
      _required = widget.field!.required;
      _isCalculated = widget.field!.isCalculated;
      _defaultValueController.text = widget.field!.defaultValue ?? '';
      _formulaController.text = widget.field!.calculationFormula ?? '';
    } else {
      _fieldId = DateTime.now().millisecondsSinceEpoch.toString();
      _type = 'text';
      _required = false;
      _isCalculated = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.field == null ? 'Add Field' : 'Edit Field'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _labelController,
                decoration: const InputDecoration(
                  labelText: 'Label',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter field label';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _type,
                decoration: const InputDecoration(
                  labelText: 'Type',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'text', child: Text('Text')),
                  DropdownMenuItem(value: 'number', child: Text('Number')),
                  DropdownMenuItem(value: 'date', child: Text('Date')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _type = value;
                      if (_type != 'number') {
                        _isCalculated = false;
                      }
                    });
                  }
                },
              ),
              const SizedBox(height: 16),
              CheckboxListTile(
                title: const Text('Required'),
                value: _required,
                onChanged: (value) {
                  setState(() {
                    _required = value ?? false;
                  });
                },
              ),
              if (_type == 'number')
                CheckboxListTile(
                  title: const Text('Calculated'),
                  value: _isCalculated,
                  onChanged: (value) {
                    setState(() {
                      _isCalculated = value ?? false;
                    });
                  },
                ),
              if (!_isCalculated) ...[
                const SizedBox(height: 16),
                TextFormField(
                  controller: _defaultValueController,
                  decoration: const InputDecoration(
                    labelText: 'Default Value',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
              if (_isCalculated) ...[
                const SizedBox(height: 16),
                TextFormField(
                  controller: _formulaController,
                  decoration: const InputDecoration(
                    labelText: 'Calculation Formula',
                    border: OutlineInputBorder(),
                    helperText:
                        'Use field IDs in curly braces, e.g., {field1} + {field2}',
                  ),
                  validator: (value) {
                    if (_isCalculated && (value?.isEmpty ?? true)) {
                      return 'Please enter calculation formula';
                    }
                    return null;
                  },
                ),
              ],
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('CANCEL'),
        ),
        TextButton(
          onPressed: _saveField,
          child: const Text('SAVE'),
        ),
      ],
    );
  }

  void _saveField() {
    if (_formKey.currentState?.validate() ?? false) {
      final field = FieldConfig(
        id: widget.field?.id,
        fieldId: _fieldId,
        label: _labelController.text,
        type: _type,
        required: _required,
        defaultValue: _defaultValueController.text.isEmpty
            ? null
            : _defaultValueController.text,
        isCalculated: _isCalculated,
        calculationFormula: _isCalculated ? _formulaController.text : null,
        orderIndex: widget.field?.orderIndex ?? 0,
      );

      widget.onSave(field);
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _labelController.dispose();
    _defaultValueController.dispose();
    _formulaController.dispose();
    super.dispose();
  }
}
