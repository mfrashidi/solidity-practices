// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./HomestayStorageStructure.sol";

contract HomestayProxy is HomestayStorageStructure {
    
    constructor(
        address _logic,
        address _ramzRial
    ) {
        owner = msg.sender;
        logic = _logic;
        ramzRial = IERC20(_ramzRial);
    }

    function updateLogic(address _newLogic) external onlyOwner {
        logic = _newLogic;
    }

    fallback() external payable {
        address opr = logic;
        require(opr != address(0));
        assembly {
            calldatacopy(0, 0, calldatasize())
            let result := delegatecall(gas(), opr, 0, calldatasize(), 0, 0)
            returndatacopy(0, 0, returndatasize())
            switch result
            case 0 {
                revert(0, returndatasize())
            }
            default {
                return(0, returndatasize())
            }
        }
    }

    receive() external payable {}
}