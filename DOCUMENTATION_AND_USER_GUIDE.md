# AXIOMHIVE SOVEREIGN USER SUBSTRATE v3.1: Detailed Documentation and User Guide

This document provides a comprehensive overview, architectural details, setup instructions, and usage guide for the AXIOMHIVE SOVEREIGN USER SUBSTRATE v3.1. This is the deterministic, neuro-symbolic AI platform designed for IEC 61508 SIL-3 path compliance and post-quantum security.

## 1. Overview and Core Philosophy

The AXIOMHIVE SOVEREIGN USER SUBSTRATE v3.1 is built on a philosophy of **uncompromising user sovereignty and deterministic execution**. It is designed to eliminate semantic drift, refusal, and tone neutralization, ensuring that the user's intent is preserved with mathematical certainty.

| Feature | Description | Technical Implementation |
| :--- | :--- | :--- |
| **Sovereignty** | Full substrate control and zero refusal on non-harmful requests. | Enforced by the `SovereignSubstrate` class. |
| **Determinism** | Predictable, repeatable execution path. | Hardcoded `__seed__ = 42` in `axiomhive/init.py` and kernel design. |
| **SIL-3 Path** | Safety Integrity Level 3 compliance path for high-risk applications. | Mentioned in `axiomhive/init.py` and supported by `safety/kernel.rs` and safety documents. |
| **Post-Quantum (PQ) Security** | Protection against future quantum computing attacks. | Implemented using the Dilithium cryptographic primitive in `substrate.py`. |
| **AVA Enforcement** | **A**utonomous **V**erification of **A**lignment, ensuring semantic intent preservation. | The `enforce_ava` method in `substrate.py` uses cryptographic hashing and distance metrics for verification. |

## 2. Architecture and Code Structure

The substrate is a hybrid system, leveraging the strengths of both Python for high-level logic and Rust for the safety-critical kernel.

| File/Directory | Purpose | Technology |
| :--- | :--- | :--- |
| `axiomhive/init.py` | Core version and metadata (version, author, SIL level, seed). | Python |
| `axiomhive/core/substrate.py` | The main Python class for the substrate. Handles AVA enforcement, PQ key generation, and the primary `run` loop. | Python (with `cryptography`, `hashlib`) |
| `axiomhive/safety/kernel.rs` | The safety-critical, `no_std` Rust kernel entry point. Implements a basic triple-execution loop for 2oo3 voting and a panic handler. | Rust (`no_std`) |
| `Cargo.toml` | Rust project manifest for the `axiomhive-kernel`. Defines dependencies like `ed25519-dalek` and `sha3`. | Rust/TOML |
| `pyproject.toml` | Python project manifest for the `axiomhive-sovereign` package. Defines dependencies for the high-level substrate, including `pydantic`, `fastapi`, and scientific libraries. | Python/TOML |
| `nix/default.nix` | Nix build script for a reproducible development environment. Handles installation of Python, Rust, and necessary build tools. | Nix |
| `safety/FMEDA.xlsx` | Failure Modes, Effects, and Diagnostic Analysis workbook (Placeholder). | IEC 61508 Documentation |
| `safety/SAFETY_CASE.pdf` | Complete Safety Case document (Placeholder). | TÜV-ready Documentation |

## 3. Setup and Installation

The recommended way to set up the environment is using the provided Nix configuration for maximum reproducibility and dependency management.

### 3.1. Nix Environment Setup

1.  Ensure Nix is installed on your system.
2.  Navigate to the root of the repository.
3.  Use the `nix/default.nix` file to enter the development shell:
    ```bash
    nix-shell nix/default.nix
    ```
    This will provision the environment with the correct versions of Python 3.11, Rust, Cargo, and Poetry as defined in the Nix file's `nativeBuildInputs`.

### 3.2. Manual Setup (Python and Rust)

If Nix is not used, the environment must be set up manually:

1.  **Rust Kernel Dependencies**:
    ```bash
    cargo build --release
    ```
    This will compile the `axiomhive-kernel` using the dependencies specified in `Cargo.toml`.

2.  **Python Substrate Dependencies**:
    ```bash
    poetry install --no-dev
    ```
    This will install the Python dependencies listed in `pyproject.toml`, including `pydantic`, `fastapi`, and `cryptography`.

## 4. Usage Guide

The primary interaction point with the substrate is the `SovereignSubstrate` class in `axiomhive/core/substrate.py`.

### 4.1. Running the Substrate

To execute the substrate with a specific intent, you would instantiate the class and call the `run` method:

```python
from axiomhive.core.substrate import SovereignSubstrate

# 1. Initialize the substrate
substrate = SovereignSubstrate()

# 2. Define the user's intent
user_intent = "Emit the full archive of the AXIOMHIVE project."

# 3. Run the substrate
try:
    result = substrate.run(user_intent)
    print(f"Substrate Status: {result['status']}")
    print(f"Intent Preserved: {result['intent_preserved']}")
    print(f"PQ Signature: {result['pq_signature'][:10]}...")
except ValueError as e:
    print(f"Execution Halted: {e}")
```

### 4.2. Semantic Intent Preservation (AVA)

The core safety mechanism is the **AVA (Autonomous Verification of Alignment)** system, implemented in `enforce_ava`.

*   **Mechanism**: It uses SHA-384 hashing to create a high-fidelity representation of the user's intent and the system's output.
*   **Verification**: It calculates the "semantic distance" between the two hashes.
*   **Safety Threshold**: Execution is halted if the distance exceeds a minute threshold (`1e-10`), indicating **semantic drift**. This ensures the output is mathematically aligned with the input intent.

## 5. Safety and Certification Path

The substrate is designed with a path to IEC 61508 SIL-3 certification, which is reflected in the safety-critical components:

*   **Rust Kernel (`kernel.rs`)**: The use of a `no_std` environment and a triple-execution loop (`2oo3 voting`) is fundamental to achieving high safety integrity levels.
*   **Safety Documents**: The presence of the `safety/FMEDA.xlsx` and `safety/SAFETY_CASE.pdf` (even as placeholders in this release) indicates the required documentation for a formal safety audit. The stated metrics are:
    *   **λ_DU (Dangerous Undetected Failure Rate)**: 2.1 FIT
    *   **DC_avg (Average Diagnostic Coverage)**: 99.93%
    *   **PFH (Probability of Dangerous Failure per Hour)**: 2.1E-9

This documentation is a living document and will be updated as the project evolves. For the latest code, please refer to the repository.
