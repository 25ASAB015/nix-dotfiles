# Documentation: docs/programs/webapps.md
# OpenSpec: openspec/changes/add-webapps/specs/programs/webapps/spec.md
# Module for declaratively managing Web Apps (SSB/PWA)
{
  config,
  lib,
  pkgs,
  ...
}: let
  # Define the launch script package
  omarchyLaunchWebapp = pkgs.writeShellScriptBin "omarchy-launch-webapp" ''
    #!/bin/bash
    # Launch the passed in URL as a web app in the default browser (or chromium if the default doesn't support --app).

    browser=$(xdg-settings get default-web-browser)

    case $browser in
    google-chrome* | brave-browser* | microsoft-edge* | opera* | vivaldi* | helium*) ;;
    *) browser="google-chrome.desktop" ;;
    esac

    # Ensure google-chrome-stable is used if browser is google-chrome.desktop
    if [[ "$browser" == "google-chrome.desktop" ]]; then
       LAUNCHER="google-chrome-stable"
    else
       # Attempt to extract executable from desktop file (simplified)
       # This part is tricky without reliable parsing, so we'll rely on common names or the PATH
       # If the browser variable holds a .desktop file, we might just try to launch "google-chrome-stable" as fallback
       LAUNCHER="google-chrome-stable"
    fi
     
    # Launch with --app
    exec setsid $LAUNCHER --app="$1" "''${@:2}"
  '';

  # Path to icons in the store
  iconPath = "${config.home.homeDirectory}/.local/share/applications/icons";

  # Helper to create a desktop entry
  mkWebApp = name: url: iconName: {
    name = name;
    exec = "${omarchyLaunchWebapp}/bin/omarchy-launch-webapp ${url}";
    icon = "${iconPath}/${iconName}";
    terminal = false;
    type = "Application";
    startupNotify = true;
    categories = [ "Network" "WebBrowser" ];
  };
  
in {
  home.packages = [
    omarchyLaunchWebapp
    pkgs.xdg-utils 
    pkgs.google-chrome # Dependency for the fallback
  ];

  # Install icons
  home.file = {
    ".local/share/applications/icons" = {
      source = ./icons;
      recursive = true;
    };
  };

  # Define Desktop Entries
  xdg.desktopEntries = {
    "canva-ai" = mkWebApp "Canva ai" "https://www.canva.com/" "Canva ai.png";
    "claro-video" = mkWebApp "Claro Video" "https://www.clarovideo.com/" "Claro Video.png";
    "claude-ai" = mkWebApp "Claude AI" "https://claude.ai/new" "Claude AI.png";
    "deepseek-ai" = mkWebApp "Deepseek ai" "https://chat.deepseek.com/" "Deepseek ai.png";
    "disney-plus" = mkWebApp "Disney" "https://www.disneyplus.com/" "Disney.png";
    "excalidraw" = mkWebApp "ExcaliDraw" "https://excalidraw.com/" "ExcaliDraw.png";
    "frontend-masters" = mkWebApp "Fronted Masters" "https://frontendmasters.com/dashboard/" "Fronted Masters.png";
    "gemini-ai" = mkWebApp "Gemini AI" "https://gemini.google.com/app" "Gemini AI.png";
    "gitkraken-dev" = mkWebApp "Gitkraken dev" "https://app.gitkraken.com/" "Gitkraken dev.png";
    "gorails" = mkWebApp "Go Rails" "https://gorails.com/" "Go Rails.png";
    "grok-ai" = mkWebApp "Grok AI" "https://grok.x.ai/" "Grok AI.png";
    "hbo-max" = mkWebApp "HBO" "https://play.max.com/" "HBO.png";
    "kimi-ai" = mkWebApp "Kimi ai" "https://kimi.moonshot.cn/" "Kimi ai.png";
    "m365-copilot" = mkWebApp "M365 Copilot ai" "https://m365.cloud.microsoft/chat" "M365 Copilot ai.png";
    "manus-ai" = mkWebApp "Manus ai" "https://manus.im/" "Manus ai.png";
    "mistral-ai" = mkWebApp "Mistral ai" "https://chat.mistral.ai/chat" "Mistral ai.png";
    "netflix" = mkWebApp "Netflix" "https://www.netflix.com/" "Netflix.png";
    "notebooklm" = mkWebApp "NotebookLM" "https://notebooklm.google.com/" "NotebookLM.png";
    "notion" = mkWebApp "Notion" "https://www.notion.so/" "Notion .png";
    "perplexity-ai" = mkWebApp "Perplexity ai" "https://www.perplexity.ai/" "Perplexity ai.png";
    "platzi" = mkWebApp "Platzi" "https://platzi.com/home/" "Platzi.png";
    "qwen-ai" = mkWebApp "Qwen ai" "https://chat.qwen.ai/" "Qwen ai.png";
    "ticktick" = mkWebApp "TickTick" "https://ticktick.com/" "TickTick.png";
    "vix" = mkWebApp "Vix" "https://vix.com/es-es" "Vix.png";
    "x-bookmarks" = mkWebApp "X bookmarks" "https://x.com/i/bookmarks" "X.png";
    "x-grok" = mkWebApp "X Grok" "https://x.com/i/grok" "X.png";
    "youtube" = (mkWebApp "YouTube" "https://youtube.com/" "YouTube.png") // {
      exec = "helium --app=https://youtube.com/";
    };
    "z-ai" = mkWebApp "Z ai" "https://chat.z.ai/" "Z ai.png";
  };
}
