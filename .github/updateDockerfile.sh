#!/bin/bash

# File we're updating
DOCKERFILE="${GITHUB_WORKSPACE}/Dockerfile"

# Current Versions
CURRENT_EXABGP="$(cat Dockerfile | grep -i "EXABGP_VERSION=" | awk -F= '{print $2}')"

CHANGED_THING=()

# Latest versions
LATEST_EXABGP=$(curl -s -L https://api.github.com/repos/Exa-Networks/exabgp/releases/latest | grep -i tag_name | awk -F'"' '{print $4}')

if [ "${CURRENT_EXABGP}" != "${LATEST_EXABGP}" ]; then
	CHANGED_THING+=("EXABGP \`${CURRENT_EXABGP}\` => \`${LATEST_EXABGP}\`")
fi;

if [ "" == "${LATEST_EXABGP}" ]; then
	echo "Unable to find new versions."
	exit 1
fi;

# Update tag
sed -i "s/EXABGP_VERSION=${CURRENT_EXABGP}/EXABGP_VERSION=${LATEST_EXABGP}/" Dockerfile

# Has Changed?
echo ""
git --no-pager diff "${DOCKERFILE}"
git diff-files --quiet "${DOCKERFILE}"
CHANGED=${?}

if [ $CHANGED != 0 ]; then
	echo "**\`Dockerfile\` was changed**" | tee -a $GITHUB_STEP_SUMMARY

	echo "" | tee -a $GITHUB_STEP_SUMMARY
	for THING in "${CHANGED_THING[@]}"; do
	     echo " - " $THING | tee -a $GITHUB_STEP_SUMMARY
	done
	ALL_CHANGED_THINGS=$(printf ", %s" "${CHANGED_THING[@]}")
	ALL_CHANGED_THINGS=${ALL_CHANGED_THINGS:2}

	echo "changes_detected=true" >> $GITHUB_OUTPUT
	echo "changed_items=${ALL_CHANGED_THINGS}" >> $GITHUB_OUTPUT
	echo "tag_version=v${LATEST_EXABGP}" >> $GITHUB_OUTPUT
else
	echo "No changes detected" | tee -a $GITHUB_STEP_SUMMARY
	echo "changes_detected=false" >> $GITHUB_OUTPUT
	echo "changed_items=" >> $GITHUB_OUTPUT
fi;
