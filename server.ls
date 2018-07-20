if Meteor.isServer

	Meteor.publish \tabel, -> tabel.find {}

	Meteor.methods do
		upsert: (doc) -> tabel.upsert doc._id, doc
		remove: (doc) -> tabel.remove doc._id
