// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./HomestayStorageStructure.sol";

contract HomestayLogic is HomestayStorageStructure {

    function addRoom(
        string memory _telegramID,
        uint _rentPerDay,
        uint _collateral
    ) public {
        roomsByID[currentRoomID] = Room(
            currentRoomID,
            0,
            _telegramID,
            true,
            msg.sender,
            address(0),
            _rentPerDay,
            _collateral,
            true
        );

        currentRoomID++;
    }

    function rentRoom(
        uint _roomID
    ) public {
        require(roomsByID[_roomID].isExisted == true, "There is no such agreement.");
        require(roomsByID[_roomID].isVacant == true, "The room is not vacant.");

        uint totalFee = roomsByID[_roomID].rentPerDay + roomsByID[_roomID].collateral;

        require(ramzRial.balanceOf(msg.sender) >= totalFee, "No money, No fun!");
        require(ramzRial.allowance(msg.sender, address(this)) >= totalFee, "The token has not the access to transfer your money.");

        Room memory theRoom = roomsByID[_roomID];

        ramzRial.transferFrom(msg.sender, address(this), totalFee);

        agreementsByID[currentAgreementID] = Agreement(
            currentAgreementID,
            _roomID,
            theRoom.telegramID,
            true,
            theRoom.landLord,
            msg.sender,
            theRoom.rentPerDay,
            theRoom.collateral,
            block.timestamp,
            true
        );

        roomsByID[_roomID].isVacant = false;
        roomsByID[_roomID].agreementID = currentAgreementID;
        roomsByID[_roomID].renter = msg.sender;

        currentAgreementID++;
    }

    function emptyRoom(
        uint _agreementID
    ) public {
        Agreement memory theAgreement = agreementsByID[_agreementID];

        require(theAgreement.isExisted == true, "There is no such agreement.");
        require(theAgreement.isActive == true, "This agreement has expired already.");
        require(block.timestamp >= theAgreement.startingTime + rentingDuration, "This agreement is not expired yet.");

        require(msg.sender == theAgreement.renter || msg.sender == theAgreement.landLord, "You don't have the right to empty this room.");

        Room memory theRoom = roomsByID[theAgreement.roomID];

        uint ownerFee = (theAgreement.rentPerDay * feePercentage) / 100;

        ramzRial.transfer(owner, ownerFee);
        ramzRial.transfer(theAgreement.landLord, theAgreement.rentPerDay - ownerFee);
        ramzRial.transfer(theAgreement.renter, theAgreement.collateral);

        theRoom.isVacant = true;
        theRoom.renter = address(0);
        theRoom.agreementID = 0;

        roomsByID[theAgreement.roomID] = theRoom;

        agreementsByID[_agreementID].isActive = false;
    }

    function setRentingDuration(uint newDuration) public onlyOwner{
        rentingDuration = newDuration;
    }

    function setFeePercentage(uint newFee) public onlyOwner{
        feePercentage = newFee;
    }
}