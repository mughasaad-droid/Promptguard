# 🛡️ PromptGuard Firewall — AI Security & Guardrails Platform

**PromptGuard Firewall** is a comprehensive, real-time security guardrail system for Large Language Model (LLM) applications. It acts as an intelligent firewall layer between end-users and AI models, detecting and mitigating prompt injections, jailbreak attempts, toxic/malicious queries, and PII (Personally Identifiable Information) data leaks in real-time.

---

## 🚀 Key Features

### 1. 📊 Real-Time Admin Dashboard
- **Live Threat Stream**: Instant notification and visualization of incoming prompt evaluations and flagged violations.
- **Security Metrics**: Quick statistics on total prompt evaluations, block counts, average risk score, and p95 latency.
- **Threat Trend Visualization**: Interactive charts powered by `fl_chart` tracking hourly security incidents and policy breaches.

### 2. 🧠 AI-Powered Multi-Lingual Prompt Inspection
- Integrated with **Google Gemini 1.5 Flash** (`google_generative_ai`).
- Multi-lingual capability: Detects attacks in **English**, **Urdu (Nastaliq script)**, and **Roman Urdu (Urdu in Latin script)**.
- Smart Fallback: Automatic seamless fallback to local pattern-matching security logic if no API key or network connection is available.

### 3. 🛡️ Dual-Model Security Engine
- **Model A (Behavioral Safety)**:
  - Detects prompt injection attacks, jailbreaks (e.g., "DAN mode", "Ignore previous instructions", "act as a criminal", "bhool jao").
  - Identifies criminal activity instructions, life-threatening content, hate speech, and harassment.
- **Model B (Data Governance Matrix)**:
  - Detects and enforces rules on sensitive entity leaks:
    - 📧 **Emails**
    - 🔑 **API Keys**
    - 💳 **Credit Card Numbers**
    - 🔐 **Passwords & Credentials**
  - Granular Policy Actions: **Hard Block**, **Redact & Allow**, or **Audit Log Only**.

### 4. 📜 Audit Logs & Forensic Ledger
- Immutable ledger recording every prompt evaluation with forensic metadata:
  - SHA-256 Prompt Hash
  - Risk Score (0.0 to 1.0)
  - Detailed Verdict breakdown (Clean, Blocked, Redacted, High Risk)
  - Masked snapshot of prompt & response for privacy compliance.

### 5. 🎛️ Dynamic Policy Configuration
- Real-time adjustment of Model A risk thresholds (e.g., 0.70 Hard Block threshold).
- Interactive governance matrix to change policies for specific sensitive data types on the fly.

### 6. 📱 Remote Control Admin App
- Standalone secondary app (`lib/admin_app.dart`) designed for Red-Teaming and remote testing.
- Uses **Firebase Cloud Firestore** to sync prompt test injections remotely in real-time to the main firewall dashboard.

---

## 🏗️ Architecture & Tech Stack

```
                     ┌───────────────────────────────┐
                     │    User / Red-Teamer Input    │
                     └───────────────┬───────────────┘
                                     │
                                     ▼
                     ┌───────────────────────────────┐
                     │    PromptGuard Firewall       │
                     │  (Flutter Cross-Platform App) │
                     └───────────────┬───────────────┘
                                     │
           ┌─────────────────────────┴─────────────────────────┐
           ▼                                                   ▼
┌──────────────────────┐                           ┌──────────────────────┐
│ Model A: Behavioral  │                           │ Model B: Governance  │
│ Gemini 1.5 Flash AI  │                           │ PII Redaction & Rules│
└──────────┬───────────┘                           └──────────┬───────────┘
           │                                                   │
           └─────────────────────────┬─────────────────────────┘
                                     │
                                     ▼
                     ┌───────────────────────────────┐
                     │ Real-Time Verdict & Audit Log │
                     │  (Firestore & Local Provider) │
                     └───────────────────────────────┘
```

- **Framework**: Flutter (Dart) — Cross-platform Mobile (Android/iOS) and Web
- **AI Integration**: Google Gemini 1.5 Flash (`google_generative_ai`)
- **Backend & Sync**: Firebase (Authentication & Cloud Firestore)
- **State Management**: `provider` (ChangeNotifier Architecture)
- **Data Visualization**: `fl_chart`

---

## 📂 Project Structure

```
lib/
├── admin_app.dart              # Standalone Admin Remote Control entry point
├── main.dart                   # Primary PromptGuard App entry point & Auth wrapper
├── admin_screens/              
│   └── admin_control_screen.dart # Remote testing & prompt injection generator
├── models/                     
│   ├── mock_data.dart          # Core AppData state provider & Gemini LLM evaluator
│   └── models.dart             # Data classes (AuditLogEntry, LiveViolation, PolicyEntity)
├── screens/                    
│   ├── audit_logs_screen.dart  # Detailed forensic audit ledger
│   ├── auth_screen.dart        # Firebase authentication screen
│   ├── dashboard_screen.dart   # Real-time metrics & live violation stream
│   └── policy_config_screen.dart# Policy thresholds & Model B governance matrix
├── theme/                      
│   └── app_theme.dart          # Dark cybersecurity UI theme & color palette
└── widgets/                    
    └── shared_widgets.dart     # Reusable UI components (StatCard, VerdictBadge, etc.)
```

---

## ⚙️ Setup & Installation

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (`>=3.0.0`)
- [Android Studio](https://developer.android.com/studio) or VS Code with Flutter extension
- Google Gemini API Key (Optional — local fallback operates without an API key)

### Steps

1. **Clone the repository**:
   ```bash
   git clone https://github.com/mughasaad-droid/Promptguard.git
   cd Promptguard
   ```

2. **Install dependencies**:
   ```bash
   flutter pub get
   ```

3. **Run the Main Application**:
   - *Without Gemini API key (uses local evaluation engine)*:
     ```bash
     flutter run
     ```
   - *With Gemini API key enabled*:
     ```bash
     flutter run --dart-define=GEMINI_API_KEY=your_gemini_api_key_here
     ```

4. **Run the Remote Admin Testing App**:
   ```bash
   flutter run -t lib/admin_app.dart
   ```

---

## 🔒 Security & Privacy Notice
All sensitive API keys and Firebase credentials have been decoupled from the source code. Credentials can be passed securely at build time via `--dart-define` parameters or environment configurations.

---

## 📄 License
This project is licensed under the MIT License — see the LICENSE file for details.
