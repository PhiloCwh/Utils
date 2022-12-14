// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;
import "@openzeppelin/contracts/utils/Base64.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";


contract SBT is ERC721, ERC721Burnable, Ownable{

    
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;
    using Base64 for bytes;
    using Strings for uint256;
    enum AttributeType {
    STRING, NUMBER
    }

    struct Attribute {
    bool isExist;
    AttributeType attrType;
    string traitType; 
    string displayType;
    string value;
    }
    //固定参数区
    string  public constant Name = "Soul Saving Plan";

    mapping(uint256 => bool) _isNember;

    string[] public attributeNames;
    mapping(uint256 => Attribute[]) public attributes;
    mapping(uint256 => string) public names;
    mapping(uint256 => string) public descriptions;
    mapping(uint256 => string) public images;
    mapping (address => uint256) public soulID;
    string[] public extraNames;
    mapping(uint256 => Attribute[]) public extras;
    string public baseImageUrl;
    string public suffix;
    

    constructor() ERC721(Name, "SSP") {}

    function granToNember(uint256 tokenId) public {
      require(balanceOf(msg.sender) == 1,"not sbt");
      require(ownerOf(tokenId) == msg.sender);
      _isNember[tokenId] = true;
      _tokenIdCounter.increment();
    }

    function isNember() public view returns(bool){
      return _isNember[soulID[msg.sender]];
    }



    function mintSBT(string memory name, string memory gender,string memory age, string memory description) public {
    
    //    putStringAttribute(tokenId, "Base", "Starfish");
    //    putStringAttribute(tokenId, "Eyes", "Big");
    //    putStringAttribute(tokenId, "Mouth", "Surprised");
      address dreamer = msg.sender;
      
      uint256 tokenId = _tokenIdCounter.current();
      _tokenIdCounter.increment();
      _safeMint(dreamer, tokenId);
      soulID[dreamer] = tokenId;
      
      //uint256 donateTime = block.timestamp;
      //putNumberAttribute(tokenId, "amount", Strings.toString(msg.value),"");
      //putNumberAttribute(tokenId, "donor", Strings.toHexString(donor),"");//关于json文档的一些问题
      //putNumberAttribute(tokenId, "donateTime", Strings.toString(donateTime),"");
      putStringAttribute(tokenId,"bindAddress",Strings.toHexString(dreamer));
      putStringAttribute(tokenId, "gender", gender);
      putNumberAttribute(tokenId, "age", age,"");
      
    //    putNumberAttribute(tokenId, "Stamina", "1.4","");
    //    putStringAttribute(tokenId, "Personality", "Sad");
    //    putNumberAttribute(tokenId, "Aqua Power", "40", "boost_number");
    //    putNumberAttribute(tokenId, "Stamina Increase", "10","boost_percentage");
      putNumberAttribute(tokenId, "Generation", "2","number");
       //putStringExtra(tokenId,"external_url","https://openseacreatures.io/3");
       setDescription(tokenId, description);
       setName(tokenId,name);
       putStringExtra(tokenId,"image",baseImageUrl);
    }

    function setBaseTokenId(uint _tokenId,string memory _baseImageUrl,string memory description,string memory name) public {
      uint256 tokenId = _tokenId;

      
      //uint256 donateTime = block.timestamp;
      //putNumberAttribute(tokenId, "amount", Strings.toString(msg.value),"");
      //putNumberAttribute(tokenId, "donor", Strings.toHexString(donor),"");//关于json文档的一些问题
      //putNumberAttribute(tokenId, "donateTime", Strings.toString(donateTime),"");
      //putStringAttribute(tokenId,"bindAddress",Strings.toHexString(dreamer));
      //putStringAttribute(tokenId, "gender", gender);
      //putNumberAttribute(tokenId, "age", age,"");
      
    //    putNumberAttribute(tokenId, "Stamina", "1.4","");
    //    putStringAttribute(tokenId, "Personality", "Sad");
    //    putNumberAttribute(tokenId, "Aqua Power", "40", "boost_number");
    //    putNumberAttribute(tokenId, "Stamina Increase", "10","boost_percentage");
      putNumberAttribute(tokenId, "Generation", "2","number");
       //putStringExtra(tokenId,"external_url","https://openseacreatures.io/3");
       setDescription(tokenId, description);
       setName(tokenId,name);
       putStringExtra(tokenId,"image",_baseImageUrl);
    }

    function resetDescription(string memory description) public {
      descriptions[soulID[msg.sender]] = description;
    }

    function resetImage(string memory imageURI) public {
        putStringExtra(soulID[msg.sender],"image",imageURI);
    }
    /**
     * 设置图片host url
     */
    function setBaseImageUrl(string memory _baseImageUrl) public onlyOwner{
      baseImageUrl = _baseImageUrl;
    }


    /**
     * 设置图片后缀名
     */


    /**
     * 设置属性名
     */
    function putAttributeName(string memory name) internal {
        attributeNames.push(name);
    }

    /**
     * 获取属性数组
     */
    function getAttributeNames() internal view returns (string[] memory) {
        return attributeNames;
    }

    /**
     * 设置描述
     */
    function setDescription(uint256 tokenId,string memory description) internal {
      descriptions[tokenId] = description;
    }

    /**
     * 获取描述
     */
    function getDescription(uint256 tokenId) public view returns(string memory){
      return descriptions[tokenId];
    }


    /**
     * 获取图片地址
     */


    /**
     * 设置名称
     */

    
    function setName(uint256 tokenId,string memory name) internal {
      names[tokenId] = name;//修改过
    }
    function setFixedName(uint256 tokenId) internal {
      names[tokenId] = Name;//修改过
    }

    /**
     * 获取名称
     */
    function getName(uint256 tokenId) public view returns(string memory){
      return names[tokenId];
    }

    /**
     * 根据属性名查找属性
     */
    function findAttribute(Attribute[] memory _attributes, string memory traitType) internal pure returns(Attribute memory attribute_, uint256 index_) {
      Attribute memory attribute;
      for(uint256 i = 0; i < _attributes.length; i++) {
          if(compareStrings(_attributes[i].traitType, traitType)){
            return (_attributes[i], i);
          } 
      }
      return (attribute, 0);
    }

    /**
     * 根据key查找数组是否已经存在
     */
    function isExist(string[] memory arr, string memory traitType) internal pure returns(bool isExist_, uint256 index_) {
      for(uint256 i = 0; i < arr.length;i++) {
        if(compareStrings(arr[i], traitType)) {
          return (true, i);
        }
      }
      return (false, 0);
    }

    /**
     * 增加字符串属性
     */
    function putStringAttribute(uint256 tokenId, string memory traitType, string memory value) public {
      putAttribute(tokenId, traitType, AttributeType.STRING,value,"");
    }

    /**
     * 增加数值属性
     */


    /**
     * 增加字符串拓展字段
     */
    function putStringExtra(uint256 tokenId, string memory traitType, string memory value) public {
      putExtra(tokenId, traitType, AttributeType.STRING,value,"");
    }

    /**
     * 增加数值拓展字段
     */
    function putNumberExtra(uint256 tokenId, string memory traitType,  string memory value,string memory displayType) public {
      putExtra(tokenId, traitType, AttributeType.NUMBER,value,displayType);
    }

    /**
     * 增加扩展字段
     */
    function putExtra(uint256 tokenId, string memory traitType, AttributeType attrType,string memory  value, string memory displayType) public {
        Attribute[] storage tokenIdExtras = extras[tokenId];
        (Attribute memory extra_, uint256 index_) = findAttribute(tokenIdExtras, traitType);
        if(extra_.isExist) {
            tokenIdExtras[index_].attrType = attrType;
            tokenIdExtras[index_].displayType = displayType;
            tokenIdExtras[index_].traitType = traitType;
            tokenIdExtras[index_].value = value;
        } else {
          extras[tokenId].push(Attribute({
            isExist: true,
            attrType: attrType,
            traitType: traitType,
            displayType: displayType,
            value: value
          }));

          (bool isExist_,) = isExist(extraNames, traitType);
          if(!isExist_) {
            extraNames.push(traitType);
          }
        }
    }

    /**
     * 获取扩展字段
     */
    function getExtra(uint256 tokenId, string memory key) public view returns (Attribute memory){
      (Attribute memory extra_,) = findAttribute(extras[tokenId], key);
      require(extra_.isExist, "Extra Not Found");
      return extra_;
    }

    function putAttribute(uint256 tokenId, string memory traitType, AttributeType attrType,string memory  value, string memory displayType) internal {
        Attribute[] storage tokenIdAttributes = attributes[tokenId];
        (Attribute memory attribute_, uint256 index_) = findAttribute(tokenIdAttributes, traitType);
        if(attribute_.isExist) {
            tokenIdAttributes[index_].attrType = attrType;
            tokenIdAttributes[index_].displayType = displayType;
            tokenIdAttributes[index_].traitType = traitType;
            tokenIdAttributes[index_].value = value;
        } else {
          attributes[tokenId].push(Attribute({
            isExist: true,
            attrType: attrType,
            traitType: traitType,
            displayType: displayType,
            value: value
          }));

          (bool isExist_,) = isExist(attributeNames, traitType);
          if(!isExist_) {
            attributeNames.push(traitType);
          }
        }
    }

    function putNumberAttribute(uint256 tokenId, string memory traitType,  string memory value,string memory displayType) public {
      putAttribute(tokenId, traitType, AttributeType.NUMBER,value,displayType);
    }    /**
     * 获取属性
     */
    function getAttribute(uint256 tokenId, string memory key) public view returns (Attribute memory){
      (Attribute memory attribute_,) = findAttribute(attributes[tokenId], key);
      require(attribute_.isExist, "Attribute Not Found");
      return attribute_;
    }

    /**
     * 比较字符串是否相等
     */
    function compareStrings(string memory a, string memory b) internal pure returns (bool) {
        return (keccak256(abi.encodePacked((a))) == keccak256(abi.encodePacked((b))));
    }

    /**
     * 获取metadata，返回base64
     */
    function tokenURI(uint256 tokenId) public override(ERC721) view returns (string memory) {
        string memory metadata = string(abi.encodePacked(
            "{",
            "\"name\":\"",names[tokenId], "\",",
            "\"image\":\"",images[tokenId], "\",",
            "\"description\":\"",descriptions[tokenId], "\",",
            getExtraMetadata(tokenId), "," ,
            "\"attributes\":", getAttributeMetaData(tokenId), 
            "}"
        ));
        return string(abi.encodePacked(
            "data:application/json;base64,",
            bytes(metadata).encode()
        ));

    }
  //获取拼接属性
      function tokenURITest(uint256 tokenId,uint tokenIdtwo) public  view returns (string memory) {
        string memory metadata = string(abi.encodePacked(
            "{",
            "\"name\":\"",names[tokenId], "\",",
            "\"image\":\"",images[tokenId], "\",",
            "\"description\":\"",descriptions[tokenId], "\",",
            getExtraMetadata(tokenId), "," ,
            "\"attributes\":", getAttributeMetaDataTest(tokenId,tokenIdtwo), 
            "}"
        ));
        return string(abi.encodePacked(
            "data:application/json;base64,",
            bytes(metadata).encode()
        ));

    }

    /**
     * 获取属性的json字符串
     */
    function getJSONString(Attribute memory attribute) internal pure returns(string memory){
      string memory value;
      if(attribute.attrType == AttributeType.STRING) {
        value = string(abi.encodePacked("\"value\":\"",attribute.value, "\""));
      } else {
        value = string(abi.encodePacked("\"value\":",attribute.value));
      }

      return string(abi.encodePacked(
        "{",
        compareStrings(attribute.displayType, "") ? "" : string(abi.encodePacked("\"display_type\":\"",attribute.displayType, "\",")),
        "\"trait_type\":\"",attribute.traitType, "\",",
        value,
        "}"
      ));
    }

    function getJSONStringTest(string memory trait_type,string memory value) public view returns(string memory){
      /*string memory value;
      if(attribute.attrType == AttributeType.STRING) {
        value = string(abi.encodePacked("\"value\":\"",attribute.value, "\""));
      } else {
        value = string(abi.encodePacked("\"value\":",attribute.value));
      }
      */
        value = string(abi.encodePacked("\"value\":\"",value, "\""));
      return string(abi.encodePacked(
        "{",
        "\"trait_type\":\"",trait_type, "\",",
        value,
        "}"
      ));
    }

    /**
     * 获取扩展字段的json字符串
     */
    function getExtraMetadata(uint256 tokenId) internal view returns (string memory) {
          bytes memory output;
        for(uint256 i = 0; i < extraNames.length; i++) {
            Attribute memory attribute = getExtra(tokenId,extraNames[i]);
            output = abi.encodePacked(output, abi.encodePacked(getExtraJSON(attribute)));
            if(i != extraNames.length - 1 && extraNames.length != 1) {
                output = abi.encodePacked(output, ",");
            }
        }
        return string(output);
    }

    /**
     * 获取单个扩展字段的json字符串
     */
    function getExtraJSON(Attribute memory attribute) internal pure returns (string memory) {
      string memory value;
      if(attribute.attrType == AttributeType.STRING) {
        value = string(abi.encodePacked("\"",attribute.value, "\""));
      } else {
        value = string(abi.encodePacked(attribute.value));
      }

      return string(abi.encodePacked(
        "\"", attribute.traitType, "\":",
        value
      ));
    }

    /**
     * 获取单个属性的json字符串
     */
    function getAttributeMetaData(uint256 tokenId) public view returns (string memory) {
        bytes memory output;
        output = abi.encodePacked("[");
        for(uint256 i = 0; i < attributeNames.length; i++) {
            Attribute memory attribute = getAttribute(tokenId,attributeNames[i]);
            output = abi.encodePacked(output, abi.encodePacked(getJSONString(attribute)));
            if(i != attributeNames.length - 1 && attributeNames.length != 1) {
                output = abi.encodePacked(output, ",");
            }
        }
        output = abi.encodePacked(output,"]");
        return string(output);
    }
    function getAttributeMetaDataTest(uint256 tokenId, uint256 tokenIdtwo) public view returns (string memory) {
        bytes memory output;
        output = abi.encodePacked("[");
        for(uint256 i = 0; i < attributeNames.length; i++) {
            Attribute memory attribute = getAttribute(tokenId,attributeNames[i]);
            output = abi.encodePacked(output, abi.encodePacked(getJSONString(attribute)));
            if(i != attributeNames.length - 1 && attributeNames.length != 1) {
                output = abi.encodePacked(output, ",");
            }
            
        }
        output = abi.encodePacked(output, ",");

        for(uint256 i = 0; i < attributeNames.length; i++) {
            Attribute memory attribute = getAttribute(tokenIdtwo,attributeNames[i]);
            output = abi.encodePacked(output, abi.encodePacked(getJSONString(attribute)));
            if(i != attributeNames.length - 1 && attributeNames.length != 1) {
                output = abi.encodePacked(output, ",");
            }
        }


        output = abi.encodePacked(output,"]");
        return string(output);
    }






}
