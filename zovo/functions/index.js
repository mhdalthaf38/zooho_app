/* eslint-disable */
const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

// Trigger on document creation or update in the "offers_today" collection
exports.deleteOldOffers = functions.firestore
  .document('offers_today/{offerId}')
  .onWrite(async (change, context) => {
    const db = admin.firestore();
    const offerRef = change.after.exists ? change.after.ref : null;

    if (!offerRef) {
      console.log("✅ No document to process.");
      return null;
    }

    // Get current timestamp
    const now = admin.firestore.Timestamp.now();
    const twentyFourHoursAgo = new Date(
      now.toDate().getTime() - 24 * 60 * 60 * 1000
    ); // 24 hours ago

    try {
      const data = change.after.data();
      let deleteFlag = false;

      // Check if Offertype is "today_offers" and created_at > 24 hours (delete)
      if (
        data.Offertype === "today_offers" &&
        data.created_at.toDate() < twentyFourHoursAgo
      ) {
        deleteFlag = true;
      }

      // Check if Offertype is "offers" and end_date is BEFORE the current date (delete)
      if (
        data.Offertype === "offers" &&
        data.end_date &&
        data.end_date.toDate() < now.toDate()
      ) {
        deleteFlag = true;
      }

      // If the conditions are met, delete the offer document
      if (deleteFlag) {
        await offerRef.delete();
        console.log(`🔥 Deleted expired offer with ID: ${context.params.offerId}`);
      } else {
        console.log("✅ No offers needed deletion.");
      }

      return null;
    } catch (error) {
      console.error("❌ Error deleting old offers:", error);
      return null;
    }
  });
