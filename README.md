# StellarGIM

StellarGIM (Stellar Graphical Interface Manager) is a hobby graphical shell that runs on top of MS-DOS. It aims to provide a graphical user interface for DOS-based systems.

## About
StellarGIM is a lightweight graphical shell designed to enhance the MS-DOS experience by providing a user-friendly interface while maintaining compatibility with DOS applications and commands.

## Architecture
StellarGIM uses a modular architecture inspired by early windowing systems, consisting of three main components:

- **Kernel**: Handles base services including process management, memory management, and cooperative multitasking
- **GDI (Graphical Device Interface)**: Provides device-independent graphics rendering
- **User**: Implements the user interface layer and window management

## **Target Requirements**

### **Hardware Requirements**
- **IBM XT or AT**: Compatibility with IBM's early personal computers.
- **512 KB of Memory**: Minimum required RAM.
- **Floppy Disk Drive**: Configured as `DRIVE A:`.
- **Hard Disk Drive**: Configured as `DRIVE C:`.
- **Color Graphics Card**: Support for color graphics (e.g., CGA or compatible).
- **External Console**: Connected to `COM1:` for debugging purposes.
- **Microsoft Mouse**: Requires a bus or serial interface mouse.
- **Timer**: Support for a system clock or additional timing hardware.

### **Software Requirements**
- **MS-DOS**: Version **2.x** or **3.0**.

## Development Status
This project is currently under development, very early development. some components will be first made on C, for later the C code will be converted to assembly to meet the memory limitations of early IBM PCs.

## License
StellarGIM is released under the GNU General Public License, version 2 or later. For more information, see the COPYING file in the root of the repository.