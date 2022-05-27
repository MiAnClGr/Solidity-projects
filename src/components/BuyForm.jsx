import React from 'react'
import { ethers } from "ethers"

function BuyForm(props) {

  const [submitData, setSubmitData] = React.useState("")

  const sendMoney = async () => {
     const tx = {
      to: props.contractAddress,
      value: ethers.utils.parseEther(submitData),
     }

    await props.contract.invest(
        props.signer.sendTransaction(tx))
      
    
  }
  
  function handleChange(event) {
    
        setSubmitData(event.target.value)
    }

  console.log(submitData)

  function handleSubmit() {
    event.preventDefault()
    sendMoney(props.contractAddress, 
               ethers.utils.parseEther(submitData) )
    
  }  

  return(
    <form>
      <img className= 'Logo' src= "./zong logo.png" />
      <div className= 'Buy'>
        <br></br>
        <br></br>
        <input
          className= 'BuyInput'
          placeholder= 'Enter Amount'
          name= 'buy'
          onChange= {handleChange}
          value= {submitData}
          >
        
        </input>
        <button 
          className= 'BuyButton' 
          onClick= {handleSubmit}
          value= {submitData}
        >
            Submit
        </button>
      </div>
        <h3 className= 'Instructions'>Enter the amount in Eth</h3>
        <h4 className= 'Instructions'>One $ZONG = 0.003 ETH</h4>
        <h4 className= 'Instructions'>Contract Address: {props.contractAddress}</h4>
      
        
    </form>
  )
}
export default BuyForm