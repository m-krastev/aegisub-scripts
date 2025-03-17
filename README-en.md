# Aegisub Script Collection

*Read this in: [Български](README.md)*

## Script Descriptions

### Quality Control (QC) Script

The QC script provides several automated subtitle quality control features:

- **Automatic Timing Adjustments**:
  - Enforces minimum and maximum subtitle duration based on text length
  - Maintains a configurable minimum gap between consecutive subtitles
  - Adjusts timing to avoid overlaps and ensure readability

- **Dialogue Management**:
  - Joins two selected dialogue lines into a single subtitle
  - Preserves styling and maintains proper timing when combining lines

- **Line Breaking**:
  - Automatically adds line breaks for subtitles exceeding a certain character length
  - Intelligently determines optimal breaking points based on sentence structure
  - Ensures better readability by balancing line lengths

These tools help maintain consistent subtitle quality and conform to professional subtitling standards.

## Autoloading the Scripts

To have your scripts automatically loaded when Aegisub starts up, you need to place them in specific directories depending on your operating system.

### Windows

```
%APPDATA%\Aegisub\automation\autoload\
```

Typically this is:

```
C:\Users\<your-username>\AppData\Roaming\Aegisub\automation\autoload\
```

### macOS

```
~/Library/Application Support/Aegisub/automation/autoload/
```

### Linux

```
~/.aegisub/automation/autoload/
```

## How to Install Scripts

1. Download the script files (`.lua` files)
2. Copy them to the appropriate autoload directory for your OS
3. Restart Aegisub if it's already running
4. The scripts should now appear in the Automation menu

### Automated Installation

For easier installation, use our installation scripts located in the `install_scripts` folder:

- **Windows**: Run `install_scripts/install_scripts_windows.bat` by double-clicking it
- **macOS/Linux**: Run `install_scripts/install_scripts_unix.sh` using Terminal:

  ```
  chmod +x install_scripts/install_scripts_unix.sh
  ./install_scripts/install_scripts_unix.sh
  ```

## Manual Loading

If you don't want to place scripts in the autoload directory, you can also load them manually:

1. In Aegisub, go to Automation > Automation...
2. Click "Add" and browse to the script file
3. Select the script and click "Open"

## Troubleshooting

- Make sure the script has a `.lua` extension
- Check that the script is properly formatted for Aegisub automation
- If a script doesn't appear in the menu, check the console (Help > Show log) for errors

For more information, visit the [Aegisub documentation](http://docs.aegisub.org/3.2/Automation/).
