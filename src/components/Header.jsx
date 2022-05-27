import React from 'react'



function Header(props) {
  
 
  return(
    <header className='Header'>
      <div className= 'User'>
        <h4>Current User: {props.user} </h4>
        <h4>Current Balance: {props.balance}</h4>
      </div>
      <button
        className= 'Connect'
        onClick= {props.connect}
         >
        Connect Wallet
      </button>  
      
    </header>
  )
}
export default Header