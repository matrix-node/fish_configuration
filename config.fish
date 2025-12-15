function fish_prompt -d "Write out the prompt"
    # This shows up as USER@HOST /home/user/ >, with the directory colored
    # $USER and $hostname are set by fish, so you can just use them
    # instead of using `whoami` and `hostname`
    printf '%s@%s %s%s%s > ' $USER $hostname \
        (set_color $fish_color_cwd) (prompt_pwd) (set_color normal)
end

if status is-interactive # Commands to run in interactive sessions can go here

    # No greeting
    set fish_greeting

    # Use starship
    starship init fish | source
    if test -f ~/.local/state/quickshell/user/generated/terminal/sequences.txt
        cat ~/.local/state/quickshell/user/generated/terminal/sequences.txt
    end

    # Aliases
    alias pamcan pacman
    alias ls 'eza --icons'
    alias clear "printf '\033[2J\033[3J\033[1;1H'"
    alias q 'qs -c ii'
    
end

# functions
function sys_update
    printf "=== Updating the system... ==="
    sleep 3

    sudo pacman -Sy
    sudo yay -Sy

    sleep 2
    printf "=== Finished Updating the System! ==="
end

function sys_upgrade
    printf "=== Ugrading the system... ==="
    sleep 3

    sudo pacman -Syu
    sudo yay -Syu

    sleep 2
    printf "=== Finished Upgrading the System! ==="
end

# Extract any archive
function extract
    if test -f $argv[1]
        switch $argv[1]
            case "*.tar.bz2"
                tar xjf $argv[1]
            case "*.tar.gz"
                tar xzf $argv[1]
            case "*.bz2"
                bunzip2 $argv[1]
            case "*.rar"
                unrar x $argv[1]
            case "*.gz"
                gunzip $argv[1]
            case "*.tar"
                tar xf $argv[1]
            case "*.zip"
                unzip $argv[1]
            case "*.Z"
                uncompress $argv[1]
            case "*.7z"
                7z x $argv[1]
            case "*"
                echo "'$argv[1]' cannot be extracted"
        end
    else
        echo "'$argv[1]' is not a valid file"
    end
end

# Quick backup
function backup
    cp $argv[1] $argv[1].backup-(date +%Y%m%d-%H%M%S)
end

# Get a random quote
function quote
    curl -s https://api.quotable.io/random | jq -r '"\(.content)\n  — \(.author)"'
end

# Show system information
function sysinfo
    echo "🖥️  System Information"
    echo "─────────────────────"
    echo "Kernel: "(uname -r)
    echo "Uptime: "(uptime -p)
    echo "Packages: "(pacman -Q | wc -l)" (pacman)"
    echo "Shell: $SHELL"
    echo "CPU: "(lscpu | grep "Model name" | sed 's/Model name: *//')
    echo "Memory: "(free -h | awk '/^Mem:/ {print $3 "/" $2}')
    echo "Disk: "(df -h / | awk 'NR==2 {print $3 "/" $2 " (" $5 ")"}')
end

# Aliases for basic commands

alias update=sys_update
alias upgrade=sys_upgrade
alias search='sudo pacman -Ss'
alias searchy='yay -Ss'
alias d=docker
alias drit='docker run -it'
alias weather='curl wttr.in/kenya'
