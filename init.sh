#!/bin/bash
yarn global add typescript
cd authing-server && yarn && cd src/packages/samlify && tsc && rm -rf ../../../node_modules/samlify/* && mv ./build/* ../../../node_modules/samlify/  && cd ../../../../ && \
cd authing-fe-console && yarn && cd .. && \
cd authing-user-portal && yarn && cd ..