//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract ERC721 {

    string private _name;
    string private _symbol;

    mapping(uint256 => address) public _owners;
    mapping(address => uint256) public _balances;
    mapping(uint256 => address) public _tokenApprovals;
    mapping(address => mapping(address => bool)) public _operatorApprovals;

    event Transfer(address indexed _from, address indexed _to, uint256 indexed _tokenId);
    event Approval(address indexed _owner, address indexed _approved, uint256 indexed _tokenId);
    event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);

     constructor(string memory name_, string memory symbol_) {
        _name = name_;
        _symbol = symbol_;
    }

    function name() external view returns(string memory) {
        return _name;
    }

    function symbol() external view returns(string memory) {
        return _symbol;
    }

    function balanceOf(address _owner) external view returns (uint256) {
        require(_owner != address(0), "Address 0 can't be a valid Owner address");
        return _balances[_owner];
    }

    function ownerOf(uint256 _tokenId) public view returns (address) {
        address owner = _owners[_tokenId];
        require(owner != address(0), "Nonexistent token");
        return owner;
    }

    function _exists(uint256 _tokenId) internal view returns (bool) {
        return _owners[_tokenId] != address(0);
    }

    function mint(address _to, uint256 _tokenId) public {
        require(_to != address(0), "Mint to the zero address");
        require(!_exists(_tokenId), "Token is already minted");

        _balances[_to] += 1;
        _owners[_tokenId] = _to;

        emit Transfer(address(0), _to, _tokenId);
    }

    function transferFrom(address _from, address _to, uint256 _tokenId) public payable {
        require(ownerOf(_tokenId) == _from, "Transfer from incorrect owner");
        require(_to != address(0), "Transfer to the zero address");

        approve(address(0), _tokenId);

        _balances[_from] -= 1;
        _balances[_to] += 1;
        _owners[_tokenId] = _to;

        emit Transfer(_from, _to, _tokenId);
    }

    function safeTransferFrom(address _from, address _to, uint256 _tokenId) external payable {
        address tokenOwner = _owners[_tokenId];
        require(tokenOwner == _from, "Not Owner");
        require(_to != address(0), "Zero Adderess");

        transferFrom(_from, _to, _tokenId);
    }

       function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes memory data) external payable {
        address tokenOwner = _owners[_tokenId];
        require(tokenOwner == _from, "Not called by the Owner");
        require(_to != address(0), "Zero Adderess");

        transferFrom(_from, _to, _tokenId);
        // incomplete
    }


    function approve(address _approved, uint256 _tokenId) public payable {
        address owner = ownerOf(_tokenId);
        require(_approved != owner, "Approval to current owner");
        require(msg.sender == owner || isApprovedForAll(owner,msg.sender),
            "Approve caller is not owner nor approved for all"
        );

        _tokenApprovals[_tokenId] = _approved;
        emit Approval(ownerOf(_tokenId), _approved, _tokenId);
    }

    function setApprovalForAll(address _operator, bool _approved) external {
         require(msg.sender != _operator, "ERC721: approve to caller");
        _operatorApprovals[msg.sender][_operator] = _approved;
        emit ApprovalForAll(msg.sender, _operator, _approved);
    }

    function getApproved(uint256 _tokenId) external view returns (address) {
        require(_exists(_tokenId), "ERC721: approved query for nonexistent token");
        return _tokenApprovals[_tokenId];
    }

    function isApprovedForAll(address _owner, address _operator) public view returns (bool) {
        return _operatorApprovals[_owner][_operator];
    }

}