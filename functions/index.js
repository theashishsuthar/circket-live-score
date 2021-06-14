const functions = require("firebase-functions");
const admin = require('firebase-admin');
admin.initializeApp();

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
exports.oncreatefeednotification = functions.firestore.document("/NotificationFeed/{userid}/NotificationStatus/{activityfeeditems}")
    .onCreate(async (snapshot, context) => {
        console.log('activity feed items data', snapshot.data());
        const userid = context.params.userid;
        const userref = admin.firestore().doc(`Users/${userid}`);
        const doc = await userref.get();
        const androidNotificationToken = doc.data().androidNotificationToken;
        const feeddata = snapshot.data();
        if (androidNotificationToken) {
            sendnotification(androidNotificationToken, feeddata);
        } else {
            console.log('user token is not created , so not sent notification');
        }
        function sendnotification(androidNotificationToken, feeddata) {

            let body;
            let title;
            let image;
            let message;

            switch (feeddata.type) {
                case "Prediction":
                    message = {
                        notification: {
                            'title': `${feeddata.title}`,
                            'body': `${feeddata.body}`,

                        },
                        token: androidNotificationToken,
                        data: {
                            'title': `${feeddata.title}`,
                            'body': `${feeddata.body}`,
                            'gameId': `${feeddata.gameId}`,
                            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
                            recipient: userid,
                        },

                    };
                    break;
                // case "review":
                //     message = {
                //         notification: {
                //             'title': `${feeddata.title}`,
                //             'body': `${feeddata.body}`,

                //         },
                //         token: androidNotificationToken,
                //         data: {
                //             'title': `${feeddata.title}`,
                //             'body': `${feeddata.body}`,
                //             'iexist': 'no',
                //             'click_action': 'FLUTTER_NOTIFICATION_CLICK',
                //             'type': 'review',
                //             recipient: userid,
                //         },

                //     };
                //     break;
                // case "LastDue":
                //     message = {
                //         notification: {
                //             'title': `${feeddata.title}`,
                //             'body': `${feeddata.body}`,

                //         },
                //         token: androidNotificationToken,
                //         data: {
                //             'title': `${feeddata.title}`,
                //             'body': `${feeddata.body}`,
                //             'iexist': 'no',
                //             'click_action': 'FLUTTER_NOTIFICATION_CLICK',
                //             recipient: userid,
                //         },

                //     };
                //     break;
                case "General":
                    message = {
                        notification: {
                            'title': `${feeddata.title}`,
                            'body': `${feeddata.body}`,
                        },
                        token: androidNotificationToken,
                        data: {
                            'title': `${feeddata.title}`,
                            'body': `${feeddata.body}`,
                            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
                            recipient: userid,
                        },

                    };
                    break;



                default:
                    break;
            }
            // const message = {
            //     notification: {
            //         'title': title,
            //         'body': body,
            //         'image': image,
            //     },
            //     token: androidNotificationToken,
            //     data: {
            //         'title': title,
            //         'body': body,
            //         'image': image,
            //         click_action: 'FLUTTER_NOTIFICATION_CLICK',
            //         recipient: userid,
            //     },

            // };
            admin.messaging().send(message).then((response) => console.log('send notification successfully', response))
                .catch((error) => console.log('error occurs during send message', error));
        }
    });