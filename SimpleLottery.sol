// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SimpleLottery {
    address public owner;
    uint256 public ticketPrice;
    uint256 public ticketCount;
    uint256 public drawNumber;
    mapping(uint256 => address) public tickets;
    bool public drawConducted;

    event TicketPurchased(address buyer, uint256 ticketNumber);
    event WinnerSelected(address winner, uint256 amount);

    constructor(uint256 _ticketPrice) {
        owner = msg.sender;
        ticketPrice = _ticketPrice;
        drawNumber = 1;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    function buyTicket() public payable {
        require(msg.value == ticketPrice, "Incorrect ticket price");
        require(!drawConducted, "Draw already conducted");

        ticketCount++;
        tickets[ticketCount] = msg.sender;

        emit TicketPurchased(msg.sender, ticketCount);
    }

    function conductDraw() public onlyOwner {
        require(ticketCount > 0, "No tickets sold");
        require(!drawConducted, "Draw already conducted");

        uint256 winningNumber = generateRandomNumber() % ticketCount + 1;
        address winner = tickets[winningNumber];
        uint256 prizeAmount = address(this).balance;

        drawConducted = true;
        payable(winner).transfer(prizeAmount);

        emit WinnerSelected(winner, prizeAmount);

        // Reset for next draw
        ticketCount = 0;
        drawNumber++;
        drawConducted = false;
    }

    function generateRandomNumber() private view returns (uint256) {
        return uint256(keccak256(abi.encodePacked(block.timestamp, block.difficulty, ticketCount)));
    }

    function getContractBalance() public view returns (uint256) {
        return address(this).balance;
    }
}
