# Authentication System Design

**Updated:** December 26, 2025  
**Status:** ✅ Implemented for Store Manager

---

## Overview

The Insight authentication system uses **store code-based** login instead of traditional email authentication.

### Two Different Apps, Two Different Models:

**Store Manager App (macOS):**

- Individual manager accounts
- Each manager has their own store code + password
- Used for creating forms, viewing analytics, scheduling

**Store App (iOS/Android):**

- **Shared device model** - one login per store location
- Store code represents the physical store (e.g., `PX0000`)
- All employees use the same logged-in device
- No individual employee logins needed

---

## Authentication Flow

### 1. **Login Flow (Existing Users)**

```
User enters store code (e.g., "PX0000") + password
         ↓
App sends: POST /api/v1/auth/login/json
   Body: { "username": "PX0000", "password": "..." }
         ↓
Backend validates credentials
         ↓
   Success: Returns AuthToken + User data
   Failure: Returns error (invalid credentials)
         ↓
Token stored in Flutter Secure Storage
         ↓
User logged in → Navigate to main app
```

### 2. **First-Time Setup Flow**

```
User enters store code (e.g., "PX0000") + password
         ↓
App attempts login → Fails (account not found)
         ↓
UI switches to "First-Time Setup" mode
   - Shows info banner
   - Shows "Confirm Password" field
   - Button changes to "Create Account"
         ↓
User creates password + confirms
         ↓
App sends: POST /api/v1/auth/create-account
   Body: { "username": "PX0000", "password": "..." }
         ↓
Backend creates account for store code
         ↓
Returns AuthToken + User data
         ↓
User logged in → Navigate to main app
```

### 3. **Back to Login**

Users can press "Back to Login" button during first-time setup to return to the normal login screen if they entered the wrong store code.

---

## UI Components

### Login Screen (`apps/store_manager/lib/features/auth/login_screen.dart`)

**Normal Mode:**

- Store Code field (text input, auto-uppercase)
- Password field (obscured)
- "Sign In" button

**First-Time Setup Mode:**

- Store Code field (disabled, shows entered code)
- Info banner: "First time signing in? Create a password for PX0000"
- "Create Password" field
- "Confirm Password" field
- "Create Account" button
- "Back to Login" text button

**Validation Rules:**

- Store Code: Required, minimum 4 characters
- Password (login): Minimum 6 characters
- Password (setup): Minimum 8 characters
- Confirm Password: Must match password

---

## Backend Integration

### Repository: `packages/insight_core/lib/src/repositories/auth_repository.dart`

#### Methods:

**`login(String storeCode, String password)`**

- Endpoint: `POST /api/v1/auth/login/json`
- Request: `{ "username": "PX0000", "password": "..." }`
- Response: `{ "access_token": "...", "user": {...} }`
- Stores token in secure storage
- Sets token in API client headers

**`createAccount(String storeCode, String password)`**

- Endpoint: `POST /api/v1/auth/create-account`
- Request: `{ "username": "PX0000", "password": "..." }`
- Response: `{ "access_token": "...", "user": {...} }`
- Stores token in secure storage
- Sets token in API client headers

**`logout()`**

- Endpoint: `POST /api/v1/auth/logout`
- Clears secure storage
- Removes token from API client

**`restoreSession()`**

- Reads token from secure storage
- Reads user data from secure storage
- Sets token in API client
- Returns User if valid, null otherwise

---

## State Management

### Provider: `apps/store_manager/lib/core/providers/auth_provider.dart`

**AuthState:**

```dart
class AuthState {
  final User? user;
  final bool isLoading;
  final String? error;

  bool get isAuthenticated => user != null;
}
```

**AuthNotifier Methods:**

- `login(storeCode, password)` → bool
- `createAccount(storeCode, password)` → bool
- `logout()` → void
- `clearError()` → void
- `_restoreSession()` → void (called on init)

---

## Security Features

### Secure Storage

- Auth tokens stored in **Flutter Secure Storage**
- Encrypted at rest (AES-256)
- Keys: `auth_token`, `auth_user`

### Password Requirements

- **Login:** Minimum 6 characters
- **First-Time Setup:** Minimum 8 characters
- Passwords transmitted over HTTPS only

### Token Management

- Tokens included in all API requests via `Authorization` header
- Token refresh handled by backend (if implemented)
- Logout clears token from storage and API client

---

## Store Code Format

**Examples:**

- `PX0000` - Primary Express store #0
- `PX0001` - Primary Express store #1
- `RS0042` - Regional Store #42
- `WH0001` - Warehouse #1

**Characteristics:**

- **Case-insensitive** (converted to uppercase)
- **Alphanumeric** characters
- **Minimum 4 characters** required
- Typically follows pattern: `[A-Z]{2}[0-9]{4}`

**Validation:**

- Frontend: Basic length check (≥4 chars)
- Backend: Validates against registered store codes

---

## Backend Requirements

### Required Endpoints

#### 1. Login Endpoint

```
POST /api/v1/auth/login/json
Content-Type: application/json

Request:
{
  "username": "PX0000",
  "password": "secret123"
}

Response (Success):
{
  "access_token": "eyJ0eXAiOiJKV1QiLCJhbGc...",
  "token_type": "bearer",
  "user": {
    "id": "uuid",
    "username": "PX0000",
    "full_name": "Store PX0000",
    "role": "manager",
    "created_at": "2025-12-26T00:00:00Z"
  }
}

Response (Error):
{
  "detail": "Invalid credentials"
}
```

#### 2. Create Account Endpoint

```
POST /api/v1/auth/create-account
Content-Type: application/json

Request:
{
  "username": "PX0000",
  "password": "newsecurepass123"
}

Response (Success):
{
  "access_token": "eyJ0eXAiOiJKV1QiLCJhbGc...",
  "token_type": "bearer",
  "user": {
    "id": "uuid",
    "username": "PX0000",
    "full_name": "Store PX0000",
    "role": "manager",
    "created_at": "2025-12-26T00:00:00Z"
  }
}

Response (Error):
{
  "detail": "Store code not found or account already exists"
}
```

#### 3. Logout Endpoint (Optional)

```
POST /api/v1/auth/logout
Authorization: Bearer <token>

Response:
{
  "message": "Successfully logged out"
}
```

#### 4. Get Current User

```
GET /api/v1/auth/me
Authorization: Bearer <token>

Response:
{
  "id": "uuid",
  "username": "PX0000",
  "full_name": "Store PX0000",
  "role": "manager",
  "created_at": "2025-12-26T00:00:00Z"
}
```

---

## Database Schema (Backend)

### Users Table

```sql
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    username VARCHAR(50) UNIQUE NOT NULL,  -- Store code (e.g., "PX0000")
    password_hash VARCHAR(255) NOT NULL,   -- Bcrypt hash
    full_name VARCHAR(255),
    role VARCHAR(50) DEFAULT 'store',      -- 'manager', 'store', 'admin'
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    last_login TIMESTAMP
);

CREATE INDEX idx_users_username ON users(username);
```

### Store Codes Table (Optional Pre-registration)

```sql
CREATE TABLE store_codes (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    code VARCHAR(50) UNIQUE NOT NULL,      -- "PX0000"
    name VARCHAR(255),                     -- "Primary Express #0"
    location VARCHAR(255),
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT NOW()
);

-- Ensures only valid store codes can create accounts
```

---

## User Model

### Dart Model: `packages/insight_core/lib/src/models/user.dart`

```dart
@freezed
class User with _$User {
  const factory User({
    required String id,
    required String username,      // Store code (e.g., "PX0000")
    String? fullName,
    String? role,
    DateTime? createdAt,
    DateTime? lastLogin,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
```

### Auth Token Model

```dart
@freezed
class AuthToken with _$AuthToken {
  const factory AuthToken({
    required String accessToken,
    required String tokenType,
    required User user,
  }) = _AuthToken;

  factory AuthToken.fromJson(Map<String, dynamic> json) =>
      _$AuthTokenFromJson(json);
}
```

---

## Testing Checklist

### Manual Testing

- [ ] Login with valid store code + password
- [ ] Login with invalid store code
- [ ] Login with valid store code + wrong password
- [ ] First-time setup with new store code
- [ ] Password confirmation mismatch
- [ ] Password too short (< 8 chars in setup)
- [ ] "Back to Login" button works
- [ ] Session restoration on app restart
- [ ] Logout clears session
- [ ] Token included in API requests after login

### Unit Tests (To Implement)

- [ ] `AuthRepository.login()` success
- [ ] `AuthRepository.login()` failure
- [ ] `AuthRepository.createAccount()` success
- [ ] `AuthRepository.createAccount()` failure
- [ ] `AuthNotifier.login()` state changes
- [ ] `AuthNotifier.createAccount()` state changes
- [ ] Token storage and retrieval
- [ ] Session restoration

### Widget Tests (To Implement)

- [ ] Login screen renders correctly
- [ ] First-time setup mode switches properly
- [ ] Form validation works
- [ ] Error messages display
- [ ] Loading states show
- [ ] Navigation after successful login

---

## Store App Implementation

**Status:** ✅ Implemented

The Store app (iOS/Android) uses a **simplified shared-device model**:

### Key Differences from Store Manager:

- **No individual employee logins** - device stays logged in as the store
- **One store code per location** (e.g., `PX0000` for the store, not individual employees)
- **Persistent session** - rarely needs to log out
- **Shared by all team members** at that location

### Implementation:

- ✅ `apps/store/lib/features/auth/login_screen.dart` - Simple login UI
- ✅ `appsEmployee Identification in Store App (Optional)\*\*
- Add "Who's completing this form?" picker at start of each form
- Pre-populate list of employee names from Store Manager
- Purely for attribution, not authentication
- Example: Form submission shows "Submitted by PX0000 (John Doe)"t

### When to Log Out:

- Device reassignment to different store
- Security concern
- Testing/troubleshooting

### Form Submissions:

Since there are no individual employee logins, form submissions will be attributed to:

- The store code (e.g., "PX0000")
- Optional: Employee can enter their name in a form field
- Optional: Use device metadata (device ID, timestamp) for audit trail

---

## Future Enhancements

### 1. **Multi-Role Support**

- Differentiate between Manager and Store Employee roles
- Different permissions based on role

### 2. **Employee Validation**

- Validate entered names against employee roster
- Highlight if name doesn't match known employees
- Still allow free text for flexibility (temps, contractors)

### 3. **Password Reset**

- Forgot password flow
- Email/SMS OTP verification (if contact info available)
- Admin password reset capability

### 3. **Password Reset**

- Forgot password flow
- Email/SMS OTP verification (if contact info available)
- Admin password reset capability

### 4. **Biometric Authentication**

- Face ID / Touch ID on iOS
- Fingerprint on Android
- After initial login with password

### 5. **Biometric Authentication**

- Face ID / Touch ID on iOS
- Fingerprint on Android
- After initial login with password

### 4. **Session Management**

- Token refresh mechanism
- Automatic logout after inactivity
- "Remember me" checkbox

### 6. **Session Management**

- Token refresh mechanism
- Automatic logout after inactivity
- "Remember me" checkbox

### 5. **Audit Logging**

- Log all login attempts
- Track failed login attempts
- Lock acDevice Management for Store App\*\*
- Register devices with specific stores
- Remote logout capability
- Device transfer between stores
- View all devices logged into a store

---

## Form Submission Attribution

Since Store app is shared, form submissions capture employee names **within the form itself**:

### Implementation:

Each form includes "Completed by" text fields at appropriate sections. This is configured by the manager when building the form.

**Example Form Structure:**

```
Opening Checklist Form
├─ Section 1: Store Opening
│  ├─ Doors unlocked? (Yes/No)
│  ├─ Lights on? (Yes/No)
│  └─ Completed by: [Text field] ← Employee enters name
│
├─ Section 2: Register Setup
│  ├─ Cash count correct? (Number)
│  ├─ Register online? (Yes/No)
│  └─ Completed by: [Text field] ← Employee enters name
```

### Database Schema:

```dart
Submission(
  submittedBy: "PX0000",  // Store code from device auth
  responses: {
    "field_1": "Yes",
    "field_2": "Yes",
    "field_3": "John Doe",  // ← Employee name captured here
    "field_4": "850.00",
    "field_5": "Yes",
    "field_6": "Jane Smith",  // ← Different employee name
  }
)
```

### Benefits:

- ✅ Flexible - managers decide which sections need attribution
- ✅ No complex login system for individual employees
- ✅ Audit trail shows who did what
- ✅ Works offline (just a text field)
- ✅ Simple for employees (just type their name)

### Form Builder Helper:

When creating forms in Store Manager, managers can use the standard "Completed by" field:

- Field Type: Short Text
- Label: "Completed by" (constant: `FormConstants.completedByLabel`)
- Placeholder: "Enter your name" (constant: `FormConstants.completedByHint`)
- Required: Yes (recommended)
- Max Length: 50 characters

---

## Migration from Email-Based Auth

If you have existing users with email-based accounts:

1. **Backend Migration Script:**

   ```sql
   -- Add username column if not exists
   ALTER TABLE users ADD COLUMN username VARCHAR(50);

   -- Populate with store codes (manual mapping required)
   UPDATE users SET username = 'PX0000' WHERE email = 'store0@example.com';

   -- Make username unique and not null
   ALTER TABLE users ADD UNIQUE (username);
   ALTER TABLE users ALTER COLUMN username SET NOT NULL;

   -- Optionally keep email for password reset
   ALTER TABLE users ALTER COLUMN email DROP NOT NULL;
   ```

2. **Support Both Login Methods (Transition Period):**

   - Check if input contains `@` → use email login
   - Otherwise → use store code login

3. **Full Cutover:**
   - Remove email login support
   - Update documentation
   - Notify users of change

---

## Support & Troubleshooting

### Common Issues

**"Invalid credentials" error:**

- Check store code is correct (case-insensitive)
- Verify password is correct
- Ensure account exists (try first-time setup)

**"Store code not found" error:**

- Store code not registered in backend
- Contact admin to add store code

**Session not restoring:**

- Clear app data and re-login
- Check Flutter Secure Storage permissions
- Verify token not expired

**Can't create account:**

- Store code may already have an account
- Backend endpoint may not be implemented
- Check network connectivity

---

## Implementation Status

### ✅ Completed

- Store Manager login UI with store code
- First-time setup flow
- Password confirmation
- Auth repository updated
- Auth provider updated
- Form validation
- Error handling
- Session restoration

### ⏳ Pending

- Store app auth screens
- Backend endpoint implementation
- Unit tests
- Widget tests
- Backend database schema
- API documentation

### 🎯 Next Steps

1. Implement backend auth endpoints (`/login`, `/create-account`)
2. Test login flow end-to-end
3. Add Store app auth screens
4. Write unit tests for auth logic
5. Add biometric authentication (optional)

---

**For Questions:** Refer to this document or check implementation in:

- `apps/store_manager/lib/features/auth/login_screen.dart`
- `packages/insight_core/lib/src/repositories/auth_repository.dart`
- `apps/store_manager/lib/core/providers/auth_provider.dart`
