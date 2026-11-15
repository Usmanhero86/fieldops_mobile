import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/datasources/beneficiary_local_dao.dart';

part 'beneficiary_registration_state.dart';

/// Manages the save lifecycle for the Beneficiary Registration form.
///
/// The Cubit keeps presentation logic out of the screen widget.  Field
/// validation lives in the [Form] widget itself; this Cubit only handles the
/// async persist operation.
class BeneficiaryRegistrationCubit
    extends Cubit<BeneficiaryRegistrationState> {
  BeneficiaryRegistrationCubit({required BeneficiaryLocalDao dao})
      : _dao = dao,
        super(const BeneficiaryRegistrationIdle());

  final BeneficiaryLocalDao _dao;

  /// Persists the validated form data to the local database.
  ///
  /// Emits [BeneficiaryRegistrationSaving] while the write is in flight,
  /// then either [BeneficiaryRegistrationSuccess] or
  /// [BeneficiaryRegistrationFailure].
  Future<void> save({
    required String firstName,
    required String lastName,
    required String gender,
    required DateTime dateOfBirth,
    String? phoneNumber,
    required String lga,
    required String ward,
    required String communityId,
    required String projectId,
    int? householdSize,
    String? vulnerabilityCategory,
    double? latitude,
    double? longitude,
    int? gpsTimestamp,
    required String fieldOfficerId,
    String? photoPath,
  }) async {
    emit(const BeneficiaryRegistrationSaving());
    try {
      final id = await _dao.insertBeneficiary(
        firstName: firstName,
        lastName: lastName,
        gender: gender,
        dateOfBirth: dateOfBirth,
        phoneNumber: phoneNumber,
        lga: lga,
        ward: ward,
        communityId: communityId,
        projectId: projectId,
        householdSize: householdSize,
        vulnerabilityCategory: vulnerabilityCategory,
        latitude: latitude,
        longitude: longitude,
        gpsTimestamp: gpsTimestamp,
        fieldOfficerId: fieldOfficerId,
        photoPath: photoPath,
      );
      emit(BeneficiaryRegistrationSuccess(beneficiaryId: id));
    } catch (e) {
      emit(BeneficiaryRegistrationFailure(message: e.toString()));
    }
  }

  /// Resets back to idle so the form can be reused without re-creating
  /// the cubit (e.g. after showing a success snackbar).
  void reset() => emit(const BeneficiaryRegistrationIdle());
}
