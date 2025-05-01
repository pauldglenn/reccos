# Reccos

Reccos is an iOS app for managing and sharing content recommendations. It allows users to track recommendations for movies, TV shows, podcasts, and other content types.

## Features

- Add recommendations with details like title, content type, recommender, and notes
- Search for content on various platforms (Spotify, Amazon, IMDB)
- Filter recommendations by content type
- Simple and intuitive user interface

## Requirements

- iOS 15.0+
- Xcode 13.0+
- Swift 5.5+

## Installation

1. Clone the repository
2. Open `reccos.xcodeproj` in Xcode
3. Build and run the project

## Running Tests

The project includes UI tests to verify the core functionality. To run the tests:

1. Open the project in Xcode
2. Select the `reccosUITests` target
3. Press `Cmd+U` or select `Product > Test` from the menu

### Test Coverage

The UI tests cover the following functionality:

- Adding a new recommendation
  - Searching for content
  - Selecting content type
  - Entering title, recommender, and notes
  - Saving the recommendation
- Filtering recommendations
  - Filtering by content type
  - Verifying filtered results

## Architecture

The app follows the MVVM (Model-View-ViewModel) architecture pattern:

- **Models**: Define the data structures (Content, SearchResult)
- **Views**: SwiftUI views for the user interface
- **ViewModels**: Handle business logic and state management

## Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details 