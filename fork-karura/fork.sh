#!/bin/bash
# usage
# ./fork-karura/fork.sh

set -xe

[ -d node_modules ] || npm i

[ -d data ] || mkdir data

[ -f data/runtime.wasm ] || false # wget https://gateway.pinata.cloud/ipfs/Qmc3SsBgi2muATLijKpxMD5sPBwxmAYf7Q1s2bMRsupJsS -O data/runtime.wasm

[ -f data/binary ] || false # docker cp node:/usr/local/bin/acala data/binary

[ -d fork-karura/node_modules ] || (cd fork-karura && yarn && cd ..)

[ -d fork-karura/output ] || ( \
	cd fork-karura && \
	yarn start generate && \
	mv output/karura-dev-2000.json output/karura-dev-2000.json-bak && \
	cd .. \
	)

HTTP_RPC_ENDPOINT=http://localhost:9933 ORIG_CHAIN=karura FORK_CHAIN=fork-karura/output/karura-dev-2000.json-bak npm start

echo "Set the evm.ChainID 596 to allow reset relaychain"
sed -i 's/"0x1da53b775b270400e7e61ed5cbc5a146d8b4519d4aceb8073dbaffde1eef0d79": "0xae02000000000000"/"0x1da53b775b270400e7e61ed5cbc5a146d8b4519d4aceb8073dbaffde1eef0d79": "0x5402000000000000"/' data/fork.json

cp data/fork.json fork-karura/output/karura-dev-2000.json

# cd fork-karura/output && docker-compose up -d --build

# relaychain set header and code
