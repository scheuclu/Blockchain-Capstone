// Test if a new solution can be added for contract - SolnSquareVerifier

// Test if an ERC721 token can be minted for contract - SolnSquareVerifier

var SolnSquareVerifier = artifacts.require('SolnSquareVerifier');
var verifierProof = require('../../zokrates/code/square/proof.json');

const truffleAssert = require('truffle-assertions');

const {
    BN,
    expectEvent,
    expectRevert,
} = require('@openzeppelin/test-helpers');
const { assertion } = require('@openzeppelin/test-helpers/src/expectRevert');

contract('Soln Square Verifier', accounts => {

    const account_one = accounts[0];
    const account_two = accounts[1];

    describe('Verifier', function () {
        before(async function () {
            this.contract = await SolnSquareVerifier.new();

        })

        it('Test if a new solution can be added for contract', async function () {

            let result = await this.contract.addSolution(
                { a: verifierProof.proof.a, b: verifierProof.proof.b, c: verifierProof.proof.c },
                verifierProof.inputs,
                { from: account_one }
            );
            await expectEvent(result, "SolutionAdded");
        })

        it('Make sure the same solution cannot be added twice', async function () {

            let sucess = true;
            try {
                let result = await this.contract.addSolution(
                    { a: verifierProof.proof.a, b: verifierProof.proof.b, c: verifierProof.proof.c },
                    verifierProof.inputs,
                    { from: account_one }
                )
                console.log(result);
            } catch (err) {
                sucess = false;
            }

            assert.equal(sucess, false, "Should fail");

        })


    });
})