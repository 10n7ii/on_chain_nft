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
          '<svg width="200" height="220" xmlns="http://www.w3.org/2000/svg">',
          '<text fill="#000000" stroke="#000" stroke-width="0" x="232.98438" y="207" id="svg_2" font-size="24" font-family="Noto Sans JP" text-anchor="start" xml:space="preserve">Hello World</text>',
          '<text transform="matrix(2.37335 0 0 1.02786 -348.314 -3.69223)" stroke="#000" xml:space="preserve" text-anchor="start" font-family="Noto Sans JP" font-size="24" stroke-width="0" id="svg_3" y="115.18972" x="149.57865" fill="#000000">katana</text>',
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
            '", "image": "',
            'data:image/svg+xml;base64,',
            buildImage(),
            '"}')))));
  }

}
