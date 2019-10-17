pragma solidity ^0.5.11;

contract CampaignFactory {
    address[] public deployedCampaigns;

    function createCampaign(uint minimum) public {
        deployedCampaigns.push(
            address(new Campaign(minimum, msg.sender))
        );
    }

    function getDeployedCampaigns() public view returns (address[] memory) {
        return deployedCampaigns;
    }
}

contract Campaign {
    struct Request {
        string description;
        uint value;
        address payable recipient;
        bool complete;
        uint approvalCount;
        mapping(address => bool) approvals;
    }

    Request[] public requests;
    address public manager;
    uint public minimumContribution;
    mapping(address => bool) public approvers;
    uint public approversCount;

    modifier restricted() {
        require(msg.sender == manager, "Only manager can call");
        _;
    }

    constructor (uint minimum, address creator) public {
        manager = creator;
        minimumContribution = minimum;
    }

    function contribute() public payable {
        require(
            msg.value > minimumContribution,
            'Minimum contribution required'
        );

        approvers[msg.sender] = true;
        approversCount++;
    }

    function createRequest(
        string memory description, uint value,
        address payable recipient
        ) public restricted {
        require(
            approvers[msg.sender],
            'Sender did not contribute to the campaign.'
        );
        Request memory newRequest = Request({
           description: description,
           value: value,
           recipient: recipient,
           complete: false,
           approvalCount: 0
        });
        requests.push(newRequest);
    }

    function approveRequest(uint index) public {
        Request storage request = requests[index];

        require(
            approvers[msg.sender],
            'Sender did not contribute'
        );
        require(
            !request.approvals[msg.sender],
            "Sender already voted for this Request"
        );

        request.approvals[msg.sender] = true;
        request.approvalCount++;
    }

    function finalizeRequest(uint index) public restricted {
        Request storage request = requests[index];

        require(
            !request.complete,
            "This request has been already completed!"
        );
        require(
            request.approvalCount > (approversCount / 2),
            "At least half of the approvers needs."
        );

        request.recipient.transfer(request.value);
        request.complete = true;
    }

    function getSummary() public view returns (
        uint, uint, uint, uint, address
        ) {
        return (
            minimumContribution,
            address(this).balance,
            requests.length,
            approversCount,
            manager
        );
    }

    function getRequestCount() public view returns (uint) {
        return requests.length;
    }
}