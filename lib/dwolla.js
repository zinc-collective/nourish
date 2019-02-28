/** @module lib/dwolla */

// store the dwolla-v2 library from package.json in the dwolla variable
const dwolla = require("dwolla-v2");
const _ = require("lodash");

// Confidentially Provide the EBREC API Keys to Dwolla
// so we can use their API as the correct user
// Also, set to sandbox mode so we don't accidentally
// ruin Zee financially or otherwise violate laws.
const dwollaConfig = {
  key: process.env.DWOLLA_APP_KEY,
  secret: process.env.DWOLLA_APP_SECRET,
  environment: process.env.DWOLLA_MODE
};

/** Adapter to wrap the dwolla-v2 Client */
class Client {
  /**
   * Create a client point.
   */
  constructor() {
    // Instantiate a dwolla Client with the credentials defined above.
    this.client = new dwolla.Client(dwollaConfig);
  }

  /**
   * Start a session  for interacting with the Dwolla API
   */
  start() {
    return this.client.auth.client().then(session => new Session(session));
  }
}

/**
 * Adapter that wraps a dwolla-v2 Session
 */
class Session {
  /**
   * Wrap the dwolla.Session class so we can inject behavior around it.
   * @param {dwolla.Session} session - The session we're working with
   */
  constructor(session) {
    this.session = session;
  }

  /**
   * Query the dwolla API for an iavToken for the given Customer
   * @see https://docs.dwolla.com/#create-an-iav-token-for-dwolla-js
   * @param {Object} keywords - Keyword arguments for destructuring
   * @param {Customer} Keywords.customer - The customer we want to get an IAV Token for
   */
  iavToken({ customer }) {
    return this.session
      .post(`customers/${customer.id}/iav-token`)
      .then(response => ({ iavToken: response.body.token }));
  }

  /**
   * Query the dwolla API a list of Customers
   * @see https://docs.dwolla.com/#list-and-search-customers
   * @param {Object} keywords - Keyword arguments for destructuring
   * @param {number} Keywords.limit - The amount of customers to retrieve
   */
  customers({ limit = 10, search = null }) {
    return this.session.get("customers", { limit, search }).then(response => {
      return {
        response,
        session: this,
        customers: response.body._embedded.customers
      };
    });
  }

  customerFind({ email }) {
    return this.customers({ search: email }).then(
      ({ response, customers }) => ({
        response,
        session: this,
        customer: customers[0]
      })
    );
  }

  customerUpsert({ email, firstName, lastName }) {
    return this.session
      .post("customers", _.pickBy({ email, firstName, lastName }, _.identity))
      .then(() => this.customerFind({ email }))
      .catch(response => {
        if (
          response.body &&
          response.body._embedded &&
          response.body._embedded.errors[0].code === "Duplicate"
        ) {
          return this.customerFind({ email });
        }
        throw response;
      });
  }

  transfer({ source, amount, note }) {
    const transfer = {
      _links: {
        source: {
          href: source
        },
        destination: { href: process.env.DWOLLA_DESTINATION_ACCOUNT }
      },
      amount: {
        currency: "USD",
        value: `${amount}.00`
      },
      metadata: {
        // TODO: This is not a reasonable note, or payment id.
        note: note
      }
      // TODO - I think there are more pieces of data we want to use
      // to make sure we don't accidentally double-submit (idempotency key?)

      // TODO - We may also want to create an internal transaction id so
      // that we can correlate these transactions between Dwolla and our
      // records
    };

    return this.session.post("transfers", transfer).then(response => {
      if (response.status === 201) {
        response.success = true;
      } else {
        response.success = false;
      }
      response.source = source;
      response.amount = amount;
      response.note = note;
      return response;
    });
  }
}

module.exports = {
  Session,
  Client
};
