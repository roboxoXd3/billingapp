import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../bloc/company/company_bloc.dart';
import '../../../bloc/company/company_state.dart';

class CompanyHeader extends StatelessWidget {
  const CompanyHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CompanyBloc, CompanyState>(
      builder: (context, state) {
        if (state is CompanyLoaded) {
          return Container(
            padding: const EdgeInsets.all(16),
            color: Theme.of(context).colorScheme.primaryContainer,
            child: Column(
              children: [
                if (state.details.logo != null)
                  Image.file(
                    File(state.details.logo!),
                    height: 60,
                  ),
                Text(
                  state.details.name,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Text(state.details.address),
                Text('${state.details.phone} | ${state.details.email}'),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
