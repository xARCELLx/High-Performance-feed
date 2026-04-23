# High Performance Feed (Flutter)

This project is a high-performance infinite scrolling social feed built using Flutter, Riverpod, and Supabase.

## Features

- Infinite scrolling with pagination (10 items per request)
- Pull-to-refresh
- GPU optimized UI using RepaintBoundary
- RAM optimized image loading using memCacheWidth
- Hero animations for smooth transitions
- Tiered image loading (thumbnail → mobile → raw)
- Optimistic UI for likes
- Backend sync using Supabase RPC
- Offline support with automatic rollback
- Spam click protection for consistent state

## State Management

Riverpod is used with StateNotifier to manage feed state and handle asynchronous operations cleanly.

## Performance Optimizations

- RepaintBoundary ensures UI is rasterized efficiently
- memCacheWidth reduces memory usage for images
- Only thumbnail images are loaded in feed

## Edge Case Handling

- Rapid clicking is handled using request locking
- Offline failures revert UI state safely
- Pagination prevents duplicate or excessive requests

## Tech Stack

- Flutter
- Riverpod
- Supabase (DB + Storage + RPC)
