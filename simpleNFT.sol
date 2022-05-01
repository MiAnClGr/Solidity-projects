// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

interface IERC721Metadata is IERC721 {
  
    function name() external view returns (string memory);
    function symbol() external view returns (string memory);
    function tokenURI(uint256 tokenId) external view returns (string memory);
}

interface IERC721Enumerable {
   
    function totalSupply() external view returns (uint256);
    function tokenByIndex(uint256 _index) external view returns (uint256);
    function tokenOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256);
}


interface ERC721Interface {

    function balanceOf(address _owner) external view returns (uint256);
    function ownerOf(uint256 _tokenId) external view returns (address);
    // function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes data) external payable;
    // function safeTransferFrom(address _from, address _to, uint256 _tokenId) external payable;
    function transferFrom(address _from, address _to, uint256 _tokenId) external payable;
    function approve(address _approved, uint256 _tokenId) external payable;
    function setApprovalForAll(address _operator, bool _approved) external;
    function getApproved(uint256 _tokenId) external view returns (address);
    function isApprovedForAll(address _owner, address _operator) external view returns (bool);

}

contract simpleNFT is ERC721Interface {

    string override public name;
    string override public symbol;
    uint public totalSupply;

    address public owner;

    mapping(address => uint) public balances;

    mapping(uint => address) public owners;

    mapping(uint => address) approved;

    mapping(address => mapping(address => bool)) private operatorApprovals;

    constructor(){

    }

    function tokenURI(uint _tokenId) public view returns(string memory) {

    }

    function balanceOf(address _owner) override public view returns(uint) {
        return balances[_owner];
    } 

    function ownerOf(uint _tokenId) override public view returns(address) {
        return owners[_tokenId];
    }

    function transferFrom(address _from, address _to, uint _tokenId) override public payable {
        require(_from == msg.sender || approved[_tokenId] == _from);
        require(owners[_tokenId] == _from);
        require(_from != address(0));
        require(_to != address(0));
        

        balances[_from] -= 1;
        balances[_to] += 1;
        owners[_tokenId] = _to;
    }

    function approve(address _approved, uint _tokenId ) override public payable {
        require(owners[_tokenId] == msg.sender);
        require(owners[_tokenId] != address(0));

        approved[_tokenId] = _approved;
    }

    function setApprovalForAll(address _operator, bool _approved) override public {
        require(msg.sender != _operator);

        operatorApprovals[msg.sender][_operator] = true;
    }

    function getApproved(uint _tokenId) override public view returns(address) {
        return approved[_tokenId];
    }

    function isApprovedForAll(address _owner, address _operator) override public view returns(bool) {
        return operatorApprovals[_owner][_operator];
    }

    
}
