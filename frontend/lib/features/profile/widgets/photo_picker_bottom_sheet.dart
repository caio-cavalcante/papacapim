import 'package:flutter/material.dart';

/// Callback chamado quando o usuário escolhe uma fonte de imagem.
/// [source] será 'camera' ou 'gallery'.
/// Como esta é a Parte 1 (design/mock), nenhum pacote externo é necessário.
typedef PhotoSourceCallback = void Function(String source);

/// BottomSheet para seleção de foto de perfil.
/// Abre via [showPhotoPickerBottomSheet].
class PhotoPickerBottomSheet extends StatelessWidget {
  final PhotoSourceCallback onSourceSelected;

  const PhotoPickerBottomSheet({
    super.key,
    required this.onSourceSelected,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Drag handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: colorScheme.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Text(
              'Alterar foto de perfil',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 24),
            _PickerOption(
              icon: Icons.camera_alt_outlined,
              label: 'Tirar foto com a Câmera',
              onTap: () {
                Navigator.pop(context);
                onSourceSelected('camera');
              },
            ),
            const SizedBox(height: 12),
            _PickerOption(
              icon: Icons.photo_library_outlined,
              label: 'Escolher da Galeria',
              onTap: () {
                Navigator.pop(context);
                onSourceSelected('gallery');
              },
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancelar',
                style: TextStyle(color: colorScheme.error),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Opção individual do picker com ícone, label e fundo arredondado.
class _PickerOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _PickerOption({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Material(
      color: colorScheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          child: Row(
            children: [
              Icon(icon, color: colorScheme.primary, size: 24),
              const SizedBox(width: 16),
              Text(
                label,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Helper para abrir o [PhotoPickerBottomSheet].
/// Retorna a source escolhida ('camera' | 'gallery') ou null se cancelado.
Future<String?> showPhotoPickerBottomSheet(BuildContext context) async {
  String? result;
  await showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (_) => PhotoPickerBottomSheet(
      onSourceSelected: (src) => result = src,
    ),
  );
  return result;
}
