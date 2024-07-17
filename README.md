# Key components of this contract:

## State Variables:

- owner: The address of the contract owner.
- ticketPrice: The price of each lottery ticket.
- ticketCount: The number of tickets sold.
- drawNumber: The current draw number.
- tickets: A mapping of ticket numbers to buyer addresses.
- drawConducted: A boolean to check if the draw has been conducted.


## Events:

- TicketPurchased: Emitted when a ticket is purchased.
- WinnerSelected: Emitted when a winner is selected.


## Constructor:

Sets the owner and ticket price.


## Functions:

- buyTicket(): Allows users to buy a ticket.
- conductDraw(): Conducts the lottery draw (only callable by the owner).
- generateRandomNumber(): Generates a pseudo-random number for the draw.
- getContractBalance(): Returns the current balance of the contract.


# To use this contract:

1.  Deploy the contract, specifying the ticket price in wei (I recomend you Vottun APIs for deploying this contract).
2. Users can call buyTicket() with the correct amount of Ether to purchase tickets.
3.  Once enough tickets are sold, the owner can call conductDraw() to select a winner.
4.  The winner receives the entire balance of the contract.
The contract resets for the next draw.

Note: This is a basic implementation and has some limitations:

The random number generation is not truly random and could potentially be manipulated by miners.
There's no time limit for the draw, so the owner controls when it happens.
There's no limit on the number of tickets a single address can buy.

For a production-ready lottery, you'd want to address these issues and addmore features like time limits, ticket limits per address, and a more secure random number generation method (like Chainlink VRF).
