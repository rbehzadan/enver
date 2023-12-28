# enver

`enver` (short for "env evaluate and run") is a specialized command-line tool
designed to facilitate the process of loading environment variables,
specifically passwords and API keys, using `pass` or `gopass`. It streamlines
the execution of applications that require secure access to sensitive
information, by loading these credentials from a `.env` file where the values
can be dynamically set through evaluated shell commands.

## Key Features

- **Secure Credential Management**: Safely load passwords and API keys using `pass` or `gopass`.
- **Dynamic Configuration**: Evaluate environment variable values with shell commands, enabling dynamic credential retrieval.
- **Cross-platform Builds**: Compatible with multiple platforms including Linux, Windows, and ARM architectures.
- **Simplicity and Flexibility**: Easy to use, enhancing the flexibility of environment configuration for secure applications.

## Getting Started

### Prerequisites

- Go (1.x or later)
- `pass` or `gopass` installed for managing passwords and API keys
- Bash (for command evaluation)

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/rbehzadan/enver.git
   cd enver
   ```
2. Build the binary:
   ```bash
   make build
   ```

### Usage

To use enver with `pass` or `gopass`, ensure your `.env` file contains the
necessary commands:

```bash
API_KEY=`pass apikey/service`
DB_PASSWORD=`gopass db/prod/password`
```

Run enver with the specified `.env` file and your application:

```bash
./enver -f path/to/your/.env your_application
```

enver will replace the environment variable values with the output from `pass`
or `gopass` commands and execute your application with these variables.


## Building for Specific Platforms

For different platforms, use the corresponding make command, for example:

```bash
make arm64  # For ARM64 architecture
```

## Contributing

Contributions to enver are welcome! Please open issues for any bugs, requests,
or suggestions. For code contributions, kindly submit a pull request.

## License

enver is released under the [MIT License](LICENSE).

## Acknowledgements

- enver was created to enhance the security and efficiency of applications requiring access to sensitive data like passwords and API keys, particularly in varied development and production environments.
