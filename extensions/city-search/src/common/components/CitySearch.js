import React from 'react';
import CityDetail from './CityDetail';

class CitySearch extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      city: "Dallas",
      state: "TX"
    };

    this.handleInputChange = this.handleInputChange.bind(this);
    this.handleSubmit = this.handleSubmit.bind(this);


    
    this.webClient = props.webClient;
  }

  handleInputChange(event) {
    const target = event.target;
    const value = target.type === 'checkbox' ? target.checked : target.value;
    const name = target.name;

    this.setState({
      [name]: value
    });
  }

  handleSubmit(event) {
    this.webClient.fetch(
      'city/search?' + new URLSearchParams({
        'city': this.state.city,
        'state': this.state.state
      })
    ).then((res) => {
      this.setState({"detail":res[0]});
    });
    event.preventDefault();
  }

  render() {
    return (
      <form onSubmit={this.handleSubmit}>
        <h1>City Search</h1>
        <table>
          <tr>
            <td>
              <label>
                City: 
              </label>
            </td>
            <td>
              <input
                name="city"
                type="text"
                defaultValue="Dallas"
                onChange={this.handleInputChange} />
            </td>
          </tr>
          <tr>
            <td>
              <label>State:</label>
            </td>
            <td>
              <input
                name="state"
                type="text"
                defaultValue="TX"
                onChange={this.handleInputChange} />
            </td>
          </tr>
          <tr>
            <td colSpan="2"><input type="submit" value="Search" /></td>
          </tr>
        </table>
        {this.state.detail != null && <CityDetail detail={this.state.detail} />}
      </form>
    );
  }
}

export default CitySearch;