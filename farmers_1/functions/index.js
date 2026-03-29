const { onCall } = require("firebase-functions/v2/https");
const { onDocumentCreated } = require("firebase-functions/v2/firestore");
const admin = require("firebase-admin");
admin.initializeApp();

exports.sendNotificationV2 = onCall({ invoker: 'public' }, async (req) => {
  const { title, body } = req.data;

  if (!title || !body) {
    return { success: false, message: "Missing title/body" };
  }

  const message = {
    notification: { title, body },
    topic: "allUsers",
  };

  try {
    await admin.messaging().send(message);
    // persist broadcast in Firestore for history
    await admin.firestore().collection("broadcast_notifications").add({
      title,
      body,
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
      type: "admin_broadcast",
    });
    return { success: true };
  } catch (error) {
    return { success: false, message: error.message };
  }
});

// Trigger a product-added notification to all users and persist
exports.notifyProductAdded = onCall({ invoker: 'public' }, async (req) => {
  const { productName } = req.data || {};
  if (!productName) {
    return { success: false, message: "Missing productName" };
  }
  const title = "New product added";
  const body = `${productName} is now available. Check it out!`;
  const message = {
    notification: { title, body },
    topic: "allUsers",
  };
  try {
    await admin.messaging().send(message);
    await admin.firestore().collection("broadcast_notifications").add({
      title,
      body,
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
      type: "product_added",
      productName,
    });
    return { success: true };
  } catch (error) {
    return { success: false, message: error.message };
  }
});

// Firestore trigger: when admin writes to broadcast_outbox, send to topic and persist
exports.broadcastFromOutbox = onDocumentCreated("broadcast_outbox/{docId}", async (event) => {
  const data = event.data?.data();
  if (!data) return;
  const title = data.title || "Notification";
  const body = data.body || "";
  try {
    await admin.messaging().send({ notification: { title, body }, topic: "allUsers" });
    await admin.firestore().collection("broadcast_notifications").add({
      title,
      body,
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
      type: "admin_broadcast",
      sourceDocId: event.params.docId,
    });
  } catch (e) {
    console.error("broadcastFromOutbox error", e);
  }
});

// Firestore trigger: when new product item is created, notify all users and persist
exports.notifyOnItemCreate = onDocumentCreated("items/{itemId}", async (event) => {
  const data = event.data?.data();
  if (!data) return;
  const productName = data.name || "New item";
  const title = "New product added";
  const body = `${productName} is now available. Check it out!`;
  try {
    await admin.messaging().send({ notification: { title, body }, topic: "allUsers" });
    await admin.firestore().collection("broadcast_notifications").add({
      title,
      body,
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
      type: "product_added",
      productName,
      itemId: event.params.itemId,
    });
  } catch (e) {
    console.error("notifyOnItemCreate error", e);
  }
});
