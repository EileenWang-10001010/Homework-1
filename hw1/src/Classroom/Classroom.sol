// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/* Problem 1 Interface & Contract */
contract StudentV1 {
    // Note: You can declare some state variable
    bool private _init = true;
    // bool public isEnrolled = false;
    function register() external returns (uint256) {
        // TODO: please add your implementaiton here
        if (_init){
            _init = false;
            return 1000;
        }
        else{
            // isEnrolled = true;
            return 123;
        }
    }
}

/* Problem 2 Interface & Contract */
interface IClassroomV2 {
    function isEnrolled() external view returns (bool);
}

contract StudentV2 {
    function register() external view returns (uint256) {
    // TODO: please add your implementaiton here
    IClassroomV2 classroom = IClassroomV2(msg.sender);

    if (classroom.isEnrolled()) {
        return 123;
    } else {
        return 1000;
    }
    }
}

/* Problem 3 Interface & Contract */
contract StudentV3 {
    function register() external view returns (uint256) {
        // TODO: please add your implementaiton here
        if (gasleft() > 7000){
            return 1000;
        }
        else{
            return 123;
        }
    }
}
