const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

exports.deleteExpiredOffers = functions.pubsub.schedule("every 1 hours").
    onRun(async (context) => {
      const db = admin.firestore();
      const now = admin.firestore.Timestamp.now();
      const cutoff = new Date(now.toDate()
          .getTime() - 24 * 60 * 60 * 1000); // 24 hours ago
      const query = db .collection("today_offers")
          .collection("items").where("created_at", "<=", cutoff);

      const snapshot = await query.get();
      const batch = db.batch();

      snapshot.forEach((doc) => {
        batch.delete(doc.ref);
      });

      await batch.commit();
      console.log(`${snapshot.size} expired documents deleted.`);
    });
