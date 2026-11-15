import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/dummy/dummy_data.dart';
import '../../../../core/themes/app_colors.dart';
import '../../../../core/widgets/form_section_header.dart';
import '../../../../core/widgets/labeled_text_field.dart';

/// Phase 1: pure dummy form — no DB writes.
/// Saves locally with a pending-sync success screen.
class FieldActivityPage extends StatefulWidget {
  const FieldActivityPage({super.key});

  @override
  State<FieldActivityPage> createState() => _FieldActivityPageState();
}

class _FieldActivityPageState extends State<FieldActivityPage> {
  final _formKey = GlobalKey<FormState>();

  // Dropdowns
  String? _projectId;
  String? _communityId;
  String? _activityType;

  // Date
  DateTime? _date;
  final _dateCtrl = TextEditingController();

  // Participants
  final _maleCtrl = TextEditingController(text: '0');
  final _femaleCtrl = TextEditingController(text: '0');
  final _childrenCtrl = TextEditingController(text: '0');

  // Description
  final _descCtrl = TextEditingController();

  // GPS
  bool _gpsLoading = false;
  bool _gpsCaptured = false;
  double? _lat, _lon;

  // Photos
  int _photoCount = 0;

  // Save state
  bool _saving = false;
  bool _savedLocally = false;

  @override
  void dispose() {
    _dateCtrl.dispose();
    _maleCtrl.dispose();
    _femaleCtrl.dispose();
    _childrenCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  List<DummyCommunity> get _communities =>
      _projectId != null ? communitiesForProject(_projectId!) : [];

  static const _activityTypes = [
    'Beneficiary Registration',
    'Grant Disbursement',
    'M&E Business Monitoring',
    'Entrepreneurship Training',
    'Food & Relief Distribution',
    'Skills Training',
    'Community Sensitisation',
    'Supportive Supervision',
    'Verification Visit',
    'Follow-up Visit',
    'Data Collection / Survey',
    'Other',
  ];

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _date ?? now,
      firstDate: DateTime(now.year - 2),
      lastDate: now,
      helpText: 'Select activity date',
    );
    if (picked == null) return;
    setState(() {
      _date = picked;
      _dateCtrl.text =
          '${picked.day.toString().padLeft(2, '0')} '
          '${_months[picked.month - 1]} '
          '${picked.year}';
    });
  }

  static const _months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  Future<void> _captureGps() async {
    setState(() => _gpsLoading = true);
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    setState(() {
      _gpsLoading = false;
      _gpsCaptured = true;
      _lat = 11.8311 + (DateTime.now().millisecond / 100000);
      _lon = 13.1510 + (DateTime.now().millisecond / 100000);
    });
  }

  void _addPhoto() {
    setState(() => _photoCount++);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Photo $_photoCount added (simulated)'),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    await Future.delayed(const Duration(milliseconds: 700));
    if (!mounted) return;

    final selectedComm =
        _communityId != null ? communityById(_communityId!) : null;
    final commName = selectedComm?.name ?? 'Muna Garage';
    final lgaName = selectedComm?.lga ?? 'Jere';

    final newActivity = DummyActivity(
      id: 'act_${DateTime.now().millisecondsSinceEpoch}',
      projectId: _projectId ?? kCurrentProject.id,
      activityType: _activityType ?? 'Community Engagement',
      community: commName,
      lga: lgaName,
      date: _date ?? DateTime.now(),
      maleCount: int.tryParse(_maleCtrl.text.trim()) ?? 0,
      femaleCount: int.tryParse(_femaleCtrl.text.trim()) ?? 0,
      childrenCount: int.tryParse(_childrenCtrl.text.trim()) ?? 0,
      description: _descCtrl.text.trim(),
      hasGps: _gpsCaptured,
      photoCount: _photoCount,
      syncStatus: 'pending',
      fieldOfficerId: kCurrentOfficer.id,
    );

    kActivities.insert(0, newActivity);

    setState(() {
      _saving = false;
      _savedLocally = true;
    });
  }

  int get _totalParticipants =>
      (int.tryParse(_maleCtrl.text) ?? 0) +
      (int.tryParse(_femaleCtrl.text) ?? 0) +
      (int.tryParse(_childrenCtrl.text) ?? 0);

  @override
  Widget build(BuildContext context) {
    if (_savedLocally) {
      return _SavedScreen(
        activityType: _activityType ?? 'Activity',
        onDone: () => Navigator.of(context).pop(),
        onLogAnother: () => setState(() {
          _savedLocally = false;
          _formKey.currentState?.reset();
          _projectId = null;
          _communityId = null;
          _activityType = null;
          _date = null;
          _dateCtrl.clear();
          _maleCtrl.text = '0';
          _femaleCtrl.text = '0';
          _childrenCtrl.text = '0';
          _descCtrl.clear();
          _gpsCaptured = false;
          _photoCount = 0;
        }),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Log Field Activity'),
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
            // Offline banner
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
                      'Works offline. Saves to device and syncs when connected.',
                      style: TextStyle(fontSize: 12, color: AppColors.primary),
                    ),
                  ),
                ],
              ),
            ),

            // ── Activity Details ─────────────────────────────────────────
            const FormSectionHeader(title: 'Activity Details'),

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
              }),
              validator: (v) => v == null ? 'Required' : null,
            ),

            LabeledDropdown<String>(
              label: 'Community',
              required: true,
              hint: _projectId == null
                  ? 'Select a project first'
                  : _communities.isEmpty
                  ? 'No communities available'
                  : 'Select community',
              value: _communityId,
              items: _communities
                  .map(
                    (c) => DropdownMenuItem(value: c.id, child: Text(c.name)),
                  )
                  .toList(),
              onChanged: (v) => setState(() => _communityId = v),
              validator: (v) => v == null ? 'Required' : null,
            ),

            LabeledDropdown<String>(
              label: 'Activity Type',
              required: true,
              hint: 'Select activity type',
              value: _activityType,
              items: _activityTypes
                  .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                  .toList(),
              onChanged: (v) => setState(() => _activityType = v),
              validator: (v) => v == null ? 'Required' : null,
            ),

            LabeledTextField(
              label: 'Activity Date',
              hint: 'Select date',
              controller: _dateCtrl,
              required: true,
              readOnly: true,
              onTap: _pickDate,
              suffixIcon: const Icon(Icons.calendar_today, size: 18),
              validator: (v) => _date == null ? 'Please select a date' : null,
            ),

            // ── Participants ─────────────────────────────────────────────
            const FormSectionHeader(title: 'Participants'),
            _ParticipantsSection(
              maleCtrl: _maleCtrl,
              femaleCtrl: _femaleCtrl,
              childrenCtrl: _childrenCtrl,
            ),

            // Running total
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Center(
                child: AnimatedBuilder(
                  animation: Listenable.merge([
                    _maleCtrl,
                    _femaleCtrl,
                    _childrenCtrl,
                  ]),
                  builder: (_, child) {
                    final total = _totalParticipants;
                    return Text(
                      'Total: $total participant${total == 1 ? '' : 's'}',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: total > 0
                            ? AppColors.primary
                            : AppColors.textSecondary,
                      ),
                    );
                  },
                ),
              ),
            ),

            // ── Description ──────────────────────────────────────────────
            const FormSectionHeader(title: 'Description'),

            LabeledTextField(
              label: 'What happened?',
              hint: 'Describe activities conducted, observations, outcomes…',
              controller: _descCtrl,
              maxLines: 4,
              minLines: 3,
              textCapitalization: TextCapitalization.sentences,
            ),

            // ── GPS Location ─────────────────────────────────────────────
            const FormSectionHeader(title: 'GPS Location'),
            _GpsTile(
              captured: _gpsCaptured,
              loading: _gpsLoading,
              lat: _lat,
              lon: _lon,
              onCapture: _captureGps,
            ),

            // ── Photos ───────────────────────────────────────────────────
            const FormSectionHeader(title: 'Photos'),
            _PhotosTile(
              count: _photoCount,
              onAdd: _addPhoto,
              onRemoveLast: _photoCount > 0
                  ? () => setState(() => _photoCount--)
                  : null,
            ),
          ],
        ),
      ),
      bottomNavigationBar: _SaveBar(saving: _saving, onSave: _save),
    );
  }
}

// ---------------------------------------------------------------------------
// Participants section — three stepper fields
// ---------------------------------------------------------------------------

class _ParticipantsSection extends StatelessWidget {
  const _ParticipantsSection({
    required this.maleCtrl,
    required this.femaleCtrl,
    required this.childrenCtrl,
  });

  final TextEditingController maleCtrl;
  final TextEditingController femaleCtrl;
  final TextEditingController childrenCtrl;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            child: _CountField(label: 'Male', ctrl: maleCtrl),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _CountField(label: 'Female', ctrl: femaleCtrl),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _CountField(label: 'Children', ctrl: childrenCtrl),
          ),
        ],
      ),
    );
  }
}

class _CountField extends StatelessWidget {
  const _CountField({required this.label, required this.ctrl});
  final String label;
  final TextEditingController ctrl;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            _StepBtn(
              icon: Icons.remove,
              onTap: () {
                final v = int.tryParse(ctrl.text) ?? 0;
                if (v > 0) ctrl.text = '${v - 1}';
              },
            ),
            Expanded(
              child: TextFormField(
                controller: ctrl,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 10,
                  ),
                ),
                validator: (v) {
                  if (v == null || v.isEmpty) return null;
                  final n = int.tryParse(v);
                  if (n == null || n < 0) return '≥ 0';
                  return null;
                },
              ),
            ),
            _StepBtn(
              icon: Icons.add,
              onTap: () {
                final v = int.tryParse(ctrl.text) ?? 0;
                ctrl.text = '${v + 1}';
              },
            ),
          ],
        ),
      ],
    );
  }
}

class _StepBtn extends StatelessWidget {
  const _StepBtn({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      width: 32,
      height: 40,
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, size: 18, color: AppColors.primary),
    ),
  );
}

// ---------------------------------------------------------------------------
// GPS tile
// ---------------------------------------------------------------------------

class _GpsTile extends StatelessWidget {
  const _GpsTile({
    required this.captured,
    required this.loading,
    required this.lat,
    required this.lon,
    required this.onCapture,
  });
  final bool captured;
  final bool loading;
  final double? lat;
  final double? lon;
  final VoidCallback onCapture;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: captured && lat != null
          ? Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: AppColors.success.withValues(alpha: 0.35),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.gps_fixed,
                    color: AppColors.success,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Location captured',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.success,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${lat!.toStringAsFixed(6)},  ${lon!.toStringAsFixed(6)}',
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.textSecondary,
                            fontFamily: 'monospace',
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.refresh,
                      size: 18,
                      color: AppColors.textSecondary,
                    ),
                    onPressed: onCapture,
                  ),
                ],
              ),
            )
          : SizedBox(
              width: double.infinity,
              height: 52,
              child: OutlinedButton.icon(
                onPressed: loading ? null : onCapture,
                icon: loading
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.primary,
                        ),
                      )
                    : const Icon(Icons.gps_not_fixed, color: AppColors.primary),
                label: Text(
                  loading ? 'Acquiring GPS fix…' : '  Capture Location',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.primary),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
    );
  }
}

// ---------------------------------------------------------------------------
// Photos tile
// ---------------------------------------------------------------------------

class _PhotosTile extends StatelessWidget {
  const _PhotosTile({
    required this.count,
    required this.onAdd,
    required this.onRemoveLast,
  });
  final int count;
  final VoidCallback onAdd;
  final VoidCallback? onRemoveLast;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (count > 0) ...[
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.25),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.photo_library_outlined,
                    color: AppColors.primary,
                    size: 22,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      '$count photo${count == 1 ? '' : 's'} added',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  if (onRemoveLast != null)
                    IconButton(
                      icon: const Icon(
                        Icons.remove_circle_outline,
                        size: 20,
                        color: AppColors.textSecondary,
                      ),
                      onPressed: onRemoveLast,
                    ),
                  IconButton(
                    icon: const Icon(
                      Icons.add_a_photo_outlined,
                      size: 20,
                      color: AppColors.primary,
                    ),
                    onPressed: onAdd,
                  ),
                ],
              ),
            ),
          ] else ...[
            SizedBox(
              width: double.infinity,
              height: 52,
              child: OutlinedButton.icon(
                onPressed: onAdd,
                icon: const Icon(
                  Icons.add_a_photo_outlined,
                  color: AppColors.primary,
                ),
                label: const Text(
                  '  Add Photos',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.primary),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Save bar
// ---------------------------------------------------------------------------

class _SaveBar extends StatelessWidget {
  const _SaveBar({required this.saving, required this.onSave});
  final bool saving;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        16,
        12,
        16,
        12 + MediaQuery.of(context).padding.bottom,
      ),
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton(
          onPressed: saving ? null : onSave,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.6),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 0,
          ),
          child: saving
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: Colors.white,
                  ),
                )
              : const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.save_outlined, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Save Activity',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Saved locally success screen
// ---------------------------------------------------------------------------

class _SavedScreen extends StatelessWidget {
  const _SavedScreen({
    required this.activityType,
    required this.onDone,
    required this.onLogAnother,
  });
  final String activityType;
  final VoidCallback onDone;
  final VoidCallback onLogAnother;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 88,
                height: 88,
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle_outline,
                  color: AppColors.success,
                  size: 52,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Activity Saved',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                activityType,
                style: const TextStyle(
                  fontSize: 15,
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 28),

              // Pending sync banner
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.warning.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.warning.withValues(alpha: 0.35),
                  ),
                ),
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.cloud_upload_outlined,
                      color: AppColors.warning,
                      size: 24,
                    ),
                    SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '🟠  Pending Sync',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppColors.warning,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Saved to your device. Will sync automatically when you have internet access.',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: onLogAnother,
                  icon: const Icon(Icons.add_chart_outlined),
                  label: const Text(
                    'Log Another Activity',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 0,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton(
                  onPressed: onDone,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(color: AppColors.primary),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Back to Activities',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
