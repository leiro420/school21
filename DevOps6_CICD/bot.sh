#!/bin/bash

set -e

JOBS_JSON=$(curl -s --header "Authorization: Bearer $CI_JOB_TOKEN" \
  "https://git.21-school.ru/api/v4/projects/$CI_PROJECT_ID/pipelines/$CI_PIPELINE_ID/jobs")

if command -v python3 &>/dev/null; then
    DEPLOY_STATUS=$(echo "$JOBS_JSON" | python3 -c "
import sys, json
try:
    jobs = json.load(sys.stdin)
    for job in jobs:
        if job.get('name') == 'deploy_prod':
            print(job.get('status', 'not triggered'))
            sys.exit(0)
    print('not triggered')
except Exception:
    print('error')
    sys.exit(1)
")
else
	DEPLOY_STATUS="unknown (python3 missing)"
fi

OVERALL_STATUS="success"
echo "$JOBS_JSON" | grep -o '{[^}]*"name":"[^}]*"}' | while read -r job; do
    name=$(echo "$job" | grep -o '"name":"[^"]*"' | cut -d '"' -f4)
    status=$(echo "$job" | grep -o '"status":"[^"]*"' | cut -d '"' -f4)

    if [ "$name" = "notify" ]; then
        continue
    fi

    if [ "$status" != "success" ]; then
        OVERALL_STATUS="$status"
    fi
done

if echo "$JOBS_JSON" | grep -v '"name":"notify"' | grep -q '"status":"failed"'; then
    OVERALL_STATUS="failed"
elif echo "$JOBS_JSON" | grep -v '"name":"notify"' | grep -q '"status":"running"'; then
    OVERALL_STATUS="running"
else
    OVERALL_STATUS="success"
fi

if [ "$OVERALL_STATUS" = "success" ]; then
    EMOJI="✅"
else
    EMOJI="❌"
fi

TEXT="${EMOJI} Pipeline ${OVERALL_STATUS}
Project: ${CI_PROJECT_NAME}
Branch: ${CI_COMMIT_REF_NAME}
Commit: ${CI_COMMIT_SHORT_SHA}
CI: ${OVERALL_STATUS}
CD: ${DEPLOY_STATUS}
URL: ${CI_PIPELINE_URL}"

URL="https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/sendMessage"
curl -s --max-time 10 -X POST \
    -d "chat_id=${TELEGRAM_CHAT_ID}" \
    -d "disable_web_page_preview=1" \
    --data-urlencode "text=${TEXT}" \
    "${URL}" > /dev/null
