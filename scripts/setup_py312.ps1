# Setup script for Python 3.12 virtualenv and installing requirements
# Usage: Run this in PowerShell as an administrator or regular user.

# Check for Python 3.12 via the py launcher
$py = "py -3.12 --version"
try {
    & py -3.12 --version > $null 2>&1
} catch {
    Write-Host "Python 3.12 not found. Please install Python 3.12 from https://www.python.org/downloads/windows/ and re-run this script." -ForegroundColor Yellow
    exit 1
}

# Create virtualenv directory
$venvDir = ".venv312"
if (-Not (Test-Path $venvDir)) {
    Write-Host "Creating venv in $venvDir..."
    py -3.12 -m venv $venvDir
} else {
    Write-Host "Virtualenv $venvDir already exists."
}

# Activate the venv for this script
Write-Host "Activating venv..."
& $venvDir\Scripts\Activate.ps1

# Upgrade pip and install requirements
Write-Host "Upgrading pip and installing requirements..."
python -m pip install --upgrade pip
pip install -r requirements.txt

# Apply migrations
Write-Host "Applying Django migrations..."
python manage.py migrate --noinput

Write-Host "Setup complete. To run the server:"
Write-Host "  & $venvDir\Scripts\Activate.ps1"
Write-Host "  python manage.py runserver 0.0.0.0:8000"
