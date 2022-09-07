import logo from './logo.svg';
import './App.css';
import { useEffect, useState } from 'react';
import { Celebration } from './celebration/celebration'

function App() {

  const [btnText, setBtnText] = useState('Get your coupon now!');

  function getYourCoupon() {
    setBtnText('Please wait ..');
   fetch(process.env.REACT_APP_ASSIGN_NEXT_COUPON_API + '?p_auth=' + window.Liferay.authToken, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        cUserId: window.Liferay.ThemeDisplay.getUserId()
      })
    })
      .then(res => {
        // Unfortunately, fetch doesn't send (404 error) into the cache itself
        // You have to send it, as I have done below
        if(res.status >= 400) {
            throw new Error("Server responds with error!");
        }
        return res.json();
		})
      .then(data => {
        setBtnText('Your Coupon Code is ' + data.id );
        
		setTimeout(() => {
          setBtnText('Get your coupon now!');
        }, 10000);
      })
		.catch((error) => {
            setBtnText('Error Occurred');
        })
  };

  return (
    <div className='rca-container'>
      <div className='rca-box'>
        <div className='first-section'>
          <h1 className='d-none'>test</h1>
          <h1>Big Sale!</h1>
        </div>
        <div className='second-section'>
          <p>Up to <span className='percentage'>70%</span></p>
          <p>* valid until the end of the year</p>
          <button onClick={getYourCoupon}>{btnText}</button>
        </div>
      </div>
      <Celebration />
    </div>
  );
}

export default App;
