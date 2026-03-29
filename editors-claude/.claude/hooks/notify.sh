#!/bin/bash
TITLE="${1:-AI Agent}"
MESSAGE="${2:-タスクが完了しました}"

case "$(uname -s)" in
  Darwin)
    osascript -e "display notification \"$MESSAGE\" with title \"$TITLE\" sound name \"Glass\""
    ;;
  Linux)
    if command -v notify-send &>/dev/null; then
      notify-send "$TITLE" "$MESSAGE"
    else
      echo "[$TITLE] $MESSAGE"
    fi
    ;;
  MINGW*|MSYS*|CYGWIN*)
    powershell.exe -Command "
      [Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime] > \$null
      \$template = [Windows.UI.Notifications.ToastNotificationManager]::GetTemplateContent(0)
      \$template.GetElementsByTagName('text')[0].AppendChild(\$template.CreateTextNode('$MESSAGE'))
      [Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier('$TITLE').Show(
        [Windows.UI.Notifications.ToastNotification]::new(\$template)
      )
    " 2>/dev/null || echo "[$TITLE] $MESSAGE"
    ;;
  *)
    echo "[$TITLE] $MESSAGE"
    ;;
esac
