#!/bin/sh

healthCheckTargetUrl=$1
healthCheckMethod=$2
healthCheckHeader=$3
healthCheckBody=$4
warmupTargetUrl=$5
warmupMethod=$6
warmupHeader=$7
warmupBody=$8
warmupNum=$9

if [ ! $# = 9 ]; then
  echo "selecting all parameter is needed."
  exit 1
fi

waitHealthy () {

  echo "healthCheckTargetUrl: $healthCheckTargetUrl, healthCheckMethod: $healthCheckMethod, healthCheckHeader: $healthCheckHeader, healthCheckBody: $healthCheckBody"

  if [ ! "$healthCheckMethod" ]; then
    healthCheckMethodParameter=""
  else
    healthCheckMethodParameter=" -X $healthCheckMethod "
  fi

  if [ ! "$healthCheckHeader" ]; then
    healthCheckHeaderParameter=""
  else
    healthCheckHeaderParameter=" -H '$healthCheckHeader' "
  fi

  if [ ! "$healthCheckBody" ]; then
    healthCheckBodyParameter=""
  else
    healthCheckBodyParameter=" -d '$healthCheckBody' "
  fi

  while true
  do

    statusCode=$(curl -LI -s -w '%{http_code}' "${healthCheckMethodParameter}" "${healthCheckHeaderParameter}" "${healthCheckBodyParameter}" "${healthCheckTargetUrl}" | tail -n 1)
    echo "statusCode: $statusCode"
    if [ "$statusCode" = 200 ]; then
      break
    fi
    sleep 1
  done
}

warmup () {

  echo "warmupTargetUrl: $warmupTargetUrl, warmupMethod: $warmupMethod, warmupHeader: $warmupHeader, warmupBody: $warmupBody"

  if [ ! "$warmupMethod" ]; then
    warmupMethodParameter=""
  else
    warmupMethodParameter=" -X $warmupMethod "
  fi

  if [ ! "$warmupHeader" ]; then
    warmupHeaderParameter=""
  else
    warmupHeaderParameter=" -H '$warmupHeader' "
  fi

  if [ ! "$warmupBody" ]; then
    warmupBodyParameter=""
  else
    warmupBodyParameter=" -d '$warmupBody' "
  fi

  for i in $(seq 0 "$warmupNum")
  do
    statusCode=$(curl -LI -s -w '%{http_code}' "${warmupMethodParameter}" "${warmupHeaderParameter}" "${warmupBodyParameter}" "${warmupTargetUrl}" | tail -n 1)
    echo "warmupCount: $i"
    if [ ! "$statusCode" = 200 ]; then
      exit 1
    fi
  done
}

waitHealthy

warmup

touch /http-warmup/warmup-completed
