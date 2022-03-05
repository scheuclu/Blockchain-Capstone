// SPDX-License-Identifier: Unlicensed
pragma solidity 0.8.12;

import "./ERC721Mintable.sol";

//  TODO's: Create CustomERC721Token contract that inherits from the ERC721Metadata contract. You can name this contract as you please
//  1) Pass in appropriate values for the inherited ERC721Metadata contract
//      - make the base token uri: https://s3-us-west-2.amazonaws.com/udacity-blockchain/capstone/
//  2) create a public mint() that does the following:
//      -can only be executed by the contract owner
//      -takes in a 'to' address, tokenId, and tokenURI as parameters
//      -returns a true boolean upon completion of the function
//      -calls the superclass mint and setTokenURI functions
contract ScheucluHouseToken is ERC721Metadata {
    constructor()
        ERC721Metadata(
            "ScheucluHouseToken",
            "SHT",
            "https://s3-us-west-2.amazonaws.com/udacity-blockchain/capstone/"
        )
    {}

    function mint(address to, uint256 tokenId)
        public
        onlyOwner
        IsUnpaused
        returns (bool)
    {
        _mint(to, tokenId);
        setTokenURI(tokenId);
        return true;
    }
}
