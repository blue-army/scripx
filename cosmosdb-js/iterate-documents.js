"use strict";

const dotenv = require('dotenv');
const cosmos = require('documentdb');
var async = require('async');

dotenv.load();

let config = {
    host: process.env.COSMOSDB_HOST,
    key: process.env.COSMOSDB_KEY
};

var client = new cosmos.DocumentClient(config.host, { masterKey: config.key });

var collLink = cosmos.UriFactory.createDocumentCollectionUri('jibe', 'events');

function deleteDocument(docUri) {
    return function (callback) {
        client.deleteDocument(docUri, function (err, res) {
            callback(err, res);
        })
    }
}

let tasks = [];
let iterator = client.queryDocuments(collLink, 'select event._self from events event').toArray(function (err, events) {

    events.forEach(e => {
        tasks.push(deleteDocument(e._self));
    });

    async.parallelLimit(tasks, 5, function(err, res) {
        console.log(res);
    })
})
