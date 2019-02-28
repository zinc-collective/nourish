// server.js
// where your node app starts

// store the express.js library from package.json in the express variable
const express = require("express");

//create express application
const app = express();

const Dwolla = require("./lib/dwolla");

const { seedExampleData } = require("./lib/seed");

const client = new Dwolla.Client();

seedExampleData(client);

// Set up views and templates
// configure express to use the `ejs` package for rendering it's views
app.set("view engine", "ejs");

// configure express to look in the app folder for it's views
app.set("views", __dirname);

// Expose form data on `request.body` in our routes.
app.use(express.urlencoded());

// http://expressjs.com/en/starter/static-files.html
app.use(express.static("public"));

app.use(function(err, req, res, next) {
  console.error(err.stack);
  res.status(500).render("common/error");
});

// http://expressjs.com/en/starter/basic-routing.html
// Define homepage for users to verify their bank accounts
app.get("/", function(request, response) {
  response.render("index/guest", { iavToken: null, investor: false });
});

app.post("/", function(request, response, next) {
  const investor = request.body.investor;
  return client
    .start()
    .then(session =>
      session.customerUpsert({
        email: investor.email,
        firstName: investor.personalName,
        lastName: investor.familyName
      })
    )
    .then(({ session, customer }) => {
      investor.dwollaId = customer.id;
      return session.iavToken({ customer: { id: customer.id } });
    })
    .then(({ iavToken }) =>
      response.render("index/investor", { iavToken, investor })
    )
    .catch(next);
});

// Transer money from a specified account to the
// EBPREC's main account
app.post("/transfer", function(request, response, next) {
  const amount = parseInt(request.body.transfer.amount);
  // TODO: Not sure what makes sense to put in here.
  const note = "???";
  // TODO: Pull this from variables
  console.log(request.body);
  const source = request.body.transfer.fundingSource;
  return client
    .start()
    .then(session => session.transfer({ amount, note, source }))
    .then(transfer => response.render("transfer/show.ejs", { transfer }))
    .catch(next);
});

// listen for requests :)
const listener = app.listen(process.env.PORT, function() {
  console.log("Your app is listening on port " + listener.address().port);
});
