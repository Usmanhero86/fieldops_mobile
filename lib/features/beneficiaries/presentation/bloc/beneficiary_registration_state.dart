part of 'beneficiary_registration_cubit.dart';

/// States emitted by [BeneficiaryRegistrationCubit].
sealed class BeneficiaryRegistrationState {
  const BeneficiaryRegistrationState();
}

/// The form is idle and ready for input.
final class BeneficiaryRegistrationIdle extends BeneficiaryRegistrationState {
  const BeneficiaryRegistrationIdle();
}

/// A save operation is in progress.
final class BeneficiaryRegistrationSaving extends BeneficiaryRegistrationState {
  const BeneficiaryRegistrationSaving();
}

/// The beneficiary was saved successfully.
final class BeneficiaryRegistrationSuccess extends BeneficiaryRegistrationState {
  const BeneficiaryRegistrationSuccess({required this.beneficiaryId});
  final String beneficiaryId;
}

/// An error occurred during saving.
final class BeneficiaryRegistrationFailure extends BeneficiaryRegistrationState {
  const BeneficiaryRegistrationFailure({required this.message});
  final String message;
}
