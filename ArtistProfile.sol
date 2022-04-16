// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract ArtistProfile {

    string artistName;
    address artistAddress;
    
    constructor(string memory _artistName) {
        artistName = _artistName;
        artistAddress = msg.sender;
    }

    function deposit() public payable {
        
    }

    receive() external payable {
        deposit();

    }

    function balance() public view returns(uint) {
        return address(this).balance;
    }
}
