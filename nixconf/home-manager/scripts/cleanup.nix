{pkgs, ...}: {
  home.packages = with pkgs; [
    (pkgs.writeShellScriptBin "nixconf-cleanup" ''
      #!/bin/bash

      # Colors
      RED='\033[0;31m'
      GREEN='\033[0;32m'
      YELLOW='\033[1;33m'
      BLUE='\033[0;34m'
      NC='\033[0m' # No Color

      echo -e "''${YELLOW}Starting System Cleanup...''${NC}"

      # Helper function to cleanup a directory
      cleanup_dir() {
        name=$1
        path=$2

        if [ -d "$path" ]; then
          # Get size - handled safely if directory is empty or permission denied
          size=$(du -sh "$path" 2>/dev/null | cut -f1)
          if [ -z "$size" ]; then size="0B"; fi

          echo -ne "Cleaning $name cache... found ''${RED}$size''${NC}"

          # Remove contents but keep directory
          find "$path" -mindepth 1 -delete 2>/dev/null

          echo -e " ''${GREEN}✓''${NC}"
        fi
      }

      # Browsers
      cleanup_dir "Brave Browser" "$HOME/.cache/BraveSoftware/Brave-Browser/Default/Cache"
      cleanup_dir "Brave Code" "$HOME/.cache/BraveSoftware/Brave-Browser/Default/Code Cache"
      cleanup_dir "Brave Service Worker" "$HOME/.cache/BraveSoftware/Brave-Browser/Default/Service Worker/CacheStorage"

      # Communication
      cleanup_dir "Slack" "$HOME/.config/Slack/Cache"
      cleanup_dir "Slack Service Worker" "$HOME/.config/Slack/Service Worker/CacheStorage"
      cleanup_dir "Telegram" "$HOME/.local/share/TelegramDesktop/tdata/user_data/cache"
      cleanup_dir "Telegram Media" "$HOME/.local/share/TelegramDesktop/tdata/user_data/media_cache"

      # Vesktop (Discord)
      cleanup_dir "Vesktop" "$HOME/.config/vesktop/sessionData/Cache"
      cleanup_dir "Vesktop Code" "$HOME/.config/vesktop/sessionData/Code Cache"
      cleanup_dir "Vesktop GPU" "$HOME/.config/vesktop/sessionData/GPUCache"

      # Development
      echo -e "\n''${YELLOW}Cleaning Development Tools...''${NC}"

      if command -v npm &> /dev/null; then
        echo -ne "Running npm cache clean..."
        npm cache clean --force &> /dev/null
        echo -e " ''${GREEN}✓''${NC}"
      fi

      if command -v pip &> /dev/null; then
        echo -ne "Running pip cache purge..."
        pip cache purge &> /dev/null
        echo -e " ''${GREEN}✓''${NC}"
      elif command -v pip3 &> /dev/null; then
        echo -ne "Running pip3 cache purge..."
        pip3 cache purge &> /dev/null
        echo -e " ''${GREEN}✓''${NC}"
      fi

      if command -v go &> /dev/null; then
        echo -ne "Running go clean..."
        go clean -cache -modcache &> /dev/null
        echo -e " ''${GREEN}✓''${NC}"
      fi

      if command -v bun &> /dev/null; then
        echo -ne "Running bun cache rm..."
        bun pm cache rm &> /dev/null
        echo -e " ''${GREEN}✓''${NC}"
      fi

      # System
      cleanup_dir "Thumbnails" "$HOME/.cache/thumbnails"
      cleanup_dir "Trash" "$HOME/.local/share/Trash"

      # Media
      cleanup_dir "YouTube Music" "$HOME/.config/YouTube Music/Cache"
      cleanup_dir "YouTube Music Code" "$HOME/.config/YouTube Music/Code Cache"

      # Docker Cleanup
      if command -v docker &> /dev/null; then
        if docker info &> /dev/null; then
          echo -e "\n''${BLUE}Cleaning Docker unused images...''${NC}"
          docker image prune -f
          echo -e "''${GREEN}✓ Docker images pruned''${NC}"
        else
          echo -e "\n''${RED}Skipping Docker: Daemon not running''${NC}"
        fi
      fi

      # Home Manager Cleanup
      if command -v home-manager &> /dev/null; then
        echo -e "\n''${BLUE}Expiring Home Manager generations (older than 7 days)...''${NC}"
        home-manager expire-generations "-7 days"
        echo -e "''${GREEN}✓ Home Manager generations expired''${NC}"
      fi

      # Nix Cleanup
      if command -v nix-collect-garbage &> /dev/null; then
        echo -e "\n''${BLUE}Collecting Nix garbage (older than 7 days)...''${NC}"
        nix-collect-garbage --delete-older-than 7d
        echo -e "''${GREEN}✓ Nix garbage collected''${NC}"
      fi

      if command -v nix-store &> /dev/null; then
        echo -e "\n''${BLUE}Optimizing Nix store (deduplicating files)...''${NC}"
        nix-store --optimise
        echo -e "''${GREEN}✓ Nix store optimized''${NC}"
      fi

      echo -e "\n''${GREEN}Cleanup Complete!''${NC}"
    '')
  ];
}
