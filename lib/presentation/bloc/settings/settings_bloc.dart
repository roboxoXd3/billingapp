import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/utils/constants.dart';

// Events
abstract class SettingsEvent {}

class TemplateChanged extends SettingsEvent {
  final String template;
  TemplateChanged(this.template);
}

// State
class SettingsState {
  final String selectedTemplate;

  SettingsState({
    this.selectedTemplate = defaultTemplate,
  });

  SettingsState copyWith({
    String? selectedTemplate,
  }) {
    return SettingsState(
      selectedTemplate: selectedTemplate ?? this.selectedTemplate,
    );
  }
}

// Bloc
class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc() : super(SettingsState()) {
    on<TemplateChanged>((event, emit) {
      emit(state.copyWith(selectedTemplate: event.template));
    });
  }
}
