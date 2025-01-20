# StellarGIM

StellarGIM (Stellar Graphical Interface Manager) is a hobby graphical shell that runs on top of MS-DOS. It aims to provide a graphical user interface for DOS-based systems.

## About
StellarGIM is a lightweight graphical shell designed to enhance the MS-DOS experience by providing a user-friendly interface while maintaining compatibility with DOS applications and commands.

## Architecture
StellarGIM uses a modular architecture inspired by early windowing systems, consisting of three main components:

- **Kernel**: Handles base services including process management, memory management, and cooperative multitasking
- **GDI (Graphical Device Interface)**: Provides device-independent graphics rendering
- **User**: Implements the user interface layer and window management

## Development Status
This project is currently under development, very early development. some components will be first made on C, and later converting the C code to assembly to meet the memory limitations of early IBM PCs.

## License
StellarGIM is released under the GNU General Public License, version 2 or later. For more information, see the COPYING file in the root of the repository.