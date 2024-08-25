<img src="https://github.com/user-attachments/assets/ff395892-ced5-4cf6-820c-25d1d3ec3fe8" alt="logo" width="100"/> 

# Crypto Tracker App



*A SwiftUI-based app to track cryptocurrency prices and manage your portfolio*

## Overview

The **Crypto Tracker App** allows you to stay updated with the latest cryptocurrency prices and manage your portfolio seamlessly. With a sleek and intuitive user interface, the app provides real-time data with insightful visualizations.

## Features

- **Real-Time Price Tracking**: View live prices of various cryptocurrencies.
- **Portfolio Management**: Add or remove cryptocurrencies to your portfolio and track your investments.
- **Price Line Graphs**: Visualize the price trend of each cryptocurrency with interactive and animated graphs.
- **Market Information**: Access detailed market data, including market cap, 24h trading volume, circulating supply, and more.


## Screenshots

<table border="0">
  <tr>
    <td><img width="378" alt="Screenshot 2024-08-26 at 1 12 01 AM" src="https://github.com/user-attachments/assets/fdb445f1-225d-4e8b-8f60-8276875e623b"></td>
    <td><img width="378" alt="Screenshot 2024-08-26 at 1 10 28 AM" src="https://github.com/user-attachments/assets/cd3a63c5-fe3f-4118-9e09-506c86aaa587"></td>
    <td><img width="375" alt="Screenshot 2024-08-26 at 1 09 51 AM" src="https://github.com/user-attachments/assets/117b9739-428b-4358-b6ad-b4309b616b5a"></td>
  </tr>
  <tr>
    <td><img width="377" alt="Screenshot 2024-08-26 at 1 10 54 AM" src="https://github.com/user-attachments/assets/31d35353-ccdd-4282-a2da-d819072c75f8"></td>
    <td><img width="379" alt="Screenshot 2024-08-26 at 1 10 12 AM" src="https://github.com/user-attachments/assets/27479088-4d5b-4634-a8f8-463902614535"></td>
    <td><img width="383" alt="Screenshot 2024-08-26 at 1 16 50 AM" src="https://github.com/user-attachments/assets/e0d8e7eb-3b18-43da-8c84-240e726d2f73"></td>
  </tr>
</table>


## Installation

1. **Clone the repository**:
   ```bash
   git clone https://github.com/yourusername/crypto-tracker-app.git

2. **Navigate to the project directory**:
   ```bash
   cd crypto-tracker-app
   
3. **Open the project in Xcode**:
   ```bash
   open CryptoTrackerApp.xcodeproj
   
4. **Run the app**:
   - Select the target device (simulator or a connected device).
   - Click the **Run** button or press `Cmd + R` in Xcode.
  
## API

  The app uses the CoinGecko API to fetch cryptocurrency data. The following endpoint is used to retrieve market data:

   **Endpoint**: `https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd`


## Requirements

  - **Xcode 14.0** or later
  - **iOS 15.0** or later
  - **Swift 5.6** or later

## Technologies Used

- **SwiftUI**: For building the user interface.
- **Combine**: For handling asynchronous data streams.
- **CoinGecko API**: To fetch real-time cryptocurrency data.
- **Core Data (planned)**: To persist portfolio data.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.




