// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SimpleLottery {
    // Contract owner's address
    address public owner;
    // Price of each lottery ticket in wei
    uint256 public ticketPrice;
    // Total number of tickets sold for the current draw
    uint256 public ticketCount;
    // Current draw number
    uint256 public drawNumber;
    // Mapping of ticket numbers to buyer addresses
    mapping(uint256 => address) public tickets;
    // Flag to check if the draw has been conducted
    bool public drawConducted;

    // Event emitted when a ticket is purchased
    event TicketPurchased(address buyer, uint256 ticketNumber);
    // Event emitted when a winner is selected
    event WinnerSelected(address winner, uint256 amount);

    // Constructor to initialize the lottery
    constructor(uint256 _ticketPrice) {
        owner = msg.sender;
        ticketPrice = _ticketPrice;
        drawNumber = 1;
    }

    // Modifier to restrict function access to the owner only
    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    // Function to buy a lottery ticket
    function buyTicket() public payable {
        // Check if the sent amount matches the ticket price
        require(msg.value == ticketPrice, "Incorrect ticket price");
        // Ensure the draw hasn't been conducted yet
        require(!drawConducted, "Draw already conducted");

        // Increment ticket count and assign the ticket to the buyer
        ticketCount++;
        tickets[ticketCount] = msg.sender;

        // Emit event for ticket purchase
        emit TicketPurchased(msg.sender, ticketCount);
    }

    // Function to conduct the lottery draw
    function conductDraw() public onlyOwner {
        // Ensure at least one ticket has been sold
        require(ticketCount > 0, "No tickets sold");
        // Check that the draw hasn't been conducted yet
        require(!drawConducted, "Draw already conducted");

        // Generate a winning ticket number
        uint256 winningNumber = generateRandomNumber() % ticketCount + 1;
        // Get the winner's address
        address winner = tickets[winningNumber];
        // Calculate the prize amount (entire contract balance)
        uint256 prizeAmount = address(this).balance;

        // Mark the draw as conducted
        drawConducted = true;
        // Transfer the prize to the winner
        payable(winner).transfer(prizeAmount);

        // Emit event for winner selection
        emit WinnerSelected(winner, prizeAmount);

        // Reset for the next draw
        ticketCount = 0;
        drawNumber++;
        drawConducted = false;
    }

    // Function to generate a pseudo-random number
    // Note: This method is not secure for production use
    function generateRandomNumber() private view returns (uint256) {
        return uint256(keccak256(abi.encodePacked(block.timestamp, block.difficulty, ticketCount)));
    }

    // Function to get the current balance of the contract
    function getContractBalance() public view returns (uint256) {
        return address(this).balance;
    }
}
