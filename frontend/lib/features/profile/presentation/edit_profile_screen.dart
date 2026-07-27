import 'package:flutter/material.dart';
import '../../../data/models/user_model.dart';
import '../../../data/mocks/mock_data.dart';
import '../widgets/photo_picker_bottom_sheet.dart';

/// Tela de Edição de Perfil.
///
/// Recebe o [user] atual, permite alterar nome, senha e foto,
/// e retorna um [UserModel] atualizado quando "Salvar" é pressionado.
class EditProfileScreen extends StatefulWidget {
  final UserModel user;

  const EditProfileScreen({super.key, required this.user});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _passwordController;

  // Simula a seleção de foto: null = sem alteração, true = câmera, false = galeria
  bool _photoSelected = false;
  String _photoSource = '';

  bool _isSaving = false;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.name);
    _passwordController = TextEditingController(text: '••••••••');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // ─── Handlers ─────────────────────────────────────────────────────────────

  Future<void> _openPhotoPicker() async {
    final source = await showPhotoPickerBottomSheet(context);
    if (source != null && mounted) {
      setState(() {
        _photoSelected = true;
        _photoSource = source;
      });
      _showSnackBar(
        source == 'camera'
            ? '📷 Simulando câmera… foto selecionada!'
            : '🖼️ Simulando galeria… foto selecionada!',
        icon: Icons.check_circle_outline,
      );
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);
    // Simula latência de rede
    await Future.delayed(const Duration(milliseconds: 600));

    if (!mounted) return;

    final updatedUser = UserModel(
      id: widget.user.id,
      name: _nameController.text.trim(),
      username: widget.user.username,
      avatarUrl: widget.user.avatarUrl,
      followersCount: widget.user.followersCount,
      followingCount: widget.user.followingCount,
      isFollowing: widget.user.isFollowing,
    );

    setState(() => _isSaving = false);
    Navigator.pop(context, updatedUser);
  }

  Future<void> _confirmDeleteAccount() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.red),
            SizedBox(width: 8),
            Text('Excluir Conta'),
          ],
        ),
        content: const Text(
          'Tem certeza que deseja excluir sua conta?\n\n'
          'Esta ação é permanente e não poderá ser desfeita. '
          'Todos os seus dados e postagens serão removidos.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      _showSnackBar(
        'Conta excluída (simulação). Em produção, chamaria a API.',
        icon: Icons.delete_outline,
        isError: true,
      );
    }
  }

  void _showSnackBar(String message,
      {IconData? icon, bool isError = false}) {
    final colorScheme = Theme.of(context).colorScheme;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            if (icon != null) ...[
              Icon(icon,
                  color: isError ? Colors.white : colorScheme.inversePrimary,
                  size: 20),
              const SizedBox(width: 8),
            ],
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: isError ? Colors.red.shade700 : null,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  // ─── Build ────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Editar Perfil',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: _isSaving ? null : _save,
            child: _isSaving
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text(
                    'Salvar',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // ── Avatar clicável ──────────────────────────────────────────
              GestureDetector(
                onTap: _openPhotoPicker,
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            colorScheme.primary,
                            colorScheme.tertiary,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(3),
                        child: CircleAvatar(
                          radius: 47,
                          backgroundColor: colorScheme.surface,
                          // Se foi selecionada uma foto (simulado), mostra
                          // um placeholder colorido
                          backgroundImage: null,
                          child: _photoSelected
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      _photoSource == 'camera'
                                          ? Icons.camera_alt
                                          : Icons.photo_library,
                                      color: colorScheme.primary,
                                      size: 28,
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      'Preview',
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: colorScheme.primary,
                                      ),
                                    ),
                                  ],
                                )
                              : Text(
                                  MockData.currentUser.name[0].toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 38,
                                    fontWeight: FontWeight.w700,
                                    color: colorScheme.primary,
                                  ),
                                ),
                        ),
                      ),
                    ),
                    // Ícone de câmera sobre o avatar
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: colorScheme.primary,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: colorScheme.surface,
                          width: 2,
                        ),
                      ),
                      child: Icon(
                        Icons.camera_alt,
                        size: 16,
                        color: colorScheme.onPrimary,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              TextButton(
                onPressed: _openPhotoPicker,
                child: const Text('Alterar foto de perfil'),
              ),

              const SizedBox(height: 24),

              // ── Campos do formulário ──────────────────────────────────────
              _SectionLabel(label: 'Informações pessoais'),
              const SizedBox(height: 12),

              // Nome
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Nome completo',
                  prefixIcon: const Icon(Icons.person_outline),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  filled: true,
                  fillColor: colorScheme.surfaceContainerHighest,
                ),
                textCapitalization: TextCapitalization.words,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return 'O nome não pode ser vazio.';
                  }
                  if (v.trim().length < 2) {
                    return 'Nome muito curto.';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Username (readonly)
              TextFormField(
                initialValue: '@${widget.user.username}',
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Nome de usuário',
                  prefixIcon: const Icon(Icons.alternate_email),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  filled: true,
                  fillColor: colorScheme.surfaceContainerHighest
                      .withValues(alpha: 0.5),
                  helperText: 'O username não pode ser alterado por enquanto.',
                ),
                style:
                    TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.5)),
              ),

              const SizedBox(height: 24),

              _SectionLabel(label: 'Segurança'),
              const SizedBox(height: 12),

              // Senha
              TextFormField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: 'Senha',
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(_obscurePassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined),
                    onPressed: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  filled: true,
                  fillColor: colorScheme.surfaceContainerHighest,
                ),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Informe a senha.';
                  if (v.length < 6) return 'Mínimo de 6 caracteres.';
                  return null;
                },
              ),

              const SizedBox(height: 32),

              // ── Botão Salvar ──────────────────────────────────────────────
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: _isSaving ? null : _save,
                  icon: _isSaving
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.save_outlined, size: 20),
                  label: const Text(
                    'Salvar alterações',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // ── Zona de perigo ────────────────────────────────────────────
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.red.shade200),
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.warning_amber_rounded,
                            color: Colors.red.shade700, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Zona de Perigo',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: Colors.red.shade700,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Excluir sua conta é uma ação permanente e não pode ser desfeita.',
                      style: TextStyle(
                        color: colorScheme.onSurfaceVariant,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: _confirmDeleteAccount,
                        icon: const Icon(Icons.delete_forever_outlined,
                            color: Colors.red),
                        label: const Text(
                          'Excluir Conta',
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.red),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

/// Label de seção acima dos campos de formulário.
class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        label,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: Theme.of(context).colorScheme.primary,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
