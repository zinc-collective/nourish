// Set up the dwolla account with example data if necessary
module.exports = {
  seedExampleData: function(client) {
    client
      .start()
      .then(session =>
        session.customerUpsert({
          firstName: "Zee",
          lastName: "Example",
          email: "zee@example.com"
        })
      )
      .then(({ session, customer }) => console.log(customer));
  }
};
