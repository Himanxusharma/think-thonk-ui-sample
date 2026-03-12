/**
 * Core Data Models - Language agnostic
 * These models are designed to be easily translated to Flutter/Dart
 */

export interface ContentItem {
  id: number;
  category: string;
  headline: string;
  content: string;
  expandedContent: string;
  saved: boolean;
  liked: boolean;
  shared: boolean;
  likeCount: number;
  saveCount: number;
}

export interface UserEngagement {
  contentId: number;
  liked: boolean;
  saved: boolean;
  shared: boolean;
}

export interface UserProfile {
  id: string;
  name: string;
  email: string;
  avatar?: string;
  streakCount: number;
  totalLikes: number;
  totalSaves: number;
}

export interface AppState {
  content: ContentItem[];
  selectedContent: ContentItem | null;
  isModalOpen: boolean;
  isFullscreenOpen: boolean;
  fullscreenIndex: number;
  currentTheme: 'light' | 'dark';
  userProfile: UserProfile | null;
  streak: number;
}

export interface NavigationParams {
  cardIndex?: number;
  articleId?: number;
}

export interface ModalState {
  isOpen: boolean;
  content: ContentItem | null;
}

export interface FullscreenState {
  isOpen: boolean;
  currentIndex: number;
  content: ContentItem[];
}

// Enum for Content Categories (for type safety)
export enum ContentCategory {
  PSYCHOLOGY = 'Psychology',
  NEUROSCIENCE = 'Neuroscience',
  BEHAVIORAL_SCIENCE = 'Behavioral Science',
  COGNITIVE_SCIENCE = 'Cognitive Science',
  PHILOSOPHY = 'Philosophy',
  TECHNOLOGY = 'Technology',
  ECOLOGY = 'Ecology',
  ECONOMICS = 'Economics',
}

// Enum for Theme
export enum Theme {
  LIGHT = 'light',
  DARK = 'dark',
  SYSTEM = 'system',
}
