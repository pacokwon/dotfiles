{ pkgs, ... }: {
  environment.systemPackages = [
    pkgs.spaceship-prompt
  ];

  programs.zsh = {
    enable = true;

    # interactiveShellInit = ''
    #   autoload -Uz add-zsh-hook
    #
    #   # Background fetch function
    #   async_git_fetch() {
    #     if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    #       if [[ ! -f .git/FETCH_HEAD || $(find .git/FETCH_HEAD -mmin +5) ]]; then
    #         git fetch --quiet >/dev/null 2>&1 &!
    #       fi
    #     fi
    #   }
    #
    #   # Run this function every time the prompt is rendered
    #   add-zsh-hook precmd async_git_fetch
    # '';

    # promptInit = ''
    #   # 1. Define the Order (Format)
    #   # This replicates: $directory$git_branch$git_status \n $character
    #   SPACESHIP_PROMPT_ORDER=(
    #     dir           # $directory
    #     git_branch    # $git_branch
    #     git_status    # $git_status
    #     line_sep      # The newline before character
    #     char          # $character
    #   )
    #
    #   # 2. Character Settings (The "Pure" ❯)
    #   SPACESHIP_CHAR_SYMBOL="❯"
    #   SPACESHIP_CHAR_SUFFIX=" "
    #   SPACESHIP_CHAR_COLOR_SUCCESS="cyan"
    #   SPACESHIP_CHAR_COLOR_FAILURE="red"
    #
    #   # 3. Directory Settings
    #   SPACESHIP_DIR_STYLE="bold blue"
    #   SPACESHIP_DIR_TRUNC=0 # Show full path
    #
    #   # 4. Git Branch Settings
    #   SPACESHIP_GIT_BRANCH_SYMBOL="" # No icon
    #   SPACESHIP_GIT_BRANCH_COLOR="#4EF279"
    #   SPACESHIP_GIT_BRANCH_PREFIX="" # Remove default "on "
    #   SPACESHIP_GIT_BRANCH_SUFFIX=" "
    #
    #   # 5. Git Status Settings
    #   SPACESHIP_GIT_STATUS_COLOR="yellow"
    #   SPACESHIP_GIT_STATUS_PREFIX="("
    #   SPACESHIP_GIT_STATUS_SUFFIX=")"
    #   SPACESHIP_GIT_STATUS_STASHED="≡"
    #   SPACESHIP_GIT_STATUS_AHEAD="↑"
    #   SPACESHIP_GIT_STATUS_BEHIND="↓"
    #   SPACESHIP_GIT_STATUS_STAGED="+"
    #   SPACESHIP_GIT_STATUS_MODIFIED="*"
    #
    #   # 6. Disable unwanted modules
    #   SPACESHIP_PYTHON_SHOW=false
    #   SPACESHIP_PACKAGE_SHOW=false
    #   SPACESHIP_NODE_SHOW=false
    #
    #   # Load the prompt engine
    #   source ${pkgs.spaceship-prompt}/lib/spaceship-prompt/spaceship.zsh
    # '';
  };
}
