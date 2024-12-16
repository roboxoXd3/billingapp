import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../core/utils/constants.dart';
import '../../../../domain/entities/bill_line_item.dart';
import '../../../bloc/settings/settings_bloc.dart';

class LineItemForm extends StatefulWidget {
  final BillLineItem? item;

  const LineItemForm({super.key, this.item});

  @override
  State<LineItemForm> createState() => _LineItemFormState();
}

class _LineItemFormState extends State<LineItemForm> {
  final _formKey = GlobalKey<FormState>();
  late String _description;
  late double _gross;
  late double _less;
  late double _rate;
  late double _discount;
  late String _type;

  // Optical specific fields
  late String _frame;
  late String _lensType;
  late String _coating;
  late double _framePrice;
  late double _lensPrice;
  late double _coatingPrice;

  @override
  void initState() {
    super.initState();
    _description = widget.item?.description ?? '';
    _gross = widget.item?.gross ?? 0;
    _less = widget.item?.less ?? 0;
    _rate = widget.item?.rate ?? 0;
    _discount = widget.item?.discount ?? 0;
    _type = widget.item?.type ?? billTypeSale;

    // Initialize optical fields
    final additionalInfo = widget.item?.additionalInfo;
    _frame = additionalInfo?['frame'] ?? '';
    _lensType = additionalInfo?['lensType'] ?? 'single';
    _coating = additionalInfo?['coating'] ?? '';
    _framePrice = double.tryParse(additionalInfo?['framePrice'] ?? '0') ?? 0;
    _lensPrice = double.tryParse(additionalInfo?['lensPrice'] ?? '0') ?? 0;
    _coatingPrice =
        double.tryParse(additionalInfo?['coatingPrice'] ?? '0') ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final selectedTemplate =
        context.watch<SettingsBloc>().state.selectedTemplate;
    final isOptical = selectedTemplate == opticalTemplate;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isOptical) ...[
                TextFormField(
                  initialValue: _frame,
                  decoration: InputDecoration(
                    labelText: l10n.frame,
                    border: const OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return l10n.required;
                    }
                    return null;
                  },
                  onChanged: (value) => _frame = value,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  initialValue: _framePrice == 0 ? '' : _framePrice.toString(),
                  decoration: InputDecoration(
                    labelText: l10n.framePrice,
                    prefixText: '₹',
                    border: const OutlineInputBorder(),
                  ),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return l10n.required;
                    }
                    if (double.tryParse(value) == null) {
                      return l10n.invalidInput;
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      _framePrice = double.tryParse(value) ?? 0;
                      _updateOpticalTotals();
                    });
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _lensType,
                  decoration: InputDecoration(
                    labelText: l10n.lensType,
                    border: const OutlineInputBorder(),
                  ),
                  items: [
                    'single',
                    'bifocal',
                    'progressive',
                    'office',
                  ]
                      .map((type) => DropdownMenuItem(
                            value: type,
                            child: Text(type.toUpperCase()),
                          ))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _lensType = value);
                    }
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  initialValue: _lensPrice == 0 ? '' : _lensPrice.toString(),
                  decoration: InputDecoration(
                    labelText: l10n.lensPrice,
                    prefixText: '₹',
                    border: const OutlineInputBorder(),
                  ),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return l10n.required;
                    }
                    if (double.tryParse(value) == null) {
                      return l10n.invalidInput;
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      _lensPrice = double.tryParse(value) ?? 0;
                      _updateOpticalTotals();
                    });
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  initialValue: _coating,
                  decoration: InputDecoration(
                    labelText: l10n.coating,
                    border: const OutlineInputBorder(),
                  ),
                  onChanged: (value) => _coating = value,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  initialValue:
                      _coatingPrice == 0 ? '' : _coatingPrice.toString(),
                  decoration: InputDecoration(
                    labelText: l10n.coatingPrice,
                    prefixText: '₹',
                    border: const OutlineInputBorder(),
                  ),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  onChanged: (value) {
                    setState(() {
                      _coatingPrice = double.tryParse(value) ?? 0;
                      _updateOpticalTotals();
                    });
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  initialValue: _discount == 0 ? '' : _discount.toString(),
                  decoration: InputDecoration(
                    labelText: l10n.discount,
                    suffixText: '%',
                    border: const OutlineInputBorder(),
                  ),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return null;
                    }
                    final discount = double.tryParse(value);
                    if (discount == null || discount < 0 || discount > 100) {
                      return l10n.invalidDiscount;
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      _discount = double.tryParse(value) ?? 0;
                      _updateOpticalTotals();
                    });
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  initialValue: _rate.toString(),
                  decoration: InputDecoration(
                    labelText: l10n.totalAmount,
                    prefixText: '₹',
                    border: const OutlineInputBorder(),
                  ),
                  readOnly: true,
                ),
              ] else ...[
                // Default template fields
                TextFormField(
                  initialValue: _description,
                  decoration: InputDecoration(
                    labelText: l10n.description,
                    border: const OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return l10n.required;
                    }
                    return null;
                  },
                  onChanged: (value) => _description = value,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        initialValue: _gross == 0 ? '' : _gross.toString(),
                        decoration: InputDecoration(
                          labelText: l10n.gross,
                          border: const OutlineInputBorder(),
                        ),
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return l10n.required;
                          }
                          if (double.tryParse(value) == null) {
                            return l10n.invalidInput;
                          }
                          return null;
                        },
                        onChanged: (value) {
                          _gross = double.tryParse(value) ?? 0;
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        initialValue: _less == 0 ? '' : _less.toString(),
                        decoration: InputDecoration(
                          labelText: l10n.less,
                          border: const OutlineInputBorder(),
                        ),
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return null;
                          }
                          final less = double.tryParse(value);
                          if (less == null) {
                            return l10n.invalidInput;
                          }
                          if (less > _gross) {
                            return l10n.cannotExceedGross;
                          }
                          return null;
                        },
                        onChanged: (value) {
                          _less = double.tryParse(value) ?? 0;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        initialValue: _rate == 0 ? '' : _rate.toString(),
                        decoration: InputDecoration(
                          labelText: l10n.rate,
                          prefixText: '₹',
                          border: const OutlineInputBorder(),
                        ),
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return l10n.required;
                          }
                          if (double.tryParse(value) == null) {
                            return l10n.invalidInput;
                          }
                          return null;
                        },
                        onChanged: (value) {
                          _rate = double.tryParse(value) ?? 0;
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        initialValue:
                            _discount == 0 ? '' : _discount.toString(),
                        decoration: InputDecoration(
                          labelText: l10n.discount,
                          suffixText: '%',
                          border: const OutlineInputBorder(),
                        ),
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return null;
                          }
                          final discount = double.tryParse(value);
                          if (discount == null ||
                              discount < 0 ||
                              discount > 100) {
                            return l10n.invalidDiscount;
                          }
                          return null;
                        },
                        onChanged: (value) {
                          _discount = double.tryParse(value) ?? 0;
                        },
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _type,
                      decoration: InputDecoration(
                        labelText: l10n.type,
                        border: const OutlineInputBorder(),
                      ),
                      items: [
                        DropdownMenuItem(
                            value: billTypeSale, child: Text(l10n.sale)),
                        DropdownMenuItem(
                            value: billTypeReturn,
                            child: Text(l10n.returnText)),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => _type = value);
                        }
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(l10n.cancel),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: _submit,
                    child: Text(
                        widget.item == null ? l10n.addItem : l10n.updateItem),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _updateOpticalTotals() {
    // final subtotal = _framePrice + _lensPrice + _coatingPrice;
    // final discountAmount = subtotal * (_discount / 100);
    // _rate = subtotal - discountAmount;
    // _gross = subtotal; // Set gross to subtotal for consistency
    // _less = discountAmount; // Set less to discount amount
    // Calculate subtotal
    final subtotal = _framePrice + _lensPrice + _coatingPrice;

    // Calculate discount amount (ensuring discount is properly converted to decimal)
    final discountAmount = subtotal * (_discount.clamp(0, 100) / 100);

    // Set the values
    _gross = subtotal;
    _less = discountAmount;
    _rate = subtotal - discountAmount;
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      final selectedTemplate =
          context.read<SettingsBloc>().state.selectedTemplate;
      final isOptical = selectedTemplate == opticalTemplate;

      if (isOptical) {
        _updateOpticalTotals(); // Ensure final calculations are done
      }

      final item = BillLineItem(
        description: isOptical
            ? '$_frame - $_lensType${_coating.isNotEmpty ? ' with $_coating' : ''}'
            : _description,
        gross: _gross,
        less: _less,
        rate: _rate,
        discount: _discount,
        type: _type,
        templateId: selectedTemplate,
        additionalInfo: isOptical
            ? {
                'frame': _frame,
                'lensType': _lensType,
                'coating': _coating,
                'framePrice': _framePrice.toString(),
                'lensPrice': _lensPrice.toString(),
                'coatingPrice': _coatingPrice.toString(),
              }
            : null,
      );
      Navigator.pop(context, item);
    }
  }
}
