pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/access/Roles.sol";

contract AutomateDataPipelineNotifier {
    using Roles for address[];

    address private owner;
    address[] internal pipelineOperators;
    address[] internal notificationRecipients;

    mapping(address => bool) internal isOperator;
    mapping(address => bool) internal isRecipient;

    constructor() public {
        owner = msg.sender;
    }

    modifier onlyOwner {
        require(msg.sender == owner, "Only the owner can call this function.");
        _;
    }

    function addPipelineOperator(address _operator) public onlyOwner {
        require(!isOperator[_operator], "This address is already a pipeline operator.");
        pipelineOperators.push(_operator);
        isOperator[_operator] = true;
    }

    function removePipelineOperator(address _operator) public onlyOwner {
        require(isOperator[_operator], "This address is not a pipeline operator.");
        for (uint256 i = 0; i < pipelineOperators.length; i++) {
            if (pipelineOperators[i] == _operator) {
                pipelineOperators[i] = pipelineOperators[pipelineOperators.length - 1];
                pipelineOperators.pop();
                isOperator[_operator] = false;
                break;
            }
        }
    }

    function addNotificationRecipient(address _recipient) public onlyOwner {
        require(!isRecipient[_recipient], "This address is already a notification recipient.");
        notificationRecipients.push(_recipient);
        isRecipient[_recipient] = true;
    }

    function removeNotificationRecipient(address _recipient) public onlyOwner {
        require(isRecipient[_recipient], "This address is not a notification recipient.");
        for (uint256 i = 0; i < notificationRecipients.length; i++) {
            if (notificationRecipients[i] == _recipient) {
                notificationRecipients[i] = notificationRecipients[notificationRecipients.length - 1];
                notificationRecipients.pop();
                isRecipient[_recipient] = false;
                break;
            }
        }
    }

    function notifyPipelineStatusChange(string memory _status) public {
        for (uint256 i = 0; i < notificationRecipients.length; i++) {
            notify(notificationRecipients[i], _status);
        }
    }

    function notify(address _recipient, string memory _status) internal {
        // Implement your own notification logic here, e.g., using Web3.js and sending an HTTP request.
        // For demonstration purposes, we'll simply print the notification to the console.
        console.log("Notification sent to", _recipient, ":", _status);
    }
}