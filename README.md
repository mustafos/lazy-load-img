# 🐾 Catstagram

<p align="center">
<img src="https://github.com/mustafos/lazy-load-img/blob/master/Preview.png" alt="Lazy Load Gallery" width="100%"/>
</p>

## ✨ Features

- **📸 Mixed Media Feed**: Supports photos, videos, and mixed posts with horizontal paging.
- **▶️ Smart Video Playback**: Videos auto-play when visible and pause when off-screen.
- **❤️ Like with Animation**: Double-tap to like with smooth heartbeat animation + haptics.
- **🗂️ Caching & Preheating**: Images downsampled and preheated, videos pooled for reuse.
- **🎨 Modern UI**: Card-style posts, custom header, floating action button with gradient.
- **☀️ Light Mode Only**: Clean, consistent design locked to light appearance.

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
- Select a simulator or real device.
- Press `Cmd + R` or hit the ▶️ Run button.

## 📂 Project Structure

- `LazyLoadGalleryApp.swift` — app entry point, audio session + scene management.
- `FeedView.swift` — main scrollable feed.
- `PostCell.swift` — single post UI (header, media, actions, caption).
- `MediaPagerView.swift` — horizontal pager for mixed photo + video posts.
- `PlayerPool.swift` — AVPlayer pool for smooth video reuse.
- `ImageLoader.swift` — downsampled image loading with caching.
- `AppTheme.swift` — shared colors, shadows, and layout constants.

## 🎮 Usage

- Scroll the feed to view posts.
- Photos display instantly with lazy downsampled loading.
- Videos auto-play when at least 25% visible.
- Double-tap a photo or video to like it — ❤️ animates with a beat.
- Toggle sound with the mute button in the corner.

## 🤝 Contribution

Pull requests are welcome!
For big changes, open an issue first to discuss what you’d like to add.

## 📜 License

This project is licensed under the MIT License - see the [LICENSE](https://github.com/mustafos/lazy-load-img/blob/master/LICENSE) file for details.
