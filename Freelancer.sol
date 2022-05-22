// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Freelancer {

    address public owner;

    struct Job {
        uint cost;
        uint timeBegun;
        uint clockStart;
        uint clockEnd;
        string contractName;
        address client;
        bool completed;
        bool paid;
        jobState state;
        uint timeClocked;
    }
    
    event jobCreated (string contractName, address client, uint ticketNo);

    mapping(uint => Job) public Jobs;

    mapping(address => Job) public jobByAddress;

    mapping(string => Job) public jobByName;
    
    enum jobState {created, begun, finalised, paid}

    uint jobNumber = 0;
    uint public rate = 10000000000000000;
    address public factoryAddress;
    
    constructor(address _owner) {
        owner = _owner;
        factoryAddress = msg.sender;
    }

    function createJob(string memory _contractName, address _client) public {
        Job storage job = Jobs[jobNumber];
       
        job = jobByAddress[_client];
        job = jobByName[_contractName];
        //job.cost = _cost;
        job.contractName = _contractName;
        job.client = _client;
        job.state = jobState.created;

                
        emit jobCreated(_contractName, _client, jobNumber);
        
        jobNumber ++;
    }

    function jobClockStart(uint _jobNumber) public {
        Job storage job = Jobs[_jobNumber];
        job.clockStart = block.timestamp;
    }

    function jobClockEnd(uint _jobNumber) public {
        Job storage job =Jobs[_jobNumber];
        job.clockEnd = block.timestamp;
        uint timeWorked = (job.clockEnd) - (job.clockStart);
        job.timeClocked += timeWorked;
        job.cost += (timeWorked * rate) / 3600;
    }

    function finaliseJob(uint _jobNumber) public {
        Job storage job = Jobs[_jobNumber];
        job.completed = true;
        job.state = jobState.finalised;
    }

    function payJob(uint _jobNumber) public payable {
        Job storage job = Jobs[_jobNumber];
        // require(msg.value == job.cost, "incorrect payment");
        // require(msg.sender == job.client);
        // require(job.state == jobState.finalised);
        job.paid = true;
        job.state = jobState.paid;

        // uint fee = msg.value/1000;
        //payable(factoryAddress).transfer(fee);
        payable(owner).transfer(address(this).balance);
    }


}

contract freelancerFactory {

    mapping(address => Freelancer) public owners;

     function createFreelancer() public {
        Freelancer freelancer = new Freelancer(msg.sender);
        owners[msg.sender] = freelancer;
    }

    function balance() public view returns(uint) {
        return address(this).balance;
    }
    
    receive() external payable {
    }
}
