# Technology Stack

This project uses a declarative approach to system configuration, built entirely on the Nix ecosystem.

## Core Technologies

*   **Primary Language: Nix**
    *   The entire configuration is written in the Nix expression language, a purely functional language used to describe package builds and system configurations.

*   **Operating System: NixOS**
    *   The project targets the NixOS Linux distribution, which allows for reproducible and declarative system-wide configuration.

*   **Dependency Management: Nix Flakes**
    *   The project utilizes Nix Flakes to provide reproducible builds and manage all dependencies, including system packages, external Nix projects, and user applications. Flakes ensure that the exact same environment can be replicated anywhere.

## Key Components

*   **User Environment: Home Manager**
    *   User-specific configurations, applications, and dotfiles are managed declaratively using Home Manager. This allows for a consistent and reproducible user environment across different machines.

## Supporting Technologies

*   **Automation: Shell Scripting**
    *   Various shell scripts are used for automation, custom commands, and to supplement the declarative configuration where imperative logic is needed.
