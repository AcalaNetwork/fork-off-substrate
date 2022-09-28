#!/bin/bash
# usage
# ./fork-karura/clean.sh

set -xe

cd fork-karura/output && docker-compose down -v
