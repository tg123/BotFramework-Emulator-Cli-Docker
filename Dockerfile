FROM node AS builder

RUN mkdir /app
WORKDIR /app

RUN git clone https://github.com/Microsoft/BotFramework-Emulator.git /app
RUN npm install
RUN npm run bootstrap

ADD users.ts packages/emulator/core/src/facility


RUN npm run build; exit 0

RUN npm i -g pkg
RUN pkg -t node10-alpine-x64 packages/emulator/cli

FROM alpine
RUN apk add libstdc++

COPY --from=builder /app/emulator-cli /

EXPOSE 5000

ENV BOT_ID bot1
ENV BOT_URL http://localhost:3978/api/messages/
ENV SERVICE_URL http://localhost:5000

CMD ["sh", "-c", "/emulator-cli --bot-id $BOT_ID --bot-url $BOT_URL --service-url $SERVICE_URL"]
