// SPDX-License-Identifier: Unlicensed
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

error cannotMint();
error insufficientFund(uint256 ETHAmount);
error txFailed();
error notTokenOwner(address sender);

contract Rfart is ERC721, Ownable {
// EVENTS

    event NewMintPrice(uint256 newPrice);

// STORAGE

    uint256 public constant MAX_MINT = 3;

    uint256 private mintPrice;
    uint256 private totalSupply;
    uint256 private minted;
    bool private mintIsAllowed;
    mapping(address => uint256) private accountMinted;

    // Set initial mintPrice and create the RFA token
    constructor(uint256 _mintPrice) ERC721("Rfart", "RFA") {
        mintPrice = _mintPrice;
        mintIsAllowed = true;
    }

// VIEW FUNCTIONS

    function getTotalSupply() external view returns(uint256) {
        return totalSupply;
    }
    function getMintPrice() public view returns(uint256) {
        return mintPrice;
    }

    function getMintStatus() public view returns(bool) {
        return mintIsAllowed;
    }
    
    function enableToMint(address _account) public view returns(uint256 mintAllowed_) {
        if(!mintIsAllowed) mintAllowed_ = 0;
        uint256 _minted = accountMinted[_account];
        if(minted < MAX_MINT) mintAllowed_ = MAX_MINT - _minted;
    }

// OWNER/INTERNAL FUNCTIONS

    // Set the max number of mint allowed
    function setMintAllowed(bool _allowed) external onlyOwner {
        mintIsAllowed = _allowed;
    }

    // set the mint price. It's possible to set it to 0
    function setMintPrice(uint256 _newPrice) external onlyOwner {
        mintPrice = _newPrice;
        emit NewMintPrice(_newPrice);
    }

    // withdraw all the eth in this contract from selling the token
    function withdrawETH() external onlyOwner {
        (bool success, ) = owner().call{value: address(this).balance} ("");
        if(!success) revert txFailed();
    }

    function _baseURI() internal pure override returns (string memory) {
        return "";
    }

// PUBLIC FUNCTIONS
    // Buy the NFT 
    function mint() public payable {
        if(msg.value < mintPrice) revert insufficientFund(msg.value);

        if(enableToMint(msg.sender) == 0) revert cannotMint();
        ++accountMinted[msg.sender];
        ++totalSupply;

        uint256 _tokenId = ++minted;
        _safeMint(msg.sender, _tokenId);

    }

    // Burn the NFT
    // It doesn't decrease the accountMinted per account
    function burn(uint256 _tokenId) external {
        if(!_isApprovedOrOwner(msg.sender, _tokenId)) revert notTokenOwner(msg.sender);

        --totalSupply;
        _burn(_tokenId);
    }
    
    // Call mint() function if caller sent eth directly to the contract
    receive() external payable {
        mint();
    }

}