// SPDX-License-Identifier: MIT

pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./Base64.sol";

contract OnChainNft is ERC721Enumerable, Ownable {
  using Strings for uint256;

  constructor() ERC721("On Chain NFT", "OCN") {}

  // public
  function mint() public payable {
    uint256 supply = totalSupply();
    require(supply + 1 <= 10000);

    if (msg.sender != owner()) {
      require(msg.value >= 0.05 ether);
    }

    _safeMint(msg.sender, supply + 1);
  }

  function buildImage() public pure returns(string memory) {
      return Base64.encode(bytes(abi.encodePacked(
        '<svg viewBox="0 0 10 10" xmlns="http://www.w3.org/2000/svg">',
        '<rect width="10" height="10">',
        '<animate attributeName="rx" values="0;5;0" dur="10s" repeatCount="indefinite" />',
        '</rect>',
        '</svg>'
        )));
  }

  function tokenURI(uint256 tokenId)
    public
    view
    virtual
    override
    returns (string memory)
  {
    require(
      _exists(tokenId),
      "ERC721Metadata: URI query for nonexistent token"
    );

    return string(abi.encodePacked(
        'data:application/json;base64,', Base64.encode(bytes(abi.encodePacked(
            '{"name":"',
            "REPLACE",
            '", "description":"',
            "REPLACE",
            '", "image_data": "',
            'data:image/svg+xml;base64,',
            buildImage(),
            '"}')))));
  }

}
