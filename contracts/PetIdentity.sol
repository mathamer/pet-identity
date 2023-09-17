// SPDX-License-Identifier: MIT 

pragma solidity ^0.8.18;

contract PetIdentity {
    struct Pet {
        string name;
        string breed;
        uint256 age;
        address owner;

        string healthRecords; // IPFS hash
        string image; // IPFS hash

        bool isLost;
        bool isFound;
    }

    mapping(uint256 => Pet) public pets;
    uint256 public petsCount;

    event PetAdded(uint256 id, string name, string breed, uint256 age, address owner);
    event PetOwnershipTransferred(uint256 id, address oldOwner, address newOwner);

    function addPet(string memory _name, string memory _breed, uint256 _age, string memory _healthRecords, string memory _image) public {
        require(bytes(_name).length > 0, "Name cannot be empty");
        require(bytes(_breed).length > 0, "Breed cannot be empty");

        petsCount++;
        pets[petsCount] = Pet(_name, _breed, _age, msg.sender, _healthRecords, _image, false, false);
        emit PetAdded(petsCount, _name, _breed, _age, msg.sender);
    }

    function getPet(uint256 _id) public view returns (Pet memory) {
        require(_id > 0 && _id <= petsCount, "Invalid pet ID");

        Pet storage pet = pets[_id];
        Pet memory petInfo;
        petInfo.name = pet.name;
        petInfo.breed = pet.breed;
        petInfo.age = pet.age;
        petInfo.owner = pet.owner;
        petInfo.healthRecords = pet.healthRecords;
        petInfo.image = pet.image;
        petInfo.isLost = pet.isLost;
        petInfo.isFound = pet.isFound;
        return petInfo;
    }

    function getPetCount() public view returns (uint256) {
        return petsCount;
    }

    function updatePetInformation(uint256 _id, string memory _name, string memory _breed, uint256 _age, string memory _healthRecords, string memory _image) public {
        require(pets[_id].owner == msg.sender, "You are not the owner of this pet");

        pets[_id].name = _name;
        pets[_id].breed = _breed;
        pets[_id].age = _age;
        pets[_id].healthRecords = _healthRecords;
        pets[_id].image = _image;
    }

    function transferOwnership(uint256 _id, address _newOwner) public {
        require(pets[_id].owner == msg.sender, "You are not the owner of this pet");
        pets[_id].owner = _newOwner;
    }

    function reportLost(uint256 _id) public {
        require(pets[_id].owner == msg.sender, "You are not the owner of this pet");
        require(pets[_id].isLost == false, "This pet is already reported lost");
        pets[_id].isLost = true;
    }

    function reportFound(uint256 _id) public {
        require(pets[_id].isLost == true, "This pet is not reported lost");
        pets[_id].isFound = true;
    }

    function clearReport(uint256 _id) public {
        require(pets[_id].owner == msg.sender, "You are not the owner of this pet");
        require(pets[_id].isLost == true || pets[_id].isFound == true, "This pet is not reported lost or found");
        pets[_id].isLost = false;
        pets[_id].isFound = false;
    }

    function listAllOwnerPets(address _owner) public view returns (Pet[] memory) {
        uint256 count = 0;
        for (uint256 i = 1; i <= petsCount; i++) {
            if (pets[i].owner == _owner) {
                count++;
            }
        }

        Pet[] memory ownerPets = new Pet[](count);
        uint256 index = 0;
        for (uint256 i = 1; i <= petsCount; i++) {
            if (pets[i].owner == _owner) {
                ownerPets[index] = pets[i];
                index++;
            }
        }
        return ownerPets;
    }
}