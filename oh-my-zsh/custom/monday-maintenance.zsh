# Monday Maintenance — weekly reboot + brew upgrade reminder
# Auto-sourced by Oh My Zsh from $ZSH_CUSTOM

[[ -o interactive ]] || return 0
[[ -t 0 && -t 1 ]] || return 0

typeset -g _MONDAY_MAINTENANCE_STATE_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/monday-maintenance"
typeset -g _MONDAY_MAINTENANCE_STATE_FILE="${_MONDAY_MAINTENANCE_STATE_DIR}/state"

_monday_maintenance_week_id() {
  local dow
  dow=$(date +%u)
  if (( dow == 1 )); then
    date +%Y-%m-%d
  else
    date -v-$((dow - 1))d +%Y-%m-%d
  fi
}

_monday_maintenance_load() {
  # Sets: week_id, reboot_done, brew_done (via namerefs-style globals for callers)
  local week_saved=""
  reboot_done=0
  brew_done=0
  week_id=$(_monday_maintenance_week_id)

  if [[ ! -f "$_MONDAY_MAINTENANCE_STATE_FILE" ]]; then
    return 0
  fi

  local key val
  while IFS='=' read -r key val; do
    case "$key" in
      week) week_saved=$val ;;
      reboot) reboot_done=$val ;;
      brew) brew_done=$val ;;
    esac
  done < "$_MONDAY_MAINTENANCE_STATE_FILE"

  if [[ "$week_saved" != "$week_id" ]]; then
    reboot_done=0
    brew_done=0
  fi
}

_monday_maintenance_save() {
  local week_id=$1 reboot_done=$2 brew_done=$3
  mkdir -p "$_MONDAY_MAINTENANCE_STATE_DIR"
  cat > "$_MONDAY_MAINTENANCE_STATE_FILE" <<EOF
week=${week_id}
reboot=${reboot_done}
brew=${brew_done}
EOF
}

_monday_maintenance_confirm() {
  local prompt=$1 reply
  echo -n "${prompt} [y/N] "
  read -r reply
  [[ "$reply" == [yY] ]]
}

_monday_maintenance_run() {
  local week_id reboot_done brew_done
  _monday_maintenance_load

  if (( reboot_done && brew_done )); then
    return 0
  fi

  echo
  print -P "%B%F{cyan}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━%f%b"
  print -P "%B%F{cyan}  Monday Maintenance%f%b"
  print -P "%B%F{cyan}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━%f%b"
  echo
  echo "  Weekly upkeep still outstanding:"
  echo

  if (( reboot_done )); then
    print -P "  %F{green}✓%f Reboot laptop"
  else
    print -P "  %F{yellow}□%f Reboot laptop"
    print -P "    %F{244}→ sudo shutdown -r now%f"
  fi
  echo

  if (( brew_done )); then
    print -P "  %F{green}✓%f Brew upgrade"
  else
    print -P "  %F{yellow}□%f Brew upgrade"
    print -P "    %F{244}→ brew upgrade%f"
  fi
  echo

  if (( !reboot_done )); then
    if _monday_maintenance_confirm "  Reboot completed?"; then
      reboot_done=1
    fi
  fi

  if (( !brew_done )); then
    if _monday_maintenance_confirm "  Brew upgrade completed?"; then
      brew_done=1
    fi
  fi

  _monday_maintenance_save "$week_id" "$reboot_done" "$brew_done"

  echo
  if (( reboot_done && brew_done )); then
    print -P "  %F{green}All clear. See you next Monday.%f"
  else
    print -P "  %F{yellow}Still outstanding — I'll ask again next session.%f"
  fi
  echo
}

_monday_maintenance_run

unfunction _monday_maintenance_week_id _monday_maintenance_load \
  _monday_maintenance_save _monday_maintenance_confirm _monday_maintenance_run
unset _MONDAY_MAINTENANCE_STATE_DIR _MONDAY_MAINTENANCE_STATE_FILE
