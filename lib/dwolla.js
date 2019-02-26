/** @module lib/dwolla */

// store the dwolla-v2 library from package.json in the dwolla variable
const dwolla = require('dwolla-v2');
const _ = require('lodash');

// Confidentially Provide the EBREC API Keys to Dwolla 
// so we can use their API as the correct user
// Also, set to sandbox mode so we don't accidentally 
// ruin Zee financially or otherwise violate laws.
const dwollaConfig = {
  key: process.env.DWOLLA_APP_KEY,
  secret: process.env.DWOLLA_APP_SECRET,
  environment: process.env.DWOLLA_MODE,
}


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
    return this.client.auth.client().then((session) => new Session(session))
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
    return this.session.post(`customers/${customer.id}/iav-token`).then((response) => ({ iavToken: response.body.token }))
  }
  
  /**
   * Query the dwolla API a list of Customers
   * @see https://docs.dwolla.com/#list-and-search-customers
   * @param {Object} keywords - Keyword arguments for destructuring
   * @param {number} Keywords.limit - The amount of customers to retrieve
   */
  customers({ limit=10, search = null }) {
    return this.session.get('customers', { limit, search })
      .then((response) => ({ response, session: this, customers: response.body._embedded.customers }))
  }
  
  customerUpsert({ email, firstName, lastName }) {
    return this.session.post('customers', _.pickBy({ email, firstName, lastName }, _.identity)).then((response) => {
      return { response, session: this, customer: this.response.body.embedded }
    }).catch((response) => {
      console.error(JSON.stringify(response))
      if(response.body && response.body._embedded && response.body._embedded.errors[0].code === "Duplicate") {
        return this.customers({ search: email })
          .then(({ response, customers }) => ({ response, session: this, customer: customers[0] }))
      }
      throw response;
    });
  }
}

module.exports = {
  Session,
  Client
}