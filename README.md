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
