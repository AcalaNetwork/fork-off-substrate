#!/bin/bash
# usage
# ./fork-mandala/fork.sh

set -xe

[ -d node_modules ] || npm i

[ -d data ] || mkdir data

[ -f data/runtime.wasm ] || false # wget https://gateway.pinata.cloud/ipfs/Qmc3SsBgi2muATLijKpxMD5sPBwxmAYf7Q1s2bMRsupJsS -O data/runtime.wasm

[ -f data/binary ] || false # docker cp node:/usr/local/bin/acala data/binary

[ -d fork-mandala/node_modules ] || (cd fork-mandala && yarn && cd ..)

[ -d fork-mandala/output ] || ( \
	cd fork-mandala && \
	yarn start generate && \
	cd .. \
	)

[ -f fork-mandala/mandala-dist.json ] || docker run --rm acala/mandala-node:2.9.1 build-spec --chain=mandala --disable-default-bootnode > fork-mandala/mandala-dist.json

# delete bootNodes in fork-mandala/mandala-dist.json

HTTP_RPC_ENDPOINT=http://localhost:9933 ORIG_CHAIN=mandala FORK_CHAIN=fork-mandala/mandala-dist.json npm start

cp data/fork.json fork-mandala/output/mandala-dist.json
cp fork-mandala/rococo-mandala.json fork-mandala/output/rococo-mandala.json

# cd fork-mandala/output && docker-compose up -d --build

# relaychain set header and code

# parachain author_insertKey
