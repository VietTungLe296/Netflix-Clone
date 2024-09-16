<!-- TABLE OF CONTENTS -->
<details>
  <summary>Table of Contents</summary>
  <ol>
    <li>
      <a href="#netflix-clone">Netflix Clone</a>
      <ul>
        <li><a href="#description">Description</a></li>
         <li><a href="#usage">Usage</a></li>
      </ul>
    </li>
    <li>
      <a href="#getting-started">Getting Started</a>
      <ul>
        <li><a href="#prerequisites">Prerequisites</a></li>
        <li><a href="#installation">Installation</a></li>
      </ul>
    </li>
    <li><a href="#technologies-used">Technologies used</a></li>
    <li><a href="#screenshots">Screenshots</a></li>
    <li><a href="#references">References</a></li>
  </ol>
</details>

# Netflix Clone
## Description
An application based on the general idea and design of Netflix from a basic UIKit YouTube course. I have extended the application with additional features like loading state when calling APIs, skeleton views, alphabetical sorting, hiding/showing toggle for adult contents when searching, success/error/info alerts (including exception handling), etc.
## Usage
- The home screen will be like a movie newsfeed with sections like Popular, Highly Rated, Upcoming, etc.
- Users can watch trailers of movies, search by their titles, and download them to the offline storage
- Under development features: Sign-up/Sign-in and Profile

# Getting started
## Prerequisites
Support devices from iOS 13+. Run this project in Xcode 12 above for the best compatibility
## Installation
1. Clone the repo
```
git clone https://github.com/VietTungLe296/Netflix-Clone.git
```
2. Install CocoaPods (skip this if you already installed)
```
sudo gem install cocoapods
```
3. Install Dependencies From CocoaPods
```
pod install
```
4. API Tokens
- Movie database: https://developer.themoviedb.org/docs/getting-started
- Youtube APIs: https://developers.google.com/youtube/v3/getting-started
5. Config
- Create a config.plist file under the Config folder inside the project (The config.plist file should be in the same folder with the AppConfig.swift file)
- Create a key-value pairs inside config.plist with your tokens:
  + MOVIE_DB_API_TOKEN=YOUR_MOVIE_DATABASE_API_TOKEN
  + GOOGLE_YOUTUBE_API_TOKEN=YOUR_YOUTUBE_API_TOKEN

# Technologies used
1. Codebase: Swift, UIKit, Interface Builder, Core Data
2. Architecture: Clean VIP (optional router)
3. Package Manager: CocoaPods
4. 3rd party libraries: SVProgressHUD, SDWebImage, SkeletonView

## Screenshots
<img src="https://github.com/user-attachments/assets/7cbaa047-5fab-4755-9bc0-3115455bc3b2" alt="Home" width="300" height="650">
<img src="https://github.com/user-attachments/assets/93109999-c421-4845-b7fd-35c4448828bd" alt="Home" width="300" height="650">
<img src="https://github.com/user-attachments/assets/dac6f53d-88d8-47e4-8103-3b53d949ee7a" alt="Home" width="300" height="650">
<br><br>
<img src="https://github.com/user-attachments/assets/4f3cfb0f-387a-4d25-850c-7ad42f445d00" alt="Home" width="300" height="650">
<img src="https://github.com/user-attachments/assets/005dfa7d-081c-487e-90d9-2c99affdf99f" alt="Home" width="300" height="650">
<br><br>
<img src="https://github.com/user-attachments/assets/5c83d3e0-cb1f-44ed-9694-d8d4bbde7921" alt="Home" width="300" height="650">
<img src="https://github.com/user-attachments/assets/d80b1bdb-f561-40e5-8399-839eb5bf99c2" alt="Home" width="300" height="650">
<br><br>
<img src="https://github.com/user-attachments/assets/fcc1ab79-bab4-4cf5-8a93-4b587f96906a" alt="Home" width="300" height="650">
<img src="https://github.com/user-attachments/assets/d8e67dd0-2ad3-4c4e-9e8b-7e4b9c71a940" alt="Home" width="300" height="650">
<img src="https://github.com/user-attachments/assets/0ecf4d16-1dfe-44a5-b11c-8d14303b8be2" alt="Home" width="300" height="650">

## References
YouTube course: https://www.youtube.com/watch?v=KCgYDCKqato <br>
APIs: https://www.themoviedb.org/
