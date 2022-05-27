import React from 'react';
import './App.css';
import Header from './components/Header'
import BuyForm from './components/BuyForm'
import { ethers } from "ethers"
import abi from './zongICO.json'

const contractABI = abi.output.abi
    
const contractAddress =     
        '0x16Ffeb7f89CCDC50fe2aBcC834B3BAD18d766BCa'
const provider = 
        new ethers.providers.Web3Provider(window.ethereum)
const ICOContract = 
      new ethers.Contract(contractAddress, contractABI, provider);

console.log(ICOContract)
console.log(ICOContract.name())



function App() {

  const [currentAccount, setCurrentAccount] = React.useState('Ox')
  const [userBalance, setUserBalance] = React.useState('')
  

  const provider = new 
        ethers.providers.Web3Provider(window.ethereum)
  const signer = provider.getSigner()



  console.log(provider)
  console.log(signer)
  console.log(signer.getAddress())

  const connectWallet = async () =>  {
    if(window.ethereum) {
    
    await console.log('Wallet')
    }

    const currentAddress = await signer.getAddress()
      await console.log(currentAddress)

    setCurrentAccount(currentAddress)
      await console.log(currentAccount)

    const balance = await provider.getBalance(currentAddress)
    await console.log(ethers.utils.formatEther(balance))

    setUserBalance(ethers.utils.formatEther(balance))
  }
  

  

  

  

  // const currentAddress = async ()=> {
  //   await signer.getAddress()
  //   return 
  // }
  

  // console.log(currentAddress)

  // function updateAddress() {
  //   setCurrentAccount(currentAddress)
  //   console.log(currentAddress)
  // }
    
  
  return (
      <div>
        <Header
          contract= {ICOContract}
          contractAddress= {contractAddress}
          provider= {provider}
          signer={signer}
          connect= {connectWallet}
          user= {currentAccount}
          balance= {userBalance}/>
        <BuyForm 
          contract=  {ICOContract}
          contractAddress= {contractAddress}
          signer= {signer}
          />
        
      </div>
  )
}

export default App;