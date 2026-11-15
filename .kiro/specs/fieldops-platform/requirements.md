# Requirements Document

## Introduction

FieldOps is a Flutter mobile application designed for field officers working in humanitarian and development programmes. The app enables field officers to register beneficiaries, log field activities, manage data collection, and synchronise records with a remote backend — all while remaining fully functional in offline environments. The system uses local SQLite storage (Drift) as the source of truth on device, with automatic background synchronisation when connectivity is restored.

---

## Glossary

- **App**: The FieldOps Flutter mobile application running on an Android or iOS device.
- **Field_Officer**: An authenticated user who collects data in the field.
- **Backend**: The remote REST API server accessible at the configured base URL.
- **Local_DB**: The on-device Drift/SQLite database that stores all entities locally.
- **Sync_Engine**: The background component responsible for detecting connectivity and uploading pending records to the Backend.
- **Pending_Record**: Any locally created or modified record that has not yet been successfully uploaded to the Backend.
- **Beneficiary**: An individual registered by a Field_Officer, associated with a project and community.
- **Field_Activity**: A logged event conducted in the field, associated with a project, community, and activity type.
- **Project**: A programme-level entity grouping communities, beneficiaries, and activities.
- **Community**: A geographic sub-unit under a project, associated with a ward and LGA.
- **GPS_Location**: A coordinate pair (latitude, longitude) captured from the device's GPS sensor.
- **Photo**: An image file captured from the device camera or selected from the gallery, stored on the device filesystem.
- **Sync_Status_Banner**: A persistent UI element displaying the count of Pending_Records and current sync state.
- **Session_Token**: A JWT or equivalent credential issued by the Backend on successful authentication, stored securely on the device.
- **LGA**: Local Government Area — an administrative geographic unit.
- **Ward**: An administrative sub-unit within an LGA.
- **Vulnerability_Category**: A classification label applied to a Beneficiary indicating level of need.
- **BLoC**: Business Logic Component — the state management layer used throughout the App.
- **DioClient**: The configured HTTP client used by the App to communicate with the Backend.

---

## Requirements

### Requirement 1: Authentication

**User Story:** As a Field_Officer, I want to log in with my credentials, so that I can access the App and have my identity associated with all records I create.

#### Acceptance Criteria

1. WHEN a Field_Officer submits a valid username and password, THE App SHALL authenticate against the Backend `/api/auth/login` endpoint and store the returned Session_Token securely on the device.
2. WHEN authentication succeeds, THE App SHALL navigate the Field_Officer to the Dashboard screen.
3. IF the Backend returns an authentication error, THEN THE App SHALL display a descriptive error message on the login screen without clearing the username field.
4. WHILE a login request is in flight, THE App SHALL display a loading indicator and disable the submit button to prevent duplicate submissions.
5. WHEN the App launches and a valid Session_Token is present on the device, THE App SHALL navigate directly to the Dashboard screen without prompting for credentials.
6. WHEN a Field_Officer selects logout, THE App SHALL invalidate the local Session_Token and navigate to the login screen.
7. THE App SHALL attach the Session_Token as a Bearer token in the Authorization header of every request sent to the Backend via DioClient.

---

### Requirement 2: Navigation

**User Story:** As a Field_Officer, I want a clear navigation structure, so that I can move between all sections of the App efficiently.

#### Acceptance Criteria

1. THE App SHALL provide navigation access to Dashboard, My Projects, My Communities, Beneficiaries, Field Activities, Data Collection, Pending Sync, and Profile screens after authentication.
2. WHEN a Field_Officer navigates to any screen, THE App SHALL render that screen within 300ms of the navigation gesture completing.
3. THE App SHALL maintain navigation state so that a Field_Officer returning to a previously visited screen sees the same scroll position and filter state unless a data refresh has occurred.
4. IF a Field_Officer attempts to navigate to a screen that requires a selected Project context and no Project is selected, THEN THE App SHALL prompt the Field_Officer to select a Project before proceeding.

---

### Requirement 3: Offline-First Data Access

**User Story:** As a Field_Officer, I want to access all my data without an internet connection, so that I can work in areas with no network coverage.

#### Acceptance Criteria

1. THE App SHALL store all Projects, Communities, Beneficiaries, and Field_Activities in the Local_DB upon first successful sync and make them readable without network access.
2. WHEN the device has no internet connectivity, THE App SHALL read all list and detail views from the Local_DB and display the data without showing network error messages.
3. WHEN a Field_Officer creates or modifies a record while offline, THE App SHALL persist the record to the Local_DB immediately and mark it as a Pending_Record.
4. THE App SHALL allow a Field_Officer to complete Beneficiary registration and Field_Activity logging in their entirety while the device is offline.
5. WHILE the device is offline, THE App SHALL display a connectivity status indicator so the Field_Officer is aware that sync is not active.

---

### Requirement 4: Beneficiary Registration

**User Story:** As a Field_Officer, I want to register a new beneficiary with personal, location, programme, and field data, so that the beneficiary's information is captured accurately and linked to the correct project.

#### Acceptance Criteria

1. THE App SHALL provide a multi-step registration form collecting: First Name, Last Name, Gender, Date of Birth, Phone Number, LGA, Ward, Community, Project, Household Size, Vulnerability Category, GPS Location, and Photo.
2. WHEN a Field_Officer initiates beneficiary registration, THE App SHALL auto-populate the GPS_Location field by reading the device's current coordinates via the geolocator package.
3. WHEN a Field_Officer submits the registration form, THE App SHALL auto-capture and persist latitude, longitude, timestamp, field_officer_id, and project_id alongside the beneficiary record in the Local_DB.
4. IF any mandatory field (First Name, Last Name, Gender, Date of Birth, LGA, Ward, Community, Project) is empty on form submission, THEN THE App SHALL display a field-level validation error and prevent the record from being saved.
5. WHEN a Field_Officer submits a valid registration form, THE App SHALL save the Beneficiary record to the Local_DB within 500ms and mark it as a Pending_Record if no active sync is in progress.
6. THE App SHALL display the newly registered Beneficiary in the Beneficiaries list immediately after successful local save, without waiting for Backend confirmation.
7. WHEN a Field_Officer selects GPS Location capture, THE App SHALL request location permission via permission_handler if not already granted, and display a descriptive message if permission is denied.
8. THE App SHALL prevent duplicate beneficiary registration by checking the Local_DB for an existing record with the same First Name, Last Name, Date of Birth, and Project before saving.
9. IF a duplicate record is detected, THEN THE App SHALL display a warning message identifying the existing record and require explicit Field_Officer confirmation before saving.

---

### Requirement 5: Photo Capture and Storage

**User Story:** As a Field_Officer, I want to attach photos to beneficiary records and field activities, so that visual evidence is captured alongside the structured data.

#### Acceptance Criteria

1. THE App SHALL allow a Field_Officer to capture a Photo using the device camera or select a Photo from the device gallery for both Beneficiary and Field_Activity records.
2. WHEN a Photo is captured or selected, THE App SHALL store the Photo file on the device filesystem and record the absolute file path in the associated Local_DB record.
3. THE App SHALL support attaching multiple Photos to a single Field_Activity record.
4. WHEN a Beneficiary record is synced to the Backend, THE App SHALL upload the associated Photo file as a multipart attachment alongside the structured record data.
5. WHEN a Field_Activity record is synced to the Backend, THE App SHALL upload all associated Photo files as multipart attachments alongside the structured record data.
6. IF the device camera or gallery permission has not been granted, THEN THE App SHALL request the required permission via permission_handler and display a descriptive rationale before the permission dialog appears.
7. WHEN a Photo file cannot be read from the device filesystem during sync, THE App SHALL log the error, mark the individual photo upload as failed, and continue syncing the remaining record fields.

---

### Requirement 6: Field Activity Logging

**User Story:** As a Field_Officer, I want to log a field activity with participant counts, location, and photos, so that programme activities are accurately recorded.

#### Acceptance Criteria

1. THE App SHALL provide a Field_Activity form collecting: Project, Community, Activity Type, Date, Male Participant Count, Female Participant Count, Children Participant Count, Description, GPS Location, and one or more Photos.
2. IF any mandatory field (Project, Community, Activity Type, Date) is empty on form submission, THEN THE App SHALL display a field-level validation error and prevent the record from being saved.
3. WHEN a Field_Officer submits a valid Field_Activity form, THE App SHALL save the record to the Local_DB within 500ms and mark it as a Pending_Record if no active sync is in progress.
4. WHEN a Field_Officer initiates GPS Location capture on the Field_Activity form, THE App SHALL read the device's current coordinates via the geolocator package and populate the GPS_Location field.
5. THE App SHALL display the newly logged Field_Activity in the Field Activities list immediately after successful local save, without waiting for Backend confirmation.
6. THE App SHALL enforce that Male Participant Count, Female Participant Count, and Children Participant Count are non-negative integers.

---

### Requirement 7: Projects and Communities

**User Story:** As a Field_Officer, I want to view the projects and communities assigned to me, so that I can associate records with the correct programme context.

#### Acceptance Criteria

1. THE App SHALL display a list of Projects assigned to the authenticated Field_Officer, sourced from the Local_DB.
2. THE App SHALL display a list of Communities associated with a selected Project, sourced from the Local_DB.
3. WHEN a Field_Officer selects a Project, THE App SHALL filter the Communities list to show only Communities linked to that Project.
4. WHEN the App performs a sync, THE App SHALL refresh Project and Community data from the Backend `/api/projects` and `/api/communities` endpoints and update the Local_DB.
5. THE App SHALL display Project name, status, and associated community count on the My Projects screen.
6. THE App SHALL display Community name, Ward, and LGA on the My Communities screen.

---

### Requirement 8: Dashboard

**User Story:** As a Field_Officer, I want a dashboard that summarises my activity, so that I can quickly assess my progress.

#### Acceptance Criteria

1. THE App SHALL display on the Dashboard: total registered Beneficiaries, total logged Field_Activities, count of Pending_Records, and assigned Project count — all sourced from the Local_DB.
2. WHEN a Field_Officer opens the Dashboard, THE App SHALL load and render all summary counts within 500ms using data from the Local_DB.
3. THE App SHALL update Dashboard summary counts in real time when a new Beneficiary or Field_Activity is saved locally.
4. THE App SHALL provide navigation shortcuts on the Dashboard to the Beneficiary registration form and the Field_Activity logging form.

---

### Requirement 9: Automatic Background Synchronisation

**User Story:** As a Field_Officer, I want my data to sync automatically when I have internet access, so that records reach the server without manual intervention.

#### Acceptance Criteria

1. THE Sync_Engine SHALL monitor network connectivity using the connectivity_plus package and initiate a sync attempt whenever connectivity changes from unavailable to available.
2. WHEN connectivity is available and Pending_Records exist, THE Sync_Engine SHALL upload Pending_Records to the Backend in the order they were created (oldest first).
3. WHEN a Pending_Record is successfully uploaded to the Backend, THE Sync_Engine SHALL update the record's sync status in the Local_DB from pending to synced.
4. IF the Backend returns a non-retryable error (HTTP 400 or HTTP 422) for a Pending_Record, THEN THE Sync_Engine SHALL mark that record's sync status as failed in the Local_DB and proceed to the next Pending_Record.
5. IF the Backend returns a retryable error (HTTP 5xx or network timeout) for a Pending_Record, THEN THE Sync_Engine SHALL retain that record's pending status and retry it on the next sync cycle.
6. THE Sync_Engine SHALL operate silently in the background without interrupting the Field_Officer's current workflow.
7. WHEN sync is in progress, THE Sync_Status_Banner SHALL display the number of Pending_Records remaining and a visual in-progress indicator.
8. WHEN all Pending_Records have been successfully uploaded, THE Sync_Status_Banner SHALL display a confirmation that all records are synced.
9. THE Sync_Engine SHALL sync Beneficiary photos and Field_Activity photos as multipart uploads to the Backend alongside their parent records.

---

### Requirement 10: Pending Sync Screen

**User Story:** As a Field_Officer, I want to view all records awaiting sync, so that I can monitor what data has not yet reached the server.

#### Acceptance Criteria

1. THE App SHALL display on the Pending Sync screen a list of all Pending_Records grouped by record type (Beneficiary, Field_Activity).
2. THE App SHALL display for each Pending_Record: record type, display name or identifier, creation timestamp, and current sync status (pending, failed, syncing).
3. WHEN a Pending_Record's sync status changes, THE App SHALL update the Pending Sync screen in real time without requiring a manual refresh.
4. WHERE a Pending_Record has a failed sync status, THE App SHALL provide a manual retry action for that individual record.
5. WHEN a Field_Officer triggers manual retry on a failed Pending_Record and connectivity is available, THE Sync_Engine SHALL attempt to upload that record immediately.

---

### Requirement 11: Profile

**User Story:** As a Field_Officer, I want to view my profile information, so that I can verify my account details and perform account-level actions.

#### Acceptance Criteria

1. THE App SHALL display on the Profile screen: full name, username, assigned role, and assigned Projects of the authenticated Field_Officer.
2. THE App SHALL source Profile data from the Local_DB and refresh it from the Backend `/api/profile` endpoint when connectivity is available.
3. THE App SHALL provide a logout action on the Profile screen that clears the Session_Token and returns the Field_Officer to the login screen.

---

### Requirement 12: Permissions Management

**User Story:** As a Field_Officer, I want the App to request device permissions clearly, so that I understand why permissions are needed and can grant them without confusion.

#### Acceptance Criteria

1. WHEN the App requires camera, gallery, or location permission for the first time, THE App SHALL display a plain-language rationale to the Field_Officer before invoking the system permission dialog via permission_handler.
2. IF a Field_Officer permanently denies a required permission, THEN THE App SHALL display a message explaining the impact and provide a direct link to the device Settings screen.
3. THE App SHALL request only the permissions required for the active operation and SHALL NOT request all permissions at application launch.

---

### Requirement 13: Error Handling and Resilience

**User Story:** As a Field_Officer, I want the App to handle errors gracefully, so that I can continue working without losing data when something goes wrong.

#### Acceptance Criteria

1. IF a network request via DioClient fails due to a connection timeout (exceeding 30 seconds), THEN THE App SHALL cancel the request, surface a user-visible error message, and preserve any unsaved form data.
2. IF the Local_DB write operation fails, THEN THE App SHALL display an error message to the Field_Officer and retain the form data so the Field_Officer can retry.
3. WHEN an unhandled exception occurs, THE App SHALL log the exception details to a local log file and display a generic error message to the Field_Officer without exposing stack traces.
4. THE App SHALL not lose any locally saved record due to an application crash — the Local_DB SHALL remain intact and consistent after an application restart.
