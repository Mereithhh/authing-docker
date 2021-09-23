#!/bin/bash
npm -g install yarn
yarn global add tyarn
yarn global add typescript
cd authing-server && tyarn && cd src/packages/samlify && tsc && rm -rf ../../../node_modules/samlify/* && mv ./build/* ../../../node_modules/samlify/  && cd ../../../../ && \
cd authing-fe-console && tyarn && cd .. && \
cd authing-user-portal && tyarn && cd ..