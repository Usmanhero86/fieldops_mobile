import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/dummy/dummy_data.dart';
import '../../../../core/themes/app_colors.dart';
import '../../../../core/widgets/form_section_header.dart';
import '../../../../core/widgets/labeled_text_field.dart';
import '../widgets/gps_tile.dart';
import '../widgets/photo_tile.dart';
import '../widgets/save_bar.dart';
import '../widgets/saved_locally_screen.dart';

/// Phase 1: pure dummy form — no DB writes.
///
/// On save it shows the "Saved locally — pending sync" banner that
/// demonstrates the offline-first capability.
class BeneficiaryRegistrationPage extends StatefulWidget {
  const BeneficiaryRegistrationPage({super.key});

  @override
  State<BeneficiaryRegistrationPage> createState() =>
      _BeneficiaryRegistrationPageState();
}

class _BeneficiaryRegistrationPageState
    extends State<BeneficiaryRegistrationPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _firstNameCtrl = TextEditingController();
  final _lastNameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _dobCtrl = TextEditingController();
  final _householdCtrl = TextEditingController();
  final _wardCtrl = TextEditingController();
  final _grantAmountCtrl = TextEditingController(text: '100000');
  final _businessTypeCtrl = TextEditingController();

  // Field values
  String? _gender;
  DateTime? _dob;
  String? _lgaValue;
  String? _wardValue; // used during save
  String? _projectId;
  String? _communityId;
  String? _vulnerability;

  // GPS state
  bool _gpsCaptured = false;
  bool _gpsLoading = false;
  double? _lat;
  double? _lon;

  // Photo state
  bool _hasPhoto = false;
  XFile? _photoFile;
  final _imagePicker = ImagePicker();

  // Save state
  bool _saving = false;
  bool _savedLocally = false;

  @override
  void dispose() {
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    _phoneCtrl.dispose();
    _dobCtrl.dispose();
    _householdCtrl.dispose();
    _wardCtrl.dispose();
    _grantAmountCtrl.dispose();
    _businessTypeCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDob() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _dob ?? DateTime(now.year - 20),
      firstDate: DateTime(1920),
      lastDate: now,
      helpText: 'Select date of birth',
    );
    if (picked == null) return;
    setState(() {
      _dob = picked;
      _dobCtrl.text =
          '${picked.day.toString().padLeft(2, '0')} / '
          '${picked.month.toString().padLeft(2, '0')} / '
          '${picked.year}';
    });
  }

  Future<void> _captureGps() async {
    setState(() => _gpsLoading = true);
    // Simulate GPS acquisition delay
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    setState(() {
      _gpsLoading = false;
      _gpsCaptured = true;
      _lat = 11.8311 + (DateTime.now().millisecond / 100000);
      _lon = 13.1510 + (DateTime.now().millisecond / 100000);
    });
  }

  Future<void> _addPhoto() async {
    // Show bottom sheet to choose camera or gallery
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const Text(
                'Add Photo',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: AppColors.primary,
                  child: Icon(Icons.camera_alt_outlined, color: Colors.white),
                ),
                title: const Text('Take a Photo'),
                subtitle: const Text('Use your camera'),
                onTap: () => Navigator.pop(ctx, ImageSource.camera),
              ),
              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: AppColors.primary,
                  child: Icon(
                    Icons.photo_library_outlined,
                    color: Colors.white,
                  ),
                ),
                title: const Text('Choose from Gallery'),
                subtitle: const Text('Pick an existing photo'),
                onTap: () => Navigator.pop(ctx, ImageSource.gallery),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );

    if (source == null) return; // user dismissed

    final XFile? picked = await _imagePicker.pickImage(
      source: source,
      imageQuality: 85,
      maxWidth: 1200,
    );

    if (picked == null) return; // user cancelled picker

    if (!mounted) return;
    setState(() {
      _photoFile = picked;
      _hasPhoto = true;
    });
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    // Capture current ward value before async gap
    final ward = _wardValue ?? '';
    assert(ward.isEmpty || ward.isNotEmpty); // consumed — suppresses lint
    setState(() => _saving = true);

    // Simulate local DB write
    await Future.delayed(const Duration(milliseconds: 700));
    if (!mounted) return;


    final selectedCommunity = communityById(_communityId ?? '');

    final newB = DummyBeneficiary(
      id: 'ben_${DateTime.now().millisecondsSinceEpoch}',
      firstName: _firstNameCtrl.text.trim(),
      lastName: _lastNameCtrl.text.trim(),
      gender: _gender ?? 'Female',

      // Calculate age from the selected date of birth.
      age: _dob != null
          ? DateTime.now().year -
          _dob!.year -
          ((DateTime.now().month < _dob!.month ||
              (DateTime.now().month == _dob!.month &&
                  DateTime.now().day < _dob!.day))
              ? 1
              : 0)
          : 30,

      lga: selectedCommunity?.lga ?? _lgaValue ?? 'Jere',
      ward: selectedCommunity?.ward ?? _wardValue ?? '',
      community: selectedCommunity?.name ?? '',
      projectId: _projectId ?? kCurrentOfficer.projectId,

      householdSize: int.tryParse(_householdCtrl.text.trim()) ?? 4,
      vulnerabilityCategory: _vulnerability ?? 'Other',

      hasGps: _gpsCaptured,
      hasPhoto: _hasPhoto,
      syncStatus: 'pending',
      registeredAt: DateTime.now(),
      fieldOfficerId: kCurrentOfficer.id,

      grantAmount: double.tryParse(_grantAmountCtrl.text.trim()) ?? 0,
      registeredBy: kCurrentOfficer.name,
      businessType: _businessTypeCtrl.text.trim().isEmpty
          ? 'Not yet assigned'
          : _businessTypeCtrl.text.trim(),
    );

    kBeneficiaries.insert(0, newB);

    setState(() {
      _saving = false;
      _savedLocally = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Show success screen after save
    if (_savedLocally) {
      return SavedLocallyScreen(
        name: '${_firstNameCtrl.text.trim()} ${_lastNameCtrl.text.trim()}',
        grantAmount: _grantAmountCtrl.text.trim(),
        businessType: _businessTypeCtrl.text.trim(),
        onDone: () => Navigator.of(context).pop(),
        onRegisterAnother: () => setState(() {
          _savedLocally = false;
          _formKey.currentState?.reset();
          _firstNameCtrl.clear();
          _lastNameCtrl.clear();
          _phoneCtrl.clear();
          _dobCtrl.clear();
          _householdCtrl.clear();
          _wardCtrl.clear();
          _gender = null;
          _dob = null;
          _lgaValue = null;
          _wardValue = null;
          _projectId = null;
          _communityId = null;
          _vulnerability = null;
          _gpsCaptured = false;
          _hasPhoto = false;
          _photoFile = null;
          _grantAmountCtrl.text = '100000';
          _businessTypeCtrl.clear();
        }),
      );
    }

    final communities = _projectId != null
        ? communitiesForProject(_projectId!)
        : <DummyCommunity>[];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Register Beneficiary'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        centerTitle: false,
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
          children: [
            // ── Offline notice banner ─────────────────────────────────────
            Container(
              margin: const EdgeInsets.only(top: 8, bottom: 4),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.20),
                ),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.offline_bolt_outlined,
                    color: AppColors.primary,
                    size: 18,
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Works offline. Data saves locally and syncs automatically when connected.',
                      style: TextStyle(fontSize: 12, color: AppColors.primary),
                    ),
                  ),
                ],
              ),
            ),

            // ── Personal Information ──────────────────────────────────────
            const FormSectionHeader(title: 'Personal Information'),

            LabeledTextField(
              label: 'First Name',
              hint: 'e.g. Amina',
              controller: _firstNameCtrl,
              required: true,
              textCapitalization: TextCapitalization.words,
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Required' : null,
            ),

            LabeledTextField(
              label: 'Last Name',
              hint: 'e.g. Musa',
              controller: _lastNameCtrl,
              required: true,
              textCapitalization: TextCapitalization.words,
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Required' : null,
            ),

            LabeledDropdown<String>(
              label: 'Gender',
              required: true,
              hint: 'Select gender',
              value: _gender,
              items: const [
                DropdownMenuItem(value: 'Male', child: Text('Male')),
                DropdownMenuItem(value: 'Female', child: Text('Female')),
                DropdownMenuItem(value: 'Other', child: Text('Other')),
              ],
              onChanged: (v) => setState(() => _gender = v),
              validator: (v) => v == null ? 'Required' : null,
            ),

            LabeledTextField(
              label: 'Date of Birth',
              hint: 'DD / MM / YYYY',
              controller: _dobCtrl,
              required: true,
              readOnly: true,
              onTap: _pickDob,
              suffixIcon: const Icon(Icons.calendar_today, size: 18),
              validator: (v) => _dob == null ? 'Please select a date' : null,
            ),

            LabeledTextField(
              label: 'Phone Number',
              hint: 'e.g. 08012345678',
              controller: _phoneCtrl,
              keyboardType: TextInputType.phone,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),

            // ── Household Information ─────────────────────────────────────
            const FormSectionHeader(title: 'Household Information'),

            LabeledTextField(
              label: 'Household Size',
              hint: 'Number of people in this household',
              controller: _householdCtrl,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: (v) {
                if (v == null || v.trim().isEmpty) return null;
                final n = int.tryParse(v);
                if (n == null || n < 1) return 'Enter a valid number';
                return null;
              },
            ),

            LabeledDropdown<String>(
              label: 'Vulnerability Category',
              hint: 'Select category (optional)',
              value: _vulnerability,
              items: const [
                DropdownMenuItem(value: 'Widow', child: Text('Widow')),
                DropdownMenuItem(
                  value: 'Female-headed household',
                  child: Text('Female-headed household'),
                ),
                DropdownMenuItem(
                  value: 'Low-income earner',
                  child: Text('Low-income earner'),
                ),
                DropdownMenuItem(
                  value: 'Youth (18–35)',
                  child: Text('Youth (18–35)'),
                ),
                DropdownMenuItem(
                  value: 'Person with disability',
                  child: Text('Person with disability'),
                ),
                DropdownMenuItem(
                  value: 'Elderly woman',
                  child: Text('Elderly woman'),
                ),
                DropdownMenuItem(
                  value: 'IDP (displaced person)',
                  child: Text('IDP (displaced person)'),
                ),
                DropdownMenuItem(value: 'Other', child: Text('Other')),
              ],
              onChanged: (v) => setState(() => _vulnerability = v),
            ),

            // ── Location ─────────────────────────────────────────────────
            const FormSectionHeader(title: 'Location'),

            LabeledDropdown<String>(
              label: 'Project',
              required: true,
              hint: 'Select project',
              value: _projectId,
              items: kProjects
                  .map(
                    (p) => DropdownMenuItem(value: p.id, child: Text(p.name)),
                  )
                  .toList(),
              onChanged: (v) => setState(() {
                _projectId = v;
                _communityId = null;
                _lgaValue = null;
                _wardValue = null;
                _wardCtrl.clear();
              }),
              validator: (v) => v == null ? 'Required' : null,
            ),

            LabeledDropdown<String>(
              label: 'LGA',
              required: true,
              hint: 'Select LGA',
              // key ensures the widget reflects the auto-populated value
              // when a community is selected
              key: ValueKey('lga_$_lgaValue'),
              value: _lgaValue,
              items: const [
                DropdownMenuItem(value: 'Maiduguri', child: Text('Maiduguri')),
                DropdownMenuItem(value: 'Jere', child: Text('Jere')),
                DropdownMenuItem(value: 'Konduga', child: Text('Konduga')),
                DropdownMenuItem(value: 'Bama', child: Text('Bama')),
                DropdownMenuItem(value: 'Gwoza', child: Text('Gwoza')),
                DropdownMenuItem(value: 'Ngala', child: Text('Ngala')),
              ],
              onChanged: (v) => setState(() => _lgaValue = v),
              validator: (v) => v == null ? 'Required' : null,
            ),

            LabeledTextField(
              label: 'Ward',
              hint: 'Enter ward name',
              required: true,
              controller: _wardCtrl,
              textCapitalization: TextCapitalization.words,
              onChanged: (v) => setState(() => _wardValue = v),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Required' : null,
            ),

            LabeledDropdown<String>(
              label: 'Community',
              required: true,
              hint: _projectId == null
                  ? 'Select a project first'
                  : communities.isEmpty
                  ? 'No communities for this project'
                  : 'Select community',
              // key forces the widget to fully rebuild when the project
              // changes, preventing a stale value assertion in the dropdown
              key: ValueKey('community_$_projectId'),
              value: _communityId,
              items: communities
                  .map(
                    (c) => DropdownMenuItem(value: c.id, child: Text(c.name)),
                  )
                  .toList(),
              onChanged: _projectId == null || communities.isEmpty
                  ? (_) {}
                  : (v) {
                      if (v == null) return;
                      final community = communities.firstWhere(
                        (c) => c.id == v,
                      );
                      setState(() {
                        _communityId = v;
                        // Auto-populate LGA and Ward from community data
                        _lgaValue = community.lga;
                        _wardCtrl.text = community.ward;
                        _wardValue = community.ward;
                      });
                    },
              validator: (v) => v == null ? 'Required' : null,
            ),

            // ── GPS Location ──────────────────────────────────────────────
            const FormSectionHeader(title: 'GPS Location'),
            GpsTile(
              captured: _gpsCaptured,
              loading: _gpsLoading,
              lat: _lat,
              lon: _lon,
              onCapture: _captureGps,
            ),

            // ── Photo ─────────────────────────────────────────────────────
            const FormSectionHeader(title: 'Photo'),
            PhotoTile(
              hasPhoto: _hasPhoto,
              photoPath: _photoFile?.path,
              onAdd: _addPhoto,
              onRemove: () => setState(() {
                _hasPhoto = false;
                _photoFile = null;
              }),
            ),

            // ── Grant Information ─────────────────────────────────────
            const FormSectionHeader(title: 'Grant Information'),

            // Registered By — auto-filled from logged-in officer
            Container(
              margin: const EdgeInsets.only(bottom: 14),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.04),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.18),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.badge_outlined,
                    color: AppColors.primary,
                    size: 18,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Registered by',
                          style: TextStyle(
                            fontSize: 11,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          kCurrentOfficer.name,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.success.withValues(alpha: 0.10),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Auto-filled',
                      style: TextStyle(
                        fontSize: 10,
                        color: AppColors.success,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            LabeledTextField(
              label: 'Grant Amount (₦)',
              hint: 'e.g. 100000',
              controller: _grantAmountCtrl,
              required: true,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              suffixIcon: const Icon(Icons.payments_outlined, size: 18),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Required';
                final n = double.tryParse(v);
                if (n == null || n < 0) return 'Enter a valid amount';
                return null;
              },
            ),

            LabeledDropdown<String>(
              label: 'Business / Livelihood Type',
              required: true,
              hint: 'Select business type',
              value: _businessTypeCtrl.text.isEmpty
                  ? null
                  : _businessTypeCtrl.text,
              items: const [
                DropdownMenuItem(
                  value: 'Petty trading (foodstuffs)',
                  child: Text('Petty trading (foodstuffs)'),
                ),
                DropdownMenuItem(
                  value: 'Tailoring / fashion design',
                  child: Text('Tailoring / fashion design'),
                ),
                DropdownMenuItem(
                  value: 'Food vending (miya/tuwon)',
                  child: Text('Food vending (miya/tuwon)'),
                ),
                DropdownMenuItem(
                  value: 'Groundnut oil processing',
                  child: Text('Groundnut oil processing'),
                ),
                DropdownMenuItem(
                  value: 'Vegetable farming',
                  child: Text('Vegetable farming'),
                ),
                DropdownMenuItem(
                  value: 'Soap making',
                  child: Text('Soap making'),
                ),
                DropdownMenuItem(
                  value: 'Kuli-kuli / groundnut snacks',
                  child: Text('Kuli-kuli / groundnut snacks'),
                ),
                DropdownMenuItem(
                  value: 'Hair braiding / cosmetics',
                  child: Text('Hair braiding / cosmetics'),
                ),
                DropdownMenuItem(
                  value: 'Tie-dye / adire fabric',
                  child: Text('Tie-dye / adire fabric'),
                ),
                DropdownMenuItem(
                  value: 'Poultry / livestock',
                  child: Text('Poultry / livestock'),
                ),
                DropdownMenuItem(value: 'Other', child: Text('Other')),
              ],
              onChanged: (v) => setState(() {
                if (v != null) _businessTypeCtrl.text = v;
              }),
              validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
            ),

            // end of form children
          ],
        ),
      ),
      bottomNavigationBar: SaveBar(saving: _saving, onSave: _save),
    );
  }
}

// ---------------------------------------------------------------------------
// GPS tile
// ---------------------------------------------------------------------------

