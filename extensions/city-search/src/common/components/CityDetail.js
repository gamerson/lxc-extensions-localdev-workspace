import React from 'react';

class CityDetail extends React.Component {
  render() {
    return (
      <div>
        <hr />
        <h1>City Details</h1>
        <table width={"100%"}>
          <tr>
            <th>
              Zip Code
            </th>
            <th>
              Latitude
            </th>
            <th>
              Longitude
            </th>
            <th>
              City
            </th>
            <th>
              State
            </th>
            <th>
              County
            </th>
          </tr>
          {this.props.detail.legs.map(function (detail) {
            return (<tr>
              <td>
                {detail.zipcode}
              </td>
              <td>
                {detail.latitude}
              </td>
              <td>
                {detail.longitude}
              </td>
              <td>
                {detail.city}
              </td>
              <td>
                {detail.state}
              </td>
            </tr>);
          })}
        </table>
      </div>
    );
  }
}

export default CityDetail;