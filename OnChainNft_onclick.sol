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
        '<svg width="220" height="220" id="test_1" version="1.1" xmlns="http://www.w3.org/2000/svg">',
        '<g transform="translate(4,4)" onclick="scaleEvent(this)">',
        '<rect x="0" y="0" width="100" height="100" fill="skyblue" stroke="blue" stroke-width="4"></rect>',
        '<rect x="0" y="0" width="60" height="60" fill="tomato" rx="8" ry="8" transform="translate(20 20)"></rect>',
        '</g>',
        '<script>',
        'function scaleEvent(elm){if(elm.getAttribute("data-flg")){elm.setAttribute("transform" , "translate(4,4)");elm.removeAttribute("data-flg");}',
        'else{elm.setAttribute("transform" , "translate(4,4) scale(2)");elm.setAttribute("data-flg" , "1");}}',
        '</script>',
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
