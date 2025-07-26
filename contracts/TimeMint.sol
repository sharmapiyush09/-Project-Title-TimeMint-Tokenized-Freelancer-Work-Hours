// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract TimeMint is Ownable { 
    IERC20 public paymentToken;

    struct WorkSession { 
        uint256 startTime;
        uint256 endTime;
        uint256 hoursWorked;
        uint256 ratePerHour;
        bool isPaid;
    }

    mapping(address => WorkSession[]) public workSessions;

    event WorkSessionLogged(address indexed freelancer, uint256 startTime, uint256 endTime, uint256 hoursWorked, uint256 ratePerHour);
    event PaymentMade(address indexed freelancer, uint256 amount);

    constructor(IERC20 _paymentToken) Ownable(msg.sender) {
        paymentToken = _paymentToken;
    }

    function logWorkSession(uint256 startTime, uint256 endTime, uint256 ratePerHour) external {
        require(endTime > startTime, "End time must be after start time");
        uint256 hoursWorked = (endTime - startTime) / 1 hours;
        require(hoursWorked > 0, "Session must be at least 1 hour");

        workSessions[msg.sender].push(WorkSession({
            startTime: startTime,
            endTime: endTime,
            hoursWorked: hoursWorked,
            ratePerHour: ratePerHour,
            isPaid: false
        }));

        emit WorkSessionLogged(msg.sender, startTime, endTime, hoursWorked, ratePerHour);
    }

    function payFreelancer(address freelancer, uint256 sessionIndex) external onlyOwner {
        WorkSession storage session = workSessions[freelancer][sessionIndex];
        require(!session.isPaid, "Session already paid");

        uint256 paymentAmount = session.hoursWorked * session.ratePerHour;
        require(paymentAmount > 0, "No payment due");

        paymentToken.transfer(freelancer, paymentAmount);
        session.isPaid = true;

        emit PaymentMade(freelancer, paymentAmount);
    }
}
