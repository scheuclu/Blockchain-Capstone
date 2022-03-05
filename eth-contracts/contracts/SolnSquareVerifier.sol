// SPDX-License-Identifier: Unlicensed
pragma solidity 0.8.12;

import "./ScheucluHouseToken.sol";
import "./SquareVerifier.sol";

// TODO define a contract call to the zokrates generated solidity contract <Verifier> or <renamedVerifier>

// TODO define another contract named SolnSquareVerifier that inherits from your ERC721Mintable class

contract SolnSquareVerifier is ScheucluHouseToken, SquareVerifier {
    // TODO define a solutions struct that can hold an index & an address
    struct Solution {
        uint256 id;
        address from;
        bool isMinted;
    }

    // TODO define an array of the above struct
    Solution[] solutions;

    // TODO define a mapping to store unique solutions submitted
    mapping(bytes32 => bool) private submittedSolutions;

    // TODO Create an event to emit when a solution is added
    // Create an event to emit when a solution is added
    event SolutionAdded(bytes32 index, address account);

    // TODO Create a function to add the solutions to the array and emit the event
    //function addSolution(bytes32 index, address account) internal {
    function addSolution(Proof memory proof, uint[2] memory input) public {

        require(verifyTx(proof,input), "The submitted solution is not valid");

        //Hash the solution to make sure it is new
        bytes32 hashedSolution = keccak256(abi.encodePacked(input));
        require(!submittedSolutions[hashedSolution], "Solution is already submitted");
        
        uint256 index = solutions.length; //TODO lukas this is clearly wrong
        solutions.push(Solution(index, msg.sender, false));

        submittedSolutions[hashedSolution] = true;

        emit SolutionAdded(hashedSolution, msg.sender);
    }

    // TODO Create a function to mint new NFT only after the solution has been verified
    //  - make sure the solution is unique (has not been used before)
    //  - make sure you handle metadata as well as tokenSuplly
    // function mint(address to) public {
    //     bytes32 solutionIndex = 0;

    //     //TODO(lukas)

    //     //addSolution(solutionIndex, to);
    //     super.mint(to, solutions.length);
    // }

    // function isSolutionSubmitted (Proof memory proof, uint[2] memory inputs) public view returns (bool) {
    //     bytes32 solutionIndex = _getSolutionIndex(proof, inputs);
    //     return submittedSolutions[solutionIndex];
    // }

    // function _getSolutionIndex(Proof memory proof, uint[2] memory inputs) pure internal returns (bytes32) {
    //     return keccak256(abi.encodePacked(proof.a.X, proof.a.Y, proof.b.X, proof.b.Y, proof.c.X, proof.c.Y, inputs));
    // }
}
