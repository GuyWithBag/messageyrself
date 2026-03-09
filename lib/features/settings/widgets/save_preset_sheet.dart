// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/features/settings/widgets/save_preset_sheet.dart
// PURPOSE: Bottom sheet for naming and saving the current settings as a preset
// PROVIDERS: SettingsProvider
// HOOKS: useTextEditingController, useFocusNode
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_spacing.dart';
import '../providers/settings_provider.dart';

class SavePresetSheet extends HookWidget {
  const SavePresetSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final nameController = useTextEditingController();
    final focusNode = useFocusNode();
    final isSaving = useState(false);

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        focusNode.requestFocus();
      });
      return null;
    }, const []);

    Future<void> save() async {
      final name = nameController.text.trim();
      if (name.isEmpty) return;

      isSaving.value = true;
      final provider = context.read<SettingsProvider>();
      await provider.saveCurrentAsUserPreset(name, null);
      isSaving.value = false;

      if (context.mounted) Navigator.pop(context);
    }

    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.lg + MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.outlineVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'Save as preset',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: AppSpacing.lg),
          TextField(
            controller: nameController,
            focusNode: focusNode,
            decoration: const InputDecoration(
              labelText: 'Preset name',
              hintText: 'e.g. My Dark Blue',
              border: OutlineInputBorder(),
            ),
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => save(),
          ),
          const SizedBox(height: AppSpacing.lg),
          FilledButton(
            onPressed: isSaving.value ? null : save,
            child: isSaving.value
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Save preset'),
          ),
        ],
      ),
    );
  }
}
