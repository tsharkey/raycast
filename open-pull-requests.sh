#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Open Pull Requests
# @raycast.mode compact

# Optional parameters:
# @raycast.icon 🤖
# @raycast.packageName PBXX

# Documentation:
# @raycast.description Opens PBXX Pull Requests

team_members=("tsharkey" "sean-m-slattery" "josephware")
org="promoboxx"
state="open"

base_url="http://github.com/search"
search_string="is:pr+is:$state+org:$org"
for memb in "${team_members[@]}"; do
    search_string+="+author:$memb"
done

full_open_pr_url="$base_url?q=$search_string"

review_request_count=$(curl $base_url/issues\?q\=org:promoboxx+is:pr+state:open+review-requested:tsharkey -H "Authorization:Bearer $GH_ACCESS_TOKEN" | jq .total_count)
assigned_count=$(curl https://api.github.com/search/issues\?q\=org:promoboxx+assignee:tsharkey -H "Authorization:Bearer $GH_ACCESS_TOKEN" | jq .total_count)

if [ $review_request_count > 0 ]; then
    open "https://github.com/pulls/review-requested"
fi

if [ $assigned_count > 0 ]; then
    open "https://github.com/pulls/assigned"
fi

open $full_open_pr_url

