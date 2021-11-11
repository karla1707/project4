import createSubscriber from "pg-listen"

// const databaseURL = "postgres://fkxeqtpv:4xUvE88Ne-IqRxWpu-M6gWPBAilq8K0e@balarama.db.elephantsql.com:5432/fkxeqtpv"
const databaseURL = "postgresql://prj2g5:g5sqlpass@78.94.190.157:5432/g5"

const subscriber = createSubscriber({ connectionString: databaseURL })

subscriber.events.once("error", (error) => {
  console.error("Fatal database connection error:", error)
  process.exit(1)
})

let channel = "alerts"

process.on("exit", () => {
  subscriber.close()
})

export async function connect() {
  await subscriber.connect()
  await subscriber.listenTo(channel)
  console.log("subscribed to: " + subscriber.getSubscribedChannels())
}

subscriber.notifications.on(channel, (payload) => {
  console.log("Received: ", payload)

  const apn = require("apn");

  let service = new apn.Provider({
    token: {
      key: "AuthKey_MVJHJ8K8MU.p8",
      keyId: "MVJHJ8K8MU",
      teamId: "KH7BD93PMV"
    },
    production: false
    // cert: "cert.pem",
    // key: "key.p12",
  });

  // console.log("HERE")
  // console.log(service)

  let note = new apn.Notification();

  note.expiry = Math.floor(Date.now() / 1000) + 3600; // Expires 1 hour from now.
  note.sound = "ping.aiff";
  note.alert = `There is a new price for one of your price alerts!`;

  note.topic = "nl.fontys.apps20.G8ProductPriceAlert";

  note.payload = payload;

  console.log(`Sending: ${note.compile()}`);

  let token = payload.token

  console.log("to: " + token)

  service.send(note, token).then(result => {
    console.log("sent:", result.sent.length);
    console.log("failed:", result.failed.length);
    console.log(result.failed);
  });
})

connect()
