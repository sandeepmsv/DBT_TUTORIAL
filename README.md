# DBT Tutorial Project

A tutorial project for learning DBT (Data Build Tool) using Python 3.12 and uv package manager.

## Requirements

- **Python 3.12+** (already installed on your system)
- **uv** - Modern Python package manager (install from: https://docs.astral.sh/uv/)

## What is uv?

`uv` is a fast Python package installer and resolver written in Rust. It's a modern replacement for pip and pipenv that manages both your Python environment and project dependencies.

## How uv Manages Python Versions

This project uses two mechanisms to ensure Python 3.12 is always used:

1. **`.python-version` file** - Simple version specification that tells uv to use Python 3.12
2. **`pyproject.toml`** - Project configuration that specifies `requires-python = ">=3.12"`

### How it Works:
```
uv sync
    ↓
Reads .python-version → Uses Python 3.12
    ↓
Reads pyproject.toml → Installs dependencies
    ↓
Creates .venv/ virtual environment
```

## Setup Instructions

### Initial Setup

```powershell
# Navigate to project directory
cd "c:\Users\sande\OneDrive\Documents\DBT_TUTORIAL"

# Create virtual environment with Python 3.12
uv sync
```

### Run the Project

```powershell
# Run the main script
uv run python main.py

# Verify Python version
uv run python --version
```

## Key Commands

| Command | Purpose |
|---------|---------|
| `uv sync` | Create/update virtual environment with Python 3.12 |
| `uv run python main.py` | Run Python script in the environment |
| `uv add package-name` | Add a dependency to pyproject.toml |
| `uv add --dev pytest` | Add a dev dependency (testing, linting, etc.) |
| `uv python list` | Show available Python versions |
| `uv lock` | Generate lock file (commit to git for reproducibility) |
| `uv remove package-name` | Remove a dependency |
| `uv sync --all-extras` | Install with all optional dependencies |

## Adding Dependencies

### Add a Regular Dependency
```powershell
uv add dbt-core
```

### Add a Development Dependency
```powershell
uv add --dev pytest black isort flake8
```

### View Installed Packages
```powershell
uv pip freeze
```

## Project Structure

```
DBT_TUTORIAL/
├── .python-version      ← Specifies Python 3.12 (tells uv which version to use)
├── pyproject.toml       ← Project configuration & dependencies
├── README.md            ← This file - documentation
├── main.py              ← Main entry point for the project
├── .venv/               ← Virtual environment (auto-created by uv sync)
├── uv.lock              ← Dependency lock file (for reproducible installs)
└── .git/                ← Git repository
```

## Development Setup

### Install Development Dependencies

```powershell
uv sync --all-extras
```

This installs the development packages specified in `pyproject.toml`:
- pytest - Testing framework
- black - Code formatter
- isort - Import sorter
- flake8 - Linting

### Code Quality Tools

```powershell
# Format code with black
uv run black main.py

# Sort imports with isort
uv run isort main.py

# Lint code with flake8
uv run flake8 main.py

# Run tests with pytest
uv run pytest
```

## Python 3.12 Environment Details

The project is configured to use **Python 3.12.9**:

```
Python 3.12.9 (tags/v3.12.9:fdb8142, Feb 4 2025, 15:27:58) [MSC v.1942 64 bit (AMD64)]
Virtual environment: .venv\Scripts\python.exe
```

## Dependencies Configuration

All project dependencies are managed in `pyproject.toml`:

```toml
[project]
name = "dbt-tutorial"
requires-python = ">=3.12"  # Requires Python 3.12 or higher

[project.optional-dependencies]
dev = [
    "pytest>=7.0",
    "black>=22.0",
    "isort>=5.0",
    "flake8>=4.0",
]
```

## Common Workflows

### Create a Fresh Environment
```powershell
# Remove old environment if it exists
Remove-Item .venv -Recurse -Force

# Create new environment
uv sync
```

### Update Dependencies
```powershell
# Sync and update all dependencies
uv sync --upgrade
```

### Share with Team (Use Lock File)
```powershell
# After installing/updating packages, lock dependencies
uv lock

# Team members then run to get exact same versions
uv sync
```

## Terminal Commands Used

These are the commands used during setup, troubleshooting, and verification:

```powershell
cd "c:\Users\sande\OneDrive\Documents\DBT_TUTORIAL"
uv sync
uv run python main.py
uv run python --version
uv run dbt debug --profiles-dir "%USERPROFILE%\.dbt"
uv cache clean
Set-ExecutionPolicy -Scope CurrentUser RemoteSigned -Force
powershell -ExecutionPolicy Bypass -File .\.venv\Scripts\Activate.ps1
```

## Capture Terminal Activity

To save all terminal interaction for later review, use the project helper script.

1. Open PowerShell in the project root:
   ```powershell
   cd "c:\Users\sande\OneDrive\Documents\DBT_TUTORIAL"
   ```
2. Start logging:
   ```powershell
   .\start-terminal-log.ps1
   ```
3. Work as normal. All commands and output will be written to the generated log file.
4. When finished, stop logging:
   ```powershell
   Stop-Transcript
   ```
5. Review the log file in the project root, for example:
   ```powershell
   Get-ChildItem terminal_history_*.log
   ```

This captures everything in the session, including the exact commands you used and the dbt output.

## Detailed Technical Explanation

### 1. `uv sync`
- Reads `.python-version` and chooses Python 3.12.
- Reads `pyproject.toml` and installs dependencies in a local `.venv/`.
- Creates a reproducible virtual environment that isolates this project from the system Python.

### 2. `uv run python main.py`
- Runs `main.py` inside the `.venv` without requiring manual activation.
- Ensures the code uses the exact interpreter from `.venv\Scripts\python.exe`.

### 3. `uv run python --version`
- Verifies the project is using Python 3.12 as configured.
- Confirms the virtual environment is active for these commands.

### 4. `uv run dbt debug --profiles-dir "%USERPROFILE%\.dbt"`
- Runs dbt using the local environment and the user profile directory.
- Ensures dbt loads `profiles.yml` from `C:\Users\sande\.dbt`.
- Useful when `uv` is available but shell activation is unnecessary.

### 5. `uv cache clean`
- Clears uv's local cache if dependency resolution or installs behave incorrectly.
- Not usually required, but helpful during troubleshooting.

### 6. `Set-ExecutionPolicy -Scope CurrentUser RemoteSigned -Force`
- Allows PowerShell to run local scripts such as `.venv\Scripts\Activate.ps1`.
- Needed when Windows blocks script execution for security reasons.

### 7. `powershell -ExecutionPolicy Bypass -File .\.venv\Scripts\Activate.ps1`
- Runs the venv activation script once without changing the global policy.
- Useful when you want to avoid permanently changing PowerShell execution policy.

### Why the Databricks auth fix was required
- Your dbt profile originally used `token:`, which Databricks rejects for this connection type.
- For Databricks SQL warehouse connections, dbt expects:
  - `personal_access_token:`
  - `auth_type: oauth`
- The final working profile section is:

```yaml
sandeep_dbt_tutorial:
  target: dev
  outputs:
    dev:
      type: databricks
      host: dbc-db9c4f4b-27ab.cloud.databricks.com
      http_path: /sql/1.0/warehouses/ce8541004af1742c
      catalog: dbt_tutorial_dev
      schema: default
      threads: 1
      auth_type: oauth
      personal_access_token: <your_databricks_pat>
```

### Why the `profiles.yml` path matters
- dbt looks for `profiles.yml` in `%USERPROFILE%\.dbt` by default.
- Your project `dbt_project.yml` references `profile: 'sandeep_dbt_tutorial'`.
- That profile name must match the key inside `profiles.yml`.

### Why `uv run` is usually better than manual activation
- `uv run` automatically uses the `.venv` interpreter.
- It avoids PowerShell activation issues and execution policy problems.
- This is why `uv run dbt debug --profiles-dir "%USERPROFILE%\.dbt"` worked even when manual activation was blocked.

### Important security note
- Treat the Databricks PAT like a password.
- Do not share it publicly.
- If it is exposed, revoke it in Databricks and generate a new one.

### Databricks PAT generation steps
1. Open Databricks in your browser.
2. Click your user icon in the top-right corner.
3. Choose **User Settings** or **Account Settings**.
4. Open the **Access Tokens** tab.
5. Generate a new token and copy it immediately.
6. Use that token in `profiles.yml` as `personal_access_token:`.

### Exact `profiles.yml` field update path
- File: `C:\Users\sande\.dbt\profiles.yml`
- Replace `token:` with `personal_access_token:`
- Add `auth_type: oauth` under the Databricks output configuration

## Troubleshooting

### Python 3.12 Not Found
```powershell
# Check available Python versions
uv python list

# Manually specify Python if needed
uv sync --python 3.12
```

### Virtual Environment Issues
```powershell
# Delete and recreate environment
Remove-Item .venv -Recurse -Force
uv sync
```

### dbt Database Connection Error
If dbt fails with a credential error like:

> Credential was not sent or was of an unsupported type for this API.

then your database profile is not sending the correct auth method.

Check these items:
- `profiles.yml` is in your user `%USERPROFILE%\.dbt\profiles.yml` or use `--profiles-dir`
- The profile `name` matches `profile:` in `sandeep_dbt_tutorial/dbt_project.yml`
- The adapter `type:` matches your target database
- You are using the correct credential fields for that adapter
  - e.g. Databricks needs `personal_access_token` and `host`/`http_path`
  - e.g. Snowflake often uses `user`, `password`, `account`, `role`
- Environment variables are set before running dbt in PowerShell:
```powershell
$env:DBT_USER = "your_user"
$env:DBT_PASSWORD = "your_password"
```
- Run dbt debug to verify the connection:
```powershell
uv run dbt debug
```

If the database requires token auth, do not use a password field unless the adapter expects it.

### Databricks Specific Fix
If your profile uses `type: databricks` and the connection fails with:

> Credential was not sent or was of an unsupported type for this API.

then your token field or token type is likely wrong. For Databricks SQL warehouses, use a valid personal access token and this format:

```yaml
sandeep_dbt_tutorial:
  target: dev
  outputs:
    dev:
      type: databricks
      host: dbc-db9c4f4b-27ab.cloud.databricks.com
      http_path: /sql/1.0/warehouses/ce8541004af1742c
      catalog: dbt_tutorial_dev
      schema: default
      threads: 1
      personal_access_token: <your_databricks_pat>
```

If your profile currently uses `token:`, replace it with `personal_access_token:` and use a new Databricks PAT from your Databricks user settings.

#### How to get a Databricks personal access token
1. Log into your Databricks workspace.
2. Click your user icon in the top-right corner.
3. Choose **User Settings** or **Account Settings**.
4. Find the **Access Tokens** tab.
5. Create a new token, copy it immediately, and paste it into `profiles.yml`.

> Important: copy the token once. Databricks only shows it one time.

If you do not have permission to create a PAT, ask your Databricks administrator or data team to create one for you.

### Clear uv Cache
```powershell
uv cache clean
```

### PowerShell Activation Policy Blocked
If PowerShell blocks activation with `activate.ps1`, run:
```powershell
Set-ExecutionPolicy -Scope CurrentUser RemoteSigned -Force
```
Then activate again:
```powershell
cd "c:\Users\sande\OneDrive\Documents\DBT_TUTORIAL"
.\.venv\Scripts\Activate.ps1
```

If you do not want to change the policy permanently for the current user, use a temporary bypass:
```powershell
powershell -ExecutionPolicy Bypass -File .\.venv\Scripts\Activate.ps1
```

## Learning Resources

- [uv Documentation](https://docs.astral.sh/uv/)
- [DBT Documentation](https://docs.getdbt.com/)
- [Python 3.12 Features](https://docs.python.org/3.12/)

## Notes

- Always use `uv sync` before working with the project to ensure dependencies are installed
- The `.venv` directory should be committed to `.gitignore` (it's environment-specific)
- The `uv.lock` file should be committed to version control for reproducible builds
- Use `uv run` instead of activating the virtual environment manually
