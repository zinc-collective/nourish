// server.js
// where your node app starts

// store the express.js library from package.json in the express variable
const express = require('express');

//create express application
const app = express();

const Dwolla = require('./lib/dwolla');

const { seedExampleData } = require('./lib/seed')

const client = new Dwolla.Client();

seedExampleData(client)

// Set up views and templates
// configure express to use the `ejs` package for rendering it's views
app.set('view engine', 'ejs');

// configure express to look in the app folder for it's views
app.set('views', __dirname);


// Expose form data on `request.body` in our routes.
app.use(express.urlencoded())



// http://expressjs.com/en/starter/static-files.html
app.use(express.static('public'));



// http://expressjs.com/en/starter/basic-routing.html
// Define homepage for users to verify their bank accounts
app.get('/', function(request, response) {
  response.render('index/guest', { iavToken: null, investor: false });
});


app.post('/', function(request, response) {
  const investor = request.body.investor
  console.log({ investor })
  client.start().then(
    (session) => session.customerUpsert({ email: investor.email, 
                                          firstName: investor.personalName,
                                          lastName: investor.familyName }))
    .then(({ session, customer }) => {
      investor.dwollaId = customer.id;
      return session.iavToken({ customer: { id: customer.id } })
    })
    .then(({ iavToken }) => response.render('index/investor', { iavToken, investor }))
});

// Transer money from a specified account to the 
// EBPREC's main account
app.post('/transfer', function(request, response) {
  console.log('transferrring', request.body.transfer);
  const amount = parseInt(request.body.transfer.amount);
  
  const transferBody = {
    "_links": {
      // TODO: Let's not hardcode either account! The user should
      // specify which account they want the _source_ to be
      "source": { "href": "https://api.dwolla.com/funding-sources/90fa5286-8abd-4244-ba79-a8a0050d7b22" },
      // TODO: And we should use the `.env` secrets to specify the
      // destination
      "destination": { "href": "https://api.dwolla.com/funding-sources/6e539e84-5e20-46b4-82ae-44872c7b7794" }
    },
    "amount": {
      "currency": "USD",
      "value": `${amount}.00`
    },
    "metadata": {
      // TODO: This is not a reasonable note, or payment id.
      "note": "it's whats for dinner",
      "paymentId": "1234567890"
    }
    // TODO - I think there are more pieces of data we want to use
    // to make sure we don't accidentally double-submit (idempotency key?)

    // TODO - We may also want to create an internal transaction id so
    // that we can correlate these transactions between Dwolla and our 
    // records
  }
  client.auth.client().then((dwollaClient) => {
    // Send the transfer to dwolla so they may process it
    dwollaClient.post('transfers', transferBody)
      // TODO: Figure out what data we want to sure the user when the 
      // transfer completes.
      .then(dwollaRes => response.render('transfer'))
  }) 
})

// listen for requests :)
const listener = app.listen(process.env.PORT, function() {
  console.log('Your app is listening on port ' + listener.address().port);
});
