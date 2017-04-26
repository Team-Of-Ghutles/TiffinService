const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp(functions.config().firebase);

exports.updateUserBalance = functions.database.ref('Transactions/{userId}/{txnId}')
	.onWrite( event => {
		if (!event.data.exists()) {
			return;
		} else {
			const balancePerUserRef = event.data.ref.root.child('Balances').child(event.params.userId)
			var txnData = event.data.val();
			var eventType = txnData['Type'];
			var balanceType = eventType == 'ORDER' ? 'debit' : 'credit';
			return balancePerUserRef.child(balanceType).transaction( current => {
				if (!current) {
					return txnData['Amount'];
				} else {
					return current + txnData['Amount'];
				}
			}).then(() => {
				console.log('Balance node for ', event.params.userId, '/', balanceType, 'updated');
			});
		}
	});