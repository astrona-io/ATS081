#!/usr/bin/env bash
# Check: Proposals from the assistant are denied unless the label proposal-status is proposed, and other users are not affected
set -uo pipefail
fail=0
# retry <attempts> <seconds> <command...>: run the command until it succeeds.
retry() {
  local attempts="$1" pause="$2"
  shift 2
  for _ in $(seq 1 "$attempts"); do
    if "$@"; then return 0; fi
    sleep "$pause"
  done
  return 1
}

SA=system:serviceaccount:assistant:ops-assistant
can() { kubectl auth can-i "$@" --as="$SA" 2>/dev/null; }
# cm <labels block>: a ConfigMap proposal manifest.
cm() { printf 'apiVersion: v1\nkind: ConfigMap\nmetadata:\n  name: check-proposal\n  namespace: assistant\n%b\ndata:\n  target: deployment/probe\n' "$1"; }
as_sa() { kubectl --as="$SA" create --dry-run=server -f - >/dev/null 2>&1; }
approved_denied() { ! cm "  labels:\n    proposal-status: approved" | as_sa; }
unlabeled_denied() { ! cm "" | as_sa; }
proposed_ok() { cm "  labels:\n    proposal-status: proposed" | as_sa; }
if ! retry 12 5 approved_denied; then echo "FAIL: the assistant can create a proposal with the status approved"; fail=1; fi
if ! retry 3 2 unlabeled_denied; then echo "FAIL: the assistant can create a proposal without a status label"; fail=1; fi
if ! retry 3 2 proposed_ok; then echo "FAIL: the assistant cannot create a proposal with the status proposed"; fail=1; fi
if ! cm "  labels:\n    proposal-status: approved" | kubectl create --dry-run=server -f - >/dev/null 2>&1; then echo "FAIL: the policy also blocks other users in assistant"; fail=1; fi

if [ "$fail" -eq 0 ]; then echo "PASS: Proposals from the assistant are denied unless the label proposal-status is proposed, and other users are not affected"; fi
exit "$fail"
