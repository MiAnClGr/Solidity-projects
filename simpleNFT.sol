// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

interface IERC721Metadata {
  
    function name() external view returns (string memory);
    function symbol() external view returns (string memory);
    //function tokenURI(uint256 tokenId) external view returns (string memory);
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

    event Transfer(address indexed _from, address indexed _to, uint256 indexed _tokenId);
    event Approval(address indexed _owner, address indexed _approved, uint256 indexed _tokenId);
    event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);


}

contract simpleNFT is IERC721Metadata, IERC721Enumerable, ERC721Interface {

    string override public name;
    string override public symbol;

    uint override public totalSupply;

    uint[] public allTokens;

    mapping(address => uint[]) public ownedTokens;
    
    mapping(uint => uint) public tokensByIndex;
    uint tokenIndex = 0;

    mapping(uint => address) public tokenOwnersByIndex;

    mapping(uint => string) public tokenURIs;

    mapping(address => uint) public balances;

    mapping(uint => address) public owners;

    mapping(uint => address) approved;

    mapping(address => mapping(address => bool)) private operatorApprovals;

    constructor(string memory _name, string memory _symbol, uint _totalSupply){
        _name = name;
        _symbol = symbol;
        _totalSupply = totalSupply;

    }

    function mint(address _to, uint _tokenId) public {
        require((allTokens.length - 1) < totalSupply);
        require(owners[_tokenId] == address(0));

        balances[_to] += 1;
        owners[_tokenId] = _to;
        allTokens.push(_tokenId);

        tokenIndex ++;
    }

    function tokenByIndex(uint _index) override public view returns(uint) {
        return tokensByIndex[_index];
    }

    function tokenOfOwnerByIndex(address _owner, uint _index) override public view returns(uint) {
        return ownedTokens[_owner][_index];
    }

    // function tokenURI(uint _tokenId) override public view returns(string memory) {
    //     tokenURIs[_tokenId];
    // }

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

        operatorApprovals[msg.sender][_operator] = _approved;
    }

    function getApproved(uint _tokenId) override public view returns(address) {
        return approved[_tokenId];
    }

    function isApprovedForAll(address _owner, address _operator) override public view returns(bool) {
        return operatorApprovals[_owner][_operator];
    }

    
}
