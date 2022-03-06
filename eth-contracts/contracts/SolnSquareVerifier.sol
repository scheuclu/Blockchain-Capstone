// SPDX-License-Identifier: Unlicensed
pragma solidity 0.8.12;

import "./ScheucluHouseToken.sol";
import "./SquareVerifier.sol";

// [DONE] define a contract call to the zokrates generated solidity contract <Verifier> or <renamedVerifier>
// TODO(Reviewer): I did this via inheritence. is there a reason to do it differently?

// [DONE] define another contract named SolnSquareVerifier that inherits from your ERC721Mintable class

contract SolnSquareVerifier is ScheucluHouseToken, SquareVerifier {
    // TODO define a solutions struct that can hold an index & an address
    struct Solution {
        uint256 id;
        address from;
        bool isMinted;
        bool isRegistered;
    }

    // [DONE] define an array of the above struct
    Solution[] solutions;

    // [DONE] define a mapping to store unique solutions submitted
    mapping(bytes32 => Solution) private submittedSolutions;

    // [DONE] Create an event to emit when a solution is added
    // Create an event to emit when a solution is added
    event SolutionAdded(bytes32 index, address account);
    event SolutionMinted(uint256 id, address from);


    modifier SolutionValid(Proof memory proof, uint[2] memory inputs) {
        require(verifyTx(proof, inputs), "The solution is not valid");
        _;
    }

    modifier SolutionSubmitted(Proof memory proof, uint[2] memory inputs) {
        bytes32 solutionIndex = _getSolutionIndex(proof, inputs);
        require(submittedSolutions[solutionIndex].isRegistered == true, "Solution has not been submitted.");
        _;
    }

    modifier SolutionNotSubmitted(Proof memory proof, uint[2] memory inputs) {
        bytes32 solutionIndex = _getSolutionIndex(proof, inputs);
        require(submittedSolutions[solutionIndex].isRegistered == false, "Solution has already been submitted.");
        _;
    }

    modifier SolutionNotMinted(Proof memory proof, uint[2] memory inputs) {
        bytes32 solutionIndex = _getSolutionIndex(proof, inputs);
        require(submittedSolutions[solutionIndex].isMinted == false, "Solution has not been submitted.");
            _;
    }


    // [DONE] Create a function to add the solutions to the array and emit the event
    //function addSolution(bytes32 index, address account) internal {
    function addSolution(Proof memory proof, uint[2] memory inputs)
      SolutionValid(proof, inputs) SolutionNotSubmitted(proof, inputs) public {

        Solution memory sol = Solution(solutions.length, msg.sender, false, true);
        solutions.push(sol);

        bytes32 hashedSolution = _getSolutionIndex(proof, inputs);
        submittedSolutions[hashedSolution] = sol;
        
        emit SolutionAdded(hashedSolution, sol.from);
    }

    // [DONE] Create a function to mint new NFT only after the solution has been verified
    //  - make sure the solution is unique (has not been used before)
    //  - make sure you handle metadata as well as tokenSuplly
    // TODO(Reviewer) I am really not sure if this is implemented correctly.
    function mintNew(Proof memory proof, uint[2] memory inputs, address to)
      SolutionSubmitted(proof, inputs) SolutionNotMinted(proof, inputs) public {

        bytes32 hashedInput = _getSolutionIndex(proof, inputs);
        Solution storage sol = submittedSolutions[hashedInput];
        require(sol.from == msg.sender, "Minter not solution submitter.");

        sol.isMinted = true;
        super._mint(to, sol.id);
        setTokenURI(sol.id);
        emit SolutionMinted(sol.id, sol.from);

    }

    function _getSolutionIndex(Proof memory proof, uint[2] memory inputs) pure internal returns (bytes32) {
        return keccak256(abi.encodePacked(proof.a.X, proof.a.Y, proof.b.X, proof.b.Y, proof.c.X, proof.c.Y, inputs));
    }
}
