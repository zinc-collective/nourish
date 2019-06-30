# Compensated
Compensated makes it easier to instrument your server and client with mechanisms for getting paid. It is designed as an event-driven system, with very few opinions about how your application is structured or communicates the information to the client, while providing affordances and guidance around consistent, reliable payment processing.

## Roadmap

1. Q3 2019 - compensated-ruby, compensated-ruby-stripe, and compensated-ruby-gumroad will handle callbacks and provide hooks so that you can adjust data within your system when subscription payments succeed or fail.
2. Q4 2019 - ???

## Architecture

Compensated's architecture draws from prior art such as [griddler](https://github.com/thoughtbot/griddler), [omniauth](https://github.com/omniauth/omniauth) and [expressjs](https://expressjs.com/). The goal of the design is to enable functionality without imposing demands on structures.

## Licensing
Compensated is wholly owned by Zinc Technology Inc (ZTI) Copyright 2019.

Compensated is licensed as is for personal and commercial use to members or clients of ZTI per the terms of their ZTI membership or client agreement.

Licensees are allowed to maintain their own fork for private or organizational use in perpetuity even after termination of membership or client relationship.

Licensees are not entitled to updates from ZTI after termination of their client or membership relationship.

## Contributing

Contributors transfer ownership rights to ZTI upon acceptance of their contributions into the primary ZTI repository. Further, contributor's guarantee that they have the right to transfer ownership of their contributions; and shall indemnify ZTI from any and all repercussions caused by a violation of this guarantee.