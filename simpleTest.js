const {assert} = require('chai')

const simpleToken = artifacts.require('./simpleToken.sol')

// check for chai
require('chai')
.use(require('chai-as-promised'))
.should()

contract('simpleToken', ([owner, address1, address2,]) => {
    let contract 

    before( async () => {

        contract = await simpleToken.deployed() 
    })

    describe('deployment', async () => {

        it('deploys succesfully', async () => {
            const address = await contract.address
            assert.notEqual(address, '')
            assert.notEqual(address, null)
            assert.notEqual(address, undefined)
            assert.notEqual(address, 0x0)
        })

        it('transfers the owner 1000000 tokens', async () => {
            const ownerBalance = await contract.balanceOf(owner)
            assert.equal(ownerBalance, '1000000')
        })

        it('has a name', async () => {
            const name = await contract.name()
            assert.equal(name, 'simpleToken')
        })

        it('has a symbol', async () => {
            const symbol = await contract.symbol()
            assert.equal(symbol, 'SIMPLE')
        })

        it('has 0 decimals', async () => {
            const decimals = await contract.decimals()
            assert.equal(decimals, '0')
        })
    })

    describe('transfer function', async () => {

        it('transfers from one address to another', async () => {
            await contract.transfer(address1, '1000')
            const address1Balance = await contract.balanceOf(address1)
            assert.equal(address1Balance, '1000')
        })

        it('transfers from address1 to address2', async () => {
            await contract.transfer(address2, '500', {from: address1})
            const address1Balance = await contract.balanceOf(address1)
            const address2Balance = await contract.balanceOf(address2)
            assert.equal(address2Balance, '500')
            assert.equal(address1Balance, '500')
        })

        it('account tried to transfer more tokens that it has', async () => {
            await contract.transfer(address2, '5000', {from: address1}).should.be.rejected
        })
    })


    describe('approve function', async () => {

        it('approves and address an allowance', async () => {
            await contract.approve(address1, '500')
            const allowed = await contract.allowance(owner, address1)
            assert.equal(allowed, '500')
        })

        it('an address cant approve more tokens than they have', async () => {
            await contract.approve(address1, '1000001').should.be.rejected
        })
    })

    
    describe('transferFrom function', async () => {

        it('transfers from owner to address1 called by address1', async () => {
            await contract.transferFrom(owner, address1, '250', {from: address1})
            const address1Balance = await contract.balanceOf(address1)
            assert.equal(address1Balance, '750')
        })

        it('address cant transferFrom unless approved', async () => {
            await contract.transferFrom(owner, address2, '1000', {from: address2}).should.be.rejected        
        })

        it('address cant transfer more tokens than they are allowed', async () => {
            await contract.transferFrom(owner, address1, '1000', {from: address1}).should.be.rejected
        })
    })

})   
