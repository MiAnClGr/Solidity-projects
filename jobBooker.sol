// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract JobBooker {

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

    mapping(uint => Job) public Jobs;
    
    enum jobState {created, begun, finalised, paid}

    uint jobNumber = 0;
    uint public rate = 10000000000000000;

    constructor(address _owner) {
        owner = _owner;
    }

    function createJob(string memory _contractName, address _client) public {
        Job storage job = Jobs[jobNumber];
        jobNumber ++;

        //job.cost = _cost;
        job.contractName = _contractName;
        job.client = _client;
        job.state = jobState.created;
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
        require(msg.value == job.cost, "incorrect payment");
        require(msg.sender == job.client);
        require(job.state == jobState.finalised);
        job.paid = true;
        job.state = jobState.paid;

        payable(owner).transfer(address(this).balance);
    }


}

contract jobBookerFactory {

    mapping(address => JobBooker) public owners;

     function createJobBooker() public {
        JobBooker jobBooker = new JobBooker(msg.sender);
        owners[msg.sender] = jobBooker;
    }
}