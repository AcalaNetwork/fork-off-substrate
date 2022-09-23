#!/bin/bash
# usage
# ./fork-acala/clean.sh

set -xe

cd fork-acala/output && docker-compose down -v
