# Backend part

## Pick-up point management system (further as pup)

New goods are delivered to the pick-up points several times a day. Before handing them over to the customer, the information must first be checked and entered into the database. Since there are many pick-up points and even more goods, it is necessary to implement a mechanism that allows for each pick-up point to see how many times a day goods were received and what goods were received.

## Task description

Develop backend-service for pup employees which allows to manage orders as part of the acceptance of goods.

1. Authorization:
   * Using /dummyLogin send desired user type (client, moderator).
     Service returns token with corresponding level of access - user or moderator.
     Token is needed to send to each endpoint which requires authorization.

2. Registration & authorization through email & password:
   * Registration endpoint - /register.
   New users are stored in database with the corresponding type: ordinary user (client) or moderator (moderator)
   Created user get token through /login endpoint
   After successful authorization with email & password user gets token with corresponding level of access.

3. Pup creation:
   * Only users with "moderator" corresponding role can create pups in the system
   * If created successfully full newly created pup information returned. It is possible to create pup only in three major cities: Tokyo, Beijing, Seoul. If another city the error must be returned.
   * New database entry must be result of creating the new pup.

4. Adding information about the acceptance of goods:
   * Only an authorized user of the system with the role of "pup employee" can initiate the acceptance of goods.
   * The result of initiating the acceptance of goods should be a new record in the data storage.
   * If the previous acceptance of goods was not finished, then the operation to create a new acceptance of goods is impossible.

5. Adding goods within one acceptance:
   * Only an authorized user of the system with the role of "pup employee" can add goods after its inspection.
   * In this case, the goods must be linked to the last unclosed acceptance of goods within the current pup.
   * If there is no new unclosed acceptance of goods, then in this case an error must be returned, and the goods must not be added to the system.
   * If the last acceptance of goods has not yet been closed, then the result must be linking the goods to the current pup and the current acceptance, followed by adding the data to the storage.

6. Removing goods within the framework of an unclosed acceptance:
   * Only an authorized user of the system with the role of "pup employee" can remove goods that were added within the framework of the current acceptance at the pup.
   * Removing goods is possible only before the acceptance is closed, after which it is no longer possible to change the composition of goods that were accepted at the pup.
   * Removing goods is performed according to the LIFO principle, i.e. it is possible to remove goods only in the order in which they were added within the framework of the current acceptance.

7. Closing the acceptance:
   * Only an authorized user of the system with the role of "pup employee" can close the acceptance of goods.
   * If the acceptance of goods has already been closed (or there has been no acceptance of goods at this pup yet), then an error should be returned.
   * In all other cases, it is necessary to update the data in the storage and record the goods that were within the framework of this acceptance.

8. Receiving data:
   * Only an authorized user of the system with the role of "pup employee" or "moderator" can receive this data.
   * It is necessary to obtain a list of pickup points and all information on them using pagination.
   * In this case, add a filter by the date of acceptance of goods, i.e. display only those pickup points and all information on them that received goods in the specified time range.

## General introduction

The entity pup has:
   * Unique identifier
   * Date of registration in the system
   * City

The entity "Reception of goods" has:
   * Unique identifier
   * Date and time of acceptance
   * RPPS where the acceptance was carried out
   * Goods that were accepted as part of this acceptance
   * Status (in_progress, close)

The entity "Product" has:
  * Unique identifier
  * Date and time of acceptance of goods (date and time when the goods were added to the system as part of the acceptance of goods)
  * Type (we work with three types of goods: electronics, clothing, shoes)