// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "./ArtistProfile.sol";


contract CreateArtist {

    mapping(string => address) public ArtistbyName;
    mapping(address => string) public ArtistbyAddress;
    uint artistNumber = 1;


    
    function createArtist(string memory _artistName) public {
        ArtistProfile artistProfile = new ArtistProfile(_artistName);
        ArtistbyName[_artistName] = address(artistProfile);
        ArtistbyAddress[address(artistProfile)] = _artistName;

    }



    function findArtistAddress(address _artist) public view returns(string memory) { 
        return ArtistbyAddress[_artist];

    }

}
