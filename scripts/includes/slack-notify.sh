SLACK_PATH=`PASSWORD_STORE_DIR=~/.registers-pass pass services/slack/rda-team-incoming-webhook`

function notify_slack()
{
  echo ""
  echo "Slack: $1"
  curl -X POST -H 'Content-type: application/json' --data "{'text':'$1'}" "https://hooks.slack.com/services/$SLACK_PATH"
}
