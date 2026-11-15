import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../../../../core/dummy/dummy_data.dart';
import '../../../../core/themes/app_colors.dart';
import '../../../../core/widgets/form_section_header.dart';
import '../../../../core/widgets/gps_capture_tile.dart';
import '../../../../core/widgets/labeled_text_field.dart';
import '../../../../core/widgets/multi_photo_capture_tile.dart';
import '../../../../core/widgets/primary_button.dart';

class CommunityRegistrationPage extends StatefulWidget {
  const CommunityRegistrationPage({super.key});

  @override
  State<CommunityRegistrationPage> createState() =>
      _CommunityRegistrationPageState();
}

class _CommunityRegistrationPageState
    extends State<CommunityRegistrationPage> {
  final _formKey = GlobalKey<FormState>();

  final _nameCtrl = TextEditingController();
  final _wardCtrl = TextEditingController();
  final _lgaCtrl = TextEditingController();
  final _stateCtrl = TextEditingController(text: 'Borno State');
  final _householdCountCtrl = TextEditingController();
  final _beneficiaryCountCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();

  Position? _capturedPosition;

  bool _saving = false;
  bool _savedLocally = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _wardCtrl.dispose();
    _lgaCtrl.dispose();
    _stateCtrl.dispose();
    _householdCountCtrl.dispose();
    _beneficiaryCountCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);

    await Future.delayed(const Duration(milliseconds: 700));
    if (!mounted) return;

    final newCommunity = DummyCommunity(
      id: 'com_${DateTime.now().millisecondsSinceEpoch}',
      name: _nameCtrl.text.trim(),
      ward: _wardCtrl.text.trim(),
      lga: _lgaCtrl.text.trim().isEmpty ? 'Jere' : _lgaCtrl.text.trim(),
      state: _stateCtrl.text.trim().isEmpty ? 'Borno State' : _stateCtrl.text.trim(),
      projectId: kCurrentProject.id,
      beneficiaryCount: int.tryParse(_beneficiaryCountCtrl.text.trim()) ?? 0,
      activityCount: 0,
      householdCount: int.tryParse(_householdCountCtrl.text.trim()) ?? 0,
      latitude: _capturedPosition?.latitude ?? 11.8333,
      longitude: _capturedPosition?.longitude ?? 13.1500,
    );

    kCommunities.insert(0, newCommunity);

    setState(() {
      _saving = false;
      _savedLocally = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_savedLocally) {
      return _SavedScreen(
        communityName: _nameCtrl.text.trim(),
        onDone: () => Navigator.of(context).pop(),
        onAddAnother: () => setState(() {
          _savedLocally = false;
          _formKey.currentState?.reset();
          _nameCtrl.clear();
          _wardCtrl.clear();
          _lgaCtrl.clear();
          _householdCountCtrl.clear();
          _beneficiaryCountCtrl.clear();
          _notesCtrl.clear();
          _capturedPosition = null;
        }),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Add Community',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
        ),
        backgroundColor: const Color(0xFF00838F),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const FormSectionHeader(title: 'Community Information'),
              LabeledTextField(
                label: 'Community Name',
                hint: 'e.g. Muna Garage',
                controller: _nameCtrl,
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Name required' : null,
              ),
              Row(
                children: [
                  Expanded(
                    child: LabeledTextField(
                      label: 'Ward',
                      hint: 'e.g. Mashamari',
                      controller: _wardCtrl,
                      validator: (v) =>
                          v == null || v.trim().isEmpty ? 'Ward required' : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: LabeledTextField(
                      label: 'LGA',
                      hint: 'e.g. Jere',
                      controller: _lgaCtrl,
                      validator: (v) =>
                          v == null || v.trim().isEmpty ? 'LGA required' : null,
                    ),
                  ),
                ],
              ),
              LabeledTextField(
                label: 'State',
                hint: 'Borno State',
                controller: _stateCtrl,
              ),

              const SizedBox(height: 8),
              const FormSectionHeader(title: 'Estimates & Demographics'),
              Row(
                children: [
                  Expanded(
                    child: LabeledTextField(
                      label: 'Est. Households',
                      hint: 'e.g. 150',
                      controller: _householdCountCtrl,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: LabeledTextField(
                      label: 'Initial Beneficiaries',
                      hint: 'e.g. 45',
                      controller: _beneficiaryCountCtrl,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),
              const FormSectionHeader(title: 'GPS Location'),
              GpsCaptureTile(
                onLocationCaptured: (pos) {
                  setState(() => _capturedPosition = pos);
                },
              ),

              const SizedBox(height: 8),
              const FormSectionHeader(title: 'Photos & Documents'),
              const MultiPhotoCaptureTile(
                label: 'Community Photos / Site Documents',
                maxPhotos: 5,
              ),

              const SizedBox(height: 8),
              const FormSectionHeader(title: 'Notes'),
              LabeledTextField(
                label: 'Additional Notes',
                hint: 'Accessibility, infrastructure, key contacts...',
                controller: _notesCtrl,
                maxLines: 3,
              ),

              const SizedBox(height: 24),
              PrimaryButton(
                label: 'Save Community',
                loading: _saving,
                onPressed: _save,
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

class _SavedScreen extends StatelessWidget {
  const _SavedScreen({
    required this.communityName,
    required this.onDone,
    required this.onAddAnother,
  });

  final String communityName;
  final VoidCallback onDone;
  final VoidCallback onAddAnother;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle,
                  color: AppColors.success,
                  size: 48,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Community Added',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '$communityName has been added locally and will sync when connected.',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 32),
              PrimaryButton(label: 'Done', onPressed: onDone),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: onAddAnother,
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                  side: const BorderSide(color: AppColors.primary),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('Add Another Community'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
