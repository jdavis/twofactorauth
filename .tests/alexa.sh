#!/bin/bash

# Check Alexa rank
check_rank () {
	url="$(git --no-pager diff origin/master..HEAD ../_data| grep ^+[[:space:]] | grep url | cut -c11-)"
	if [ -z "$url" ]; then
		alexa_rank="$(ruby alexa.rb ${url})"
		if [ "$alexa_rank" -gt 200000 ]; then
			echo "::error::${url} has an Alexa ranking above 200K. (${alexa_rank})"
			exit 1
		else
			echo "${url} has an Alexa ranking of (${alexa_rank})."
			exit 0
		fi
	fi
}

check_rank
