const MongoClient = require('mongodb').MongoClient
const bodyparser = require('body-parser')
const CONFIG = require('./config')

const MONGO_OPTIONS = {
  socketTimeoutMS: 30000,
  keepAlive: true,
  reconnectTries: 30000,
  useNewUrlParser: true
}

const express = require('express')
const app = express()
app.use(bodyparser.json({
  strict: false
}))

process.on('uncaughtException', (err) => {
  console.error(`======= UncaughtException API Server :  ${err}`)
})

MongoClient.connect(CONFIG.mongoURL, MONGO_OPTIONS, (err, db) => {
  if (err) return console.error('Database error !!!', err)
  console.log('=== Database Connected!')
  const dbo = db.db(CONFIG.mongoDB)
  require('./historyapi')(app, dbo)
})

const http = require('http').Server(app)
http.listen(CONFIG.serverPort, () => {
  console.log('=== Listening on port:', CONFIG.serverPort)
})
http.on('error', (err) => {
  console.error('=== Http server error', err)
})
