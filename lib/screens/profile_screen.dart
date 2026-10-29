import 'dart:async';

import 'package:flutter/material.dart';

import '../models/profile_model.dart';
import '../repositories/profile_repository.dart';
import '../services/draft_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  final _nameFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _phoneFocus = FocusNode();

  final _repository = ProfileRepository();
  final _draftService = DraftService();

  Timer? _draftDebounce;
  Profile? _originalProfile;
  bool _loading = true;
  bool _savingDraft = false;
  bool _submitting = false;
  String? _errorText;
  String _sourceLabel = 'Đang tải hồ sơ...';

  Profile _currentProfile() => Profile(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
      );

  bool get _isDirty =>
      _originalProfile != null && _originalProfile != _currentProfile();

  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    if (mounted) {
      setState(() {
        _loading = true;
        _errorText = null;
      });
    }

    try {
      final draft = await _draftService.loadDraft();
      if (draft != null) {
        _applyProfileToForm(draft);
        _originalProfile = draft;
        _sourceLabel = 'Đã khôi phục bản nháp trên thiết bị';
      } else {
        final profile = await _repository.getProfile();
        _applyProfileToForm(profile);
        _originalProfile = profile;
        _sourceLabel = 'Dữ liệu được tải từ API';
      }
    } catch (error) {
      if (mounted) {
        setState(() => _errorText = error.toString());
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _applyProfileToForm(Profile profile) {
    _nameController.text = profile.name;
    _emailController.text = profile.email;
    _phoneController.text = profile.phone;
  }

  String? _validateRequired(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Không được để trống';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    final email = (value ?? '').trim();
    if (email.isEmpty) return 'Không được để trống';
    if (!RegExp(r'^[^@\\s]+@[^@\\s]+\\.[^@\\s]+$').hasMatch(email)) {
      return 'Email không hợp lệ (ví dụ: a@b.com)';
    }
    return null;
  }

  String? _validatePhone(String? value) {
    final phone = (value ?? '').trim();
    if (phone.isEmpty) return 'Không được để trống';
    if (!RegExp(r'^[0-9+\\-\\s()]{8,}$').hasMatch(phone) ||
        phone.replaceAll(RegExp(r'\\D'), '').length < 8) {
      return 'Số điện thoại không hợp lệ (ít nhất 8 chữ số)';
    }
    return null;
  }

  void _scheduleDraftSave() {
    _draftDebounce?.cancel();
    _draftDebounce = Timer(const Duration(milliseconds: 700), () async {
      if (!mounted) return;
      setState(() => _savingDraft = true);
      try {
        await _draftService.saveDraft(_currentProfile());
      } catch (error) {
        // ignore: avoid_print
        print('Save draft error: $error');
      } finally {
        if (mounted) setState(() => _savingDraft = false);
      }
    });
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;

    if (!_isDirty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bạn chưa thay đổi thông tin nào.')),
      );
      return;
    }

    setState(() {
      _submitting = true;
      _errorText = null;
    });

    try {
      final updated = _currentProfile();
      await _repository.updateProfile(updated);
      await _draftService.clearDraft();

      if (!mounted) return;
      setState(() {
        _originalProfile = updated;
        _sourceLabel = 'Đã gửi cập nhật thành công';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cập nhật thành công. Đã xóa bản nháp.')),
      );
    } catch (error) {
      if (!mounted) return;
      setState(() => _errorText = error.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cập nhật thất bại. Hãy thử lại.')),
      );
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  Future<bool> _confirmExit() async {
    if (!_isDirty) return true;
    final shouldExit = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Bạn chưa lưu thay đổi'),
        content: const Text(
          'Thông tin đã được lưu nháp tự động. Bạn có muốn rời màn hình không?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Ở lại'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Thoát'),
          ),
        ],
      ),
    );
    return shouldExit ?? false;
  }

  @override
  void dispose() {
    _draftDebounce?.cancel();
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _nameFocus.dispose();
    _emailFocus.dispose();
    _phoneFocus.dispose();
    _repository.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_isDirty,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop || !_isDirty) return;
        final shouldExit = await _confirmExit();
        if (shouldExit && mounted) Navigator.of(context).pop();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Smart Profile Editor'),
          actions: [
            IconButton(
              tooltip: 'Tải lại dữ liệu',
              onPressed: (_loading || _submitting) ? null : _bootstrap,
              icon: const Icon(Icons.refresh),
            ),
          ],
        ),
        body: SafeArea(
          child: _loading
              ? const Center(child: CircularProgressIndicator())
              : _errorText != null && _originalProfile == null
                  ? _buildInitialError()
                  : Stack(
                      children: [
                        _buildForm(),
                        if (_submitting)
                          Container(
                            color: Colors.black12,
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                      ],
                    ),
        ),
      ),
    );
  }

  Widget _buildInitialError() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cloud_off, size: 48),
            const SizedBox(height: 12),
            Text(_errorText!, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: _bootstrap,
              icon: const Icon(Icons.refresh),
              label: const Text('Thử tải lại'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildForm() {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const CircleAvatar(
                    radius: 34,
                    child: Icon(Icons.person, size: 38),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Chỉnh sửa hồ sơ',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _sourceLabel,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: _nameController,
                    focusNode: _nameFocus,
                    textCapitalization: TextCapitalization.words,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'Họ tên',
                      prefixIcon: Icon(Icons.badge_outlined),
                    ),
                    validator: _validateRequired,
                    onChanged: (_) => _scheduleDraftSave(),
                    onFieldSubmitted: (_) =>
                        FocusScope.of(context).requestFocus(_emailFocus),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _emailController,
                    focusNode: _emailFocus,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email_outlined),
                    ),
                    validator: _validateEmail,
                    onChanged: (_) => _scheduleDraftSave(),
                    onFieldSubmitted: (_) =>
                        FocusScope.of(context).requestFocus(_phoneFocus),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _phoneController,
                    focusNode: _phoneFocus,
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.done,
                    decoration: const InputDecoration(
                      labelText: 'Số điện thoại',
                      prefixIcon: Icon(Icons.phone_outlined),
                    ),
                    validator: _validatePhone,
                    onChanged: (_) => _scheduleDraftSave(),
                    onFieldSubmitted: (_) => _submit(),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(
                        _savingDraft ? Icons.sync : Icons.save_outlined,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _savingDraft
                              ? 'Đang lưu bản nháp...'
                              : 'Bản nháp được tự động lưu trên thiết bị',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                      if (_isDirty)
                        const Chip(
                          avatar: Icon(Icons.edit, size: 16),
                          label: Text('Chưa lưu'),
                        ),
                    ],
                  ),
                  if (_errorText != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      _errorText!,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ],
                  const SizedBox(height: 12),
                  FilledButton.icon(
                    onPressed: _submitting ? null : _submit,
                    icon: const Icon(Icons.save),
                    label: const Text('Lưu cập nhật'),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: _submitting
                        ? null
                        : () async {
                            await _draftService.clearDraft();
                            if (!mounted) return;
                            await _bootstrap();
                          },
                    icon: const Icon(Icons.delete_outline),
                    label: const Text('Xóa bản nháp và tải lại API'),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Lưu ý: JSONPlaceholder là API minh họa. '
                    'PUT trả kết quả giả lập, không lưu dữ liệu lâu dài trên server.',
                    style: Theme.of(context).textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
