const _ = require('lodash')
const MAX_ELEMENTS = 1000

module.exports = (app, DB) => {
  app.get('/v1/history/get_actions/:account/:action', getActions)

  function getActions (req, res) {
    // default values
    // let skip = 0
    let limit = 499
    let sort = -1
    let accountName = String(req.params.account)
    // let action = String(req.params.action)
    let blockHeight = req.query.blockHeight
    let query = { $or: [
     // { 'actions.account': accountName },
     // { 'actions.data.receiver': accountName },
      { 'actions.data.from': accountName },
      { 'actions.data.to': accountName },
     // { 'actions.data.name': accountName },
     // { 'actions.data.voter': accountName },
     // { 'actions.authorization.actor': accountName }
    ],
    $and: [{ 'actions.name': 'transfer' }]
    }
    // if (action !== 'undefined' && action !== 'all') {
    //            query['$and'].push({'actions.name': action})
    // }

    // skip = (isNaN(Number(req.query.skip))) ? skip : Number(req.query.skip)
    limit = (isNaN(Number(req.query.limit))) ? limit : Number(req.query.limit)
    sort = (isNaN(Number(req.query.sort))) ? sort : Number(req.query.sort)

    if (limit > MAX_ELEMENTS) {
      return res.status(401).send(`Max elements ${MAX_ELEMENTS}!`)
    }
    // if (skip < 0 || limit < 0) {
    //   return res.status(401).send(`Skip (${skip}) || (${limit}) limit < 0`)
    // }
    if (sort !== -1 && sort !== 1) {
      return res.status(401).send(`Sort param must be 1 or -1`)
    }

    DB.collection('transactions').find(query).sort({ '_id': sort }).limit(limit).toArray((err, result) => {
      if (err) {
        console.error(err)
        return res.status(500).end()
      }
      const transactions = []
      result.map(a => {
        if (a.block_num <= blockHeight) return false
        if (a.actions[0].name !== 'transfer') return false
        const { from, memo, quantity, to } = a.actions[0].data
        const split = quantity.split(' ')
        const [exchangeAmount, currencyCode] = split

        const singleTx = {
          txid: a.trx_id,
          date: a.block_time,
          currencyCode,
          blockHeight: a.block_num,
          networkFee: '0',
          parentNetworkFee: '0',
          signedTx: 'has_been_signed',
          metadata: { notes: memo },
          otherParams: { fromAddress: from, toAddress: to },
          exchangeAmount,
          quantity: quantity,
          name: a.actions[0].name
        }
        // protects against double entries
        if (!_.some(transactions, singleTx)) transactions.push(singleTx)
      })
      res.status(200).json(transactions)
    })
  }
}

