# AILIXIR

AI-powered drug discovery platform built with Flutter — molecular docking, generation, ADMET prediction, chemical similarity search, drug repurposing, and MD simulation setup, all in one desktop application.

## Features

### Core
| Feature | Description |
|---|---|
| **News Feed** | Dashboard with paginated pharma/biotech articles filterable by category (chemistry, pharma, biotech, medicine, research, clinical trials). Bookmark and share articles. |
| **Molecular Lab** | 3D molecular structure viewer powered by Mol* (MolStar) inside a WebView. Load structures by PDB ID or choose from sample structures (EGFR kinase, Haemoglobin, Crambin, SARS-CoV-2 Spike, COVID-19 S protein). |
| **Auth** | Email/password registration & login, Google Sign-In, email verification via OTP, password reset via OTP, secure token-based session management with Laravel Sanctum. |
| **Profile** | View and edit user profile (name, email, institution, research focus), activity history, credits. |

### Operations

| Feature | Description |
|---|---|
| **AI Molecule Generation** | Generate novel drug-like molecules with configurable parameters. View molecular properties (MW, LogP, TPSA, HBD, HBA, QED, SA Score, predicted pAff). Export ligands as PDBQT/SDF/PDB. Download results as CSV/JSON. |
| **Molecular Docking** | Submit docking jobs (AutoDock Vina style) with protein + ligand (SMILES or file), configure binding site, exhaustiveness, and number of poses. View results with Vina scores and visualize docked poses in MolStar. |
| **ADMET Prediction** | Predict Absorption, Distribution, Metabolism, Excretion, and Toxicity for compounds. Input SMILES strings or upload CSV/TXT files. View results in sortable tables with individual metric cards. |
| **Chemical Similarity Search** | Tanimoto similarity search against a database of 1M+ compounds. Two modes: Retrieval-Only (fast) and Full RAG (with LLM-generated explanations using Llama-3.1-8B). Search by SMILES with configurable top-K results. |
| **Drug Repurposing** | Find new uses for existing drugs. Quick Mode: enter a disease to find targets. Full Mode: screen drugs against a disease with scoring. Powered by DeepPurpose AI model. |
| **Molecular Dynamics** | Set up MD simulations: protein/ligand file picker, force field selection, water model, box configuration, ion concentration, equilibration parameters, and production run settings. |

### Secondary

| Feature | Description |
|---|---|
| **Chatbot** | AI-powered chemistry assistant with thread-based conversation. Analyze SMILES, compare molecules, answer chemistry questions. |
| **History** | View past operations: generation jobs, docking results, MD simulations, and ligand details with properties and scores. |
| **Awards** | Browse scientific awards (Nobel Prize, Lasker Award, etc.) and their recipients. |
| **Scientists** | Browse famous scientists, their biographies, awards, field, and nationality. |

## Tech Stack

- **Framework:** Flutter (Dart ^3.9.2)
- **State Management:** BLoC/Cubit (`flutter_bloc`) + Provider
- **Architecture:** Clean Architecture (data / domain / presentation layers)
- **Routing:** `go_router`
- **DI:** `get_it` (service locator)
- **Networking:** Dio with auth interceptor
- **Backend:** Laravel REST API + FastAPI Python microservices for AI/ML
- **3D Visualization:** Mol* (MolStar) via `flutter_inappwebview`
- **Localization:** English only for now; other languages will be added later (`flutter_localization` / `intl`)
- **Theme:** Dark theme only

## Prerequisites

- Flutter SDK ^3.9.2
- Dart SDK ^3.9.2
- .NET SDK (NuGet) — required for native desktop plugins and build tooling
- Ensure Flutter is configured for **desktop** (`flutter config --enable-windows-desktop`)

## Setup

```bash
# Clone the repository
git clone <repo-url>
cd ailixir

# Create .env file (required)
# GOOGLE_CLIENT_ID=<Google OAuth Client ID>
# GOOGLE_CLIENT_SECRET=<Google OAuth Client Secret>

# Install dependencies
flutter pub get

# Generate app icons (optional)
flutter pub run flutter_launcher_icons

# Generate localization files
flutter gen-l10n
```

## Run

```bash
flutter run
```

The app is designed for **Windows** first. Support for other platforms (macOS, Linux, Android, iOS, web) will come later.

## Build for Production

```bash
flutter build windows        # Windows
```

## Feature Flags

All features currently use mock/fake data. To connect to the real backend, set the corresponding flag to `false` in `lib/core/utils/app_feature_flag.dart`:

- `useFakeGeneration`, `useFakeDocking`, `useFakeHistory`, `useFakeAdmet`, `useFakeChemicalSearch`, `useFakeDrugRepurposing`, `useFakeChatbot`, `useFakeAwards`, `useFakeScientists`, `useFakeNews`, `useFakeProfile`

## Configuration

- **Base API:** `lib/core/services/api/app_endpoints.dart`
- **Routes:** `lib/core/services/navigation/app_router.dart`
- **DI Registrations:** `lib/core/services/di/get_it.dart`
- **Colors & Theme:** `lib/core/themes/`
- **Design Size:** 1400 × 900 (desktop-first)
