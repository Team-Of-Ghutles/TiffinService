const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp(functions.config().firebase);

exports.updateUserBalance = functions.database.ref('Transactions/{userId}/{txnId}')
	.onWrite( event => {
		const balancePerUserRef = event.data.ref.root.child('Balances').child(event.params.userId)
		var dataDeleted = !event.data.exists()
		var txnData = !dataDeleted ? event.data.val() : event.data.previous.val();
		var balanceType = txnData['Type'] == 'ORDER' ? 'debit' : 'credit';
		return balancePerUserRef.child(balanceType).transaction( current => {
			if (!current) {
				return dataDeleted ? 0 : txnData['Amount'];
			} else {
				return dataDeleted ? current - txnData['Amount'] : current + txnData['Amount'];
			}
		}).then( () => {
			console.log(balanceType,' for ', event.params.userId, 'updated by ', txnData['Amount']);
		});
	});