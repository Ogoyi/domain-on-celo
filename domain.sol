 // SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;
import { SafeMath } from "@openzeppelin/contracts/utils/math/SafeMath.sol";

interface IERC20Token {
   function transfer(address, uint256) external returns (bool);

    function approve(address, uint256) external returns (bool);

    function transferFrom(
        address,
        address,
        uint256
    ) external returns (bool);

    function totalSupply() external view returns (uint256);

    function balanceOf(address) external view returns (uint256);

    function allowance(address, address) external view returns (uint256);

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
}
contract DigitalAssetsMarketplace {
    using SafeMath for uint256;

    uint256 internal digitalAssetsLength = 0;
    address internal cUsdTokenAddress = 0x874069Fa1Eb16D44d622F2e0Ca25eeA172369bC1;

    struct DigitalAsset {
        address payable owner;
        string image;
        string brand;
        string name;
        string description;
        uint256 price;
    }

    mapping(uint256 => DigitalAsset) internal digitalAssets;

    function addDigitalAsset(
        string memory _image,
        string memory _brand,
        string memory _name,
        string memory _description,
        uint256 _price
    ) public {
        DigitalAsset storage asset = digitalAssets[digitalAssetsLength];
        asset.owner = payable(msg.sender);
        asset.image = _image;
        asset.brand = _brand;
        asset.name = _name;
        asset.description = _description;
        asset.price = _price;
        digitalAssetsLength++;
    }

    function getDigitalAsset(uint256 _index) public view returns (
        address payable,
        string memory,
        string memory,
        string memory,
        string memory,
        uint256
    ) {
        return (
            digitalAssets[_index].owner,
            digitalAssets[_index].image,
            digitalAssets[_index].brand,
            digitalAssets[_index].name,
            digitalAssets[_index].description,
            digitalAssets[_index].price
        );
    }

    function replaceDigitalAssetImage(uint256 _index, string memory _image) public {
        require(msg.sender == digitalAssets[_index].owner, "Only the owner can change the image");
        digitalAssets[_index].image = _image;
    }

    function buyDigitalAsset(uint256 _index) public payable {
        require(
            IERC20Token(cUsdTokenAddress).transferFrom(
                msg.sender,
                digitalAssets[_index].owner,
                digitalAssets[_index].price
            ),
            "Transfer failed."
        );

        digitalAssets[_index].owner = payable(msg.sender);
    }

    function getDigitalAssetsLength() public view returns (uint256) {
        return digitalAssetsLength;
    }
}