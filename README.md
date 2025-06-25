- **macos_setup.sh**  
  Automates macOS workstation provisioning. Reads credentials and device data from JSON, configures hostnames and network interfaces, installs development tools and applications (Homebrew, Unity Hub, Docker, AppCrypt, Dozer, Keeper Password Manager, Xcode, etc.), customizes the Dock, disables Bluetooth, executes additional AppleScripts, and cleans up system artifacts. Enables rapid, repeatable environment setup for development or deployment.

- **router_port_mapping.scpt**  
  Automates router port forwarding setup via Safari using AppleScript and JavaScript injection. Reads modem password and local IP from a JSON file, logs into the router’s web UI, navigates to port mapping, enables the required options, and auto-fills form fields for VNC or other remote access, removing the need for manual browser configuration.
