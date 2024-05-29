# Lazy Load Gallery

<p align="center">
  <img src="https://github.com/mustafos/lazy-load-img/blob/master/Preview.png" alt="Lazy Load Gallery" width="100%"/>
</p>

## Features

- **Lazy Loading**: Images load only when they are about to appear in the viewport.
- **Loading Indicators**: Displays a placeholder and loading spinner while images and data are loading.
- **Error Handling**: Shows an error message with a retry option if the data fetch fails.
- **Responsive UI**: Uses a grid layout to display images, ensuring a responsive design.

## Installation

1. **Clone the repository:**
    ```bash
    git clone https://github.com/mustafos/lazy-load-img.git
    cd lazy-load-img
    ```

2. **Open the project in Xcode:**
    ```bash
    open lazy-load-img.xcodeproj
    ```

3. **Run the application:**
    - Select the target device or simulator.
    - Press `Cmd + R` or click the Run button in Xcode.

## Project Structure

- `LazyLoadGalleryApp.swift`: The main entry point of the application.
- `View/GalleryView.swift`: The main view that initializes and displays the image list.
- `Model/Post.swift`: The data model representing each image item.
- `Utils/CacheAsyncImage.swift`: The view for an async image.
- `ViewModels/NetworkManager.swift`: The view model responsible for fetching and managing image data.

## Usage

- The application starts by displaying a loader.
- Once data is fetched, a grid of image cards is displayed.
- Each image card shows a placeholder until the image is fully loaded.
- If the data fetch fails, an error message with a retry button is shown.

## Contribution

Contributions are welcome! Please fork the repository and submit a pull request for any improvements or bug fixes.

## License

This project is licensed under the MIT License - see the [LICENSE](https://github.com/mustafos/lazy-load-img/blob/master/LICENSE) file for details.
