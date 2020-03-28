const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();


exports.onCreateMessage = functions.firestore
    .document("/messages/{messageId}/chat-rooms/{chatRoomId}")
    .onCreate(async (snapshot, context) => {
        const receiverId = context.params.messageId;
        const senderId = snapshot.data()['messages'][0]['ownerId'];
        if(receiverId !== senderId) {
            const userRef = admin
            .firestore()
            .collection('users')
            .doc(receiverId); 
            try{
                await userRef.update({
                    newMessagesCount: admin.firestore.FieldValue.increment(1)
                })
            } catch(error) {
                console.log('Error: ',error);
            }
        } else return;
    })

exports.onUpdateMessage = functions.firestore
    .document("/messages/{messageId}/chat-rooms/{chatRoomId}")
    .onUpdate(async (snapshot, context) => {
        const receiverId = context.params.messageId;
        const senderId = snapshot.before.data()['messages'][0]['ownerId'];
        if(receiverId !== senderId) {
            const userRef = admin
            .firestore()
            .collection('users')
            .doc(receiverId); 
            try{
                await userRef.update({
                    newMessagesCount: admin.firestore.FieldValue.increment(1)
                })
            } catch(error) {
                console.log('Error: ',error);
            }
        } else return;
    })