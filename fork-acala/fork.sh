#!/bin/bash
# usage
# ./fork-acala/fork.sh

set -xe

[ -d node_modules ] || npm i

[ -d data ] || mkdir data

[ -f data/runtime.wasm ] || false # wget https://gateway.pinata.cloud/ipfs/Qmc3SsBgi2muATLijKpxMD5sPBwxmAYf7Q1s2bMRsupJsS -O data/runtime.wasm

[ -f data/binary ] || false # docker cp node:/usr/local/bin/acala data/binary

[ -d fork-acala/node_modules ] || (cd fork-acala && yarn && cd ..)

[ -d fork-acala/output ] || ( \
	cd fork-acala && \
	yarn start generate && \
	mv output/acala-dev-2000.json output/acala-dev-2000.json-bak && \
	cd .. \
	)

HTTP_RPC_ENDPOINT=http://localhost:9933 ORIG_CHAIN=acala FORK_CHAIN=fork-acala/output/acala-dev-2000.json-bak npm start

cp data/fork.json fork-acala/output/acala-dev-2000.json

# cd fork-acala/output && docker-compose up -d --build

# relaychain set header and code
